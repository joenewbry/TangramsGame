//
//  LevelSelectionNode.m
//  Tangram
//
//  Created by Sean McQueen on 11/4/13.
//  Copyright (c) 2013 Joe Newbry. All rights reserved.
//

#import "LevelSelectionNode.h"

@implementation LevelSelectionNode

-(id)initWithLevel:(int)level
{
    if (self = [super init])
    {
        self.level = level;
        
        // create shape
        [self setColor:[UIColor orangeColor]];
        [self setSize:CGSizeMake(100.0, 100.0)];
        [self setPhysicsBody:[SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(100.0, 100.0)]];
    }
    return self;
}

@end