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

// Max number of "unit" triangles that can fit inside the template outline.
@property (nonatomic) int triangleNumber;
@property (nonatomic) int numberOfTrianglesInside;
@property (nonatomic) int level;

- (id)initWithModel:(LevelModel *)levelModel deviceIsRetina:(BOOL)isRetina level:(int)level;
- (id)initWithModel:(LevelModel *)levelModel deviceIsRetina:(BOOL)isRetina;

-(void) shouldMoveToCenter;


@end
