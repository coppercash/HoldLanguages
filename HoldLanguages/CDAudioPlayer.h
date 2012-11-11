//
//  CDPlayer.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/11/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDAudioPlayer : NSObject

@property(nonatomic) NSTimeInterval currentPlaybackTime;

- (void)openAudios;
- (void)play;
- (void)pause;
- (void)playOrPause;
- (void)playbackFor:(NSTimeInterval)playbackTime;

@end
