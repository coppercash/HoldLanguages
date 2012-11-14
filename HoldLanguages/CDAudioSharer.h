//
//  CDAudioSharer.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/11/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol CDAudioPlayerDelegate;
@class CDAudioPlayer, MPMediaItemCollection;
@interface CDAudioSharer : NSObject

@property(nonatomic, readonly, strong)NSArray* delegates;
@property(nonatomic, strong)CDAudioPlayer* audioPlayer;
@property(nonatomic, readonly, strong)NSTimer* processTimer;
@property(nonatomic, readonly, copy)NSString* audioName;

+ (CDAudioSharer*)sharedAudioPlayer;
- (void)registAsDelegate:(id<CDAudioPlayerDelegate>)delegate;
- (void)removeDelegate:(id<CDAudioPlayerDelegate>)delegate;
- (NSString*)openQueueWithItemCollection:(MPMediaItemCollection *)itemCollection;
- (void)play;
- (void)pause;
- (void)playOrPause;
- (void)stop;
- (void)playbackFor:(NSTimeInterval)playbackTime;
- (void)playbackAt:(NSTimeInterval)playbackTime;
- (float)playbackRate;

@end

@protocol CDAudioPlayerDelegate
@required
- (void)audioSharer:(CDAudioSharer*)audioSharer refreshPlaybackTime:(NSTimeInterval)playbackTime;
@end