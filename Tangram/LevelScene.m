//
//  LevelScene.m
//  Tangram
//
//  Created by Joe Newbry on 10/25/13.
//  Copyright (c) 2013 Joe Newbry. All rights reserved.
//

#import "LevelScene.h"
#import "BlockNode.h"



@implementation LevelScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKSpriteNode *testBlock = [[BlockNode alloc] init];
        testBlock.position = CGPointMake(self.size.width/2, self.size.height/2);
        //[testBlock setScale:50];
        [self addChild:testBlock];
        
        
        
        SKSpriteNode *secondBlock = [[BlockNode alloc] init];
        secondBlock.position = CGPointMake(self.size.width/3, self.size.height/3);
        [self addChild:secondBlock];
        
//        UIButton *spaceShip = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2,
//                                                                         self.frame.size.height - 40.0,
//                                                                         100.0, 25.0)];
//        [self add:spaceShip];
        
    }
    return self;
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
        //CGPoint location = [touch locationInNode:self];
        
        // later on store an array of objects
        
//        if([_testBlock containsPoint:location])
//        {
//            
//        }
    }
}

-(void)selectNodeForTouch:(CGPoint)touchLocation
{
    _selectedNode =  (SKSpriteNode *)[self nodeAtPoint:touchLocation];
    
    
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
        
        //CGPoint location = [gesture locationInView:self.view];
    
//        
//        if ([_selectedNode containsPoint:location]) {
//            NSLog(@"Pan Detected");
//        }
        
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

-(void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
}

@end