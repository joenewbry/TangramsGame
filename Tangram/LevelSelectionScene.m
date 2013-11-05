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
        self.backgroundColor = [UIColor blueColor];
        
        SKLabelNode *level1 = [[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
        level1.position = CGPointMake(self.size.width/2, self.size.height/2);
        level1.fontColor = [UIColor redColor];
        level1.text = @"Level 1";
        
        [self addChild:level1];
    }
    return self;
}

- (void)didMoveToView:(SKView *)view
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [[self view] addGestureRecognizer:tapGestureRecognizer];
}

-(void)tap:(UIGestureRecognizer*) gesture
{
    
    CGPoint touchLocation = [gesture locationInView:gesture.view];
    //[self getSelectedNode:touchLocation];
    SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
    SKScene *levelSelctionScene = [[LevelScene alloc] initWithSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view presentScene:levelSelctionScene transition:reveal];
}

//-(SKNode*)getSelectedNode:(CGPoint)touchLocation
//{
//    
//}

@end
