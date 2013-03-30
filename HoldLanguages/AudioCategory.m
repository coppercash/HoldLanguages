//
//  AudioCategory.m
//  HoldLanguages
//
//  Created by William Remaerd on 3/28/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "AudioCategory.h"
#import "CDMasterButton.h"
#import "CDiTunesFinder.h"
#import "CDLyrics.h"
#import "CDRepeatView.h"
#import "CDRepeaterView.h"
#import "CDHolder.h"

#import "LyricsCategory.h"


@interface MainViewController ()

@end

@implementation MainViewController (AudioCategory)

#pragma mark - CDAudioPlayerDelegate
- (void)audioSharer:(CDAudioSharer *)audioSharer stateDidChange:(CDAudioPlayerState)state{
    switch (state) {
        case CDAudioPlayerStatePlaying:{
            _bottomBar.masterButton.isPlaying = YES;
            [_progress setupUpdater];
        }break;
        case CDAudioPlayerStatePaused:{
            _bottomBar.masterButton.isPlaying = NO;
            [_progress stopUpdater];
        }break;
        case CDAudioPlayerStateStopped:{
            _bottomBar.masterButton.isPlaying = NO;
            [_progress stopUpdater];
        }break;
        default:
            break;
    }
}

- (void)audioSharerNowPlayingItemDidChange:(CDAudioSharer*)audioSharer{
    if (App.status->audioSourceType == AudioSourceTypeFileSharing) {
        NSString *audioTitle = [self.audioSharer valueForProperty:MPMediaItemPropertyTitle];
        NSString* lyricsPath = [CDiTunesFinder findFileWithName:audioTitle ofType:kLRCExtension];
        if (lyricsPath == nil) {
            self.lyrics = nil;
            [self removeLyricsView];
        }else{
            [self openLyricsAtPath:lyricsPath];
        }
    }
    if (_audioSharer.audioPlayer.isRepeating) [_audioSharer stopRepeating];
    [self.topBar reloadData];
    [self.bottomBar reloadData];
}

- (void)audioSharer:(CDAudioSharer *)audioSharer didRepeatInRange:(CDDoubleRange)range{
    [_repeatView.repeater setRepeatRaneg:range];
    [_bottomBar setRepeatRanege:range withDuration:audioSharer.audioPlayer.currentDuration];
    [_repeatView present];
}

- (void)audioSharer:(CDAudioSharer *)audioSharer didSetRepeatA:(NSTimeInterval)pointA{
    
}

- (void)audioSharerDidCancelRepeating:(CDAudioSharer *)audioSharer{
    if (_repeatView != nil) [_repeatView dismiss];
    [_bottomBar cleanRepeatRange];
    DLog(@"Repeat stop");
}

#pragma mark - CDAudioPregressDelegate
- (void)playbackTimeDidUpdate:(NSTimeInterval)playbackTime withTimes:(NSUInteger)times{
    if (!_holder.isBeingTouched) {
        NSUInteger focusIndex = [self.lyrics indexOfStampNearTime:playbackTime];
        [_lyricsView setFocusIndex:focusIndex];
    }
    if (_repeatView && _audioSharer.audioPlayer.isWaitingForPointB) {
        NSTimeInterval value = playbackTime - _audioSharer.audioPlayer.pointA;
        [_repeatView setValueOfCounterView:value];
    }
}

@end
