//
//  TemplateNode.m
//  Tangram
//
//  Created by SDA on 11/14/13.
//  Copyright (c) 2013 Joe Newbry. All rights reserved.
//

#import "TemplateNode.h"

@interface TemplateNode ()
{
    SKAction *moveToCenter;
    SKAction *scaleToFullSize;
    CGSize spriteSize;
}

@end

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

- (id)initWithModel:(LevelModel *)levelModel deviceIsRetina:(BOOL)isRetina level:(int)level {
    if (self = [super initWithImageNamed:levelModel.outlineFilepath]) {
        self.level = level;
        self = [self initWithModel:levelModel deviceIsRetina:isRetina];
        spriteSize = self.size;
        self.size = CGSizeMake(100.0, 100.0);
    }
    return self;
}


- (void)shouldMoveToCenter
{
    moveToCenter = [SKAction moveTo:CGPointMake(400, 600) duration:.75];
    self.size = spriteSize;
    //scaleToFullSize = [SKAction scaleXTo:spriteSize.width duration:.75];


    [self runAction:moveToCenter];
    //[self runAction:scaleToFullSize];
}

@end
