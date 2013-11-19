//
//  LevelWonScene.m
//  Tangram
//
//  Created by Joe Newbry on 11/17/13.
//  Copyright (c) 2013 Joe Newbry. All rights reserved.
//

#import "LevelWonScene.h"

@implementation LevelWonScene

- (id)initWithSize:(CGSize) size
{
    if (self = [super initWithSize:size])
    {
        self.backgroundColor = [UIColor purpleColor];

        // call setup methods

        [self setupScene];
    }
    return self;
}

- (void) setupScene
{
    NSLog(@"do animations and then swith to level scene on completion");
}

@end
