//
//  CDAudioSharer.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/11/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "CDAudioSharer.h"
#import "CDiPodPlayer.h"
#import "CDAVAudioPlayer.h"

@interface CDAudioSharer ()
- (void)initialize;
- (void)handlePlaybackStateChanged:(id)notification;
- (void)handleNowPlayingItemChanged:(id)notification;
- (void)detectPlayerState;
@end

@implementation CDAudioSharer
@synthesize audioPlayer = _audioPlayer;

- (id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize{
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory: AVAudioSessionCategoryPlayback error: &setCategoryErr];
    [session setActive: YES error: &activationErr];
    
    self.audioPlayer = [[CDAVAudioPlayer alloc] init];
}

#pragma mark - Diplomacy
+ (CDAudioSharer*)sharedAudioPlayer{
    static CDAudioSharer* sharedAudioPlayer;
    @synchronized(self){
        if (sharedAudioPlayer == nil) {
            sharedAudioPlayer = [[CDAudioSharer alloc] init];
        }
    }
    return sharedAudioPlayer;
}

- (void)registAsDelegate:(id<CDAudioPlayerDelegate>)delegate{
    NSMutableArray* delegates = nil;
    if (_delegates == nil) {
        delegates = [[NSMutableArray alloc] initWithCapacity:1];
    }else{
        delegates = [[NSMutableArray alloc] initWithArray:_delegates];
    }
    [delegates addObject:delegate];
    _delegates = delegates;
}

- (void)removeDelegate:(id<CDAudioPlayerDelegate>)delegate{
    if (_delegates == nil || _delegates.count == 0) return;
    NSMutableArray* delegates = [[NSMutableArray alloc] initWithArray:_delegates];
    [delegates removeObject:delegate];
    _delegates = delegates;
}

#pragma mark - Players
- (void)setAudioPlayer:(NSObject<CDAudioPlayer>*)audioPlayer{
    if ([_audioPlayer isKindOfClass:[CDiPodPlayer class]]) {
        CDiPodPlayer* iPodPlayer = (CDiPodPlayer*)audioPlayer;
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter removeObserver:self name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:_audioPlayer];
        [notificationCenter removeObserver:self name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:_audioPlayer];
        [iPodPlayer.audioPlayer endGeneratingPlaybackNotifications];
    }
    
    if ([audioPlayer isKindOfClass:[CDiPodPlayer class]]) {
        CDiPodPlayer* iPodPlayer = (CDiPodPlayer*)audioPlayer;
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver: self
                               selector: @selector (handlePlaybackStateChanged:)
                                   name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
                                 object: iPodPlayer.audioPlayer];
        [notificationCenter addObserver: self
                               selector: @selector (handleNowPlayingItemChanged:)
                                   name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                                 object: iPodPlayer.audioPlayer];
        [iPodPlayer.audioPlayer beginGeneratingPlaybackNotifications];
    }
    _audioPlayer = audioPlayer;
}

#pragma mark - Control
- (void)play{
    [_audioPlayer play];
    [self detectPlayerState];
}

- (void)pause{
    [_audioPlayer pause];
    [self detectPlayerState];
}

- (void)stop{
    [_audioPlayer stop];
    [self detectPlayerState];
}

- (void)next{
    BOOL isChanged = [_audioPlayer next];
    if (isChanged && [_audioPlayer isKindOfClass:[CDAVAudioPlayer class]]) {
        for (id<CDAudioPlayerDelegate> delegate in _delegates) {
            [delegate audioSharerNowPlayingItemDidChange:self];
        }
    }
}

- (void)previous{
    BOOL isChanged = [_audioPlayer previous];
    if (isChanged &&[_audioPlayer isKindOfClass:[CDAVAudioPlayer class]]) {
        for (id<CDAudioPlayerDelegate> delegate in _delegates) {
            [delegate audioSharerNowPlayingItemDidChange:self];
        }
    }
}

- (void)playOrPause{
    if (_audioPlayer.isPlaying) {
        [self pause];
    }else{
        [self play];
    }
}

#pragma mark - Playback
- (void)playbackFor:(NSTimeInterval)playbackTime{
    [self.audioPlayer playbackFor:playbackTime];
}

- (void)playbackAt:(NSTimeInterval)playbackTime{
    [self.audioPlayer playbackAt:playbackTime];
}

#pragma mark - Convertion between Time and Distance
- (float)playbackRate{
    NSTimeInterval screenDuration = 10.0f;
    CGFloat holderHeight = 480.0f;
    
    NSTimeInterval duration = self.audioPlayer.currentDuration;
    float playbackRate;
    if (screenDuration > duration) {
        //Audio is too short.
        playbackRate = duration / holderHeight;
    }else{
        //Audio is long enough.
        playbackRate = screenDuration / holderHeight;
    }
    return playbackRate;
}

#pragma mark - Information
- (NSTimeInterval)currentDuration{
    return self.audioPlayer.currentDuration;
}

- (id)valueForProperty:(NSString *)property{
    id value = [self.audioPlayer valueForProperty:property];
    return value;
}

- (void)detectPlayerState{
    if ([_audioPlayer isKindOfClass:[CDAVAudioPlayer class]]) {
        CDAudioPlayerState state = _audioPlayer.isPlaying ? CDAudioPlayerStatePlaying : CDAudioPlayerStatePaused;
        for (id<CDAudioPlayerDelegate> delegate in _delegates) {
            [delegate audioSharer:self stateDidChange:state];
        }
    }
}

#pragma mark - iPod Player
- (void)openQueueWithItemCollection:(MPMediaItemCollection *)itemCollection{
    NSObject<CDAudioPlayer> *player = self.audioPlayer;
    [player openQueueWithItemCollection:itemCollection];
    
    if ([player isKindOfClass:[CDAVAudioPlayer class]]) {
        for (id<CDAudioPlayerDelegate> delegate in _delegates) {
            [delegate audioSharerNowPlayingItemDidChange:self];
        }
    }
}

- (void)handlePlaybackStateChanged:(id)notification{
    CDiPodPlayer* audioPlayer = (CDiPodPlayer*)self.audioPlayer;
	MPMusicPlaybackState playbackState = audioPlayer.audioPlayer.playbackState;
    
    switch (playbackState) {
        case MPMusicPlaybackStatePaused:{
            for (id<CDAudioPlayerDelegate> delegate in _delegates) {
                [delegate audioSharer:self stateDidChange:CDAudioPlayerStatePaused];
            }
        }break;
        case MPMusicPlaybackStatePlaying:{
            for (id<CDAudioPlayerDelegate> delegate in _delegates) {
                [delegate audioSharer:self stateDidChange:CDAudioPlayerStatePlaying];
            }
        }break;
        case MPMusicPlaybackStateStopped:{
            for (id<CDAudioPlayerDelegate> delegate in _delegates) {
                [delegate audioSharer:self stateDidChange:CDAudioPlayerStateStopped];
            }
        }break;
        default:
            break;
    }
}

- (void)handleNowPlayingItemChanged:(id)notification{
    for (id<CDAudioPlayerDelegate> delegate in _delegates) {
        [delegate audioSharerNowPlayingItemDidChange:self];
    }
}

#pragma mark - CDAudioPregressDataSource
- (float)progress:(CDProgress *)progress{
    if (_audioPlayer.currentDuration == 0.0f) return 0.0f;
    return _audioPlayer.currentPlaybackTime / _audioPlayer.currentDuration;
}

- (NSTimeInterval)playbackTimeOfProgress:(CDAudioProgress *)progress{
    return _audioPlayer.currentPlaybackTime;
}

@end
