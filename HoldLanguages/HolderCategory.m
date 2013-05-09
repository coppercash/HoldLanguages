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

- (CDHolder *)holder{
    UIView *view = self.view;
    if (!_holder) {
        _holder = [[CDHolder alloc] initWithFrame:view.bounds];
        _holder.delegate = self;
        _holder.autoresizingMask = CDViewAutoresizingNoMaigin;
        NSValue *row0 = [NSValue valueWithCGSize:CGSizeMake(.0f, .25f)];
        NSValue *row1 = [NSValue valueWithCGSize:CGSizeMake(.25f, .25f)];
        NSValue *row2 = [NSValue valueWithCGSize:CGSizeMake(.5f, .5f)];
        _holder.rows = [[NSArray alloc] initWithObjects:row0, row1, row2, nil];
        
        NSValue *area0 = [NSValue valueWithCGRect:CGRectMake(.0f, .25f, .2f, .25f)];
        NSValue *area1 = [NSValue valueWithCGRect:CGRectMake(.8f, .25f, .2f, .25f)];
        _holder.areas = [[NSArray alloc] initWithObjects:area0, area1, nil];
    }
    if (!_holder.superview) {
        [view addSubview:_holder];
    }
    return _holder;
}

- (void)setHolder:(CDHolder *)holder{
    _holder = holder;
}

#pragma mark - CDHolderDelegate
- (void)holder:(CDHolder *)holder beginSwipingOnDirection:(CDDirection)direction index:(NSUInteger)index{
    if (direction & CDDirectionHorizontal) {
        switch (index) {
            case 0:{
                [self ratesView];
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
        switch (index) {    //Rates
            case 0:{
                [_ratesView scrollFor:-increment animated:NO];
            }break;
            case 1:{    //Pages
                [_storyView scrollFor:-increment animated:NO];
                if (_storyView) [_backgroundView igniteLeftPage];
                if (_storyView) [_backgroundView igniteRightPage];
            }break;
            case 2:{    //Repeat
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
            case 0:{    //Rates
                [_ratesView endScrolling];
            }break;
            case 1:{    //Pages

                if (direction & CDDirectionLeft) {
                    [_storyView scrollToPage:_storyView.pageIndex + 1 animated:YES];
                }else if (direction & CDDirectionRight){
                    [_storyView scrollToPage:_storyView.pageIndex - 1 animated:YES];
                }
            
            }break;
            case 2:{    //Repeat
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
            case 0:{    //Rates
                [_ratesView cancelScrolling];
            }break;
            case 1:{
                
            }break;
            case 2:{    //Repeat
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
                    if (_storyView) [_backgroundView igniteLeftPage];
                }break;
                case 2:{
                    [_storyView scrollToPage:_storyView.pageIndex + 1 animated:YES];
                    if (_storyView) [_backgroundView igniteRightPage];
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
