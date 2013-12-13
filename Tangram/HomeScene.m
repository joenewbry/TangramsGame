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
    SKSpriteNode *startText;
}

@end

@implementation HomeScene

// TODO: add in settings page
-(id)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    return self;
}


-(void) setupBackground
{
    SKTexture *backgroundTexture = [SKTexture textureWithImageNamed:@"welcome.png"];
    SKSpriteNode *background = [[SKSpriteNode alloc] initWithTexture:backgroundTexture];
    background.size = self.view.frame.size;
    
    background.position = (CGPoint) {CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame)};
    [self addChild:background];

}

-(void) setupPlayButton
{
    startButton = [[SKSpriteNode alloc] initWithImageNamed:@"resume.png"];
    startButton.position = CGPointMake(self.size.width/2, -startButton.size.height);
    [self addChild:startButton];
}

-(void) setupTitle
{
    startText = [[SKSpriteNode alloc] initWithImageNamed:@"geopets_logo-02.png"];
    startText.size = CGSizeMake(482, 167);
    
    startText.position = CGPointMake(self.size.width/2, self.size.height + 100);
    [self addChild:startText];
}


// TODO: remove unnecessary gesture recognizers
- (void)didMoveToView:(SKView *)view
{
    [self setupBackground];
    [self setupPlayButton];
    [self setupTitle];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(tap:)];
    [[self view] addGestureRecognizer:tapGestureRecognizer];

    // perform action for play button
    moveInPlayButton = [SKAction moveTo:CGPointMake(self.size.width/2, self.size.height/2 - 20) duration:1];
    moveInPlayButton.timingMode = SKActionTimingEaseOut;
    [startButton runAction:moveInPlayButton];

    moveOutPlayButton = [SKAction moveTo:CGPointMake(self.size.width/2, -startButton.size.height) duration:.5];
    moveOutPlayButton.timingMode = SKActionTimingEaseIn;

    // perform action for title screen
    moveInTitle = [SKAction moveTo:CGPointMake(self.size.width/2, self.size.height/2 + 120) duration:1];
    moveInTitle.timingMode = SKActionTimingEaseOut;
    [startText runAction:moveInTitle];

    moveOutTitle = [SKAction moveTo:CGPointMake(self.size.width/2, self.size.height + 100) duration:.5];

    
}

-(void)tap:(UIGestureRecognizer*) gesture
{
    [startText runAction:moveOutTitle];
    [startButton runAction:moveOutPlayButton completion:^{
        SKTransition *fade = [SKTransition fadeWithColor:[UIColor grayColor] duration:.5];
    SKScene *levelSelctionScene = [[LevelSelectionScene alloc] initWithSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view presentScene:levelSelctionScene transition:fade];

    }]; // could make these grouped
}

@end
