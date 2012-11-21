//
//  CDAudioSharer.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/11/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CDAudioPlayerStatePlaying,
    CDAudioPlayerStatePaused,
    CDAudioPlayerStateStopped
}CDAudioPlayerState;

@protocol CDAudioPlayerDelegate;
@class CDAudioPlayer, MPMediaItemCollection;
@interface CDAudioSharer : NSObject

@property(nonatomic, readonly, strong)NSArray* delegates;
@property(nonatomic, strong)CDAudioPlayer* audioPlayer;
@property(nonatomic, readonly, strong)NSTimer* processTimer;
@property(nonatomic, readonly, copy)NSString* audioName;
@property(nonatomic, readonly) NSTimeInterval currentDuration;

+ (CDAudioSharer*)sharedAudioPlayer;
- (void)registAsDelegate:(id<CDAudioPlayerDelegate>)delegate;
- (void)removeDelegate:(id<CDAudioPlayerDelegate>)delegate;
- (NSString*)openQueueWithItemCollection:(MPMediaItemCollection *)itemCollection;
- (void)play;
- (void)pause;
- (void)playOrPause;
- (void)stop;
- (void)playbackFor:(NSTimeInterval)playbackTime;
- (void)playbackAt:(NSTimeInterval)playbackTime;
- (float)playbackRate;
- (NSString*)valueForProperty:(NSString *)property;

@end

@protocol CDAudioPlayerDelegate
@required
- (void)audioSharer:(CDAudioSharer*)audioSharer refreshPlaybackTime:(NSTimeInterval)playbackTime;
- (void)audioSharer:(CDAudioSharer*)audioSharer stateDidChange:(CDAudioPlayerState)state;
- (void)audioSharerNowPlayingItemDidChange:(CDAudioSharer*)audioSharer;
@end