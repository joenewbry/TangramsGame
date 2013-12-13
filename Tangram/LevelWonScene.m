//
//  LevelWonScene.m
//  Tangram
//
//  Created by Joe Newbry on 11/17/13.
//  Copyright (c) 2013 Joe Newbry. All rights reserved.
//

#import "LevelWonScene.h"
#import "LevelSelectionScene.h"

@interface LevelWonScene ()
{
    SKSpriteNode *backButton;
}
@end

@implementation LevelWonScene

- (id)initWithSize:(CGSize) size
{
    if (self = [super initWithSize:size])
    {

        self.backgroundColor = [UIColor whiteColor];
        
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
    [self setupBackButton];

    // add gesture recognizer
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(tap:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}


-(void) setupBackButton
{
    backButton = [[SKSpriteNode alloc] initWithImageNamed:@"level-selection.png"];
    backButton.position = CGPointMake(60.0, 950.0);
    [self addChild:backButton];
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
    SKNode *node = [self nodeAtPoint:[self convertPointFromView:[gesture locationInView:gesture.view]]];
    if ([node isEqual:backButton]){
        SKTransition *reveal = [SKTransition flipVerticalWithDuration:0.5];
        SKScene *levelSelctionScene = [[LevelSelectionScene alloc] initWithSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height)];
        [self.view presentScene:levelSelctionScene transition:reveal];
    }
}

@end
