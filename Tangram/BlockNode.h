//
//  BlockNode.h
//  Tangram
//
//  Created by Joe Newbry on 10/25/13.
//  Copyright (c) 2013 Joe Newbry. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BlockNode : SKSpriteNode

-(id)initWithBlockType:(int) blockType;

@property (nonatomic) BOOL isButton;
@property (nonatomic) int objectType;
@end

