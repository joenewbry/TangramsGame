//
//  LevelModel.m
//  Tangram
//
//  Created by Sean McQueen on 10/28/13.
//  Copyright (c) 2013 Joe Newbry. All rights reserved.
//

#import "LevelModel.h"

@implementation LevelModel

- (id)initWithLevel:(int)level
{
    self = [super init];
    
    if (self) {
        // import data from plist
        // take the level data at index `level`
        // Format data so it looks like hard-coded data.
    
        // for w/e in plist's shapecount:
        //   if square: self.shapecount[0] = value
        
        self.shapeCount = @[@(3),@(2),@(4),@(1)];
        self.outlineFilepath = @"tri-blink.png";
        
        self.outlineNumberOfTriangles = 2;
        
        // Store X and Y coordinates of each line segment comprising the physics body outline.
        self.physicsBodyCoords = @[ @[@(18), @(16)], @[@(186), @(17)], @[@(19), @(182)] ];
    }
    return self;
}

@end
