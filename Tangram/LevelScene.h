//
//  LevelScene.h
//  Tangram
//
//  Created by Joe Newbry on 10/25/13.
//  Copyright (c) 2013 Joe Newbry. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "BlockNode.h"
#import "LevelModel.h"
#import "Constants.h"
#import "LevelSelectionScene.h"

@interface LevelScene : SKScene <SKPhysicsContactDelegate>

@property (nonatomic, strong) LevelModel *levelModel;

- (id)initWithLevel:(int)level AndSize:(CGSize)size;
- (void)rotate:(UIRotationGestureRecognizer *)gesture;
- (void)pan:(UIPanGestureRecognizer *)gesture;


@end
