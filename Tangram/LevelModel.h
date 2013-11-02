//
//  LevelModel.h
//  Tangram
//
//  Created by Sean McQueen on 10/28/13.
//  Copyright (c) 2013 Joe Newbry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LevelModel : NSObject

@property (nonatomic, strong) NSArray *shapeCount;
@property (nonatomic, strong) NSString *outlineFilepath;
@property (nonatomic, strong) NSArray *physicsBodyCoords;

- (id)initWithLevel:(int)level;

@end
