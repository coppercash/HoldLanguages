//
//  CDPlayer.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/11/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDAudioPlayer.h"

@implementation CDAudioPlayer
@synthesize currentPlaybackTime = _currentPlaybackTime, currentDuration = _currentDuration;

- (void)openAudios{}
- (void)play{}
- (void)pause{}
- (void)stop{}
- (void)playOrPause{}
- (void)playbackFor:(NSTimeInterval)playbackTime{}

@end
