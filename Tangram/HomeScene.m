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

@interface HomeScene ()
{
    SKNode *_selectedNode;
}

@end

@implementation HomeScene

// TODO: add in settings page
-(id)initWithSize:(CGSize)size {
     if (self = [super initWithSize:size])
     {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
         
         SKLabelNode *startText = [[SKLabelNode alloc] initWithFontNamed:@"HelveticaNeue-Bold"];
         startText.fontSize = 80;
         startText.fontColor = [UIColor colorWithHue:0.000 saturation:0.000 brightness:0.224 alpha:1];
         startText.position = CGPointMake(self.size.width/2, self.size.height/2);
         startText.text = @"Geopets";
         [self addChild:startText];
         
         // start button
         SKSpriteNode *startButton = [[SKSpriteNode alloc] initWithImageNamed:@"resume.png"];
         startButton.position = CGPointMake(self.size.width/2, self.size.height/2 - 80);
         [self addChild:startButton];
         
    }
    return self;
}

// TODO: remove unnecessary gesture recognizers
- (void)didMoveToView:(SKView *)view
{
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(pan:)];
    [[self view] addGestureRecognizer:gestureRecognizer];
    
    UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self
                                                                                                   action:@selector(rotate:)];
    [[self view] addGestureRecognizer:rotationRecognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(tap:)];
    [[self view] addGestureRecognizer:tapGestureRecognizer];
}

-(void)pan:(UIGestureRecognizer*) gesture
{
    
}

-(void)rotate:(UIGestureRecognizer*) gesture
{
    
}

-(void)tap:(UIGestureRecognizer*) gesture
{
    SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
    SKScene *levelSelctionScene = [[LevelSelectionScene alloc] initWithSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view presentScene:levelSelctionScene transition:reveal];
}


@end
