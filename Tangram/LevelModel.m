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

@implementation LevelModel

- (id)initWithLevel:(int)level
{
    self = [super init];
    
    if (self) {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:LEVELS_DATA_FILENAME ofType:@"plist"];
        NSArray *levelsData = [NSArray arrayWithContentsOfFile:filePath];
        NSDictionary *levelData = [levelsData objectAtIndex:level];
        
        self.shapeCount = [levelData objectForKey:kShapeCount];
        self.outlineFilepath = [levelData objectForKey:kOutlineFilepath];
        
        // Parse string fields in physicsBodyCoords into sub-arrays of NSNumbers.
        NSMutableArray *physicsBodyCoords = [[NSMutableArray alloc] init];
        for (NSString *coordsString in [levelData objectForKey:kPhysicsBodyCoords]) {
            NSArray *coords = [coordsString componentsSeparatedByString:@" "];
            // X coordinate is first, Y second.
            [physicsBodyCoords addObject:@[coords[0], coords[1]]];
        }
        // Set property.
        self.physicsBodyCoords = physicsBodyCoords;
//        
//        NSLog(@"shapeCount: %@; outlineFP: %@; physicsBC: %@",
//              self.shapeCount, self.outlineFilepath, self.physicsBodyCoords);
        
        // import data from plist
        // take the level data at index `level`
        // Format data so it looks like hard-coded data.
        
        // for w/e in plist's shapecount:
        //   if square: self.shapecount[0] = value
        
        self.shapeCount = @[@(3),@(2),@(4),@(1)];
        self.outlineFilepath = @"tri-blink.png";
        
        self.outlineNumberOfTriangles = 2;
        
        // Store X and Y coordinates of each line segment comprising the physics body outline.
        self.physicsBodyCoords = @[ @[@(18), @(16)], @[@(186), @(17)], @[@(19), @(182)] ];
    }
    return self;
}

@end
