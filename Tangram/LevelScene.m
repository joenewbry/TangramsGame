//
//  LevelScene.m
//  Tangram
//
//  Created by Joe Newbry on 10/25/13.
//  Copyright (c) 2013 Joe Newbry. All rights reserved.
//

#import "LevelScene.h"
#import "BlockNode.h"

// the different categories used in collision detection
static const uint32_t blockCategory = 0x1 << 0;
static const uint32_t wallCategory = 0x1 << 1;
static const uint32_t targetCategory = 0x1 << 2;


/* each block type corresponds to a specific number
    0 - triangle
    1 - square
    2 - rhombus
    3 - trapezoid
*/
const float levelData[] = {0,1};

@interface LevelScene ()
{
    CGPoint startPoint;
}

@end

@implementation LevelScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        [self setupPhysics];
        
        [self setupBlocksInScene];
        
        [self setupTargetInScene];
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
//        BlockNode *testBlock = [[BlockNode alloc] init];
//        testBlock.physicsBody.categoryBitMask = blockCategory; // type of physics objects
//        testBlock.physicsBody.collisionBitMask = 0; // collision with specified objects calls method
//        testBlock.physicsBody.contactTestBitMask = blockCategory | wallCategory; // contact with specified object types calls method
//        testBlock.position = CGPointMake(self.size.width/2, self.size.height/2);
//        //testBlock.physicsBody.dynamic = YES;
//        testBlock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(100.0, 100.0)];
//        [self addChild:testBlock];
        
//        SKSpriteNode *secondBlock = [[BlockNode alloc] init];
//        secondBlock.position = CGPointMake(self.size.width/3, self.size.height/3);
//        secondBlock.physicsBody.categoryBitMask = blockCategory;
//        secondBlock.physicsBody.collisionBitMask = 0;
//        secondBlock.physicsBody.contactTestBitMask = blockCategory | wallCategory;
//        //secondBlock.physicsBody.dynamic = YES;
//        secondBlock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(100.0, 100.0)];
//    
//        [self addChild:secondBlock];
        
//        SKSpriteNode * redBlock = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(100.0, 100.0)];
//        redBlock.position = CGPointMake(self.size.width/2, self.size.height/2);
//        redBlock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(100.0, 100.0)];
//        redBlock.physicsBody.dynamic = YES;
//        redBlock.physicsBody.categoryBitMask = blockCategory;
//        //redBlock.physicsBody.contactTestBitMask = blockCategory; // calls intersection method
//        redBlock.physicsBody.collisionBitMask = blockCategory;
//        [self addChild:redBlock];
//        
//        SKSpriteNode * greenBlock = [SKSpriteNode spriteNodeWithColor:[UIColor greenColor] size:CGSizeMake(100.0, 100.0)];
//        greenBlock.position = CGPointMake(self.size.width/3, self.size.height/3);
//        greenBlock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(100.0, 100.0)];
//        greenBlock.physicsBody.dynamic = YES;
//        greenBlock.physicsBody.categoryBitMask = blockCategory;
//        greenBlock.physicsBody.contactTestBitMask = blockCategory; // calls intersection method
//        greenBlock.physicsBody.collisionBitMask = blockCategory;
//        [self addChild:greenBlock];
    }
    return self;
}

