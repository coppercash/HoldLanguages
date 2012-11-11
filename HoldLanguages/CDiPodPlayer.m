//
//  CDiPodPlayer.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/11/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDiPodPlayer.h"

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

@end
