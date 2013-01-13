//
//  HoldLanguagesLogicTests.m
//  HoldLanguagesLogicTests
//
//  Created by William Remaerd on 12/17/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "HoldLanguagesLogicTests.h"
#import "CDLRCLyrics.h"
#import "CDiTunesFinder.h"
#import "CDPullBottomBar.h"

@implementation HoldLanguagesLogicTests

- (void)setUp
{
    [super setUp];
    
    NSString* lyricsPath = [CDiTunesFinder findFileWithName:@"Halo.lrc" ofType:kLRCExtension];
    _lrcLyrics = [[CDLRCLyrics alloc] initWithFile:lyricsPath];
}

- (void)tearDown
{
    SafeMemberRelease(_lrcLyrics);
    [super tearDown];
}

- (void)testLRCLyrics{
    LogStart;
    
    [_lrcLyrics indexOfStampNearTime:10];
    
    LogEnd;
}

NSString* textWithTimeInterval(NSTimeInterval timeInterval);
- (void)testTextWithTimeInterval{
    LogStart;

    NSString *test1 = textWithTimeInterval(3600);
    STAssertTrueNoThrow([test1 isEqualToString:@"01:00:00"], @"01:00:00 fails %@", test1);
    
    NSString *test2 = textWithTimeInterval(-1);
    STAssertTrueNoThrow([test2 isEqualToString:@"-00:01"], @"-00:01 fails %@", test2);

    NSString *test3 = textWithTimeInterval(-3601);
    STAssertTrueNoThrow([test3 isEqualToString:@"-01:00:01"], @"-01:00:01 fails %@", test3);

    LogEnd;
}


@end
