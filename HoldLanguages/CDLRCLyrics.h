//
//  CDLRCLyrics.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/12/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDLyrics.h"

@interface CDLRCLyrics : CDLyrics
@property(nonatomic, readonly,strong) NSArray* timeStamps;
@property(nonatomic, readonly,strong) NSArray* otherStamps;
@end

@interface CDLRCTimeStamp : NSObject
@property(nonatomic, readonly) NSTimeInterval time;
@property(nonatomic, readonly, strong) NSString* content;
- (id)initWithTime:(NSString*)timeInString content:(NSString*)content;
@end

@interface CDLRCOtherStamp : NSObject
@property(nonatomic, readonly, copy) NSString* type;
@property(nonatomic, readonly, copy) NSString* content;
- (id)initWithStamp:(NSString*)stamp;
@end

@interface CDLRCParser : NSObject
@property(nonatomic, strong) NSMutableArray* lines;
@property(nonatomic, strong) NSMutableArray* stampDictionaries;
@property(nonatomic, strong) NSMutableArray* timeStamps;
@property(nonatomic, strong) NSMutableArray* otherStamps;
+ (void)parseFile:(NSString*)filePath intoDictionary:(NSMutableDictionary*)dictionary;
@end