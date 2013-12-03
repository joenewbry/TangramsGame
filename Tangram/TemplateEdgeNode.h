//
//  TemplateEdgeNode.h
//  Tangram
//
//  Created by Sean McQueen on 12/3/13.
//  Copyright (c) 2013 Joe Newbry. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Constants.h"
#import "LevelModel.h"

@interface TemplateEdgeNode : SKSpriteNode


- (id)initWithModel:(LevelModel *)levelModel deviceIsRetina:(BOOL)isRetina;


@end
