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

typedef enum {
    NO_CONTACT,
    TOUCHING_DRAWER,
    TOUCHING_TANGRAM,
    TOUCHING_TARGET
} ContactType;

#define TRIANGLE_FILE @"tri-open.png"
#define SQUARE_FILE @"sq-open.png"
#define TRAPEZOID_FILE @"trap-open.png"
#define RHOMBUS_FILE @"para-open.png"

#define NUM_SHAPES 4
#define NUM_LEVELS 3

// the different categories used in collision detection
static const uint32_t blockCategory = 0x1 << 0;
static const uint32_t wallCategory = 0x1 << 1;
static const uint32_t targetCategory = 0x1 << 2;
static const uint32_t trashCategory = 0x1 << 3;

// keys for testflight and lookback
#define LOOK_BACK_KEY @"QbWwzjHmCSWqJJRTB"
#define TESTFLIGHT_KEY @"84039049-e473-4dce-9965-b3ae71a59692"


@interface Constants : NSObject

@end
