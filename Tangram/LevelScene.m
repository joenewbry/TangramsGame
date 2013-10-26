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
        
        _testBlock = [[BlockNode alloc] init];
        _testBlock.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:_testBlock];
        
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

-(void)pan:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan)
    {

    }
    
    else if ((gesture.state == UIGestureRecognizerStateChanged) ||
        gesture.state == UIGestureRecognizerStateEnded)
    {
        CGPoint translation = [gesture translationInView:self.view];
        _testBlock.position = CGPointMake(_testBlock.position.x + translation.x,
                                          _testBlock.position.y - translation.y);
        [gesture setTranslation:CGPointMake(0, 0) inView:self.view];
        
        if ([_testBlock containsPoint:[gesture locationInView:(UIView *)self.view]]) {
            NSLog(@"Rotation Detected");
        }
        
    }
}

-(void)rotate:(UIRotationGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        gesture.state == UIGestureRecognizerStateEnded)
    {
        _rotation = _rotation + gesture.rotation;
        _testBlock.zRotation = _rotation;
        
        gesture.rotation = 0.0;
        
        
        if ([_testBlock containsPoint:[gesture locationInView:(UIView *)self.view]]) {
            NSLog(@"Rotation Detected");
        }
    }
}

-(void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
}

@end