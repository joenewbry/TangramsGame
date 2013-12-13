//
//  LevelModel.m
//  Tangram
//
//  Created by Sean McQueen on 10/28/13.
//  Copyright (c) 2013 Joe Newbry. All rights reserved.
//

#import "LevelModel.h"

#define LEVELS_DATA_FILENAME @"levelsData"
#define kShapeCount @"shapeCount"
#define kOutlineFilepath @"outlineFilepath"
#define kPhysicsBodyCoords @"physicsBodyCoords"
#define kTriangleNumber @"triangleNumber"

@implementation LevelModel

- (id)initWithLevel:(int)level
{
    self = [super init];
    
    if (self) {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:LEVELS_DATA_FILENAME ofType:@"plist"];
        NSArray *levelsData = [NSArray arrayWithContentsOfFile:filePath];
        NSDictionary *levelData = [levelsData objectAtIndex:level];
        
        // shapecount is hardcoded. so effectively unlimited.
        self.shapeCount = @[@20, @20, @20, @20];
        self.outlineFilepath = [levelData objectForKey:kOutlineFilepath];
        self.triangleNumber = [[levelData objectForKey:kTriangleNumber] intValue];

        
        // Parse string fields in physicsBodyCoords into sub-arrays of NSNumbers.
        NSMutableArray *physicsBodyCoords = [[NSMutableArray alloc] init];
        for (NSString *coordsString in [levelData objectForKey:kPhysicsBodyCoords]) {
            NSArray *coords = [coordsString componentsSeparatedByString:@" "];
            // X coordinate is first, Y second.
            [physicsBodyCoords addObject:@[coords[0], coords[1]]];
        }
        
        // Set properties.
        self.physicsBodyCoords = physicsBodyCoords;
    }
    return self;
}

@end
