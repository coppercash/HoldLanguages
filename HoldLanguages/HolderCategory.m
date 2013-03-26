//
//  HolderCategory.m
//  HoldLanguages
//
//  Created by William Remaerd on 3/26/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "HolderCategory.h"
#import "MainViewController.h"
#import "CDBackgroundView.h"
#import "CDLyrics.h"

@implementation MainViewController (HolderCategory)

#pragma mark - CDHolderDelegate
- (void)holder:(CDHolder *)holder beginSwipingOnDirection:(CDDirection)direction index:(NSUInteger)index{
    if (direction & CDDirectionHorizontal) {
        switch (index) {
            case 0:{
                [self prepareToChangeRate];
            }break;
            case 1:{
                [self prepareToRepeat:direction];
            }break;
            default:
                break;
        }
    }
}

- (void)holder:(CDHolder *)holder continueSwipingOnDirection:(CDDirection)direction forIncrement:(CGFloat)increment fromStart:(CGFloat)distance index:(NSUInteger)index{
    if (direction & CDDirectionHorizontal) {
        switch (index) {
            case 0:{
                [_ratesView scrollFor:-increment animated:NO];
            }break;
            case 1:{
                [self countRepeatTimeWithDistance:distance];
            }
            default:
                break;
        }
    }else if (direction & CDDirectionVertical){
        [self.lyricsView scrollFor:-increment animated:NO];
        
        [_backgroundView moveWithValue:increment];
    }
}

- (void)holder:(CDHolder *)holder endSwipingOnDirection:(CDDirection)direction fromStart:(CGFloat)distance index:(NSUInteger)index{
    if (direction & CDDirectionHorizontal) {
        switch (index) {
            case 0:{
                [_ratesView endScrolling];
            }break;
            case 1:{
                [self repeatWithDirection:direction distance:distance];
            }break;
            default:
                break;
        }
    }else if (direction & CDDirectionVertical){
        if (_lyrics) {
            NSUInteger focusIndex = _lyricsView.focusIndex;
            NSTimeInterval playbackTime = [_lyrics timeAtIndex:focusIndex];
            [self.audioSharer playbackAt:playbackTime];
            [_lyricsView setFocusIndex:focusIndex]; //For making focus accrute.
        }else{
            float rate = _audioSharer.playbackRate;
            NSTimeInterval playbackTime = - rate * distance;
            [self.audioSharer playbackFor:playbackTime];
        }
        [_progress synchronize:nil];
        
        [_backgroundView move:CDAnimationStateReset];
    }
}

- (void)holder:(CDHolder *)holder cancelSwipingOnDirection:(CDDirection)direction index:(NSUInteger)index{
    if (direction & CDDirectionHorizontal) {
        switch (index) {
            case 0:{
                [_ratesView cancelScrolling];
            }break;
            case 1:{
                [_repeatView cancel];
                DLog(@"Release Repeat View");
            }break;
            default:
                break;
        }
    }else if (direction & CDDirectionVertical){
        [_backgroundView move:CDAnimationStateReset];
    }
}

- (void)holder:(CDHolder *)holder handleTap:(NSUInteger)count{
    switch (count) {
        case 1:{
            [self setBarsHidden:YES animated:YES];
        }break;
        case 2:{
            [self.audioSharer playOrPause];
        }break;
        default:
            break;
    }
}

- (void)holderTapDouble:(CDHolder *)holder{
    [self.audioSharer playOrPause];
}

- (void)holderLongPressed:(CDHolder *)holder{
    [self switchBarsHidden];
}

@end
