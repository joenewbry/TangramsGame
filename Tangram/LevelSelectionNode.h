//
//  LevelSelectionNode.h
//  Tangram
//
//  Created by Sean McQueen on 11/4/13.
//  Copyright (c) 2013 Joe Newbry. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface LevelSelectionNode : SKSpriteNode

@property (nonatomic) int level;

-(id)initWithLevel:(int)level;

-(void) shouldMoveToCenter;

@end
