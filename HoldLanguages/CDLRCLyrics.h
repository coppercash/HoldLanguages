//
//  CDLRCLyrics.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/12/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDLyrics.h"

@interface CDLRCLyrics : CDLyrics
@property(nonatomic, strong) NSArray* timeStamps;
@property(nonatomic, strong) NSArray* otherStamps;
@end

@interface CDLRCTimeStamp : NSObject
@property(nonatomic) NSTimeInterval time;
@property(nonatomic, strong) NSString* content;
- (id)initWithTime:(NSString*)timeInString content:(NSString*)content;
@end

@interface CDLRCOtherStamp : NSObject
@property(nonatomic, copy) NSString* type;
@property(nonatomic, copy) NSString* content;
- (id)initWithStamp:(NSString*)stamp;
@end

@interface CDLRCParser : NSObject
@property(nonatomic, strong) NSMutableArray* lines;
@property(nonatomic, strong) NSMutableArray* stampDictionaries;
@property(nonatomic, strong) NSMutableArray* timeStamps;
@property(nonatomic, strong) NSMutableArray* otherStamps;
- (id)initWithFile:(NSString*)filePath;
+ (void)parseFile:(NSString*)filePath intoDictionary:(NSMutableDictionary*)dictionary;
@end