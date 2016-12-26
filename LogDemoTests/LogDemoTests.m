//
//  LogDemoTests.m
//  LogDemoTests
//
//  Created by feiyujie on 2016/12/26.
//  Copyright © 2016年 feiyujie. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface LogDemoTests : XCTestCase

@end

@implementation LogDemoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample
{
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        for (NSInteger i = 0; i < 1000; ++i) {
            NSMutableSet *mSet = [NSMutableSet set];
            [mSet addObject:@"英语"];
            [mSet addObject:@"历史"];
            [mSet addObject:@"数学"];
            
            NSArray *arr = @[@"a", @"b", @"c"];
            [mSet addObject:arr];
            
            NSMutableSet *subSet = mSet.mutableCopy;
            NSMutableSet *subSubSet = mSet.mutableCopy;
            [subSet addObject:subSubSet];
            [mSet addObject:subSet];
            
            NSDictionary *subDict = @{
                                      @"键0" : @"值0",
                                      @"键1" : @"值1",
                                      @"键2" : @"值2",
                                      };
            [mSet addObject:subDict];
            NSDictionary *dict = @{@"something" : mSet};
            
            NSLog(@"%@", dict);
            
        }
        
    }];
}

- (void)testDictionary
{
    NSDictionary *dict = @{
                           @"名字" : @"杰克",
                           @"年龄" : @20,
                           };
    
    NSLog(@"%@", dict);
}

- (void)testArray
{
    NSArray *array = @[
                       @"语文",
                       @"数学",
                       @"外语",
                       ];
    
    NSLog(@"%@", array);
}

- (void)testSet
{
    NSMutableSet *mSet = [NSMutableSet set];
    [mSet addObject:@"语文"];
    [mSet addObject:@"数学"];
    [mSet addObject:@"外语"];
    
    NSLog(@"%@", mSet);
}

- (void)testArraySet
{
    NSMutableSet *mSet = [NSMutableSet set];
    [mSet addObject:@"语文"];
    [mSet addObject:@"数学"];
    [mSet addObject:@"外语"];
    
    NSMutableArray *mArray = @[].mutableCopy;
    [mArray addObject:mSet];
    
    NSLog(@"%@", mArray);
}

- (void)testDictionayArray
{
    NSDictionary *dict = @{@"名字" : @"杰克",
                           @"年龄" : @12,
                           @"内容" : @{
                                   @"userName" : @"rose",
                                   @"message" : @"好好学习",
                                   @"testArray" : @[@"数学",
                                                    @"英语",
                                                    @"历史",
                                                    @[
                                                        @"zhangsan",
                                                        @"lisi",
                                                        @[
                                                            @"test1",
                                                            @"test2",
                                                            @"test3"
                                                            ],
                                                        ],
                                                    ],
                                   @"test" : @{
                                           @"key1" : @"测试1",
                                           @"键值2" : @"test2",
                                           @"key3" : @"test3"
                                           }
                                   
                                   },
                           
                           
                           };
    NSLog(@"%@", dict);
}

- (void)testEmpty
{
    NSArray *array = @[];
    NSMutableSet *set = [NSMutableSet set];
    NSDictionary *dict = @{};
    
    NSLog(@"%@", array);
    NSLog(@"%@", set);
    NSLog(@"%@", dict);
}

- (void)testDictionayArraySet
{
    NSMutableSet *mSet = [NSMutableSet set];
    [mSet addObject:@"英语"];
    [mSet addObject:@"历史"];
    [mSet addObject:@"数学"];
    
    NSArray *arr = @[@"a", @"b", @"c"];
    [mSet addObject:arr];
    
    NSMutableSet *subSet = mSet.mutableCopy;
    NSMutableSet *subSubSet = mSet.mutableCopy;
    [subSet addObject:subSubSet];
    [mSet addObject:subSet];
    
    NSDictionary *subDict = @{
                              @"键0" : @"值0",
                              @"键1" : @"值1",
                              @"键2" : @"值2",
                              };
    [mSet addObject:subDict];
    NSDictionary *dict = @{@"something" : mSet};
    
    NSLog(@"%@", dict);
}

@end
