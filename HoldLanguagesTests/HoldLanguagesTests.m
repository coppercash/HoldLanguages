//
//  HoldLanguagesTests.m
//  HoldLanguagesTests
//
//  Created by William Remaerd on 1/12/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "HoldLanguagesTests.h"
#import "CDiTunesFinder.h"
#import "CDFileItem.h"

@implementation HoldLanguagesTests

- (void)setUp
{
    [super setUp];
    _finder = [[CDiTunesFinder alloc] init];
    _rootItem = [[CDFileItem alloc] initWithName:documentsPath()];
    _rootItem.visibleExtension = @[@"lrc", @"gif", @"jpg"];
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    SafeMemberRelease(_finder);
    SafeMemberRelease(_rootItem);
    [super tearDown];
}

- (void)testiTunesFinder{
    //NSLog(@"%@", [_finder contentsOfCurrentDirectory]);
}

- (void)testiTunesItem{
    NSLog(@"%@", _rootItem.name);
    NSLog(@"isDirectory:\t%d", _rootItem.isDirectory);
    NSLog(@"count:\t%d", _rootItem.count);
    _rootItem.isOpened = YES;
    NSLog(@"count:\t%d", _rootItem.count);

    for (NSInteger index = 0; index < _rootItem.count; index++) {
        CDFileItem *item = [_rootItem itemWithIndex:index];
        NSLog(@"%d.\t%d:\t%@", index, item.degree, item.name);
    }
    
    CDFileItem *item = [_rootItem itemWithIndex:2];
    item.isOpened = YES;
    NSLog(@"count:\t%d", _rootItem.count);

    for (NSInteger index = 0; index < _rootItem.count; index++) {
        CDFileItem *item = [_rootItem itemWithIndex:index];
        NSLog(@"%d.\t%d:\t%@", index, item.degree, item.name);
    }
    
    item = [_rootItem itemWithIndex:5];
    item.isOpened = YES;
    NSLog(@"count:\t%d", _rootItem.count);
    
    for (NSInteger index = 0; index < _rootItem.count; index++) {
        CDFileItem *item = [_rootItem itemWithIndex:index];
        NSLog(@"%d.\t%d:\t%@", index, item.degree, item.name);
    }
    
    item = [_rootItem itemWithIndex:5];
    item.isOpened = NO;
    NSLog(@"count:\t%d", _rootItem.count);
    
    for (NSInteger index = 0; index < _rootItem.count; index++) {
        CDFileItem *item = [_rootItem itemWithIndex:index];
        NSLog(@"%d.\t%d:\t%@", index, item.degree, item.name);
    }

}

@end
