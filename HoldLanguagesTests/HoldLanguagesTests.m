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
    _rootItem = [[CDFileItem alloc] initWithName:directoryDocuments(nil)];
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
    NSString *test0 = directoryDocuments(nil);
    NSString *test1 = directoryDocuments(@"test1");
    STAssertTrueNoThrow([test1 isEqualToString:[test0 stringByAppendingPathComponent:@"test1"]],
                        @"\n%@\n%@", test0, test1);
    NSLog(@"\n%@\n%@", test0, test1);
    
    NSString *test2 = directoryRelativeDownload(nil);
    NSString *test3 = directoryRelativeDownload(@"test3");
    STAssertTrueNoThrow([test3 isEqualToString:[test2 stringByAppendingPathComponent:@"test3"]],
                        @"\n%@\n%@", test2, test3);
    NSLog(@"\n%@\n%@", test2, test3);

    NSString *test4 = directoryAbsoluteDownload(nil);
    NSString *test5 = directoryAbsoluteDownload(@"test5");
    STAssertTrueNoThrow([test5 isEqualToString:[test4 stringByAppendingPathComponent:@"test5"]],
                        @"\n%@\n%@", test4, test5);
    NSLog(@"\n%@\n%@", test4, test5);
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
