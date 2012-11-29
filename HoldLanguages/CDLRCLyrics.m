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
#import "Header.h"

@interface CDLRCLyrics ()
- (NSUInteger)seekIndexOfStampBeforeTime:(NSTimeInterval)time backwardFromIndex:(NSUInteger)index;
- (NSUInteger)seekIndexOfStampNextToTime:(NSTimeInterval)time forwardFromIndex:(NSUInteger)index;
@end
@implementation CDLRCLyrics
@synthesize timeStamps = _timeStamps, otherStamps = _otherStamps;

- (id)initWithFile:(NSString *)filePath{
    self = [super init];
    if (self) {
        NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] initWithCapacity:4];
        [CDLRCParser parseFile:filePath intoDictionary:dictionary];
        _timeStamps = [dictionary objectForKey:kTimeStamps];
        _otherStamps = [dictionary objectForKey:kOtherStamps];
        
        /*
         for (CDLRCTimeStamp* stamp in self.timeStamps) {
         DLog(@"%f\t%@", stamp.time, stamp.content);
         }
         for (CDLRCOtherStamp* stamp in self.otherStamps) {
         DLog(@"%@\t%@", stamp.type, stamp.content);
         }
         */
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
        NSTimeInterval currentTime = [self timeAtIndex:index];
        NSUInteger newIndex = 0;
        if(time > currentTime){
            newIndex = [self seekIndexOfStampNextToTime:time forwardFromIndex:index];
        }else{
            newIndex = [self seekIndexOfStampBeforeTime:time backwardFromIndex:index];
        }
        index = newIndex;
        return index;
    }
    @catch (NSException *exception) {
        return NSUIntegerMax;
    }
}

- (NSUInteger)seekIndexOfStampBeforeTime:(NSTimeInterval)time backwardFromIndex:(NSUInteger)index{
    if (index == 0) return 0;
    NSUInteger backwardIndex = index - 1;
    NSTimeInterval backwardTime = [self timeAtIndex:backwardIndex];
    if (time < backwardTime) {
        return [self seekIndexOfStampBeforeTime:time backwardFromIndex:backwardIndex];
    }else{
        return backwardIndex;
    }
}

- (NSUInteger)seekIndexOfStampNextToTime:(NSTimeInterval)time forwardFromIndex:(NSUInteger)index{
    if (index >= self.timeStamps.lastIndex) return self.timeStamps.lastIndex;
    NSUInteger forwardIndex = index + 1;
    NSTimeInterval forwardTime = [self timeAtIndex:forwardIndex];
    if (time > forwardTime) {
        return [self seekIndexOfStampNextToTime:time forwardFromIndex:forwardIndex];
    }else{
        return index;
    }
}

#pragma mark - Don't delete, there will be a variable about "degree".
- (NSUInteger)seekIndexOfStampNearTime:(NSTimeInterval)time backwardFromIndex:(NSUInteger)index{
    if (index == 0) return 0;
    NSUInteger backwardIndex = index - 1;
    NSTimeInterval backwardTime = [self timeAtIndex:backwardIndex];
    NSTimeInterval forwardTime = [self timeAtIndex:index];
    if (time < backwardTime) {
        return [self seekIndexOfStampNearTime:time backwardFromIndex:backwardIndex];
    }else{
        if (time - backwardTime < forwardTime - time) {
            return backwardIndex;
        }else{
            return index;
        }
    }
}

- (NSUInteger)seekIndexOfStampNearTime:(NSTimeInterval)time forwardFromIndex:(NSUInteger)index{
    if (index >= self.timeStamps.lastIndex) return self.timeStamps.lastIndex;
    NSUInteger forwardIndex = index + 1;
    NSTimeInterval backwardTime = [self timeAtIndex:index];
    NSTimeInterval forwardTime = [self timeAtIndex:forwardIndex];
    if (time > forwardTime) {
        return [self seekIndexOfStampNearTime:time forwardFromIndex:forwardIndex];
    }else{
        if (time - backwardTime > forwardTime - time) {
            return forwardIndex;
        }else{
            return index;
        }
    }
}

bool isCloserToPrevious(NSTimeInterval reciever, NSTimeInterval previous, NSTimeInterval next){
    bool isCloser = (reciever - previous) < (next - reciever);
    return isCloser;
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

- (void)initialize;
- (void)parseFile:(NSString *)filePath;
- (void)lines:(NSMutableArray*)lines withString:(NSString*)string;
- (void)stampDictionaries:(NSMutableArray*)dictionaries withLines:(NSArray*)lines;
- (void)timeStamps:(NSMutableArray*)timeStamps otherStamps:(NSMutableArray*)otherStamps withStampDictionaries:(NSArray*)dictionaries;
- (void)stampDictionary:(NSMutableDictionary*)dictionary withLine:(NSString*)line;
- (BOOL)isTimeStamp:(NSDictionary*)stampDictionary;
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
    NSString* pattern = @"^\\d|[:.]$";
    NSError *error = [[NSError alloc] init];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    NSArray* matches = [regex matchesInString:stamp
                                      options:NSRegularExpressionCaseInsensitive
                                        range:NSMakeRange(0, stamp.length)];
    bool isMatch = matches.count == 1;
    return isMatch;
}


