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
    SKAction *frownAnimation;
}
@end


@implementation BlockNode


-(id)initWithBlockType:(BlockType)blockType deviceIsRetina:(BOOL)isRetina
{

    NSArray *filePaths = @[TRIANGLE_FILE, SQUARE_FILE, TRAPEZOID_FILE, PARALLELOGRAM_FILE];
    NSArray *filePathsBlink = @[TRIANGLE_FILE_BLINK, SQUARE_FILE_BLINK, TRAPEZOID_FILE_BLINK, PARALLELOGRAM_FILE_BLINK];
    NSArray *filePathsFrown = @[TRIANGLE_FILE_FROWN, SQUARE_FILE_FROWN, TRAPEZOID_FILE_FROWN, PARALLELOGRAM_FILE_FROWN];

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

    [self configureAnimation:blockType withFilePath:filePaths withBlinkFilePath:filePathsBlink withFrownFilePath:filePathsFrown];
    
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

- (void) configureAnimation: (BlockType) blockType withFilePath:(NSArray *) filePath withBlinkFilePath:(NSArray *) filePathBlink withFrownFilePath:(NSArray *)filePathFrown
{
    SKTexture *unblinkTexture = [SKTexture textureWithImageNamed:filePath[blockType]];
    SKTexture *blinkTexture = [SKTexture textureWithImageNamed:filePathBlink[blockType]];
    SKTexture *frownTexture = [SKTexture textureWithImageNamed:filePathFrown[blockType]];
    NSArray *blinkFrames = @[blinkTexture];
    NSArray *unblinkFrames = @[unblinkTexture];
    NSArray *frownFrames = @[frownTexture];
    blinkAnimation = [SKAction animateWithTextures:blinkFrames timePerFrame:1];
    //blinkAnimation = [SKAction repeatActionForever:blinkAnimation];
    unblinkAnimation = [SKAction animateWithTextures:unblinkFrames timePerFrame:.1];
    frownAnimation = [SKAction animateWithTextures:frownFrames timePerFrame:.1];
}

- (void)shouldBlink
{
    [self runAction:blinkAnimation];
}

- (void)shouldUnblink
{
    [self runAction:unblinkAnimation];
}

- (void) shouldWiggleSlideTo: (CGPoint) point
{
    // wiggle
    SKAction *wOne = [SKAction rotateByAngle: (M_PI_4/8) duration: 0.05];
    wOne.timingMode = SKActionTimingEaseInEaseOut;
    SKAction *wTwo = [SKAction rotateByAngle: -(M_PI_4/4) duration: 0.01];
    SKAction *wThree = [SKAction rotateByAngle: (M_PI_4/8) duration: 0.05];
    wThree.timingMode = SKActionTimingEaseInEaseOut;
    
    // wait briefly
    SKAction *wait = [SKAction waitForDuration:0.1];
    
    // slide to previous position
    SKAction *slideTo = [SKAction moveTo:point duration:0.2];

    SKAction *wiggleSequence = [SKAction sequence:@[wOne, wTwo, wThree, wait, slideTo]];
    
    // run animation
    [self runAction:wiggleSequence];
}

- (void) shouldFrown
{
    [self runAction:frownAnimation];
}
@end
