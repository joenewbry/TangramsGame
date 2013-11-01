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
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
         
         SKLabelNode *playButton = [[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
         playButton.fontSize = 20;
         playButton.fontColor = [UIColor blueColor];
         playButton.position = CGPointMake(self.size.width/2, self.size.height/2);
         playButton.text = @"Click to Play Game";
         [self addChild:playButton];
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
    SKScene *levelSelctionScene = [[LevelSelectionScene alloc] initWithSize:CGSizeMake(1024, 768)];
    [self.view presentScene:levelSelctionScene transition:reveal];
}


@end
