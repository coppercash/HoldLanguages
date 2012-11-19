//
//  CDAudioSharer.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/11/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDAudioSharer.h"
#import "CDiPodPlayer.h"
#import "Header.h"

@interface CDAudioSharer ()
- (void)initialize;
- (void)refresh;
- (void)resumeTimerWithTimeInterval:(NSTimeInterval)timeInterval;
- (void)invalidateTimer;
- (void)handlePlaybackStateChanged:(id)notification;
@end

@implementation CDAudioSharer
@synthesize delegates = _delegates, audioPlayer = _audioPlayer, processTimer = _processTimer, audioName = _audioName;

- (id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize{
    self.audioPlayer = [[CDiPodPlayer alloc] init];
}

+ (CDAudioSharer*)sharedAudioPlayer{
    static CDAudioSharer* sharedAudioPlayer;
    @synchronized(self){
        if (sharedAudioPlayer == nil) {
            sharedAudioPlayer = [[CDAudioSharer alloc] init];
        }
    }
    return sharedAudioPlayer;
}

#pragma mark - Players
- (void)setAudioPlayer:(CDAudioPlayer *)audioPlayer{
    if ([_audioPlayer isKindOfClass:[CDiPodPlayer class]]) {
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter removeObserver:self name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:_audioPlayer];
    }
    
    if ([audioPlayer isKindOfClass:[CDiPodPlayer class]]) {
        CDiPodPlayer* iPodPlayer = (CDiPodPlayer*)audioPlayer;
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver: self
                               selector: @selector (handlePlaybackStateChanged:)
                                   name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
                                 object: iPodPlayer.audioPlayer];
        [iPodPlayer.audioPlayer beginGeneratingPlaybackNotifications];
    }
    _audioPlayer = audioPlayer;
}

#pragma mark - Delegates
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

#pragma mark - Timer
- (void)resumeTimerWithTimeInterval:(NSTimeInterval)timeInterval{
    if (_processTimer != nil) {
        [_processTimer invalidate];
    }
    _processTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(refresh) userInfo:nil repeats:YES];
    DLogCurrentMethod;
}

- (void)invalidateTimer{
    if (_processTimer != nil) {
        [_processTimer invalidate];
        _processTimer = nil;
    }
    DLogCurrentMethod;
}

- (void)refresh{
    NSTimeInterval playbackTime = self.audioPlayer.currentPlaybackTime;
    for (id<CDAudioPlayerDelegate> delegate in self.delegates) {
        [delegate audioSharer:self refreshPlaybackTime:playbackTime];
    }
}

#pragma mark - Control Types of Players
- (void)play{
    [self.audioPlayer play];
}

- (void)pause{
    [self.audioPlayer pause];
}

- (void)playOrPause{
    if (self.audioPlayer.isPlaying) {
        [self pause];
    }else{
        [self play];
    }
}

- (void)stop{
    [self.audioPlayer stop];
}

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

#pragma mark - Getter
- (NSString*)audioName{
    return self.audioPlayer.audioName;
}

- (NSTimeInterval)currentDuration{
    return self.audioPlayer.currentDuration;
}

#pragma mark - iPod Player
- (NSString*)openQueueWithItemCollection:(MPMediaItemCollection *)itemCollection{
    CDiPodPlayer* iPodPlayer = (CDiPodPlayer*)self.audioPlayer;
    [iPodPlayer openQueueWithItemCollection:itemCollection];
    
    MPMediaItem* firstItem = [itemCollection.items objectAtIndex:0];
    NSString* itemName = [firstItem valueForKey:MPMediaItemPropertyTitle];
    return itemName;    //The first item will be played.
}

- (void)handlePlaybackStateChanged:(id)notification{
    DLogCurrentMethod;
    CDiPodPlayer* audioPlayer = (CDiPodPlayer*)self.audioPlayer;
	MPMusicPlaybackState playbackState = audioPlayer.audioPlayer.playbackState;
    
    switch (playbackState) {
        case MPMusicPlaybackStatePaused:{
            [self invalidateTimer];
            for (id<CDAudioPlayerDelegate> delegate in self.delegates) {
                [delegate audioSharer:self stateDidChange:CDAudioPlayerStatePaused];
            }
        }break;
        case MPMusicPlaybackStatePlaying:{
            [self resumeTimerWithTimeInterval:0.5];
            for (id<CDAudioPlayerDelegate> delegate in self.delegates) {
                [delegate audioSharer:self stateDidChange:CDAudioPlayerStatePlaying];
            }
        }break;
        case MPMusicPlaybackStateStopped:{
            [self invalidateTimer];
            for (id<CDAudioPlayerDelegate> delegate in self.delegates) {
                [delegate audioSharer:self stateDidChange:CDAudioPlayerStateStopped];
            }
        }break;
        default:
            break;
    }
}

@end
