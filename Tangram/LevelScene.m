//
//  LevelScene.m
//  Tangram
//
//  Created by Joe Newbry on 10/25/13.
//  Copyright (c) 2013 Joe Newbry. All rights reserved.
//

#import "LevelScene.h"
#import "LevelWonScene.h"

@interface LevelScene ()
{
    CGPoint startPoint; // stores starting touch location if final block placement is incorrect
    CGFloat _rotation;
    BlockNode *_selectedNode;
    
    int shapeCount[NUM_SHAPES];
    CGPoint shapeStartingPoints[NUM_SHAPES];
    CGPoint shapeLabelPoints[NUM_SHAPES];
    BOOL isRetina;  // device has a Retina display.

    SKSpriteNode *backButton;
    SKSpriteNode *pauseButton;

    TemplateNode *template;
    TemplateEdgeNode *templateEdge;

}



@property (strong, nonatomic) NSTimer *timeElapsed;
@property (strong, nonatomic) NSDate *startDate;

- (void) setupPhysics;
- (void) setupTangramDrawer;
- (void) setupTemplateWithModel:(LevelModel *)levelModel;
- (void) setupBackButton;
- (void) selectNodeForTouch:(CGPoint)touchLocation;
- (void) handleBeginningPan:(UIPanGestureRecognizer *)gesture;
- (void) handleContinuingPan:(UIPanGestureRecognizer *)gesture;
- (void) handleEndingPan:(UIPanGestureRecognizer *)gesture;
- (void) updateDrawerWithBlockType:(BlockType) type;
- (void) rotate:(UIRotationGestureRecognizer *)gesture;

@end


@implementation LevelScene

- (id)initWithLevel:(int)level AndSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        if (debugMode) [YMCPhysicsDebugger init];

        self.levelModel = [[LevelModel alloc] initWithLevel:level];
        
        // convert shapeCount to ints
        for (int i = 0; i < self.levelModel.shapeCount.count; i++) {
            shapeCount[i] = [self.levelModel.shapeCount[i] integerValue];
        }
        
        // call setup methods
        [self setupPhysics];
        [self setupTangramDrawer];
        [self setupTemplateWithModel:self.levelModel];
        [self setupTemplateEdgeWithModel:self.levelModel];
        [self setupBackButton];
        [self setupPauseButton];
        
        self.backgroundColor = [UIColor colorWithHue:0.359 saturation:0.051 brightness:1.000 alpha:1];
        
        // Figure out if device has Retina display.
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0)) {
            isRetina = YES;
        } else {
            isRetina = NO;
        }

        if (debugMode) [self drawPhysicsBodies];
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
- (void)setupTangramDrawer
{
    float blockOffset = 20;
    float placementHeight = self.size.height / 10;
    shapeStartingPoints[TRIANGLE] = CGPointMake(blockOffset + 100, placementHeight);
    shapeStartingPoints[TRAPEZOID] = CGPointMake(blockOffset + 240, placementHeight);
    shapeStartingPoints[PARALLELOGRAM] = CGPointMake(blockOffset + 450, self.size.height / 9);
    shapeStartingPoints[SQUARE] = CGPointMake(blockOffset + 630, placementHeight);
    
    // initialize the tangrams as sprites and add them to the scene
    for (int i=0; i < NUM_SHAPES; i++){
        if (shapeCount[i] > 0){
            BlockNode *block = [self createNodeWithType:i withPoint:shapeStartingPoints[i]];
            block.physicsBody.usesPreciseCollisionDetection = YES;
            [self addChild:block];
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
    template = [[TemplateNode alloc] initWithModel:levelModel deviceIsRetina:isRetina];
    template.position = CGPointMake(self.size.width/2, self.size.height/3 *2);
    //NSLog(@"screen size is %f, %f", self.size.width, self.size.height);
    [self addChild:template];
}


- (void)setupTemplateEdgeWithModel:(LevelModel *)levelModel
{
    templateEdge = [[TemplateEdgeNode alloc] initWithModel:levelModel deviceIsRetina:isRetina];
    templateEdge.position = CGPointMake(self.size.width/2, self.size.height/3 *2);
    [self addChild:templateEdge];
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

-(void) setupPauseButton
{
    //pauseButton = [[SKSpriteNode alloc] initWithImageNamed:@"
}

/*
 * Set recognizers for pan, rotate and tap gestures
 */
- (void)didMoveToView:(SKView *)view
{    
    UIRotationGestureRecognizer *rotateRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(rotate:)];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(pan:)];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(tap:)];
    [[self view] addGestureRecognizer:rotateRecognizer];
    [[self view] addGestureRecognizer:panRecognizer];
    [[self view] addGestureRecognizer:tapGestureRecognizer];
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
    if ([_selectedNode isKindOfClass:[BlockNode class]]) {
        BlockNode *blockNode = (BlockNode *)_selectedNode;
        SKAction *rotate = [SKAction rotateByAngle:M_PI_4 duration:ROTATE_DURATION];
        [blockNode runAction:rotate];
        [blockNode shouldBlink];
        
        // Check if collision occurs. If so, rotate back.
        // Need to do this in another thread b/c rotate takes 0.25 sec to register contact.
        dispatch_async(dispatch_queue_create("check contact", nil), ^{
            [NSThread sleepForTimeInterval:ROTATE_DURATION];
            if (blockNode.touchingTangram == YES) {
                SKAction *rotateBack = [SKAction rotateByAngle:-M_PI_4 duration:0.25];
                [blockNode runAction:rotateBack];
                dispatch_async(dispatch_queue_create("unblink", nil), ^{
                    [NSThread sleepForTimeInterval:ROTATE_DURATION];
                    [blockNode shouldUnblink];
                });
            } else {
                [blockNode shouldUnblink];
            }
        });
    }
    
    // Handle backbutton
    else if ([_selectedNode isEqual:backButton]){
            SKTransition *reveal = [SKTransition flipVerticalWithDuration:0.5];
            SKScene *levelSelctionScene = [[LevelSelectionScene alloc] initWithSize:CGSizeMake(self.view.bounds.size.width,
                                                                                               self.view.bounds.size.height)];
            [self.view presentScene:levelSelctionScene transition:reveal];
    }
}

