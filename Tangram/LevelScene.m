//
//  LevelScene.m
//  Tangram
//
//  Created by Joe Newbry on 10/25/13.
//  Copyright (c) 2013 Joe Newbry. All rights reserved.
//

#import "LevelScene.h"

// the different categories used in collision detection
static const uint32_t blockCategory = 0x1 << 0;
static const uint32_t wallCategory = 0x1 << 1;
static const uint32_t targetCategory = 0x1 << 2;
static const uint32_t trashCategory = 0x1 << 3;

@interface LevelScene ()
{
    CGPoint startPoint; // stores starting touch location if final block placement is incorrect
    CGFloat _rotation;
    BlockNode *_selectedNode;
    SKLabelNode *trianglesRemaining;
    SKLabelNode *squaresRemaining;
}

@end

@implementation LevelScene


- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        // TODO: change this sop that initiWithLevel passes the right level int
        // inialize the model
        self.levelModel = [[LevelModel alloc] initWithLevel:0];
        
        self.triangleCount = [self.levelModel.shapeCount[TRIANGLE] integerValue];
        self.squareCount = [self.levelModel.shapeCount[SQUARE] integerValue];
        self.trapezoidCount = [self.levelModel.shapeCount[TRAPEZOID] integerValue];
        self.rhombusCount = [self.levelModel.shapeCount[RHOMBUS] integerValue];
        
        [self setupPhysics];
        [self setupBlocksInScene];
        [self setupTargetInScene];
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
    }
    return self;
}


// TODO: change this so the initilization is from BlockNode rather than SKSpriteNode (takes one extra parameter specifying name or type)
// TODO: move setup logic into BlockNode class rather than in these methods
-(void)setupBlocksInScene
{

    if (self.triangleCount > 0){
        
        CGPoint trianglePoint = CGPointMake(self.size.width/ 5, self.size.height / 3);
        BlockNode *triangleBlock = [self createNode:TRIANGLE withPoint:trianglePoint];
        [self addChild:triangleBlock];
      
        CGPoint triangleLabelPoint = CGPointMake(triangleBlock.position.x, triangleBlock.position.y - 75);
        trianglesRemaining = [self labelNodeWithRemaining:self.triangleCount at:triangleLabelPoint];
        [self addChild:trianglesRemaining];
    }
    
    if (self.squareCount > 0) {
        
        CGPoint squarePoint  = CGPointMake(self.size.width/ 5 + (self.size.width / 5), self.size.height / 3);
        BlockNode *squareBlock = [self createNode:SQUARE withPoint:squarePoint];
        [self addChild:squareBlock];
        
        CGPoint squareLabelPoint = CGPointMake(squareBlock.position.x, squareBlock.position.y - 75);
        squaresRemaining = [self labelNodeWithRemaining:self.squareCount at:squareLabelPoint];
        [self addChild:squaresRemaining];
    }
    
    if (self.rhombusCount > 0) {
        // draw a rhombus
       
        // set rhomuses remaining
    }

    if (self.trapezoidCount > 0) {
        // draw a trapezoid
        
        // set trapezoids remaining
    }
}

- (BlockNode *)createNode:(BlockType)type withPoint:(CGPoint) point
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


// TODO: add in physics body outline and figure out how to determine if shap is filled
-(void)setupTargetInScene
{
    SKSpriteNode *largeSquareTarget = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size: CGSizeMake(200, 200)];
    largeSquareTarget.position = CGPointMake(self.size.width/2, self.size.height/3 *2);
    largeSquareTarget.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0.0, 0.0, 200, 200)];
    largeSquareTarget.physicsBody.categoryBitMask = targetCategory;
    largeSquareTarget.physicsBody.collisionBitMask = blockCategory;
    [self addChild:largeSquareTarget];
}

- (void)setupPhysics
{
    self.physicsWorld.gravity = CGVectorMake(0.0, -0.0);
    self.physicsWorld.contactDelegate = self;
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
    
}

// TODO update so that node is only selected if touchLocation is within the physics body rather than bounds of object

-(void)selectNodeForTouch:(CGPoint)touchLocation
{
    if ([[self nodeAtPoint:touchLocation] isKindOfClass:[BlockNode class]])
    {
        _selectedNode = (BlockNode *)[self nodeAtPoint:touchLocation];
    }
    else
    {
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
            
            int thisCount = -1;
            switch (_selectedNode.objectType) {
                case TRIANGLE:
                    thisCount = --self.triangleCount;
                    trianglesRemaining.text =  [NSString stringWithFormat:@"%i", self.triangleCount];
                    break;
                case SQUARE:
                    thisCount = --self.squareCount;
                    squaresRemaining.text = [NSString stringWithFormat:@"%i", self.squareCount];
                    break;
                case RHOMBUS:
                    thisCount = --self.rhombusCount;
                    break;
                case TRAPEZOID:
                    thisCount = --self.trapezoidCount;
                    break;
                default:
                    break;
            }
            
            // a block should be added if there is more than 1 block left
            if (thisCount > 0)
            {
                BlockNode *addBlock = [[BlockNode alloc] initWithBlockType:_selectedNode.objectType];
                addBlock.position = CGPointMake(self.size.width/ 5 , self.size.height / 3);
                addBlock.physicsBody.categoryBitMask = blockCategory;
                addBlock.physicsBody.contactTestBitMask = blockCategory | targetCategory | wallCategory;
                addBlock.physicsBody.collisionBitMask = 0;
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
        [_selectedNode setAlpha:.4];
    }
    
    if ((firstBody.categoryBitMask & targetCategory) != 0)
    {
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