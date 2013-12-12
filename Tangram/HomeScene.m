//
//  HomeScene.m
//  Tangram
//
//  Created by Joe Newbry on 10/31/13.
//  Copyright (c) 2013 Joe Newbry. All rights reserved.
//

#import "HomeScene.h"
#import "LevelSelectionScene.h"
#import "LevelScene.h"
#import <YMCPhysicsDebugger.h>

@interface HomeScene ()
{
    SKNode *_selectedNode;
    SKAction *moveInPlayButton;
    SKAction *moveInTitle;
    SKAction *moveOutPlayButton;
    SKAction *moveOutTitle;

    SKSpriteNode *startButton;
    SKLabelNode *startText;
}

@end

@implementation HomeScene

// TODO: add in settings page
-(id)initWithSize:(CGSize)size {
     if (self = [super initWithSize:size])
     {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];

         [self addBackgroundTriangles];

         // Title Text
         startText = [[SKLabelNode alloc] initWithFontNamed:@"HelveticaNeue-Bold"];
         startText.fontSize = 80;
         startText.fontColor = [UIColor colorWithHue:0.000 saturation:0.000 brightness:0.224 alpha:1];
         startText.text = @"Geopets";
         startText.position = CGPointMake(self.size.width/2, self.size.height + 100);
         [self addChild:startText];
         
         // start button
         startButton = [[SKSpriteNode alloc] initWithImageNamed:@"resume.png"];
         startButton.position = CGPointMake(self.size.width/2, -startButton.size.height);
         [self addChild:startButton];
    }
    return self;
}

- (void) addBackgroundTriangles
{
    CGFloat x = 0.0;
    CGFloat y = 0.0;
    while (x < self.frame.size.width && y < self.frame.size.height){
        SKSpriteNode *backgroundTile = [[SKSpriteNode alloc] initWithImageNamed:@"Icon-40@2x.png"];
        backgroundTile.position = CGPointMake(x, y);
        [self addChild:backgroundTile];
        x = x + backgroundTile.size.width;
        if (x > self.frame.size.width) {
            y = y + backgroundTile.size.height;
            x = 0;
        }
    }
}

// TODO: remove unnecessary gesture recognizers
- (void)didMoveToView:(SKView *)view
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(tap:)];
    [[self view] addGestureRecognizer:tapGestureRecognizer];

    // perform action for play button
    moveInPlayButton = [SKAction moveTo:CGPointMake(self.size.width/2, self.size.height/2 - 80) duration:.75];
    moveInPlayButton.timingMode = SKActionTimingEaseOut;
    [startButton runAction:moveInPlayButton];

    // perform action for title screen
    moveInTitle = [SKAction moveTo:CGPointMake(self.size.width/2, self.size.height/2) duration:.75];
    moveInTitle.timingMode = SKActionTimingEaseOut;
    [startText runAction:moveInTitle];

}

-(void)tap:(UIGestureRecognizer*) gesture
{
    SKTransition *reveal = [SKTransition  doorsOpenHorizontalWithDuration:0.5];
    SKScene *levelSelctionScene = [[LevelSelectionScene alloc] initWithSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view presentScene:levelSelctionScene transition:reveal];
}

@end
