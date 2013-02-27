//
//  CDLRCLyrics.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/12/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#define kStamp @"stamp"
#define kContent @"content"
#define kTimeStamps @"TimeStamps"
#define kOtherStamps @"OtherStamps"

#import "CDLRCLyrics.h"
#import "CDString.h"
#import "CDStack.h"

NSString * const gKeyStampType = @"ty";
NSString * const gKeyStampContent = @"ctt";

@interface CDLRCLyrics ()
NSUInteger seekIndexOfStampsClosedToTime(NSUInteger index, NSTimeInterval time, CDSeekDestination destintion, NSArray* array);
@end
@implementation CDLRCLyrics
@synthesize timeStamps = _timeStamps, otherStamps = _otherStamps;

- (id)initWithFile:(NSString *)filePath{
    self = [super initWithFile:filePath];
    if (self) {
        NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] initWithCapacity:4];
        [CDLRCParser parseFile:filePath intoDictionary:dictionary];
        _timeStamps = [dictionary objectForKey:kTimeStamps];
        _otherStamps = [dictionary objectForKey:kOtherStamps];
    }
    return self;
}

- (NSUInteger)numberOfLyricsRows{
    NSUInteger numberOfLyricsRows = [self.timeStamps count];
    return numberOfLyricsRows;
}

- (NSString*)contentAtIndex:(NSUInteger)index{
    CDLRCTimeStamp* stamp = [self.timeStamps objectAtIndex:index];
    NSString* content = stamp.content;
    return content;
}

- (NSTimeInterval)timeAtIndex:(NSUInteger)index{
    CDLRCTimeStamp* stamp = [self.timeStamps objectAtIndex:index];
    NSTimeInterval time = stamp.time;
    return time;
}

- (BOOL)isReady{
    BOOL isReady = YES;
    if (self.timeStamps == nil) isReady = NO;
    if (self.timeStamps.count == 0) isReady = NO;
    return isReady;
}

- (NSUInteger)indexOfStampNearTime:(NSTimeInterval)time{
    static NSUInteger index = 0;
    @try {
        index = seekIndexOfStampsClosedToTime(index, time, CDSeekUndefined, self.timeStamps);
        return index;
    }
    @catch (NSException *exception) {
        return NSUIntegerMax;
    }
}

NSUInteger seekIndexOfStampsClosedToTime(NSUInteger index,
                                         NSTimeInterval time,
                                         CDSeekDestination destintion,
                                         NSArray* array
                                         ){
    /*Determine seeking destination,backward or forward*/
    if (destintion == CDSeekUndefined) {
        CDLRCTimeStamp* cStamp = [array objectAtIndex:index];
        destintion = time < cStamp.time ? CDSeekBackward : CDSeekForward;
    }
    
    //Find the closed stamp to current one.
    NSUInteger seekIndex = index + destintion;
    {//Ensure seeking won't be out of scope.
        if (seekIndex == NSUIntegerMax) return 0;   //Because NSUInteger 0 minus 1 wont't be -1.
        NSUInteger lastIndex = array.lastIndex;
        if (seekIndex > lastIndex) return lastIndex;    //Must under last sentence.Because NSUInteger is greater than lastIndex.
    }
    CDLRCTimeStamp* seekStamp = [array objectAtIndex:seekIndex];
    NSTimeInterval seekTime = seekStamp.time;
    //According to destination, determine continuing seeking or not
    BOOL continueSeeking = NO;
    switch (destintion) {
        case CDSeekBackward:{
            continueSeeking = time < seekTime;
        }break;
        case CDSeekForward:{
            continueSeeking = time > seekTime;
        }break;
        default:
            break;
    }
    
    if (continueSeeking) {
        index = seekIndexOfStampsClosedToTime(seekIndex, time, destintion, array);
    }else{
        /*
         The index should be the previous one before the time in using.
         So, for backward seeking the previous index, for forward seeking the current.
         */
        if (destintion == CDSeekBackward) {
            index = seekIndex;
        }
    }
    return index;
}

- (NSString*)contentOfType:(CDLyricsStampType)type{
    NSArray *typeIDs = @[@"tl", @"ar", @"al", @"by"];
    NSString *typeID = [typeIDs objectAtIndex:(NSUInteger)type];
    NSString *content = nil;
    for (CDLRCOtherStamp *stamp in _otherStamps) {
        if ([stamp.type isEqualToString:typeID]) {
            content = stamp.content;
            break;
        }
    }
    return content;
}

- (NSArray*)lyricsInfo{
    NSMutableArray *info = [[NSMutableArray alloc] initWithCapacity:_otherStamps.count];
    for (CDLRCOtherStamp *stamp in _otherStamps) {
        NSString *type = stamp.type;
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(type, type), gKeyStampType, stamp.content, gKeyStampContent, nil];
        [info addObject:dic];
    }
    return info;
}

@end

@implementation CDLRCTimeStamp
@synthesize time = _time, content = _content;
- (id)initWithTime:(NSString*)timeInString content:(NSString*)content{
    self = [super init];
    if (self) {
        @try {
            NSCharacterSet* separeters = [NSCharacterSet characterSetWithCharactersInString:@":."];
            NSArray* components = [timeInString componentsSeparatedByCharactersInSet:separeters];
            
            NSString* minute = [components objectAtIndex:0];
            NSString* second = [components objectAtIndex:1];
            NSString* subSecond = [components objectAtIndex:2];
            
            NSTimeInterval time = minute.doubleValue * 60 + second.doubleValue + subSecond.doubleValue / 100;
            
            _time = time;
            _content = content;
        }
        @catch (NSException *exception) {
            _time = 0.0f;
            _content = @"Error Timp Stamp";
        }
    }
    return self;
}

