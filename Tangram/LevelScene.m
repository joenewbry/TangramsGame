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
}

@property (strong, nonatomic) NSTimer *timeElapsed;
@property (strong, nonatomic) NSDate *startDate;

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
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
    }
    return self;
}

- (void)setupPhysics
{
    self.physicsWorld.gravity = CGVectorMake(0.0, -0.0);
    self.physicsWorld.contactDelegate = self;
}

-(void)setupTangramDrawer
{
    // set tangram starting points
    float placementWidth = self.size.width / 5;
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

- (BlockNode *)createNodeWithType:(BlockType)type withPoint:(CGPoint) point
{
    BlockNode * block = [[BlockNode alloc] initWithBlockType:type];
    block.position = point;
    block.physicsBody.categoryBitMask = blockCategory;
    block.physicsBody.contactTestBitMask = blockCategory | targetCategory | wallCategory;
    block.physicsBody.collisionBitMask = 0;
    block.isButton = true;
    return block;
}

- (SKLabelNode *)labelNodeWithRemaining:(int)numRemaining at:(CGPoint)labelPoint
{
    SKLabelNode * shapeRemaining = [[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
    shapeRemaining.fontColor = [UIColor greenColor];
    shapeRemaining.text =  [NSString stringWithFormat:@"%i", numRemaining];
    shapeRemaining.position = labelPoint;
    return shapeRemaining;
}

// TODO: this needs to come from the model
-(void)setupTargetInScene
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

// sets recognizers for pan, rotate, and tap gestures
- (void)didMoveToView:(SKView *)view
{
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(pan:)];
    [[self view] addGestureRecognizer:gestureRecognizer];
    
    UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self
                                                                                                   action:@selector(rotate:)];
    [[self view] addGestureRecognizer:rotationRecognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(tap:)];
    [[self view] addGestureRecognizer:tapGestureRecognizer];
}

// TODO navigation objects added and recognized/responded to here
-(void)tap:(UITapGestureRecognizer *)gesture
{
    SKNode *node = [self nodeAtPoint:[self convertPointFromView:[gesture locationInView:gesture.view]]];
    
    if ([node isKindOfClass:[BlockNode class]]) {
        SKAction *rotate = [SKAction rotateByAngle:M_PI_4 duration:0.25];
        [node runAction:rotate];
    }
}

// TODO update so that node is only selected if touchLocation is within the physics body rather than bounds of object
-(void)selectNodeForTouch:(CGPoint)touchLocation
{
    if ([[self nodeAtPoint:touchLocation] isKindOfClass:[BlockNode class]]) {
        SKPhysicsBody *bodyAtPoint = [self.physicsWorld  bodyAtPoint:touchLocation];
        _selectedNode = (BlockNode *)bodyAtPoint.node;
    }
    else {
        _selectedNode = nil;
    }
}

// TODO: check to see if object location is over the trash can, if it is remove the object
// TODO: add in block counting functionality so on drop from pallet a new block is added
// TODO (not critical): fix initial point calculation stuff
-(void)pan:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint touchLocation = [gesture locationInView:gesture.view];
        startPoint = touchLocation;
        
        touchLocation = [self convertPointFromView:touchLocation];
        [self selectNodeForTouch:touchLocation];
        
        startPoint.x = startPoint.x + _selectedNode.position.x - touchLocation.x;
        startPoint.y = startPoint.y + touchLocation.y - _selectedNode.position.y;
        _selectedNode.position = touchLocation;
        
        [_selectedNode setScale:.9];
        [_selectedNode setZPosition:100.0];
    }
    
    else if ((gesture.state == UIGestureRecognizerStateChanged) ||
        gesture.state == UIGestureRecognizerStateEnded)
    {
        
        CGPoint translation = [gesture translationInView:self.view];
        _selectedNode.position = CGPointMake(_selectedNode.position.x + translation.x,
                                          _selectedNode.position.y - translation.y);
        [gesture setTranslation:CGPointMake(0, 0) inView:self.view];
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        
        if (_selectedNode.alpha != 1.0)
        {
            [_selectedNode setPosition:CGPointMake(startPoint.x, self.size.height - startPoint.y)];
        }
        else if (_selectedNode.isButton)
        {
            _selectedNode.isButton = false;
            shapeCount[_selectedNode.objectType]--;
            shapesRemaining[_selectedNode.objectType].text = [NSString stringWithFormat:@"%i", shapeCount[_selectedNode.objectType]];
            
            // a block should be added if there is more than 1 block left
            if (shapeCount[_selectedNode.objectType] > 0)
            {
                BlockNode  *addBlock = [self createNodeWithType:_selectedNode.objectType
                                                      withPoint:shapeStartingPoints[_selectedNode.objectType]];

                [self addChild:addBlock];
            }
        }
        
        // set selected node scale back to default size and alpha and zPosition
        [_selectedNode setScale:1];
        [_selectedNode setAlpha:1];
        [_selectedNode setZPosition:1.0];
    }
}

-(void)rotate:(UIRotationGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint touchLocation = [gesture locationInView:gesture.view];
        touchLocation = [self convertPointFromView:touchLocation];
        [self selectNodeForTouch:touchLocation];
    }
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        gesture.state == UIGestureRecognizerStateEnded)
    {
        _rotation = _rotation - gesture.rotation;
        _selectedNode.zRotation = _rotation;
        gesture.rotation = 0.0;
    }
    

}


// TODO: block collision with target handled
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
    
    if ((firstBody.categoryBitMask & blockCategory) != 0) {
        [_selectedNode setAlpha:.4];
    }
    
    if ((firstBody.categoryBitMask & targetCategory) != 0) {
        NSLog(@"Hit block");
    }
}

- (void)didEndContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    if ((firstBody.categoryBitMask & blockCategory) != 0)
    {
        [_selectedNode setAlpha:1];
    }
}

// TODO: Maybe check for win condition in here??
-(void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
}

@end