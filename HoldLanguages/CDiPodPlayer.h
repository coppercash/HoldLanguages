//
//  CDiPodPlayer.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/11/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDAudioPlayer.h"
#import <MediaPlayer/MPMediaItemCollection.h>
#import <MediaPlayer/MPMusicPlayerController.h>
@interface CDiPodPlayer : NSObject <CDAudioPlayer>{
    MPMusicPlayerController *_audioPlayer;
}
@property(nonatomic, strong)MPMusicPlayerController *audioPlayer;
- (void)openQueueWithItemCollection:(MPMediaItemCollection *)itemCollection;
@end
