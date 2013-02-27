//
//  CDLyrics.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/12/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kLRCExtension @"lrc"

//#define kKeyStampType @"Type"
//#define kKeyStampContent @"Content"

typedef enum {
    CDLyricsStampTypeTitle,
    CDLyricsStampTypeArtist,
    CDLyricsStampTypeAlbum,
    CDLyricsStampTypeAuthor
}CDLyricsStampType;

typedef enum{
    CDSeekBackward = -1,
    CDSeekUndefined = 0,
    CDSeekForward = 1
}CDSeekDestination;

@interface CDLyrics : NSObject
@property(nonatomic, readonly) NSUInteger numberOfLyricsRows;
@property(nonatomic, readonly) BOOL isReady;
- (id)initWithFile:(NSString*)filePath;
- (NSString*)contentAtIndex:(NSUInteger)index;
- (NSTimeInterval)timeAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfStampNearTime:(NSTimeInterval)time;
- (NSString*)contentOfType:(CDLyricsStampType)type;
- (NSArray*)lyricsInfo;
@end
