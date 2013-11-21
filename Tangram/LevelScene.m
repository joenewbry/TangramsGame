//
//  LevelScene.m
//  Tangram
//
//  Created by Joe Newbry on 10/25/13.
//  Copyright (c) 2013 Joe Newbry. All rights reserved.
//

#import "LevelScene.h"
#import "LevelWonScene.h"
#import "TemplateNode.h"


@interface LevelScene ()
{
    CGPoint startPoint; // stores starting touch location if final block placement is incorrect
    CGFloat _rotation;
    BlockNode *_selectedNode;
    
    int shapeCount[NUM_SHAPES];
    SKLabelNode *shapesRemaining[NUM_SHAPES];
    CGPoint shapeStartingPoints[NUM_SHAPES];
    CGPoint shapeLabelPoints[NUM_SHAPES];
    BOOL isRetina;  // device has a Retina display.

    // back button
    SKSpriteNode *backButton;
    
    // Template
    SKSpriteNode *_template;

    // triangles remaining
    int templateTriRemaining;
}



@property (strong, nonatomic) NSTimer *timeElapsed;
@property (strong, nonatomic) NSDate *startDate;

- (void) setupPhysics;
- (void) setupTangramDrawer;
- (void)setupTemplateWithModel:(LevelModel *)levelModel;
- (void) setupBackButton;
- (void) selectNodeForTouch:(CGPoint)touchLocation;
- (void) handleBeginningPan:(UIPanGestureRecognizer *)gesture;
- (void) handleContinuingPan:(UIPanGestureRecognizer *)gesture;
- (void) handleEndingPan:(UIPanGestureRecognizer *)gesture;
- (void) updateDrawerWithBlockType:(BlockType) type;
- (CGFloat) nearestAngleFromAngle :(CGFloat)angle;

@end


@implementation LevelScene

- (id)initWithLevel:(int)level AndSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        self.levelModel = [[LevelModel alloc] initWithLevel:level];

        // create a level label -- this is mostly to prove that levels work, we might not want this
        SKLabelNode * levelLabel = [[SKLabelNode alloc] initWithFontNamed:@"HelveticaNeue-Bold"];
        levelLabel.fontColor = [UIColor colorWithHue:0.000 saturation:0.000 brightness:0.224 alpha:1];
        levelLabel.text =  [NSString stringWithFormat:@"Level %i", (level+1)];
        levelLabel.position = CGPointMake(self.size.width / 2, self.size.height - 87);
        [self addChild:levelLabel];
        
        
        // convert shapeCount to ints
        for (int i = 0; i < self.levelModel.shapeCount.count; i++) {
            shapeCount[i] = [self.levelModel.shapeCount[i] integerValue];
        }
        
        // call setup methods
        [self setupPhysics];
        [self setupTangramDrawer];
        [self setupTemplateWithModel:self.levelModel];
        [self setupBackButton];
        
        self.backgroundColor = [UIColor whiteColor];
        
        // Figure out if device has Retina display.
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0)) {
            isRetina = YES;
        } else {
            isRetina = NO;
        }

        // should get passed in triangles in shape, or it should be a property on the template node
        templateTriRemaining = 1;
        
    }
    return self;
}

/*
 * Setup physicsWorld. Make sure gravity is off.
 */
- (void)setupPhysics
{
    self.physicsWorld.gravity = CGVectorMake(0.0, -0.0);
    self.physicsWorld.contactDelegate = self;
}

/*
 * Position and place all tangrams in their respective locations in the drawer.
 */
