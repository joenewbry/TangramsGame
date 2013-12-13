//
//  LevelSelectionScene.m
//  Tangram
//
//  Created by Joe Newbry on 10/31/13.
//  Copyright (c) 2013 Joe Newbry. All rights reserved.
//

#import "LevelSelectionScene.h"


@implementation LevelSelectionScene
{
    CGPoint levelStartPoints[NUM_LEVELS];
    CGPoint levelLabelStartPoints[NUM_LEVELS];
    LevelSelectionNode *_selectedNode;

    NSMutableArray *levelNodesArray;
    NSMutableArray *levelLabelArray;
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
        LevelSelectionNode * levelNode = [self createLevelNodeOfLevel:i At:levelStartPoints[i]];
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

-(LevelSelectionNode*)createLevelNodeOfLevel:(int)level At:(CGPoint) point
{
    LevelSelectionNode * node = [[LevelSelectionNode alloc] initWithLevel:level];
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


        for (LevelSelectionNode *level in levelNodesArray){
            if (level == _selectedNode){
                [level shouldMoveToCenter];
            } else {
                [level setAlpha:0.0];
            }
        }

        for (SKLabelNode *label in levelLabelArray ){
            [label setAlpha:0.0];
        }

        CGSize size = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
        LevelScene * level = [[LevelScene alloc] initWithLevel:_selectedNode.level AndSize:size];

        // present the level with a nice transition
        SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
        [self.view presentScene:level transition:reveal];
    }
}

-(void)selectNodeForTouch:(CGPoint)touchLocation
{
    SKNode *selectedNode = [self nodeAtPoint:touchLocation];
    if ([selectedNode isKindOfClass:[LevelSelectionNode class]]) {
        _selectedNode = (LevelSelectionNode *)[self nodeAtPoint:touchLocation];
    } else {
        _selectedNode = nil;
    }
}

@end