/*
 * Handle a pan gesture. This is complex, so its handled in sub-cases.
 */
- (void)pan:(UIPanGestureRecognizer *)gesture
{
    // if _selectedNode is a BlockNode, handle panning
    // this allows us to assume _selectedNode is a tangram in all subsequent handle methods
    if (_selectedNode && [_selectedNode isKindOfClass:[BlockNode class]]) {
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
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    touchLocation = [self.view convertPoint:touchLocation fromView:self.view];
    [self selectNodeForTouch:touchLocation];
}

/*
 * Set the _selectedNode to the one being touched at a given location.
 */
-(void)selectNodeForTouch:(CGPoint)touchLocation
{
    // in debugMode, we have a physicsbody outline/overlay that we don't want to accidentally grab
    if (debugMode) {
        NSArray * possibleNodes = [self nodesAtPoint:touchLocation];

        // update _selectedNode only if possibleNodes is not empty
        if (possibleNodes.count != 0) {
            _selectedNode = (BlockNode *)possibleNodes[0];
        } else {
            _selectedNode = nil;
        }
    } else {
        // if no node at location, this does not update _selectedNode
        _selectedNode = (BlockNode *)[self nodeAtPoint:touchLocation];
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
    [_selectedNode shouldBlink];
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
    [_selectedNode shouldUnblink];
    
    // unsuccessful placement
    if (_selectedNode.touchingTangram) {
        
        // wiggle, then slide back to old position
        [_selectedNode shouldWiggleSlideTo:CGPointMake(startPoint.x, self.size.height - startPoint.y)];
        _selectedNode.touchingTangram = NO;
    }
    
    // successful placement
    else {
        
        // if the tangram started inside the template
        if (_selectedNode.isInsideTemplate) {
            // if the tangram ends up outside the template
            if (!(_selectedNode.touchingTemplateVolumn) || _selectedNode.touchingTemplateEdge) {
                _selectedNode.isInsideTemplate = NO;
                
                template.numberOfTrianglesInside -= _selectedNode.tangramTriangleNumber;
                NSLog(@"template is %d triangles away from being full", template.triangleNumber - template.numberOfTrianglesInside);
            }
            
        // otherwise tangram started outside the template
        } else {
            // if the tangram ends up inside the template
            if (_selectedNode.touchingTemplateVolumn && !(_selectedNode.touchingTemplateEdge)) {
                _selectedNode.isInsideTemplate = YES;
                
                template.numberOfTrianglesInside += _selectedNode.tangramTriangleNumber;
                NSLog(@"template is %d triangles away from being full", template.triangleNumber - template.numberOfTrianglesInside);
            }
        }
        
        if (_selectedNode.touchingDrawer) {
            // TODO: deal with this case
        }
        
        // if the tangram came from the drawer, update the drawer
        if (_selectedNode.inDrawer) {
            _selectedNode.inDrawer = NO;
            [self updateDrawerWithBlockType:_selectedNode.objectType];
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
    // do noting on rotate. can we remove this method?
    // when we remove it, shit breaks -- we should figure that out eventually.
}

- (BOOL) isGameWon
{
    // if the number of triangles in the template equals its triangle number, it is full
    return (template.numberOfTrianglesInside == template.triangleNumber);
}

- (void) gameWon
{
    
    NSArray * possibleTangrams = @[TRIANGLE_FILE, SQUARE_FILE, TRAPEZOID_FILE, PARALLELOGRAM_FILE,
                                   TRIANGLE_FILE_BLINK, SQUARE_FILE_BLINK, TRAPEZOID_FILE_BLINK, PARALLELOGRAM_FILE_BLINK];

    dispatch_async(dispatch_queue_create("sleep then open", nil), ^{
        [NSThread sleepForTimeInterval:2.75];
        CGSize size = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
        LevelSelectionScene * nextScene = [[LevelSelectionScene alloc] initWithSize:size];
        
        SKTransition *reveal = [SKTransition flipVerticalWithDuration:0.5];
        [self.view presentScene:nextScene transition:reveal];
    });
    
    
    for (int i = 0; i < 100; i++) {
        // set up random numbers
        NSInteger randomNumber = arc4random() % 8;
        CGFloat randomX = self.size.width * ((double)arc4random() / 0x100000000);
        CGFloat randomY = self.size.height * ((double)arc4random() / 0x100000000);
        
        CGFloat randomEntrance = 1.5 * ((double)arc4random() / 0x100000000);
        CGFloat randomExit = 1.5 * ((double)arc4random() / 0x100000000);

        // create a new node and give it
        SKSpriteNode * newIcon = [[SKSpriteNode alloc] initWithImageNamed:possibleTangrams[randomNumber]];
        newIcon.position = CGPointMake(randomX, randomY);
        newIcon.alpha = 0;
        [self addChild:newIcon];
        
        SKAction * comeIn = [SKAction fadeAlphaTo:1 duration:randomEntrance];
        SKAction * wait = [SKAction waitForDuration:1];
        SKAction * goOut = [SKAction fadeAlphaTo:0 duration:randomExit];
        
        SKAction * inAndOut = [SKAction sequence:@[comeIn, wait, goOut, wait]];
        [newIcon runAction: inAndOut];
    }
    
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
        _selectedNode.touchingTangram = YES;
        [_selectedNode shouldFrown];
    }
    
    // handle a block and a template touching
    if ((secondBody.categoryBitMask & targetCategory) != 0) {
        _selectedNode.touchingTemplateVolumn = YES;
    }
    
    // handle a block and a edge touching
    if ((secondBody.categoryBitMask & edgeCategory) != 0) {
        _selectedNode.touchingTemplateEdge = YES;
        [_selectedNode shouldFrown];
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
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }

    // handle two blocks ending contact with each other
    if ((secondBody.categoryBitMask & blockCategory) != 0) {
        _selectedNode.touchingTangram = NO;
        [_selectedNode shouldBlink];
    }
    
    // handle tangram ending contact with volumn
    if ((secondBody.categoryBitMask & targetCategory) != 0){
        _selectedNode.touchingTemplateVolumn = NO;
    }
    
    // handle tangram ending contact with edge
    if ((secondBody.categoryBitMask & edgeCategory) != 0){
        _selectedNode.touchingTemplateEdge = NO;
    }
}


-(void)update:(NSTimeInterval)currentTime{

}

@end
