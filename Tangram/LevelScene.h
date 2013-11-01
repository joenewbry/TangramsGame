//
//  LevelScene.h
//  Tangram
//
//  Created by Joe Newbry on 10/25/13.
//  Copyright (c) 2013 Joe Newbry. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "BlockNode.h"

@interface LevelScene : SKScene <SKPhysicsContactDelegate>

-(void)rotate:(UIRotationGestureRecognizer *)gesture;
-(void)pan:(UIPanGestureRecognizer *)gesture;

@end
