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
    //self.audioPlayer = [MPMusicPlayerController iPodMusicPlayer];
    self.audioPlayer = [MPMusicPlayerController applicationMusicPlayer];
    self.audioPlayer.shuffleMode = MPMusicShuffleModeOff;
    self.audioPlayer.repeatMode = MPMusicRepeatModeOne;
}

#pragma mark - Play Control
- (void)openQueueWithItemCollection:(MPMediaItemCollection *)itemCollection{
    [self.audioPlayer setQueueWithItemCollection:itemCollection];
    [self openAudios];
}

- (void)play{
    [self.audioPlayer play];
}

- (void)pause{
    [self.audioPlayer pause];
}

- (void)stop{
    [self pause];
}

- (void)playOrPause{
	MPMusicPlaybackState playbackState = self.audioPlayer.playbackState;
	if (playbackState == MPMusicPlaybackStateStopped || playbackState == MPMusicPlaybackStatePaused) {
		[self play];
	} else if (playbackState == MPMusicPlaybackStatePlaying) {
		[self pause];
	}
}


- (void)playbackFor:(NSTimeInterval)playbackTime{
    NSTimeInterval currentPlaybackTime = self.audioPlayer.currentPlaybackTime;
    NSTimeInterval destinationPlaybackTime = currentPlaybackTime + playbackTime;
    self.audioPlayer.currentPlaybackTime = destinationPlaybackTime;
}

- (NSTimeInterval)currentDuration{
    //Get current playing duration.
    MPMediaItem* currentAudio = self.audioPlayer.nowPlayingItem;
    
    NSString *string = [currentAudio valueForKey:MPMediaItemPropertyPlaybackDuration];
    
    NSTimeInterval currentDuration = string.floatValue;
    _currentDuration = currentDuration;
    
    return _currentDuration;
}

@end
