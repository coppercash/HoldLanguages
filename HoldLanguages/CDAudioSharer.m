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
@end

@implementation CDAudioSharer
@synthesize audioPlayer = _audioPlayer;

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

- (void)openQueueWithItemCollection:(MPMediaItemCollection *)itemCollection{
    CDiPodPlayer* iPodPlayer = (CDiPodPlayer*)self.audioPlayer;
    [iPodPlayer openQueueWithItemCollection:itemCollection];
}

- (void)playOrPause{
    [self.audioPlayer playOrPause];
}

- (void)playbackFor:(NSTimeInterval)playbackTime{
    [self.audioPlayer playbackFor:playbackTime];
}

@end
