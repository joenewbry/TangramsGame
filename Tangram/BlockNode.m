//
//  BlockNode.m
//  Tangram
//
//  Created by Joe Newbry on 10/25/13.
//  Copyright (c) 2013 Joe Newbry. All rights reserved.
//

#import "BlockNode.h"

@interface BlockNode ()
{
    // block juice
    SKAction * blinkAnimation;
    SKAction * unblinkAnimation;
    SKAction * wiggleAnimation;
}
@end


@implementation BlockNode


-(id)initWithBlockType:(BlockType)blockType deviceIsRetina:(BOOL)isRetina
{

    NSArray *filePaths = @[TRIANGLE_FILE, SQUARE_FILE, TRAPEZOID_FILE, PARALLELOGRAM_FILE];
    NSArray *filePathsBlink = @[TRIANGLE_FILE_BLINK, SQUARE_FILE_BLINK, TRAPEZOID_FILE_BLINK, PARALLELOGRAM_FILE_BLINK];

    if (self = [super initWithImageNamed:filePaths[blockType]]) {

        self.objectType = blockType;
        self.touchingTangram = NO;
        self.touchingTemplateEdge = NO;
        self.touchingTemplateVolumn = NO;
        self.isInsideTemplate = NO;
    
        int scale = isRetina ? 1 : 2;

        [self.physicsBody setDynamic:YES];
        [self.physicsBody setUsesPreciseCollisionDetection:YES];
        
        if (blockType == TRIANGLE) {
            self.inDrawer = YES;
            [self setPhysicsBody:[self createTriangleBodyScale:scale]];
            self.tangramTriangleNumber = 1;
        }
        else if (blockType == SQUARE) {
            self.inDrawer = YES;
            [self setPhysicsBody:[self createSquareBodyScale:scale]];
            self.tangramTriangleNumber = 2;
        }
        else if (blockType == TRAPEZOID) {
            self.inDrawer = YES;
            [self setPhysicsBody:[self createTrapezoidBodyScale:scale]];
            self.tangramTriangleNumber = 4;
            
        }
        else if (blockType == PARALLELOGRAM) {
            self.inDrawer = YES;
            [self setPhysicsBody:[self createParallelogramBodyScale:scale]];
            self.tangramTriangleNumber = 2;
        }
    }
    
    self.physicsBody.categoryBitMask = blockCategory;
    self.physicsBody.contactTestBitMask = blockCategory | targetCategory | wallCategory;
    self.physicsBody.collisionBitMask = 0;

    [self configureWiggleAnimation];
    [self configureBlinkAnimation:blockType withFilePath:filePaths withBlinkFilePath:filePathsBlink];
    
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

-(SKPhysicsBody *)createParallelogramBodyScale:(int)scale
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

- (void) configureBlinkAnimation: (BlockType) blockType withFilePath:(NSArray *) filePath withBlinkFilePath:(NSArray *) filePathBlink
{
    SKTexture *f1 = [SKTexture textureWithImageNamed:filePath[blockType]];
    SKTexture *f2 = [SKTexture textureWithImageNamed:filePathBlink[blockType]];
    NSArray *blinkFrames = @[f2];
    NSArray *unblinkFrames = @[f1];
    blinkAnimation = [SKAction animateWithTextures:blinkFrames timePerFrame:.1];
    unblinkAnimation = [SKAction animateWithTextures:unblinkFrames timePerFrame:.1];
}

- (void)shouldBlink
{
    [self runAction:blinkAnimation];
}

- (void)shouldUnblink
{
    [self runAction:unblinkAnimation];
}

- (void) configureWiggleAnimation
{
    SKAction *one = [SKAction rotateByAngle: (M_PI_4/8) duration: 0.05];
    one.timingMode = SKActionTimingEaseInEaseOut;
    SKAction *two = [SKAction rotateByAngle: -(M_PI_4/4) duration: 0.01];
    SKAction *three = [SKAction rotateByAngle: (M_PI_4/8) duration: 0.05];
    three.timingMode = SKActionTimingEaseInEaseOut;
    wiggleAnimation = [SKAction sequence:@[one, two, three]];
}

- (void) shouldWiggle
{
    [self runAction:wiggleAnimation];
}

- (void) shouldFrown
{
#warning replace with frown animation once created
    [self runAction:blinkAnimation];
}
@end