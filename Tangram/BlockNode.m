//
//  BlockNode.m
//  Tangram
//
//  Created by Joe Newbry on 10/25/13.
//  Copyright (c) 2013 Joe Newbry. All rights reserved.
//

#import "BlockNode.h"

@implementation BlockNode


-(id)initWithBlockType:(BlockType)blockType deviceIsRetina:(BOOL)isRetina
{

    NSArray *filePaths = @[TRIANGLE_FILE, SQUARE_FILE, TRAPEZOID_FILE, RHOMBUS_FILE];
    
    if (self = [super initWithImageNamed:filePaths[blockType]]) {

        self.objectType = blockType;
        self.contactType = NO_CONTACT;
        
        int scale = isRetina ? 1 : 2;

        [self.physicsBody setDynamic:YES];
        [self.physicsBody setUsesPreciseCollisionDetection:YES];
        
        if (blockType == TRIANGLE) {
            self.inDrawer = YES;
            [self setPhysicsBody:[self createTriangleBodyScale:scale]];
        }
        else if (blockType == SQUARE) {
            self.inDrawer = YES;
            [self setPhysicsBody:[self createSquareBodyScale:scale]];
        }
        else if (blockType == TRAPEZOID) {
            self.inDrawer = YES;
            [self setPhysicsBody:[self createTrapezoidBodyScale:scale]];
        }
        else if (blockType == RHOMBUS) {
            NSLog(@"blockType: %d", blockType);
            self.inDrawer = YES;
            [self setPhysicsBody:[self createRhombusBodyScale:scale]];
        }
    }
    
    self.physicsBody.categoryBitMask = blockCategory;
    self.physicsBody.contactTestBitMask = blockCategory | targetCategory | wallCategory;
    self.physicsBody.collisionBitMask = 0;
    
    return self;
}


-(SKPhysicsBody *)createTriangleBodyScale:(int)scale
{
    CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
    CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, (0 * scale) - offsetX, (50 * scale) - offsetY);
    CGPathAddLineToPoint(path, NULL, (50 * scale) - offsetX, (0 * scale) - offsetY);
    CGPathAddLineToPoint(path, NULL, (0 * scale) - offsetX, (0 * scale) - offsetY);
    
    CGPathCloseSubpath(path);

    SKPhysicsBody * body = [SKPhysicsBody bodyWithPolygonFromPath:path];
    return body;
}

-(SKPhysicsBody *)createSquareBodyScale:(int)scale
{
    
    CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
    CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, (0 * scale) - offsetX, (50 * scale) - offsetY);
    CGPathAddLineToPoint(path, NULL, (50 * scale) - offsetX, (50 * scale) - offsetY);
    CGPathAddLineToPoint(path, NULL, (50 * scale) - offsetX, (0 * scale) - offsetY);
    CGPathAddLineToPoint(path, NULL, (0 * scale) - offsetX, (0 * scale) - offsetY);
    CGPathCloseSubpath(path);
    
    SKPhysicsBody * body = [SKPhysicsBody bodyWithPolygonFromPath:path];
    return body;
    
}

-(SKPhysicsBody *)createTrapezoidBodyScale:(int)scale
{
    
    CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
    CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, (0 * scale) - offsetX, (50 * scale) - offsetY);
    CGPathAddLineToPoint(path, NULL, (150 * scale) - offsetX, (50 * scale) - offsetY);
    CGPathAddLineToPoint(path, NULL, (100 * scale) - offsetX, (0 * scale) - offsetY);
    CGPathAddLineToPoint(path, NULL, (50 * scale) - offsetX, (0 * scale) - offsetY);
    
    CGPathCloseSubpath(path);
    
    SKPhysicsBody * body = [SKPhysicsBody bodyWithPolygonFromPath:path];
    return body;
    
}

-(SKPhysicsBody *)createRhombusBodyScale:(int)scale
{
    
    CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
    CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, (0 * scale) - offsetX, (0 * scale) - offsetY);
    CGPathAddLineToPoint(path, NULL, (35 * scale) - offsetX, (34 * scale) - offsetY);
    CGPathAddLineToPoint(path, NULL, (103 * scale) - offsetX, (34 * scale) - offsetY);
    CGPathAddLineToPoint(path, NULL, (70 * scale) - offsetX, (0 * scale) - offsetY);
    
    CGPathCloseSubpath(path);
    
    SKPhysicsBody * body = [SKPhysicsBody bodyWithPolygonFromPath:path];
    return body;
    
}

@end
