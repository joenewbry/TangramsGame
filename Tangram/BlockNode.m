//
//  BlockNode.m
//  Tangram
//
//  Created by Joe Newbry on 10/25/13.
//  Copyright (c) 2013 Joe Newbry. All rights reserved.
//

#import "BlockNode.h"

@implementation BlockNode


-(id)initWithBlockType:(BlockType)blockType
{

    NSArray *filePaths = @[TRIANGLE_FILE, SQUARE_FILE, TRAPEZOID_FILE, RHOMBUS_FILE];
    
    if (self = [super initWithImageNamed:filePaths[blockType]]) {

        self.objectType = blockType;

        [self.physicsBody setDynamic:YES];
        [self.physicsBody setUsesPreciseCollisionDetection:YES];
        
        if (blockType == TRIANGLE) {
            self.isButton = true;
            [self setPhysicsBody:[self createTriangleBody]];
        }
        else if (blockType == SQUARE) {
            self.isButton = true;
            [self setPhysicsBody:[self createSquareBody]];
        }
        else if (blockType == TRAPEZOID) {
            self.isButton = true;
            [self setPhysicsBody:[self createTrapezoidBody]];
        }
        else if (blockType == RHOMBUS) {
            self.isButton = true;
            [self setPhysicsBody:[self createRhombusBody]];
        }
    }
    return self;
}


-(SKPhysicsBody *)createTriangleBody
{
    CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
    CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, 0 - offsetX, 50 - offsetY);
    CGPathAddLineToPoint(path, NULL, 50 - offsetX, 0 - offsetY);
    CGPathAddLineToPoint(path, NULL, 0 - offsetX, 0 - offsetY);
    
    CGPathCloseSubpath(path);

    SKPhysicsBody * body = [SKPhysicsBody bodyWithPolygonFromPath:path];
    return body;
}

-(SKPhysicsBody *)createSquareBody
{
    
    CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
    CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0 - offsetX, 50 - offsetY);
    CGPathAddLineToPoint(path, NULL, 50 - offsetX, 50 - offsetY);
    CGPathAddLineToPoint(path, NULL, 50 - offsetX, 0 - offsetY);
    CGPathAddLineToPoint(path, NULL, 0 - offsetX, 0 - offsetY);
    CGPathCloseSubpath(path);
    
    SKPhysicsBody * body = [SKPhysicsBody bodyWithPolygonFromPath:path];
    return body;
    
}

-(SKPhysicsBody *)createTrapezoidBody
{
    
    CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
    CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, 0 - offsetX, 50 - offsetY);
    CGPathAddLineToPoint(path, NULL, 150 - offsetX, 50 - offsetY);
    CGPathAddLineToPoint(path, NULL, 100 - offsetX, 0 - offsetY);
    CGPathAddLineToPoint(path, NULL, 50 - offsetX, 0 - offsetY);
    
    CGPathCloseSubpath(path);
    
    SKPhysicsBody * body = [SKPhysicsBody bodyWithPolygonFromPath:path];
    return body;
    
}

-(SKPhysicsBody *)createRhombusBody
{
    
    CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
    CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, 35 - offsetX, 34 - offsetY);
    CGPathAddLineToPoint(path, NULL, 104 - offsetX, 34 - offsetY);
    CGPathAddLineToPoint(path, NULL, 69 - offsetX, 0 - offsetY);
    CGPathAddLineToPoint(path, NULL, 0 - offsetX, 0 - offsetY);
    
    CGPathCloseSubpath(path);
    
    SKPhysicsBody * body = [SKPhysicsBody bodyWithPolygonFromPath:path];
    return body;
    
}

@end
