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
#import "CDFunctions.h"

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

- (void)testMakeTimeRange{
    CDTimeRange range1 = CDMakeTimeRange(1.0, 10.0);
    CDTimeRange range2 = CDMakeTimeRange(1.0, -10.0);
    STAssertTrueNoThrow((range1.location == range2.location && range1.length == range2.length), @"{%f, %f} fails {%f, %f}", range1.location, range1.length, range2.location, range2.length);
}

- (void)testEqualTimeRanges{
    CDTimeRange range1 = CDMakeTimeRange(1.0, 10.0);
    CDTimeRange range2 = CDMakeTimeRange(1.0, 10.0);
    CDTimeRange range3 = CDMakeTimeRange(1.0, -11.0);
    STAssertTrueNoThrow(CDEqualTimeRanges(range1, range2), @"{%f, %f} fails {%f, %f}", range1.location, range1.length, range2.location, range2.length);
    STAssertFalseNoThrow(CDEqualTimeRanges(range1, range3), @"{%f, %f} fails {%f, %f}", range1.location, range1.length, range3.location, range3.length);
}

- (void)testIntersectionTimeRange{
    CDTimeRange range1 = CDMakeTimeRange(1.0, 10.0);
    CDTimeRange range2 = CDMakeTimeRange(1.0, 10.0);
    CDTimeRange range3 = CDMakeTimeRange(1.0, 11.0);
    CDTimeRange range4 = CDMakeTimeRange(0.5, 0.8);
    CDTimeRange range5 = CDMakeTimeRange(10.0, 10.0);

    CDTimeRange intersection1 = CDIntersectionTimeRange(range1, range2);
    CDTimeRange answer1 = CDMakeTimeRange(1.0, 10.0);
    STAssertTrueNoThrow(CDEqualTimeRanges(intersection1, answer1), @"{%f, %f} fails {%f, %f}", intersection1.location, intersection1.length, answer1.location, answer1.length);
    
    CDTimeRange intersection2 = CDIntersectionTimeRange(range2, range3);
    CDTimeRange answer2 = CDMakeTimeRange(1.0, 10.0);
    STAssertTrueNoThrow(CDEqualTimeRanges(intersection2, answer2), @"{%f, %f} fails {%f, %f}", intersection2.location, intersection2.length, answer2.location, answer2.length);
    
    CDTimeRange intersection3 = CDIntersectionTimeRange(range2, range4);
    CDTimeRange answer3 = CDMakeTimeRange(1.0, 0.3);
    STAssertTrueNoThrow(CDEqualTimeRanges(intersection3, answer3), @"{%f, %f} fails {%f, %f}", intersection3.location, intersection3.length, answer3.location, answer3.length);

    CDTimeRange intersection4 = CDIntersectionTimeRange(range3, range5);
    CDTimeRange answer4 = CDMakeTimeRange(10, 2);
    STAssertTrueNoThrow(CDEqualTimeRanges(intersection4, answer4), @"{%f, %f} fails {%f, %f}", intersection4.location, intersection4.length, answer4.location, answer4.length);
}

- (void)testTimeRangeContainsTimeRange{
    CDTimeRange range1 = CDMakeTimeRange(1.0, 10.0);
    CDTimeRange range2 = CDMakeTimeRange(1.0, 10.0);
    CDTimeRange range3 = CDMakeTimeRange(0.5, 10.5);
    CDTimeRange range4 = CDMakeTimeRange(1.0, 11.0);
    CDTimeRange range5 = CDMakeTimeRange(2, 2);
    CDTimeRange range6 = CDMakeTimeRange(-1.0, 60.0);

    STAssertTrueNoThrow(CDTimeRangeContainsTimeRange(range1, range2), @"{%f, %f} fails {%f, %f}", range1.location, range1.length, range2.location, range2.length);
    STAssertTrueNoThrow(CDTimeRangeContainsTimeRange(range3, range1), @"{%f, %f} fails {%f, %f}", range3.location, range3.length, range1.location, range1.length);
    STAssertTrueNoThrow(CDTimeRangeContainsTimeRange(range4, range1), @"{%f, %f} fails {%f, %f}", range4.location, range4.length, range1.location, range1.length);
    STAssertTrueNoThrow(CDTimeRangeContainsTimeRange(range1, range5), @"{%f, %f} fails {%f, %f}", range1.location, range1.length, range5.location, range5.length);
    STAssertTrueNoThrow(CDTimeRangeContainsTimeRange(range6, range1), @"{%f, %f} fails {%f, %f}", range6.location, range6.length, range1.location, range1.length);
}

@end