//Old version of LRC parse functions below
- (id)initWithFile:(NSString*)filePath{
    self = [super init];
    if (self) {
        [self initialize];
        [self parseFile:filePath];
    }
    return self;
}

- (void)initialize{
    self.lines = [[NSMutableArray alloc] init];
    self.stampDictionaries = [[NSMutableArray alloc] init];
    self.timeStamps = [[NSMutableArray alloc] init];
    self.otherStamps = [[NSMutableArray alloc] init];
}

- (void)parseFile:(NSString *)filePath{
    if (filePath == nil) return;
    NSError* error = [[NSError alloc] init];
    NSString* fileInString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (fileInString == nil) return;
    [self lines:self.lines withString:fileInString];
    [self stampDictionaries:self.stampDictionaries withLines:self.lines];
    [self timeStamps:self.timeStamps otherStamps:self.otherStamps withStampDictionaries:self.stampDictionaries];
    
    NSArray* sortedTimeStamps = [self.timeStamps sortedArrayUsingSelector:@selector(compare:)];
    [self.timeStamps removeAllObjects];
    [self.timeStamps addObjectsFromArray:sortedTimeStamps];
}

- (void)lines:(NSMutableArray*)lines withString:(NSString*)string{
    if (lines == nil) return;
    if (string == nil || string.length == 0) return;
    
    NSString* separater = @"\n";
    NSArray* newLines = [string componentsSeparatedByString:separater];
    [lines addObjectsFromArray:newLines];
}

- (void)stampDictionaries:(NSMutableArray*)dictionaries withLines:(NSArray*)lines{
    for (NSString* line in lines) {
        if (line.isVisuallyEmpty) continue;
        
        NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
        [self stampDictionary:dictionary withLine:line];
        [dictionaries addObject:dictionary];
    }
}

- (void)timeStamps:(NSMutableArray*)timeStamps otherStamps:(NSMutableArray*)otherStamps withStampDictionaries:(NSArray*)dictionaries{
    for (NSDictionary* dictionary in dictionaries) {
        NSArray* stamps = [dictionary objectForKey:kStamp];
        NSString* content = [dictionary objectForKey:kContent];
        if ([self isTimeStamp:dictionary]) {
            for (NSString* stamp in stamps) {
                CDLRCTimeStamp* timeStamp = [[CDLRCTimeStamp alloc] initWithTime:stamp content:content];
                [timeStamps addObject:timeStamp];
            }
        }else{
            for (NSString* stamp in stamps) {
                CDLRCOtherStamp* otherStamp = [[CDLRCOtherStamp alloc] initWithStamp:stamp];
                [otherStamps addObject:otherStamp];
            }
        }
    }
}

- (void)stampDictionary:(NSMutableDictionary*)dictionary withLine:(NSString*)line{
    NSCharacterSet* separeters = [NSCharacterSet characterSetWithCharactersInString:@"[]"];
    NSArray* components = [line componentsSeparatedByCharactersInSet:separeters];
    
    NSMutableArray* stamps = [[NSMutableArray alloc] init];
    [dictionary setObject:stamps forKey:kStamp];
    for (NSString* component in components) {
        if (component.isVisuallyEmpty) continue;
        
        NSString* previous = [line previousCharacterBeforeSubstring:component];
        NSString* next = [line nextCharacterAfterSubstring:component];
        BOOL isStamp = [previous isEqualToString:@"["] && [next isEqualToString:@"]"];
        if (isStamp) {
            [stamps addObject:component];
        }else{
            [dictionary setObject:component forKey:kContent];
        }
    }
}

- (BOOL)isTimeStamp:(NSDictionary *)stampDictionary{
    BOOL isTimeStamp = YES;
    NSArray* stamps = [stampDictionary objectForKey:kStamp];
    for (NSString* stamp in stamps) {
        NSString* pattern = @"^\\d|[:.]$";
        NSError *error = [[NSError alloc] init];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
        NSTextCheckingResult *isMatch = [regex firstMatchInString:stamp
                                                          options:NSRegularExpressionCaseInsensitive
                                                            range:NSMakeRange(0, stamp.length)];
        if (isMatch == nil) {
            isTimeStamp = NO;
            break;
        }
    }
    return isTimeStamp;
}

@end