-(void)setupTangramDrawer
{
    // McQueen 11/13: I changed the divisor from 5 to 4 so that tangrams are not touching when
    // the drawer is initialized. This is a hack. Good enough for now, but we need to make sure
    // the shapes and the drawer are initialized without sprite contact.
    float blockOffset = 20;
    float placementHeight = self.size.height / 10;
    shapeStartingPoints[TRIANGLE] = CGPointMake(blockOffset + 100, placementHeight);
    shapeStartingPoints[TRAPEZOID] = CGPointMake(blockOffset + 240, placementHeight);
    shapeStartingPoints[RHOMBUS] = CGPointMake(blockOffset + 450, self.size.height / 9);
    shapeStartingPoints[SQUARE] = CGPointMake(blockOffset + 630, placementHeight);
    
    // set tangram label starting points
    int offset = 75;
    shapeLabelPoints[TRIANGLE] = CGPointMake(shapeStartingPoints[TRIANGLE].x - 30, shapeStartingPoints[TRIANGLE].y + offset);
    shapeLabelPoints[TRAPEZOID] = CGPointMake(shapeStartingPoints[TRAPEZOID].x, shapeStartingPoints[TRAPEZOID].y + offset);
    shapeLabelPoints[RHOMBUS] = CGPointMake(shapeStartingPoints[RHOMBUS].x, placementHeight + offset);
    shapeLabelPoints[SQUARE] = CGPointMake(shapeStartingPoints[SQUARE].x, shapeStartingPoints[SQUARE].y + offset);

    
    // initialize the tangrams as sprites and add them to the scene
    for (int i=0; i < NUM_SHAPES; i++){
        if (shapeCount[i] > 0){
            
            // add tangram
            BlockNode *block = [self createNodeWithType:i withPoint:shapeStartingPoints[i]];
            [self addChild:block];
            
            // add label
            shapesRemaining[i] = [self labelNodeWithRemaining:shapeCount[i] at:shapeLabelPoints[i]];
            [self addChild:shapesRemaining[i]];
            
        }
    }
}

/*
 * Create one new BlockNode with a given type at a given location.
 */
- (BlockNode *)createNodeWithType:(BlockType)type withPoint:(CGPoint)point
{
    BlockNode *block = [[BlockNode alloc] initWithBlockType:type deviceIsRetina:isRetina];
    block.position = point;
    return block;
}


/*
 * Add one drawer label at a given location.
 */
- (SKLabelNode *)labelNodeWithRemaining:(int)numRemaining at:(CGPoint)labelPoint
{
    SKLabelNode * shapeRemaining = [[SKLabelNode alloc] initWithFontNamed:@"HelveticaNeue-Bold"];
    shapeRemaining.fontColor = [UIColor colorWithHue:0.000 saturation:0.000 brightness:0.224 alpha:1];
    shapeRemaining.text =  [NSString stringWithFormat:@"%i", numRemaining];
    shapeRemaining.position = labelPoint;
    return shapeRemaining;
}

- (void)setupTemplateWithModel:(LevelModel *)levelModel
{
    _template = [[TemplateNode alloc] initWithModel:levelModel deviceIsRetina:isRetina];
    
    _template.position = CGPointMake(self.size.width/2, self.size.height/3 *2);

    [self addChild:_template];
    
    NSLog(@"template physics body: %@", _template.physicsBody);
}

/*
 * Create the back button for the current level.
 * This will likely need to be refactored to bring up a pause screen.
 */
-(void) setupBackButton
{
    backButton = [[SKSpriteNode alloc] initWithImageNamed:@"level-selection.png"];
    backButton.position = CGPointMake(60.0, 950.0);
    [self addChild:backButton];
}

/*
 * Set recognizers for pan, rotate and tap gestures
 */
- (void)didMoveToView:(SKView *)view
{
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(pan:)];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(tap:)];

    [[self view] addGestureRecognizer:panRecognizer];
    [[self view] addGestureRecognizer:tapGestureRecognizer];
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
    SKNode *node = [self nodeAtPoint:[self convertPointFromView:[gesture locationInView:gesture.view]]];
    
    if ([node isKindOfClass:[BlockNode class]]) {
        SKAction *rotate = [SKAction rotateByAngle:M_PI_4 duration:0.25];
        [node runAction:rotate];
    }
    if ([node isEqual:backButton]){
            SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
            SKScene *levelSelctionScene = [[LevelSelectionScene alloc] initWithSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height)];
            [self.view presentScene:levelSelctionScene transition:reveal];
    }
}

/*
 * Handle a pan gesture. This is complex, so its handled in sub-cases.
 */
- (void)pan:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self handleBeginningPan:gesture];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        [self handleContinuingPan:gesture];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded) {
        [self handleContinuingPan:gesture];
        [self handleEndingPan:gesture];
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    [self selectNodeForTouch:touchLocation];
}

/*
 * Set the _selectedNode to the one being touched at a given location.
 */
-(void)selectNodeForTouch:(CGPoint)touchLocation
{
    SKNode *nodeAtPoint = [self nodeAtPoint:touchLocation];
    
    if ([nodeAtPoint isKindOfClass:[BlockNode class]]) {
        _selectedNode = (BlockNode *)nodeAtPoint;
    }
    else {
        _selectedNode = nil;
    }
}

