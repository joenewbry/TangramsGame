//
//  TemplateNode.h
//  Tangram
//
//  Created by SDA on 11/14/13.
//  Copyright (c) 2013 Joe Newbry. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Constants.h"
#import "LevelModel.h"

@interface TemplateNode : SKSpriteNode

@property (nonatomic) int numberOfTriangles;
// Max number of "unit" triangles that can fit inside the template outline.


- (id)initWithModel:(LevelModel *)levelModel;


@end
