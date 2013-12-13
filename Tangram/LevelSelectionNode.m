//
//  LevelSelectionNode.m
//  Tangram
//
//  Created by Sean McQueen on 11/4/13.
//  Copyright (c) 2013 Joe Newbry. All rights reserved.
//

#import "LevelSelectionNode.h"

@interface LevelSelectionNode ()
{
    SKAction *moveToCenter;
    SKAction *scaleToFullSize;
}

@end

@implementation LevelSelectionNode

-(id)initWithLevel:(int)level
{
    
    NSArray * levelTiles = @[ @"level-tiles-1.png", @"level-tiles-2.png", @"level-tiles-3.png", @"level-tiles-4.png", @"level-tiles-5.png", @"level-tiles-6.png", @"level-tiles-7.png",@"level-tiles-8.png"];

    if (self = [super initWithImageNamed:levelTiles[level]]) 
    {
        self.level = level;
        
//        // create shape
//        [self setColor:[UIColor colorWithHue:0.315 saturation:0.220 brightness:0.875 alpha:1]];
//        [self setSize:CGSizeMake(150.0, 150.0)];
        
    }
    return self;
}

@end
