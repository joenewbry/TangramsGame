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
        SKTexture *f1 = [SKTexture textureWithImageNamed:@"tri-blink.png"];
       // SKTexture *f2 = [SKTexture textureWithImageNamed:@"tri-leg.png"];
        SKTexture *f3 = [SKTexture textureWithImageNamed:@"tri-open.png"];
        NSArray *triangleChillingTextures = @[f1, f1, f1, f1, f1, f3];
        SKAction *chillingAnimiation = [SKAction animateWithTextures:triangleChillingTextures
                                                        timePerFrame:.2
                                                              resize:NO
                                                             restore:YES];
        SKAction *chillingForever = [SKAction repeatActionForever:chillingAnimiation];
        [sprite runAction:chillingForever];
        
        [self addChild:sprite];
        
        self.anchorPoint = CGPointMake(0.5, 0.5); // sets rotation anchor to center of object
        self.isButton = TRUE; // tells block that it is a button
        self.physicsBody.dynamic = YES;
    }
    return self;
}

@end