/*
 * Handle a pan begining
 */
-(void)handleBeginningPan:(UIPanGestureRecognizer *)gesture
{
    startPoint = [gesture locationInView:gesture.view];
    CGPoint touchLocation = [self convertPointFromView:startPoint];

    // set startPoint based on touchLocation
    startPoint.x = startPoint.x + _selectedNode.position.x - touchLocation.x;
    startPoint.y = startPoint.y + touchLocation.y - _selectedNode.position.y;

    [_selectedNode setZPosition:100];
}

/*
 * Handle a continuing pan: move the _selectedNode to the location the gesture has moved to.
 */
- (void)handleContinuingPan:(UIPanGestureRecognizer *)gesture
{
    CGPoint translation = [gesture translationInView:self.view];
    _selectedNode.position = CGPointMake(_selectedNode.position.x + translation.x,
                                         _selectedNode.position.y - translation.y);
    // set translation back to zero, or else it compounds
    [gesture setTranslation:CGPointMake(0, 0) inView:self.view];
}

/*
 * Handle ending pan. This is where we should handle when a tangram is over the tangram drawer,
 * the target shape, or something else that it needs special behavior when it is dropped into.
 */
- (void)handleEndingPan:(UIPanGestureRecognizer *)gesture
{
    
    [_selectedNode setZPosition:1];
    
    // unsuccessful placement
    if (_selectedNode.contactType == TOUCHING_TANGRAM) {
        // in the case of unsuccessful placement, the selected node still be tranparent
        [_selectedNode setAlpha:.5];
        [_selectedNode setPosition:CGPointMake(startPoint.x, self.size.height - startPoint.y)];
    }
    
    // successful placement
    else {
        
        if (_selectedNode.contactType == TOUCHING_TARGET) {
            // TODO: deal with this case
        }
        
        if (_selectedNode.contactType == TOUCHING_DRAWER) {
            // TODO: deal with this case
        }
        
        // if the tangram came from the drawer, update the drawer
        if (_selectedNode.inDrawer) {
            _selectedNode.inDrawer = false;
            [self updateDrawerWithBlockType:_selectedNode.objectType];
        }
        
        if (CGRectContainsRect(_template.frame, _selectedNode.frame)) {
            templateTriRemaining--;
        }

        // win condition check
        if ([self isGameWon]){
            [self gameWon];
        }
    }
}


/*
 * Update the drawer because a block was removed.
 */
-(void) updateDrawerWithBlockType:(BlockType) type
{
    // remove one node of this type
    shapeCount[type]--;
    shapesRemaining[type].text = [NSString stringWithFormat:@"%i", shapeCount[type]];
        
    // a block should be added if there is more than 1 block of this type left
    if (shapeCount[type] > 0) {
        BlockNode * addBlock = [self createNodeWithType:type withPoint:shapeStartingPoints[type]];
        [self addChild:addBlock];
    }
}

- (BOOL) isGameWon
{
    return templateTriRemaining < 1;
}

- (void) gameWon
{
    // initialize the correct level
    CGSize size = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    LevelWonScene * levelWonScene = [[LevelWonScene alloc] initWithSize:size];

    // present the level with a nice transition
    //SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
    [self.view presentScene:levelWonScene transition:nil];

}

/*
 * Handle when two physics bodies begin touching.
 */
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    // handle two blocks touching
    if ((secondBody.categoryBitMask & blockCategory) != 0) {
        _selectedNode.contactType = TOUCHING_TANGRAM;
        [_selectedNode setAlpha:.4];
    }
    
    // handle a block and a template touching
    // TODO: do we need another check here?
    if ((secondBody.categoryBitMask & targetCategory) != 0) {
        _selectedNode.contactType = TOUCHING_TARGET;
        _selectedNode.alpha = 0.5;
    }
}

/*
 * Handle when two physics bodies stop touching.
 */
- (void)didEndContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }

    // handle two blocks ending contact with each other
    if ((secondBody.categoryBitMask & blockCategory) != 0) {
            _selectedNode.contactType = NO_CONTACT;
            [_selectedNode setAlpha:1];
    }
    // must be contact between a tangram and the target
    else {
        _selectedNode.contactType = NO_CONTACT;
        [_selectedNode setAlpha:1];
        templateTriRemaining++;
    }
}


-(void)update:(NSTimeInterval)currentTime{

}

@end