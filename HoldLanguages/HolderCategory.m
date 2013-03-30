//
//  HolderCategory.m
//  HoldLanguages
//
//  Created by William Remaerd on 3/26/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "HolderCategory.h"
#import "CDBackgroundView.h"
#import "CDLyrics.h"
#import "CDRepeatView.h"
#import "CDLyricsView.h"
#import "CDAudioSharer.h"
#import "CDStoryView.h"

#import "RepeatViewCategory.h"
#import "PullViewControllerCategory.h"

@implementation MainViewController (HolderCategory)

#pragma mark - CDHolderDelegate
- (void)holder:(CDHolder *)holder beginSwipingOnDirection:(CDDirection)direction index:(NSUInteger)index{
    if (direction & CDDirectionHorizontal) {
        switch (index) {
            case 0:{
                [self prepareToChangeRate];
            }break;
            case 1:{
                
            }break;
            case 2:{
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
                [_storyView scrollFor:-increment animated:NO];
            }break;
            case 2:{
                [self countRepeatTimeWithDistance:distance];
            }
            default:
                break;
        }
    }else if (direction & CDDirectionVertical){
        [_lyricsView scrollFor:-increment animated:NO];
        
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
                
                if (direction & CDDirectionLeft) {
                    [_storyView scrollToPage:_storyView.pageIndex + 1 animated:YES];
                }else if (direction & CDDirectionRight){
                    [_storyView scrollToPage:_storyView.pageIndex - 1 animated:YES];
                }
            
            }break;
            case 2:{
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
                
            }break;
            case 2:{
                [_repeatView cancel];
            }break;
            default:
                break;
        }
    }else if (direction & CDDirectionVertical){
        [_backgroundView move:CDAnimationStateReset];
    }
}

- (void)holder:(CDHolder *)holder handleTap:(NSUInteger)count index:(NSInteger)index{
    switch (count) {
        case 1:{
            [self setBarsHidden:YES animated:YES];

            switch (index) {
                case 0:{
                }break;
                case 1:{
                    [_storyView scrollToPage:_storyView.pageIndex - 1 animated:YES];
                }break;
                case 2:{
                    [_storyView scrollToPage:_storyView.pageIndex + 1 animated:YES];
                }break;
                default:
                    break;
            }
        
        }break;
        case 2:{
            [self.audioSharer playOrPause];
        }break;
        default:
            break;
    }
}

- (void)holderLongPressed:(CDHolder *)holder{
    [self switchBarsHidden];
}

@end
