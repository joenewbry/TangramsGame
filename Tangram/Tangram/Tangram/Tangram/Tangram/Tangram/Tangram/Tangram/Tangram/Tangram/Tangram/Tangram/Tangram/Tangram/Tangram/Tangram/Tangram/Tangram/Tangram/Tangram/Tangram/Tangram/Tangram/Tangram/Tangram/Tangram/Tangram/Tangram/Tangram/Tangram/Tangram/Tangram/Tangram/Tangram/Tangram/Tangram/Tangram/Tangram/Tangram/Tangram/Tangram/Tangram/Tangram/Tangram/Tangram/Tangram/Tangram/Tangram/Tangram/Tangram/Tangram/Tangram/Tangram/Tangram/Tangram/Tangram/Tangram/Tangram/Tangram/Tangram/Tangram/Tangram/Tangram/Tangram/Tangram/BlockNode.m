//
//  BlockNode.m
//  Tangram
//
//  Created by Joe Newbry on 10/25/13.
//  Copyright (c) 2013 Joe Newbry. All rights reserved.
//

#import "BlockNode.h"

@implementation BlockNode

-(id)init
{
    if (self = [super init])
    {
         SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"tri-open"];
        
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"blocks"];
        SKTexture *f1 = [atlas textureNamed:@"tri-blink.png"];
        SKTexture *f2 = [atlas textureNamed:@"tri-leg.png"];
        SKTexture *f3 = [atlas textureNamed:@"tri-open.png"];
        NSArray *triangleChillingTextures = @[f1, f3];
        
        SKAction *chillingAnimiation = [SKAction animateWithTextures:triangleChillingTextures timePerFrame:0.1];
        
        [sprite runAction:chillingAnimiation];

        [self addChild:sprite];
//        SKShapeNode *square = [[SKShapeNode alloc] init];
//        self.path = CGPathCreateWithRoundedRect(CGRectMake(0, 0, 100, 100), 5, 5, nil);
//        self.fillColor = [UIColor redColor];
//        self.lineWidth = .2;
//        
//        self.antialiased = YES;
//        self.strokeColor = [UIColor whiteColor];
        
        
        
        self.anchorPoint = CGPointMake(0.5, 0.5); // sets rotation anchor to center of object
        
    }
    return self;
}

@end
