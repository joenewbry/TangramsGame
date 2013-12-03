//
//  TemplateNode.m
//  Tangram
//
//  Created by SDA on 11/14/13.
//  Copyright (c) 2013 Joe Newbry. All rights reserved.
//

#import "TemplateNode.h"

@implementation TemplateNode

- (id)initWithModel:(LevelModel *)levelModel deviceIsRetina:(BOOL)isRetina
{
    if (self = [super initWithImageNamed:levelModel.outlineFilepath]) {
        
        // set number of trianges that this can hold
        self.triangleNumber = levelModel.triangleNumber;
        self.numberOfTrianglesInside = 0; // start with 0
    
        // set physics body
        CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
        CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
        
        int scale = isRetina ? 1 : 2;
        
        CGMutablePathRef path = CGPathCreateMutable();
        
        int length = levelModel.physicsBodyCoords.count;
        
        NSArray *coordPair = levelModel.physicsBodyCoords[0];
        CGPathMoveToPoint(path, NULL, ([coordPair[0] floatValue] * scale) - offsetX,
                          ([coordPair[1] floatValue] * scale) - offsetY);
        
        for (int i = 1; i < length; i++) {
            coordPair = levelModel.physicsBodyCoords[i];

            CGPathAddLineToPoint(path, NULL, ([coordPair[0] floatValue] * scale) - offsetX,
                                 ([coordPair[1] floatValue] * scale) - offsetY);
        }
        CGPathCloseSubpath(path);



        
        self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
        
        // set bitmask
        self.physicsBody.categoryBitMask = targetCategory;
        self.physicsBody.contactTestBitMask = blockCategory;        
        self.physicsBody.dynamic = NO;
    }
    
    return self;
}


@end
