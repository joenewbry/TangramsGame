//
//  BlockNode.m
//  Tangram
//
//  Created by Joe Newbry on 10/25/13.
//  Copyright (c) 2013 Joe Newbry. All rights reserved.
//

#import "BlockNode.h"

@implementation BlockNode


-(id)initWithBlockType:(BlockType)blockType
{
    if (self = [super init])
    {
        [self.physicsBody setDynamic:YES];
        [self.physicsBody setUsesPreciseCollisionDetection:YES];
        
        // objectType is equal to blockType (an enum value) -- do we even need self.objectType?
        self.objectType = blockType;
        
        // triangle is type 0
        if (blockType == TRIANGLE)
        {
            self.isButton = true;
            [self setColor:[UIColor orangeColor]];
            [self setSize:CGSizeMake(100.0, 100.0)];
            [self setPhysicsBody:[SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(100.0, 100.0)]];

        }
        // square is type 1
        else if (blockType == SQUARE)
        {
            self.isButton = true;
            [self setColor:[UIColor greenColor]];
            [self setSize:CGSizeMake(100.0, 100.0)];
            [self setPhysicsBody:[SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(100.0, 100.0)]];
        }
        else if (blockType == TRAPEZOID)
        {
            self.isButton = true;
            [self setColor:[UIColor purpleColor]];
            [self setSize:CGSizeMake(100.0, 100.0)];
            [self setPhysicsBody:[SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(100.0, 100.0)]];
        }
        else if (blockType == RHOMBUS)
        {
            self.isButton = true;
            [self setColor:[UIColor whiteColor]];
            [self setSize:CGSizeMake(100.0, 100.0)];
            [self setPhysicsBody:[SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(100.0, 100.0)]];
        }
    }
    return self;
}

@end
