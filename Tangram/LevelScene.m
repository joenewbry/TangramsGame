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



@implementation LevelScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        [self setUpPhysics];
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        BlockNode *testBlock = [[BlockNode alloc] init];
        testBlock.physicsBody.categoryBitMask = blockCategory; // type of physics objects
        testBlock.physicsBody.collisionBitMask = 0; // collision with specified objects calls method
        testBlock.physicsBody.contactTestBitMask = blockCategory | wallCategory; // contact with specified object types calls method
        testBlock.position = CGPointMake(self.size.width/2, self.size.height/2);
        //testBlock.physicsBody.dynamic = YES;
        testBlock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(100.0, 100.0)];
        [self addChild:testBlock];
        
        SKSpriteNode *secondBlock = [[BlockNode alloc] init];
        secondBlock.position = CGPointMake(self.size.width/3, self.size.height/3);
        secondBlock.physicsBody.categoryBitMask = blockCategory;
        secondBlock.physicsBody.collisionBitMask = 0;
        secondBlock.physicsBody.contactTestBitMask = blockCategory | wallCategory;
        //secondBlock.physicsBody.dynamic = YES;
        secondBlock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(100.0, 100.0)];
    
        [self addChild:secondBlock];
        
//        SKSpriteNode * testing = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(100.0, 100.0)];
//        testing.position = CGPointMake(self.size.width/2, self.size.height/2);
//        testing.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(100.0, 100.0)];
//        testing.physicsBody.dynamic = YES;
//        testing.physicsBody.categoryBitMask = blockCategory;
//        testing.physicsBody.contactTestBitMask = blockCategory; // calls intersection method
//        testing.physicsBody.collisionBitMask = blockCategory;
//        [self addChild:testing];
    
    }
    return self;
}

- (void)setUpPhysics
{
    self.physicsWorld.gravity = CGVectorMake(0.0, -.3);
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
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {

    }
}

-(void)selectNodeForTouch:(CGPoint)touchLocation
{
        _selectedNode =  (BlockNode *)[self nodeAtPoint:touchLocation];
}

-(void)pan:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint touchLocation = [gesture locationInView:gesture.view];
        touchLocation = [self convertPointFromView:touchLocation];
        [self selectNodeForTouch:touchLocation];
    }
    
    else if ((gesture.state == UIGestureRecognizerStateChanged) ||
        gesture.state == UIGestureRecognizerStateEnded)
    {
        CGPoint translation = [gesture translationInView:self.view];
        _selectedNode.position = CGPointMake(_selectedNode.position.x + translation.x,
                                          _selectedNode.position.y - translation.y);
        [gesture setTranslation:CGPointMake(0, 0) inView:self.view];

        // check to see if object location is over the trash can, if it is remove the object
    }
    
    // use to determine when initial drag is completed
    // why does _selectedNode.isButton break; Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[SKSpriteNode isButton]: unrecognized selector sent to instance 0xa36ffc0'
    // break the system
    
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        SKSpriteNode *addBlock = [[BlockNode alloc] init];
        addBlock.position = CGPointMake(self.size.width/2, self.size.height/2);
        
        addBlock.physicsBody.categoryBitMask = blockCategory; // type of physics objects
        addBlock.physicsBody.collisionBitMask = blockCategory | wallCategory; // collision with specified objects calls method
        addBlock.physicsBody.contactTestBitMask = blockCategory | wallCategory; // contact with specified object types calls method
        [self addChild:addBlock];
        
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
    NSLog(@"contact occuring");
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
//    if ((firstBody.categoryBitMask & missileCategory) != 0)
//    {
//        [self attack: secondBody.node withMissile:firstBody.node];
//    }
//    ...
}

-(void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
}

@end