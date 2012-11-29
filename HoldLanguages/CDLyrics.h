//
//  CDLyrics.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/12/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kLRCExtension @"lrc"

@interface CDLyrics : NSObject
@property(nonatomic, readonly) NSUInteger numberOfLyricsRows;
@property(nonatomic, readonly) BOOL isReady;
- (id)initWithFile:(NSString*)filePath;
- (NSString*)contentAtIndex:(NSUInteger)index;
- (NSTimeInterval)timeAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfStampNearTime:(NSTimeInterval)time;

@end
