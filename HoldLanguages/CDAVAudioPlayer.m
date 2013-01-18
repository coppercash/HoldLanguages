//
//  CDAVAudioPlayer.m
//  HoldLanguages
//
//  Created by William Remaerd on 1/16/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDAVAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPMediaItemCollection.h>

@interface CDAVAudioPlayer ()
- (void)nextOrPreviousWithIndex:(NSUInteger)index;
@end

@implementation CDAVAudioPlayer
@synthesize itemCollection = _itemCollection, player = _player, repeatMode = _repeatMode, rates = _rates;
- (id)init{
    self = [super init];
    if (self) {
        _rates = [[CDCycleArray alloc] initWithArray:@[
                  [NSNumber numberWithFloat:0.5],
                  [NSNumber numberWithFloat:1.0],
                  [NSNumber numberWithFloat:1.5],
                  [NSNumber numberWithFloat:2.0]] index:1];
    }
    return self;
}

- (MPMediaItem*)currentItem{
    MPMediaItem *item = [_itemCollection.items objectAtIndex:_currentItemIndex];
    return item;
}

#pragma mark - Open
- (void)openQueueWithItemCollection:(MPMediaItemCollection *)itemCollection{
    NSArray *items = itemCollection.items;
    if (items.count == 0) return;
    self.itemCollection = itemCollection;
    _currentItemIndex = 0;
    MPMediaItem *firstItem = [items objectAtIndex:_currentItemIndex];
    NSURL *url = [firstItem valueForProperty:MPMediaItemPropertyAssetURL];
    [self openAudioWithURL:url];
}

- (void)openAudioWithURL:(NSURL*)url{
    if (_player != nil) {
        [_player stop];
        SafeMemberRelease(_player);
    }
    NSError *error;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    _player.delegate = self;
    _player.enableRate = YES;
    _player.rate = [_rates.current floatValue];
    _player.numberOfLoops = -1;
}

#pragma mark - Control
- (void)play{
    [_player prepareToPlay];
    [_player play];
}

- (void)stop{
    [_player stop];
}

- (void)pause{
    [_player pause];
}

- (BOOL)isPlaying{
    return [_player isPlaying];
}

- (BOOL)next{
    NSArray *items = _itemCollection.items;
    NSUInteger nextIndex = (_currentItemIndex + 1) % items.count;
    [self nextOrPreviousWithIndex:nextIndex];
    
    BOOL isSame = nextIndex == _currentItemIndex;
    _currentItemIndex = nextIndex;
    
    return !isSame;
}

- (BOOL)previous{
    NSArray *items = _itemCollection.items;
    NSUInteger previousIndex = (_currentItemIndex == 0) ? items.count - 1 : _currentItemIndex - 1;
    [self nextOrPreviousWithIndex:previousIndex];
    
    BOOL isSame = previousIndex == _currentItemIndex;
    _currentItemIndex = previousIndex;
    
    return !isSame;
}

- (void)nextOrPreviousWithIndex:(NSUInteger)index{
    CDAudioRepeatMode repeatMode = self.repeatMode;
    switch (repeatMode) {
        case CDAudioRepeatModeNone:{
            [self playbackAt:0.0f];
        }break;
        case CDAudioRepeatModeOne:{
            [self playbackAt:0.0f];
        }break;
        case CDAudioRepeatModeAll:{
            BOOL isPlaying = self.isPlaying;
            if (isPlaying) [self stop];
            
            NSArray *items = _itemCollection.items;
            MPMediaItem *item = [items objectAtIndex:index];
            NSURL *url = [item valueForProperty:MPMediaItemPropertyAssetURL];
            [self openAudioWithURL:url];
            
            if (isPlaying) [self play];
        }break;
        default:
            break;
    }
}

#pragma mark - Playback
- (void)playbackAt:(NSTimeInterval)playbackTime{
    if (self.isRepeating) {
        CDTimeRange range = _repeater.range;
        playbackTime = limitedDouble(playbackTime, range.location, CDTimeRangeGetEnd(range));
    }
    [_player setCurrentTime:playbackTime];
}

- (void)playbackFor:(NSTimeInterval)increment{
    NSTimeInterval now = _player.currentTime;
    NSTimeInterval max = _player.duration;
    NSTimeInterval target = limitedDouble(now + increment, 0.0f, max);
    [self playbackAt:target];
}

- (void)setRate:(float)rate{
    _player.rate = rate;
}

- (float)rate{
    return _player.rate;
}

#pragma mark - Repeater
- (void)repeatIn:(CDTimeRange)timeRange{
    if (_player == nil) return;
    if (!self.isRepeating) {
        AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        CDAudioProgress *progress = appDelegate.progress;
        _repeater = [[CDAudioRepeater alloc] initWithPlayer:self progress:progress];
    }
    [_repeater repeatIn:timeRange];
}

- (void)stopRepeating{
    if (!self.isRepeating) return;
    [_repeater stopRepeating];
    SafeMemberRelease(_repeater);
}

- (BOOL)isRepeating{
    return _repeater != nil;
}

#pragma mark - Information
- (NSArray*)availableRate{
    return _available;
}

- (CDAudioRepeatMode)repeatMode{
    return CDAudioRepeatModeOne;
}

- (NSTimeInterval)currentPlaybackTime{
    return _player.currentTime;
}

- (NSTimeInterval)currentDuration{
    return _player.duration;
}

- (id)valueForProperty:(NSString*)property{
    MPMediaItem* currentAudio = self.currentItem;
    id value = [currentAudio valueForKey:property];
    return value;
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (flag) {
        CDAudioRepeatMode repeatMode = CDAudioRepeatModeOne;
        switch (repeatMode) {
            case CDAudioRepeatModeNone:{
                if (_player.numberOfLoops != 0) [self stop];
            }break;
            case CDAudioRepeatModeOne:{
            }break;
            case CDAudioRepeatModeAll:{
                [self next];
            }break;
            default:
                break;
        }
    }
}

@end
