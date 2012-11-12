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

- (void)stop{
    [self.audioPlayer stop];
}

- (void)playbackFor:(NSTimeInterval)playbackTime{
    [self.audioPlayer playbackFor:playbackTime];
}


#pragma mark - Convertion between Time and Distance
- (float)playbackRate{
    NSTimeInterval screenDuration = 10.0f;
    CGFloat holderHeight = 480.0f;

    NSTimeInterval duration = self.audioPlayer.currentDuration;
    float playbackRate;
    if (screenDuration > duration) {
        //Audio is too short.
        playbackRate = duration / holderHeight;
    }else{
        //Audio is long enough.
        playbackRate = screenDuration / holderHeight;
    }
    return playbackRate;
}

/*
NSTimeInterval playbackTimeWithDistanceAndaudioDuration(CGFloat distance, NSTimeInterval duration){
    //If duration is 0.0f, it indicates returning the value has been calculated.
    static NSTimeInterval playbackTime = 0.0f;
    if (duration != 0.0f) {
        NSTimeInterval screenDuration = 5.0f;
        CGFloat holderHeight = 480.0f;
        
        if (screenDuration > duration) {
            //Audio is too short.
            playbackTime = (distance / holderHeight) * duration;
        }else{
            //Audio is long enough.
            playbackTime = (distance / holderHeight) * screenDuration;
        }
    }
    return playbackTime;
}
 */
/*
 + (NSTimeInterval)playbackTimeWithDistance:(CGFloat)distance audioDuration:(NSTimeInterval)duration{
 //If duration is 0.0f, it indicates returning the value has been calculated.
 static NSTimeInterval playbackTime = 0.0f;
 if (duration != 0.0f) {
 NSTimeInterval screenDuration = 5.0f;
 CGFloat holderHeight = 480.0f;
 
 if (screenDuration > duration) {
 //Audio is too short.
 playbackTime = (distance / holderHeight) * duration;
 }else{
 //Audio is long enough.
 playbackTime = (distance / holderHeight) * screenDuration;
 }
 }
 return playbackTime;
 }*/

@end
