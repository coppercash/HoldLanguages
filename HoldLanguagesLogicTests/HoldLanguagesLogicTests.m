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
    CDDoubleRange range1 = CDMakeDoubleRange(1.0, 10.0);
    CDDoubleRange range2 = CDMakeDoubleRange(1.0, -10.0);
    STAssertTrueNoThrow((range1.location == range2.location && range1.length == range2.length), @"{%f, %f} fails {%f, %f}", range1.location, range1.length, range2.location, range2.length);
}

- (void)testEqualTimeRanges{
    CDDoubleRange range1 = CDMakeDoubleRange(1.0, 10.0);
    CDDoubleRange range2 = CDMakeDoubleRange(1.0, 10.0);
    CDDoubleRange range3 = CDMakeDoubleRange(1.0, -11.0);
    STAssertTrueNoThrow(CDEqualTimeRanges(range1, range2), @"{%f, %f} fails {%f, %f}", range1.location, range1.length, range2.location, range2.length);
    STAssertFalseNoThrow(CDEqualTimeRanges(range1, range3), @"{%f, %f} fails {%f, %f}", range1.location, range1.length, range3.location, range3.length);
}

- (void)testIntersectionTimeRange{
    CDDoubleRange range1 = CDMakeDoubleRange(1.0, 10.0);
    CDDoubleRange range2 = CDMakeDoubleRange(1.0, 10.0);
    CDDoubleRange range3 = CDMakeDoubleRange(1.0, 11.0);
    CDDoubleRange range4 = CDMakeDoubleRange(0.5, 0.8);
    CDDoubleRange range5 = CDMakeDoubleRange(10.0, 10.0);

    CDDoubleRange intersection1 = CDIntersectionTimeRange(range1, range2);
    CDDoubleRange answer1 = CDMakeDoubleRange(1.0, 10.0);
    STAssertTrueNoThrow(CDEqualTimeRanges(intersection1, answer1), @"{%f, %f} fails {%f, %f}", intersection1.location, intersection1.length, answer1.location, answer1.length);
    
    CDDoubleRange intersection2 = CDIntersectionTimeRange(range2, range3);
    CDDoubleRange answer2 = CDMakeDoubleRange(1.0, 10.0);
    STAssertTrueNoThrow(CDEqualTimeRanges(intersection2, answer2), @"{%f, %f} fails {%f, %f}", intersection2.location, intersection2.length, answer2.location, answer2.length);
    
    CDDoubleRange intersection3 = CDIntersectionTimeRange(range2, range4);
    CDDoubleRange answer3 = CDMakeDoubleRange(1.0, 0.3);
    STAssertTrueNoThrow(CDEqualTimeRanges(intersection3, answer3), @"{%f, %f} fails {%f, %f}", intersection3.location, intersection3.length, answer3.location, answer3.length);

    CDDoubleRange intersection4 = CDIntersectionTimeRange(range3, range5);
    CDDoubleRange answer4 = CDMakeDoubleRange(10, 2);
    STAssertTrueNoThrow(CDEqualTimeRanges(intersection4, answer4), @"{%f, %f} fails {%f, %f}", intersection4.location, intersection4.length, answer4.location, answer4.length);
}

- (void)testTimeRangeContainsTimeRange{
    CDDoubleRange range1 = CDMakeDoubleRange(1.0, 10.0);
    CDDoubleRange range2 = CDMakeDoubleRange(1.0, 10.0);
    CDDoubleRange range3 = CDMakeDoubleRange(0.5, 10.5);
    CDDoubleRange range4 = CDMakeDoubleRange(1.0, 11.0);
    CDDoubleRange range5 = CDMakeDoubleRange(2, 2);
    CDDoubleRange range6 = CDMakeDoubleRange(-1.0, 60.0);

    STAssertTrueNoThrow(CDDoubleRangeContainsTimeRange(range1, range2), @"{%f, %f} fails {%f, %f}", range1.location, range1.length, range2.location, range2.length);
    STAssertTrueNoThrow(CDDoubleRangeContainsTimeRange(range3, range1), @"{%f, %f} fails {%f, %f}", range3.location, range3.length, range1.location, range1.length);
    STAssertTrueNoThrow(CDDoubleRangeContainsTimeRange(range4, range1), @"{%f, %f} fails {%f, %f}", range4.location, range4.length, range1.location, range1.length);
    STAssertTrueNoThrow(CDDoubleRangeContainsTimeRange(range1, range5), @"{%f, %f} fails {%f, %f}", range1.location, range1.length, range5.location, range5.length);
    STAssertTrueNoThrow(CDDoubleRangeContainsTimeRange(range6, range1), @"{%f, %f} fails {%f, %f}", range6.location, range6.length, range1.location, range1.length);
}

@end
