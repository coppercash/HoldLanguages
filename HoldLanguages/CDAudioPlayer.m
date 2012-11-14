//
//  CDPlayer.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/11/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDAudioPlayer.h"

@implementation CDAudioPlayer
@synthesize currentPlaybackTime = _currentPlaybackTime, currentDuration = _currentDuration, audioName = _audioName;

- (void)openAudios{}
- (void)play{}
- (void)pause{}
- (void)stop{}
- (BOOL)isPlaying{
    return NO;
}
- (void)playbackFor:(NSTimeInterval)playbackTime{}
- (void)playbackAt:(NSTimeInterval)playbackTime{}
@end
