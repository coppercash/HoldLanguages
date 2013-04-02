//
//  CDAudioSharer.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/11/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDProgress.h"
#import "CDAudioPlayer.h"
#import "CDCycleArray.h"

@protocol CDAudioPlayerDelegate,CDAudioPlayer;
@class MPMediaItemCollection;
@interface CDAudioSharer : UIResponder <CDAudioProgressDataSource>{
    NSArray *_delegates;
    id<CDAudioPlayer> _audioPlayer;
}
@property(nonatomic, strong)id<CDAudioPlayer> audioPlayer;
@property(nonatomic, assign)float rate;
#pragma mark - Diplomacy
+ (CDAudioSharer*)sharedAudioPlayer;
- (void)registAsDelegate:(id<CDAudioPlayerDelegate>)delegate;
- (void)removeDelegate:(id<CDAudioPlayerDelegate>)delegate;
#pragma mark - Open
- (void)openQueueWithItemCollection:(MPMediaItemCollection *)itemCollection;
- (void)openiTunesSharedFile:(NSString*)path;
#pragma mark - Control
- (void)play;
- (void)pause;
- (void)playOrPause;
- (void)stop;
- (void)next;
- (void)previous;
#pragma mark - Playback
- (void)playbackFor:(NSTimeInterval)playbackTime;
- (void)playbackAt:(NSTimeInterval)playbackTime;
#pragma mark - Repeat
- (BOOL)repeatIn:(CDDoubleRange)timeRange;
- (void)setRepeatA;
- (void)setRepeatB;
- (void)stopRepeating;
//- (CDDoubleRange)repeatRange;
//- (BOOL)isRepeating;
- (BOOL)canRepeat;
#pragma mark - Infomation
- (CDCycleArray*)rates;
- (NSTimeInterval)currentPlaybackTime;
//- (NSTimeInterval)currentDuration;
- (float)playbackRate;
- (float)repeatRate;
- (id)valueForProperty:(NSString *)property;

@end

@protocol CDAudioPlayerDelegate
@required
- (void)audioSharer:(CDAudioSharer*)audioSharer stateDidChange:(CDAudioPlayerState)state;
- (void)audioSharerNowPlayingItemDidChange:(CDAudioSharer*)audioSharer;

- (void)audioSharer:(CDAudioSharer *)audioSharer didRepeatInRange:(CDDoubleRange)range;
- (void)audioSharer:(CDAudioSharer *)audioSharer didSetRepeatA:(NSTimeInterval)pointA;
- (void)audioSharerDidCancelRepeating:(CDAudioSharer *)audioSharer;

@end