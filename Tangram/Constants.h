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
    PARALLELOGRAM
} BlockType;

#define TRIANGLE_FILE @"tri-open.png"
#define SQUARE_FILE @"sq-open.png"
#define TRAPEZOID_FILE @"trap-open.png"
#define PARALLELOGRAM_FILE @"para-open.png"

#define TRIANGLE_FILE_BLINK @"tri-closed.png"
#define SQUARE_FILE_BLINK @"sq-closed.png"
#define TRAPEZOID_FILE_BLINK @"trap-closed.png"
#define PARALLELOGRAM_FILE_BLINK @"para-closed.png"

#define TRIANGLE_FILE_FROWN @"tri-x.png"
#define SQUARE_FILE_FROWN @"sq-x.png"
#define TRAPEZOID_FILE_FROWN @"trap-x.png"
#define PARALLELOGRAM_FILE_FROWN @"para-x.png"

#define NUM_SHAPES 4
#define NUM_LEVELS 8 

#define ROTATE_DURATION 0.25

// the different categories used in collision detection
static const uint32_t blockCategory = 0x1 << 0;
static const uint32_t wallCategory = 0x1 << 1;
static const uint32_t targetCategory = 0x1 << 2;
static const uint32_t trashCategory = 0x1 << 3;
static const uint32_t edgeCategory = 0x1 << 4;

// debug mode for template
static const BOOL debugMode = NO;

@interface Constants : NSObject

@end
