//
//  ASCEmoticon_Tests.m
//  ASCEmoticon Tests
//
//  Created by wenlonggao on 14-3-30.
//  Copyright (c) 2014年 wenlonggao. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ASCEmoticonManager.h"
#import "FMDatabase.h"
#import "ASCEmoticon.h"

@interface ASCEmoticon_Tests : XCTestCase

@property (nonatomic, retain) NSString *dbPath;

@end

@implementation ASCEmoticon_Tests

@synthesize dbPath;

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    self.dbPath = [documentsDirectory stringByAppendingPathComponent:@"user.sqlite"];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreate
{
    [ASCEmoticonManager createDataBase];
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.dbPath] == YES)
    {
        return ;
    }
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

-(void)testInsert
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.dbPath] == YES)
    {
        for (int i = 0; i < 10; i++) {
            NSString * temp = [NSString stringWithFormat:@"%d", i];
            ASCEmoticon *emoticon = [[ASCEmoticon alloc] initWithName:temp description:temp type:i path:temp];
            [ASCEmoticonManager insertEmoticon:emoticon];
        }
        return ;
    }
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

-(void)testQuery
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.dbPath] == YES)
    {
        [ASCEmoticonManager queryEmoticonByType:2 complete:^(NSArray *array) {
            for (id item in array) {
                NSLog(@"%@", item);
            }
        }];
        return ;
    }
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
