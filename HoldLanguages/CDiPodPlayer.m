//
//  CDiPodPlayer.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/11/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDiPodPlayer.h"
#import "Header.h"
#import "CDAudioSharer.h"

@interface CDiPodPlayer ()
- (void)initialize;
@end

@implementation CDiPodPlayer
@synthesize audioPlayer = _audioPlayer;

- (id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize{
    self.audioPlayer = [MPMusicPlayerController iPodMusicPlayer];
    //self.audioPlayer = [MPMusicPlayerController applicationMusicPlayer];
    self.audioPlayer.shuffleMode = MPMusicShuffleModeOff;
    self.audioPlayer.repeatMode = MPMusicRepeatModeOne;
}

#pragma mark - Play Control
- (void)openQueueWithItemCollection:(MPMediaItemCollection *)itemCollection{
    [self.audioPlayer setQueueWithItemCollection:itemCollection];
    [self openAudios];
}

- (void)play{
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
}

- (void)pause{
    [self.audioPlayer pause];
}

- (void)stop{
    [self pause];
}

- (BOOL)isPlaying{
    MPMusicPlaybackState playbackState = self.audioPlayer.playbackState;
    if (playbackState == MPMusicPlaybackStatePlaying) {
        return YES;
    }else if (playbackState == MPMusicPlaybackStateStopped || playbackState == MPMusicPlaybackStatePaused) {
		return NO;
	}
    return NO;
}

- (void)playbackFor:(NSTimeInterval)playbackTime{
    NSTimeInterval currentPlaybackTime = self.audioPlayer.currentPlaybackTime;
    NSTimeInterval destinationPlaybackTime = currentPlaybackTime + playbackTime;
    [self playbackAt:destinationPlaybackTime];
}

- (void)playbackAt:(NSTimeInterval)playbackTime{
    self.audioPlayer.currentPlaybackTime = playbackTime;
}

- (NSTimeInterval)currentDuration{
    //Get current playing duration.
    MPMediaItem* currentAudio = self.audioPlayer.nowPlayingItem;
    NSNumber *string = [currentAudio valueForKey:MPMediaItemPropertyPlaybackDuration];
    NSTimeInterval currentDuration = string.doubleValue;
    _currentDuration = currentDuration;
    
    return _currentDuration;
}


- (NSTimeInterval)currentPlaybackTime{
    NSTimeInterval playbackTime = self.audioPlayer.currentPlaybackTime;
    return playbackTime;
}

- (NSString*)audioName{
    MPMediaItem* currentAudio = self.audioPlayer.nowPlayingItem;
    NSString *string = [currentAudio valueForKey:MPMediaItemPropertyTitle];
    return string;
}

- (NSString*)valueForProperty:(NSString *)property{
    MPMediaItem* currentAudio = self.audioPlayer.nowPlayingItem;
    NSString *value = [currentAudio valueForKey:property];
    return value;
}

@end
