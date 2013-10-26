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
        
        SKShapeNode *square = [[SKShapeNode alloc] init];
        square.path = CGPathCreateWithRoundedRect(CGRectMake(0, 0, 100, 100), 5, 5, nil);
        square.fillColor = [UIColor redColor];
        square.lineWidth = .2;
        
        square.antialiased = YES;
        square.strokeColor = [UIColor whiteColor];
        
        self.anchorPoint = CGPointMake(0.5, 0.5); // sets rotation anchor to center of object
        
        [self addChild:square];
    }
    return self;
}

@end
