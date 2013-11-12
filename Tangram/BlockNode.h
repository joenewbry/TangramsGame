//
//  BlockNode.h
//  Tangram
//
//  Created by Joe Newbry on 10/25/13.
//  Copyright (c) 2013 Joe Newbry. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Constants.h"

@interface BlockNode : SKSpriteNode

-(id)initWithBlockType:(BlockType)blockType deviceIsRetina:(BOOL)isRetina;

@property (nonatomic) BOOL isButton;
@property (nonatomic) BlockType blockType;
@property (nonatomic) int objectType;
@property (nonatomic) int objectValue;

@end

