//
//  CDPlayer.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/11/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
typedef enum {
    CDAudioRepeatModeNone = MPMusicRepeatModeNone,
    CDAudioRepeatModeOne = MPMusicRepeatModeOne,
    CDAudioRepeatModeAll = MPMusicRepeatModeAll
}CDAudioRepeatMode;

typedef enum {
    CDAudioPlayerStatePlaying,
    CDAudioPlayerStatePaused,
    CDAudioPlayerStateStopped
}CDAudioPlayerState;

@class MPMediaItemCollection;
@protocol CDAudioPlayer <NSObject>
@optional
#pragma mark - Open
- (void)openAudioWithURL:(NSURL*)url;
- (void)openQueueWithItemCollection:(MPMediaItemCollection *)itemCollection;
- (void)openiTunesSharedFile:(NSString*)path;

@required
@property(nonatomic, readonly)CDAudioPlayerState state;
@property(nonatomic, assign)CDAudioRepeatMode repeatMode;
@property(nonatomic, assign)float rate;
@property(nonatomic, readonly)NSTimeInterval pointA;
#pragma mark - Control
- (void)play;
- (void)pause;
- (void)stop;
- (BOOL)next;   //If YES indicates will play different audio.
- (BOOL)previous;   //If YES indicates will play different audio.
#pragma mark - Playback
- (void)playbackAt:(NSTimeInterval)playbackTime;
- (void)playbackFor:(NSTimeInterval)increment;
#pragma mark - Repeat
- (void)repeatIn:(CDTimeRange)timeRange;
- (void)setRepeatA;
- (void)setRepeatB;
- (void)stopRepeating;
- (CDTimeRange)repeatRange;
- (BOOL)isRepeating;
- (BOOL)isWaitingForPointB;
#pragma mark - Information
- (NSArray*)availableRate;
- (NSTimeInterval)currentPlaybackTime;
- (NSTimeInterval)currentDuration;
- (id)valueForProperty:(NSString*)property;
@end