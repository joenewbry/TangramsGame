//
//  BlockNode.m
//  Tangram
//
//  Created by Joe Newbry on 10/25/13.
//  Copyright (c) 2013 Joe Newbry. All rights reserved.
//

#import "BlockNode.h"

@implementation BlockNode

-(id)initWithBlockType:(int) blockType
{
    if (self = [super init])
    {
        [self.physicsBody setDynamic:YES];
        [self.physicsBody setUsesPreciseCollisionDetection:YES];
        if (blockType == 0)
        {
            self.objectType = 0;
            self.isButton = true;
            [self setColor:[UIColor orangeColor]];
            [self setSize:CGSizeMake(100.0, 100.0)];
            [self setPhysicsBody:[SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(100.0, 100.0)]];

        }
        else if (blockType == 1)
        {
            self.objectType = 1;
            self.isButton = true;
            [self setColor:[UIColor greenColor]];
            [self setSize:CGSizeMake(100.0, 100.0)];
            [self setPhysicsBody:[SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(100.0, 100.0)]];
        }
        else if (blockType == 2)
        {
            
        }
        else if (blockType == 3)
        {
            
        }
    }
    return self;
}

@end


//        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"tri-open"];
//        SKTexture *f1 = [SKTexture textureWithImageNamed:@"tri-blink.png"];
//       // SKTexture *f2 = [SKTexture textureWithImageNamed:@"tri-leg.png"];
//        SKTexture *f3 = [SKTexture textureWithImageNamed:@"tri-open.png"];
//        NSArray *triangleChillingTextures = @[f1, f1, f1, f1, f1, f3];
//        SKAction *chillingAnimiation = [SKAction animateWithTextures:triangleChillingTextures
//                                                        timePerFrame:.2
//                                                              resize:NO
//                                                             restore:YES];
//        SKAction *chillingForever = [SKAction repeatActionForever:chillingAnimiation];
//        [sprite runAction:chillingForever];