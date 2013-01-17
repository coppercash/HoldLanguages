//
//  CDAVAudioPlayer.h
//  HoldLanguages
//
//  Created by William Remaerd on 1/16/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "CDAudioPlayer.h"

@class MPMediaItemCollection, MPMediaItem, AVAudioPlayer;
@interface CDAVAudioPlayer : NSObject <CDAudioPlayer, AVAudioPlayerDelegate>{
    MPMediaItemCollection *_itemCollection;
    NSUInteger _currentItemIndex;
    AVAudioPlayer *_player;
    CDAudioRepeatMode _repeatMode;
}
@property(nonatomic, strong)MPMediaItemCollection *itemCollection;
@property(nonatomic, strong)AVAudioPlayer *player;
@property(nonatomic, assign)CDAudioRepeatMode repeatMode;
- (void)openQueueWithItemCollection:(MPMediaItemCollection *)itemCollection;
- (MPMediaItem*)currentItem;
@end
