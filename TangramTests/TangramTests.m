//
//  TangramTests.m
//  TangramTests
//
//  Created by Joe Newbry on 10/25/13.
//  Copyright (c) 2013 Joe Newbry. All rights reserved.
//

#import <XCTest/XCTest.h>


#import "LevelScene.h"


@interface TangramTests : XCTestCase

@property (nonatomic, strong) LevelScene *levelScene;
@property (nonatomic, strong) LevelModel *levelModel;

@end

@implementation TangramTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.levelScene = [self.levelScene initWithLevel:0 AndSize:CGSizeMake(10, 10)];
    self.levelModel = self.levelScene.levelModel;
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    NSAssert(YES, @"fuck");
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

- (void)testModelBasic
{
    NSAssert(self.levelModel.triangleNumber > 0, @"Triangle number is < 1.");
    NSAssert(self.levelModel.shapeCount != nil, @"shapeCount array is nil.");
    NSAssert(self.levelModel.physicsBodyCoords != nil, @"physicsBody coordinates is nil.");
    NSAssert(self.levelModel.outlineFilepath != nil, @"outline file path for level image is nil.");
}


- (void)testModelAdvanced
{
    NSAssert(YES, @"");
}



@end
