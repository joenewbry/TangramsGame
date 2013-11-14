//
//  TemplateNode.m
//  Tangram
//
//  Created by SDA on 11/14/13.
//  Copyright (c) 2013 Joe Newbry. All rights reserved.
//

#import "TemplateNode.h"

@implementation TemplateNode


- (id)initWithModel:(LevelModel *)levelModel
{
    if (self = [super initWithImageNamed:levelModel.outlineFilepath]) {
        CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
        CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
        
        CGMutablePathRef path = CGPathCreateMutable();
        
        int length = levelModel.physicsBodyCoords.count;
        
        NSArray *coordPair = levelModel.physicsBodyCoords[0];
        
        CGPathMoveToPoint(path, NULL, [coordPair[0] floatValue] - offsetX, [coordPair[1] floatValue] - offsetY);
        
        for (int i = 1; i < length; i++) {
            coordPair = levelModel.physicsBodyCoords[i];
            CGPathAddLineToPoint(path, NULL, [coordPair[0] floatValue] - offsetX, [coordPair[1] floatValue] - offsetY);
        }
        
        CGPathCloseSubpath(path);
        
        self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
        
        // set bitmask
        self.physicsBody.categoryBitMask = targetCategory;
        self.physicsBody.collisionBitMask = blockCategory;
        
        self.physicsBody.dynamic = NO;
    }
    
    return self;
}


@end
