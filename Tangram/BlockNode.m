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
         SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];

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