- (NSComparisonResult)compare:(CDLRCTimeStamp*)timeStamp{
    NSComparisonResult comparison = NSOrderedSame;
    if (self.time > timeStamp.time) {
        comparison = NSOrderedDescending;
    }else if (self.time < timeStamp.time) {
        comparison = NSOrderedAscending;
    }
    return comparison;
}

@end

@implementation CDLRCOtherStamp
@synthesize type = _type, content = _content;
- (id)initWithStamp:(NSString*)stamp{
    self = [super init];
    if (self) {
        @try {
            NSCharacterSet* separeters = [NSCharacterSet characterSetWithCharactersInString:@":"];
            NSArray* components = [stamp componentsSeparatedByCharactersInSet:separeters];
            _type = [components objectAtIndex:0];
            _content = [components objectAtIndex:1];
        }
        @catch (NSException *exception) {
            _type = @"Error Other Stamp";
            _content = @"Error Other Stamp";
        }
    }
    return self;
}
@end

@interface CDLRCParser ()
NSString* stringFromFile(NSString* filePath);
bool isStamp(NSString* subString, NSString* string);
bool isTimeStamp(NSString* stamp);

@end

@implementation CDLRCParser
@synthesize lines = _lines, stampDictionaries = _stampDictionaries, timeStamps = _timeStamps, otherStamps = _otherStamps;

NSString* stringFromFile(NSString* filePath){
    /*Mainly take care encoding problems.*/
    
    NSError* error = [[NSError alloc] init];
    NSString* fileInString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    
    NSNumber* encErrorNumber = [error.userInfo objectForKey:@"NSStringEncoding"];
    if (encErrorNumber.integerValue == 4) {
        NSStringEncoding gb2312 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        fileInString = [NSString stringWithContentsOfFile:filePath encoding:gb2312 error:&error];
    }
    return fileInString;
}

+ (void)parseFile:(NSString*)filePath intoDictionary:(NSMutableDictionary*)dictionary{
    if (filePath == nil || dictionary == nil) return;
    
    /*File to string*/
    NSString* fileInString = stringFromFile(filePath);
    if (fileInString == nil || fileInString.length == 0) return;
    
    /*String to lines*/
    NSString* lineBreak = @"\n";
    NSArray* lines = [fileInString componentsSeparatedByString:lineBreak];
    
    NSMutableArray* timeStamps = [[NSMutableArray alloc] init];
    NSMutableArray* otherStamps = [[NSMutableArray alloc] init];
    NSString* emptyContent = @"";
    for (NSString* line in lines) {
        if (line.isVisuallyEmpty) continue;
        
        NSCharacterSet* separators = [NSCharacterSet characterSetWithCharactersInString:@"[]"];
        NSArray* components = [line componentsSeparatedByCharactersInSet:separators];
        
        NSMutableArray* timeStringStack = [[NSMutableArray alloc] initWithCapacity:4];
        for (NSString* component in components) {
            if (component.isVisuallyEmpty) continue;
            
            if (isStamp(component, line)) {
                /*A Stamp*/
                if (isTimeStamp(component)) {
                    /*A time stamp*/
                    [timeStringStack push:component];
                }else{
                    /*An other stamp*/
                    CDLRCOtherStamp* otherStamp = [[CDLRCOtherStamp alloc] initWithStamp:component];
                    [otherStamps addObject:otherStamp];
                }
            }else{
                /*A Content component*/
                while (!timeStringStack.isEmpty) {
                    NSString* timeString = timeStringStack.pop;
                    CDLRCTimeStamp* timeStamp = [[CDLRCTimeStamp alloc] initWithTime:timeString content:component];
                    [timeStamps addObject:timeStamp];
                }
            }
        }
        /*Deal with empty TimeStamp*/
        while (!timeStringStack.isEmpty) {
            NSString* timeString = timeStringStack.pop;
            CDLRCTimeStamp* timeStamp = [[CDLRCTimeStamp alloc] initWithTime:timeString content:emptyContent];
            [timeStamps addObject:timeStamp];
        }
    }
    
    NSArray* sortedTimeStamps = [timeStamps sortedArrayUsingSelector:@selector(compare:)];
    [dictionary setObject:sortedTimeStamps forKey:kTimeStamps];
    [dictionary setObject:otherStamps forKey:kOtherStamps];
}

bool isStamp(NSString* subString, NSString* string){
    NSString* previous = [string previousCharacterBeforeSubstring:subString];
    NSString* next = [string nextCharacterAfterSubstring:subString];
    bool isStamp = [previous isEqualToString:@"["] && [next isEqualToString:@"]"];
    return isStamp;
}

bool isTimeStamp(NSString* stamp){
    //NSString* pattern = @"^\\d|[:.]$";
    NSString* pattern = @"^\\d{1,2}:\\d{1,2}\\.\\d{1,2}$";
    NSError *error = [[NSError alloc] init];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    NSArray* matches = [regex matchesInString:stamp
                                      options:NSRegularExpressionCaseInsensitive
                                        range:NSMakeRange(0, stamp.length)];
    bool isMatch = matches.count == 1;
    return isMatch;
}

@end