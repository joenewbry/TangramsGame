//
//  LevelScene.m
//  Tangram
//
//  Created by Joe Newbry on 10/25/13.
//  Copyright (c) 2013 Joe Newbry. All rights reserved.
//

#import "LevelScene.h"

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
}

@property (strong, nonatomic) NSTimer *timeElapsed;
@property (strong, nonatomic) NSDate *startDate;

- (void) setupPhysics;
- (void) setupTangramDrawer;
- (void) setupTargetInScene;
- (void) setupBackButton;
- (void) selectNodeForTouch:(CGPoint)touchLocation;
- (void) handleBeginningPan:(UIPanGestureRecognizer *)gesture;
- (void) handleContinuingPan:(UIPanGestureRecognizer *)gesture;
- (void) handleEndingPan:(UIPanGestureRecognizer *)gesture;
- (void) updateDrawerWithBlockType:(BlockType) type;
- (void) rotate:(UIRotationGestureRecognizer *)gesture;
- (CGFloat) nearestAngleFromAngle :(CGFloat)angle;

@end

@implementation LevelScene

- (id)initWithLevel:(int)level AndSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        self.levelModel = [[LevelModel alloc] initWithLevel:level];

        // create a level label -- this is mostly to prove that levels work, we might not want this
        SKLabelNode * levelLabel = [[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
        levelLabel.fontColor = [UIColor greenColor];
        levelLabel.text =  [NSString stringWithFormat:@"Level %i", (level+1)];
        levelLabel.position = CGPointMake(self.size.width / 2, self.size.height - 200);
        [self addChild:levelLabel];
        
        
        // convert shapeCount to ints
        for (int i = 0; i < self.levelModel.shapeCount.count; i++) {
            shapeCount[i] = [self.levelModel.shapeCount[i] integerValue];
        }
        
        // call setup methods
        [self setupPhysics];
        [self setupTangramDrawer];
        [self setupTargetInScene];
        [self setupBackButton];
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        // Figure out if device has Retina display.
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0)) {
            isRetina = YES;
        } else {
            isRetina = NO;
        }
        
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
    float placementWidth = self.size.width / 4;
    float placementHeight = self.size.height / 6;
    shapeStartingPoints[TRIANGLE] = CGPointMake(placementWidth, placementHeight);
    shapeStartingPoints[SQUARE] = CGPointMake(2 * placementWidth, placementHeight);
    shapeStartingPoints[RHOMBUS] = CGPointMake(3 * placementWidth, placementHeight);
    shapeStartingPoints[TRAPEZOID] = CGPointMake(4 *placementWidth, placementHeight);
    
    // set tangram label starting points
    int offset = 75;
    shapeLabelPoints[TRIANGLE] = CGPointMake(shapeStartingPoints[TRIANGLE].x, shapeStartingPoints[TRIANGLE].y - offset);
    shapeLabelPoints[SQUARE] = CGPointMake(shapeStartingPoints[SQUARE].x, shapeStartingPoints[SQUARE].y - offset);
    shapeLabelPoints[RHOMBUS] = CGPointMake(shapeStartingPoints[RHOMBUS].x, shapeStartingPoints[RHOMBUS].y - offset);
    shapeLabelPoints[TRAPEZOID] = CGPointMake(shapeStartingPoints[TRAPEZOID].x, shapeStartingPoints[TRAPEZOID].y - offset);
    
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
    block.physicsBody.categoryBitMask = blockCategory;
    block.physicsBody.contactTestBitMask = blockCategory | targetCategory | wallCategory;
    block.physicsBody.collisionBitMask = 0;
    block.inDrawer = true;
    return block;
}


/*
 * Add one drawer label at a given location.
 */
- (SKLabelNode *)labelNodeWithRemaining:(int)numRemaining at:(CGPoint)labelPoint
{
    SKLabelNode * shapeRemaining = [[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
    shapeRemaining.fontColor = [UIColor greenColor];
    shapeRemaining.text =  [NSString stringWithFormat:@"%i", numRemaining];
    shapeRemaining.position = labelPoint;
    return shapeRemaining;
}


/*
 * Add the target into the scene.
 *
 * We should be pulling from a XML file and initializing a sprite.
 * TODO: we should have a "TemplateNode" class that handles template initialization details.
 */
- (void)setupTargetInScene
{
    SKSpriteNode *template = [SKSpriteNode spriteNodeWithImageNamed:self.levelModel.outlineFilepath];
    template.position = CGPointMake(self.size.width/2, self.size.height/3 *2);
    
    CGFloat offsetX = template.frame.size.width * template.anchorPoint.x;
    CGFloat offsetY = template.frame.size.height * template.anchorPoint.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    int length = self.levelModel.physicsBodyCoords.count;
    
    NSArray *coordPair = self.levelModel.physicsBodyCoords[0];
    
    CGPathMoveToPoint(path, NULL, [coordPair[0] floatValue] - offsetX, [coordPair[1] floatValue] - offsetY);
    for (int i = 1; i < length; i++) {
        coordPair = self.levelModel.physicsBodyCoords[i];
        CGPathAddLineToPoint(path, NULL, [coordPair[0] floatValue] - offsetX, [coordPair[1] floatValue] - offsetY);
    }
    
//    CGPathMoveToPoint(path, NULL, 19 - offsetX, 182 - offsetY);
//    CGPathAddLineToPoint(path, NULL, 186 - offsetX, 17 - offsetY);
//    CGPathAddLineToPoint(path, NULL, 18 - offsetX, 16 - offsetY);
    
    CGPathCloseSubpath(path);
    
    template.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
    
//    SKSpriteNode *largeSquareTarget = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size: CGSizeMake(200, 200)];
//    largeSquareTarget.position = CGPointMake(self.size.width/2, self.size.height/3 *2);
//    largeSquareTarget.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0.0, 0.0, 200, 200)];
    
    
    template.physicsBody.categoryBitMask = targetCategory;
    template.physicsBody.collisionBitMask = blockCategory;
    
    template.physicsBody.dynamic = NO;
    
    [self addChild:template];
    
    NSLog(@"template: %@", template);
}

/*
 * Create the back button for the current level.
 */
-(void) setupBackButton
{
    backButton = [[SKSpriteNode alloc] initWithColor:[UIColor purpleColor] size:CGSizeMake(100.0, 100.0)];
    backButton.position = CGPointMake(250.0, 250.0);
    [self addChild:backButton];
}

/*
 * Set recognizers for pan, rotate and tap gestures
 */
- (void)didMoveToView:(SKView *)view
{
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(pan:)];
    UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self
                                                                                                   action:@selector(rotate:)];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(tap:)];
    
    [[self view] addGestureRecognizer:rotationRecognizer];
    [[self view] addGestureRecognizer:gestureRecognizer];
    [[self view] addGestureRecognizer:tapGestureRecognizer];
}

