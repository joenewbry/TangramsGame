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

// inDrawer is true if this node has not been removed from the drawer yet.
@property (nonatomic) BOOL inDrawer;
@property (nonatomic) BlockType blockType;
@property (nonatomic) int objectType;
@property (nonatomic) int objectValue;
@property (nonatomic) ContactType contactType;

@end

