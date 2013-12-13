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
    if (self = [super init])
    {
        self.level = level;
        
        // create shape
        [self setColor:[UIColor colorWithHue:0.315 saturation:0.220 brightness:0.875 alpha:1]];
        [self setSize:CGSizeMake(150.0, 150.0)];
    }
    return self;
}

- (void)shouldMoveToCenter
{
    moveToCenter = [SKAction moveTo:CGPointMake(400, 600) duration:.75];
    scaleToFullSize = [SKAction scaleTo:3.0 duration:.75];

    [self runAction:moveToCenter];
    [self runAction:scaleToFullSize];
}

@end
