//
//  LevelSelectionScene.m
//  Tangram
//
//  Created by Joe Newbry on 10/31/13.
//  Copyright (c) 2013 Joe Newbry. All rights reserved.
//

#import "LevelSelectionScene.h"
#import "LevelScene.h"

@implementation LevelSelectionScene

// TODO: add three different levels & navigation between levels
- (id)initWithSize:(CGSize) size
{
     if (self = [super initWithSize:size])
    {
        self.backgroundColor = [UIColor blackColor];
        
        SKSpriteNode *firstLevel = [[SKSpriteNode alloc] initWithColor:[UIColor purpleColor] size:CGSizeMake(100.0, 100.0)];
        [self addChild:firstLevel];
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
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(tap:)];
    [[self view] addGestureRecognizer:tapGestureRecognizer];
    
}

-(void)pan:(UIGestureRecognizer*) gesture
{
    
}

-(void)rotate:(UIGestureRecognizer*) gesture
{
    
}

-(void)tap:(UIGestureRecognizer*) gesture
{
    SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
    SKScene *levelSelctionScene = [[LevelScene alloc] initWithSize:CGSizeMake(1024, 768)];
    [self.view presentScene:levelSelctionScene transition:reveal];
}

@end
