//
//  CDPlayer.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/11/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDAudioPlayer : NSObject {
    NSTimeInterval _currentDuration;
}

@property(nonatomic) NSTimeInterval currentPlaybackTime;
@property(nonatomic, readonly) NSTimeInterval currentDuration;
@property(nonatomic, readonly, copy) NSString* audioName;

- (void)openAudios;
- (void)play;
- (void)pause;
- (void)stop;
- (BOOL)isPlaying;
- (void)playbackFor:(NSTimeInterval)playbackTime;
- (void)playbackAt:(NSTimeInterval)playbackTime;
- (NSString*)valueForProperty:(NSString *)property;

@end
