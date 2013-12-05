//
//  TemplateEdgeNode.m
//  Tangram
//
//  Created by Sean McQueen on 12/3/13.
//  Copyright (c) 2013 Joe Newbry. All rights reserved.
//

#import "TemplateEdgeNode.h"

@implementation TemplateEdgeNode : SKSpriteNode

- (id)initWithModel:(LevelModel *)levelModel deviceIsRetina:(BOOL)isRetina
{
    if (self = [super initWithImageNamed:levelModel.outlineFilepath]) {
        CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
        CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
        
        int scale = isRetina ? 1 : 2;
        
        CGMutablePathRef path = CGPathCreateMutable();
        
        int length = levelModel.physicsBodyCoords.count;
        
        NSArray *coordPair = levelModel.physicsBodyCoords[0];
        
        
        //        CGPathMoveToPoint(path, NULL, (0 * scale) - offsetX, (50 * scale) - offsetY)
        
        
        CGPathMoveToPoint(path, NULL, ([coordPair[0] floatValue] * scale) - offsetX,
                          ([coordPair[1] floatValue] * scale) - offsetY);
        
        for (int i = 1; i < length; i++) {
            coordPair = levelModel.physicsBodyCoords[i];
            CGPathAddLineToPoint(path, NULL, ([coordPair[0] floatValue] * scale) - offsetX,
                                 ([coordPair[1] floatValue] * scale) - offsetY);
        }
        
        CGPathCloseSubpath(path);

        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:path]; // body with edge chain??
        
        // set bitmask
        self.physicsBody.categoryBitMask = edgeCategory;
        self.physicsBody.contactTestBitMask = blockCategory;
        self.physicsBody.dynamic = NO;
    }
    
    return self;
}



@end
