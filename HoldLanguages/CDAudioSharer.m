//
//  CDAudioSharer.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/11/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDAudioSharer.h"
#import "CDiPodPlayer.h"

@interface CDAudioSharer ()
- (void)initialize;
- (void)refresh;
- (void)resumeTimerWithTimeInterval:(NSTimeInterval)timeInterval;
- (void)invalidateTimer;
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
}

- (void)invalidateTimer{
    if (_processTimer != nil) {
        [_processTimer invalidate];
        _processTimer = nil;
    }
}

- (void)refresh{
    if (!self.audioPlayer.isPlaying) {
        [self invalidateTimer];
        return;
    }
    NSTimeInterval playbackTime = self.audioPlayer.currentPlaybackTime;
    for (id<CDAudioPlayerDelegate> delegate in self.delegates) {
        [delegate audioSharer:self refreshPlaybackTime:playbackTime];
    }
}

#pragma mark - Control Types of Players
- (NSString*)openQueueWithItemCollection:(MPMediaItemCollection *)itemCollection{
    CDiPodPlayer* iPodPlayer = (CDiPodPlayer*)self.audioPlayer;
    [iPodPlayer openQueueWithItemCollection:itemCollection];
    
    MPMediaItem* firstItem = [itemCollection.items objectAtIndex:0];
    NSString* itemName = [firstItem valueForKey:MPMediaItemPropertyTitle];
    return itemName;    //The first item will be played.
}

- (void)play{
    [self.audioPlayer play];
    [self resumeTimerWithTimeInterval:0.5];
}

- (void)pause{
    [self.audioPlayer pause];
    [self invalidateTimer];
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
    [self invalidateTimer];
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

@end
