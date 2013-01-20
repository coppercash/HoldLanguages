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
#import "CDAudioRepeater.h"

@class MPMediaItemCollection, MPMediaItem, AVAudioPlayer, CDCycleArray;
@interface CDAVAudioPlayer : NSObject <CDAudioPlayer, CDAudioRepeaterSource, AVAudioPlayerDelegate>{
    MPMediaItemCollection *_itemCollection;
    NSUInteger _currentItemIndex;
    AVAudioPlayer *_player;
    CDAudioRepeatMode _repeatMode;
    NSArray *_available;
    CDCycleArray *_rates;
    CDAudioRepeater *_repeater;
}
@property(nonatomic, strong)MPMediaItemCollection *itemCollection;
@property(nonatomic, strong)AVAudioPlayer *player;
@property(nonatomic, readonly)CDCycleArray *rates;
- (void)openQueueWithItemCollection:(MPMediaItemCollection *)itemCollection;
- (MPMediaItem*)currentItem;
@end
