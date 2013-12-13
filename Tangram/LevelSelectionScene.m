//
//  LevelSelectionScene.m
//  Tangram
//
//  Created by Joe Newbry on 10/31/13.
//  Copyright (c) 2013 Joe Newbry. All rights reserved.
//

#import "LevelSelectionScene.h"
#import "TemplateNode.h"
#import "LevelModel.h"

@implementation LevelSelectionScene
{
    CGPoint levelStartPoints[NUM_LEVELS];
    CGPoint levelLabelStartPoints[NUM_LEVELS];
    TemplateNode *_selectedNode;

    NSMutableArray *levelNodesArray;
    NSMutableArray *levelLabelArray;

    BOOL isRetna;
}

- (id)initWithSize:(CGSize) size
{
     if (self = [super initWithSize:size])
    {
        // It would be nice to have a background pattern, can't figure
        // it out at the moment though. - Josh 11/19
        //UIImage *patternImage = [UIImage imageNamed:@"geometry.png"];
        //self.backgroundColor = [UIColor lightGrayColor];
        
        // call setup methods
        //[self setupPhysics];
        //[self setupLevelArray];
    }
    return self;
}

- (void)setupPhysics
{
    //self.physicsWorld.gravity = CGVectorMake(0.0, -0.0);
    //self.physicsWorld.contactDelegate = self;
}

-(void)setupLevelArray
{
    // figure out if device is retna
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        isRetna = YES;
    } else {
        isRetna = NO;
    }

    // set placement values
    float placementWidth = self.size.width / 4;
    float placementHeight = self.size.height / 6;
    int offset = 75;
    for (int i = 0; i < NUM_LEVELS; i++) {
        levelStartPoints[i] = CGPointMake(placementWidth * ((i % 3)+1), 800 - ((i / 3) * placementHeight));
        levelLabelStartPoints[i] = CGPointMake(levelStartPoints[i].x, levelStartPoints[i].y - offset);
    }

    // create sprites and labels for level selectors
    for (int i = 0; i < NUM_LEVELS; i++) {
        TemplateNode *levelNode = [self createLevelNodeOfLevel:i At:levelStartPoints[i]];
        levelNode.position = levelStartPoints[i];

        [self addChild:levelNode];

        if (!levelNodesArray) levelNodesArray = [[NSMutableArray alloc] init];

        [levelNodesArray addObject:levelNode];

        SKLabelNode * levelLabel = [[SKLabelNode alloc] initWithFontNamed:@"HelveticaNeue-Bold"];
        levelLabel.position = levelLabelStartPoints[i];
        levelLabel.fontColor = [UIColor colorWithHue:0.000 saturation:0.000 brightness:0.224 alpha:1];
        levelLabel.fontSize = 20;
        levelLabel.text = [NSString stringWithFormat:@"Level %i", (i+1)];
        [self addChild:levelLabel];

        if (!levelLabelArray) levelLabelArray = [[NSMutableArray alloc] init];
        [levelLabelArray addObject:levelLabel];
    }
}

-(TemplateNode *)createLevelNodeOfLevel:(int)level At:(CGPoint) point
{
    LevelModel *levelModel = [[LevelModel alloc] initWithLevel:level];
    TemplateNode * node = [[TemplateNode alloc] initWithModel:levelModel deviceIsRetina:isRetna level:level];
    [node setPosition:point];

    return node;
}

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    [self setupLevelArray];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(tap:)];
    [[self view] addGestureRecognizer:tapGestureRecognizer];

}

-(void)tap:(UIGestureRecognizer*) gesture
{
    CGPoint touchLocation = [gesture locationInView:self.view];
    touchLocation = [self.view convertPoint:touchLocation toScene:self];
    [self selectNodeForTouch:touchLocation];

    // only if we actually tapped a level selection node
    if (_selectedNode != nil) {
        // initialize the correct level


        for (TemplateNode *level in levelNodesArray){
            if (level == _selectedNode){
                [level shouldMoveToCenter];
            } else {
                [level setAlpha:0.0];
            }
        }

        for (SKLabelNode *label in levelLabelArray ){
            [label setAlpha:0.0];
        }
        dispatch_async(dispatch_queue_create("check contact", nil), ^{
            [NSThread sleepForTimeInterval:.75];
            CGSize size = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
            LevelScene * levelScene = [[LevelScene alloc] initWithLevel:_selectedNode.level AndSize:size];

            // present the level with a nice transition
            SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
            [self.view presentScene:levelScene transition:reveal];
        });


    }
}

-(void)selectNodeForTouch:(CGPoint)touchLocation
{
    SKNode *selectedNode = [self nodeAtPoint:touchLocation];
    if ([selectedNode isKindOfClass:[TemplateNode class]]) {
        _selectedNode = (TemplateNode *)[self nodeAtPoint:touchLocation];
    } else {
        _selectedNode = nil;
    }
}

@end
