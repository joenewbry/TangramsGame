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

- (id)initWithBlockType:(BlockType)blockType deviceIsRetina:(BOOL)isRetina;

// inDrawer is true if this node has not been removed from the drawer yet.
@property (nonatomic) BOOL inDrawer;

// touching target
@property (nonatomic) BOOL touchingTemplateVolumn;
@property (nonatomic) BOOL touchingTemplateEdge;

// is currently inside money zone (or started a pan from there)
@property (nonatomic) BOOL isInsideTemplate;

// touching tangram
@property (nonatomic) BOOL touchingTangram;

// touching drawer
@property (nonatomic) BOOL touchingDrawer;

@property (nonatomic) BlockType blockType;
@property (nonatomic) int objectType;
@property (nonatomic) int objectValue;

// triangle number of shape
@property (nonatomic) int tangramTriangleNumber;


@end

