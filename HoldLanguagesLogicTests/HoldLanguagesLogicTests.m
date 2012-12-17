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
#import "Header.h"

@implementation HoldLanguagesLogicTests

- (void)setUp
{
    [super setUp];
    
    NSString* lyricsPath = [CDiTunesFinder findFileWithName:@"Halo.lrc" ofType:kLRCExtension];
    _lrcLyrics = [[CDLRCLyrics alloc] initWithFile:lyricsPath];
}

- (void)tearDown
{
    SafeRelease(_lrcLyrics);
    
    [super tearDown];
}

- (void)testLRCLyrics{
    LogStart;
    
    [_lrcLyrics indexOfStampNearTime:10];
    
    LogEnd;
}

@end