-(void)setupBlocksInScene
{

    for (int i = 0; i < sizeof(levelData); i++)
    {
        if (levelData[i] == 0)
        {
            SKSpriteNode *triangleBlock = [SKSpriteNode spriteNodeWithColor:[UIColor yellowColor] size:CGSizeMake(100.0, 100.0)];
            triangleBlock.position = CGPointMake(self.size.width/ 5 + self.size.width / 5 * i, self.size.height / 3);
            triangleBlock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(100.0, 100.0)];
            triangleBlock.physicsBody.categoryBitMask = blockCategory;
            triangleBlock.physicsBody.contactTestBitMask = blockCategory | targetCategory | wallCategory;
            triangleBlock.physicsBody.collisionBitMask = 0;
            triangleBlock.physicsBody.dynamic = YES;
            
            //[triangleBlock setAnchorPoint:CGPointMake(triangleBlock.size.width/3, triangleBlock.size.width/3)];
            
            [self addChild:triangleBlock];
        }
        else if(levelData[i] == 1)
        {
            SKSpriteNode *squareBlock = [SKSpriteNode spriteNodeWithColor:[UIColor greenColor] size:CGSizeMake(100.0, 100.0)];
            squareBlock.position = CGPointMake(self.size.width/ 5 + self.size.width / 5 * i, self.size.height / 3);
            squareBlock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(100.0, 100.0)];
            squareBlock.physicsBody.categoryBitMask = blockCategory;
            squareBlock.physicsBody.contactTestBitMask = blockCategory | targetCategory | wallCategory;
            squareBlock.physicsBody.collisionBitMask = 0;
            squareBlock.physicsBody.dynamic = YES;
            
            [self addChild:squareBlock];
            
        }
        else if (levelData[i] == 2)
        {
            SKSpriteNode *rhombusBlock = [SKSpriteNode spriteNodeWithColor:[UIColor orangeColor] size:CGSizeMake(100.0, 100.0)];
            rhombusBlock.position = CGPointMake(self.size.width/ 5 + self.size.width / 5 * i, self.size.height / 3);
            [self addChild:rhombusBlock];
        }
        else if (levelData[i] == 3)
        {
            SKSpriteNode *trapezoidBlock = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(100.0, 100.0)];
            trapezoidBlock.position = CGPointMake(self.size.width/ 5 + self.size.width / 5 * i, self.size.height / 3);
            [self addChild:trapezoidBlock];
        }
    
    }
}


-(void)setupTargetInScene
{
    SKSpriteNode *largeSquareTarget = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size: CGSizeMake(200, 200)];
    largeSquareTarget.position = CGPointMake(self.size.width, self.size.height/3 *2);
    [self addChild:largeSquareTarget];
}

- (void)setupPhysics
{
    self.physicsWorld.gravity = CGVectorMake(0.0, -0.0);
    self.physicsWorld.contactDelegate = self;
}

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

-(void)tap:(UITapGestureRecognizer *)gesture
{
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {

    }
}

-(void)selectNodeForTouch:(CGPoint)touchLocation
{
    // update so that node is only selected if touchLocation is within the physics body
    _selectedNode =  [self nodeAtPoint:touchLocation];
}

-(void)pan:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint touchLocation = [gesture locationInView:gesture.view];
        startPoint = touchLocation;
        
        touchLocation = [self convertPointFromView:touchLocation];
        [self selectNodeForTouch:touchLocation];
        _selectedNode.position = touchLocation;
//        _selectedNode.physicsBody.dynamic = NO;
        [_selectedNode setScale:.5];
        //[_selectedNode setAlpha:.8];
    }
    
    else if ((gesture.state == UIGestureRecognizerStateChanged) ||
        gesture.state == UIGestureRecognizerStateEnded)
    {
        
        CGPoint translation = [gesture translationInView:self.view];
        _selectedNode.position = CGPointMake(_selectedNode.position.x + translation.x,
                                          _selectedNode.position.y - translation.y);
        [gesture setTranslation:CGPointMake(0, 0) inView:self.view];
//        CGPoint touchLocation = [gesture locationInView:gesture.view];
//        _selectedNode.position = touchLocation;

        // check to see if object location is over the trash can, if it is remove the object
    }
    
    // use to determine when initial drag is completed
    // why does _selectedNode.isButton break; Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[SKSpriteNode isButton]: unrecognized selector sent to instance 0xa36ffc0'
    // break the system
    
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        // check to see if node overlaps with any other nodes
        
        // set selected node scale back to default size
        [_selectedNode setScale:1];
        [_selectedNode setAlpha:1];
        
        // adding node if the motion is ended
//        SKSpriteNode *addBlock = [[BlockNode alloc] init];
//        addBlock.position = CGPointMake(self.size.width/2, self.size.height/2);
//        
//        addBlock.physicsBody.categoryBitMask = blockCategory; // type of physics objects
//        addBlock.physicsBody.collisionBitMask = blockCategory | wallCategory; // collision with specified objects calls method
//        addBlock.physicsBody.contactTestBitMask = blockCategory | wallCategory; // contact with specified object types calls method
//       [self addChild:addBlock];
//
//        _selectedNode.physicsBody.dynamic = YES;
        
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
    if ((firstBody.categoryBitMask & blockCategory) == 0)
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

-(void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
}

@end