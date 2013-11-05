//
//  Constants.h
//  Tangram
//
//  Created by Sean McQueen on 11/4/13.
//  Copyright (c) 2013 Joe Newbry. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TRIANGLE,
    SQUARE,
    TRAPEZOID,
    RHOMBUS
} BlockType;

// we are using 4 tangrams
#define NUM_SHAPES 4

@interface Constants : NSObject

@end
