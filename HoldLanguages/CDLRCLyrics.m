//
//  CDLRCLyrics.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/12/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#define kStamp @"stamp"
#define kContent @"content"

#import "CDLRCLyrics.h"
#import "Header.h"

@implementation CDLRCLyrics
@synthesize timeStamps = _timeStamps, otherStamps = _otherStamps;

- (id)initWithFile:(NSString *)filePath{
    self = [super init];
    if (self) {
        CDLRCParser* parser = [[CDLRCParser alloc] initWithFile:filePath];
        self.timeStamps = parser.timeStamps;
        self.otherStamps = [[NSArray alloc] initWithArray:parser.otherStamps];
        for (CDLRCTimeStamp* stamp in self.timeStamps) {
            DLog(@"%f\t%@", stamp.time, stamp.content);
        }
        for (CDLRCOtherStamp* stamp in self.otherStamps) {
            DLog(@"%@\t%@", stamp.type, stamp.content);
        }
    }
    return self;
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
            
            self.time = time;
            self.content = content;
        }
        @catch (NSException *exception) {
            self.time = 0.0f;
            self.content = @"Error Timp Stamp";
        }
    }
    return self;
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
            self.type = [components objectAtIndex:0];
            self.content = [components objectAtIndex:1];
        }
        @catch (NSException *exception) {
            self.type = @"Error Other Stamp";
            self.content = @"Error Other Stamp";
        }
    }
    return self;
}
@end

@interface CDLRCParser ()
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