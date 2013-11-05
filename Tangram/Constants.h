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

#define NUM_SHAPES 4
#define NUM_LEVELS 3

// the different categories used in collision detection
static const uint32_t blockCategory = 0x1 << 0;
static const uint32_t wallCategory = 0x1 << 1;
static const uint32_t targetCategory = 0x1 << 2;
static const uint32_t trashCategory = 0x1 << 3;


@interface Constants : NSObject

@end
