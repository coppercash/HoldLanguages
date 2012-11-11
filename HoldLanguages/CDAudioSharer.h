//
//  CDAudioSharer.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/11/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CDAudioPlayer, MPMediaItemCollection;
@interface CDAudioSharer : NSObject

@property(nonatomic, strong)CDAudioPlayer* audioPlayer;

+ (CDAudioSharer*)sharedAudioPlayer;
- (void)openQueueWithItemCollection:(MPMediaItemCollection *)itemCollection;
- (void)playOrPause;
- (void)playbackFor:(NSTimeInterval)playbackTime;

@end
