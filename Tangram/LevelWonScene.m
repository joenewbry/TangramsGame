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
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        SKLabelNode *playButton = [[SKLabelNode alloc] initWithFontNamed:@"HelveticaNeue-Bold"];
        playButton.fontSize = 80;
        playButton.fontColor = [UIColor colorWithHue:0.000 saturation:0.000 brightness:0.224 alpha:1];
        playButton.position = CGPointMake(self.size.width/2, self.size.height/2);
        playButton.text = @"woohoo :)";
        [self addChild:playButton];

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