/*
 * Rotate tangrams when they are tapped.
 *
 * TODO: we also need to rotate physics body with spite. CRITICAL.
 *
 */
-(void)tap:(UITapGestureRecognizer *)gesture
{
    SKNode *node = [self nodeAtPoint:[self convertPointFromView:[gesture locationInView:gesture.view]]];
    
    if ([node isKindOfClass:[BlockNode class]]) {
        SKAction *rotate = [SKAction rotateByAngle:M_PI_4 duration:0.25];
        [node runAction:rotate];
    }
    if ([node isEqual:backButton]){
            NSLog(@"Hit the thang");
            SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
            SKScene *levelSelctionScene = [[LevelSelectionScene alloc] initWithSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height)];
            [self.view presentScene:levelSelctionScene transition:reveal];
    }
}

/*
 * Handle a pan gesture. This is complex, so its handled in sub-cases.
 */
-(void)pan:(UIPanGestureRecognizer *)gesture
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

/*
 * Set the _selectedNode to the one being touched at a given location.
 */
-(void)selectNodeForTouch:(CGPoint)touchLocation
{
    SKNode *nodeAtPoint = [self nodeAtPoint:touchLocation];

    if ([nodeAtPoint isKindOfClass:[BlockNode class]]) {
        SKPhysicsBody *bodyAtPoint = [self.physicsWorld  bodyAtPoint:touchLocation];
        _selectedNode = (BlockNode *)bodyAtPoint.node;
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
    [self selectNodeForTouch:touchLocation];

    // set startPoint based on touchLocation
    startPoint.x = startPoint.x + _selectedNode.position.x - touchLocation.x;
    startPoint.y = startPoint.y + touchLocation.y - _selectedNode.position.y;
}

/*
 * Handle a continuing pan: move the _selectedNode to the location the gesture has moved to.
 */
-(void)handleContinuingPan:(UIPanGestureRecognizer *)gesture
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
-(void)handleEndingPan:(UIPanGestureRecognizer *)gesture
{
    // unsuccessful placement
    if (_selectedNode.contactType == TOUCHING_TANGRAM) {
        // in the case of unsuccessful placement, the selected node still be tranparent
        [_selectedNode setAlpha:1];
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


/*
 * Two finger rotate.
 */
-(void)rotate:(UIRotationGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CGPoint touchLocation = [gesture locationInView:gesture.view];
        touchLocation = [self convertPointFromView:touchLocation];
        [self selectNodeForTouch:touchLocation];
    }
    else if ((gesture.state == UIGestureRecognizerStateChanged) || gesture.state == UIGestureRecognizerStateEnded) {
        _rotation = _rotation - gesture.rotation;
        _selectedNode.zRotation = [self nearestAngleFromAngle:_rotation];
        gesture.rotation = 0.0;
    }
}

#pragma warning need to implement rotation modulo
- (CGFloat) nearestAngleFromAngle:(CGFloat) angle
{
    // mod angle by pi / 4 to get the number of 45 degreee rotations to move
    return angle;
    //return (M_2_PI/8) * fmodf(angle, M_2_PI);
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
    if ((firstBody.categoryBitMask & blockCategory) != 0) {
        if ((secondBody.categoryBitMask & blockCategory) != 0) {
            _selectedNode.contactType = TOUCHING_TANGRAM;
            [_selectedNode setAlpha:.4];
        }
    }
    
    // handle a block and a template touching
    // TODO: do we need another check here?
    if ((firstBody.categoryBitMask & targetCategory) != 0) {
        _selectedNode.contactType = TOUCHING_TARGET;
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
    if ((firstBody.categoryBitMask & blockCategory) != 0) {
        if ((secondBody.categoryBitMask & blockCategory) != 0) {
            _selectedNode.contactType = NO_CONTACT;
            [_selectedNode setAlpha:1];
        }
    }
}

// TODO: Maybe check for win condition in here??
// McQueen: Other option is checking for win condtion after every blocknode is placed. That might
// be nicer, so we don't continuously check for wins while the game is idle? Maybe it doesn't matter.
-(void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
}

@end