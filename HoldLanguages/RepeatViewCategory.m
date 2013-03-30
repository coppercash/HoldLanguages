//
//  RepeatViewCategory.m
//  HoldLanguages
//
//  Created by William Remaerd on 3/28/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "RepeatViewCategory.h"
#import "CDHolder.h"
#import "CDAudioSharer.h"

@interface MainViewController ()

@end

@implementation MainViewController (RepeatViewCategory)

#pragma mark - Repeat
- (void)loadRepeatView{
    if (_repeatView != nil) [_repeatView removeFromSuperview];
    
    CGFloat hI = (1 - 0.96) / 2 * CGRectGetWidth(self.view.bounds);  //horizontal inset
    CGRect frame = CGRectInset(self.view.bounds, hI, 0.0f);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    CGFloat topMagin = 0.02 * height;
    CGFloat bottomMagin = 0.17 * height;
    frame.origin.y = height / 2 + topMagin;
    frame.size.height = frame.size.height / 2 - topMagin - bottomMagin;
    
    _repeatView = [[CDRepeatView alloc] initWithFrame:frame delegate:self];
    _repeatView.autoresizingMask = CDViewAutoresizingFloat;
    [self.view insertSubview:_repeatView aboveSubview:_holder];
}

- (void)prepareToRepeat:(CDDirection)direction{
    if (_audioSharer.canRepeating) {
        if (_repeatView == nil) [self loadRepeatView];
        _repeatView.repeatDirection = direction;
        [_repeatView show];
        DLog(@"Create Repeat View");
    }
}

- (void)countRepeatTimeWithDistance:(CGFloat)distance{
    if (!_audioSharer.audioPlayer.isRepeating) {
        float rate = _audioSharer.repeatRate;
        NSTimeInterval length = rate * distance;
        [_repeatView setValueOfCounterView:length];
        DLog(@"Will repeat for %f", length);
    }
}

- (void)repeatWithDirection:(CDDirection)direction distance:(CGFloat)distance{
    CDDirection currentDirection = CDDirectionNone;
    if (distance < 0) currentDirection = CDDirectionLeft;
    if (distance > 0) currentDirection = CDDirectionRight;
    BOOL sameDirection = direction == currentDirection;
    
    if (sameDirection && !_audioSharer.audioPlayer.isRepeating ) {
        float rate = _audioSharer.repeatRate;
        NSTimeInterval length = rate * distance;
        NSTimeInterval location = _audioSharer.currentPlaybackTime;
        if (length < 0) {
            //Length is nagitive, so add it indicates repeat in forward range.
            location += length;
        }
        CDDoubleRange repeatRange = CDMakeDoubleRange(location, length);
        
        [_audioSharer repeatIn:repeatRange];
    }
}

#pragma mark - CDRepeatViewDelegate
/*
 - (void)repeatViewDidPresent:(CDRepeatView*)repeatView{
 [repeatView.repeater setRepeatRaneg:_audioSharer.repeatRange];
 [_bottomBar setRepeatRanege:_audioSharer.repeatRange withDuration:_audioSharer.currentDuration];
 }*/

- (void)repeatViewDidDismiss:(CDRepeatView*)repeatView{
    [_audioSharer stopRepeating];
    
    [_repeatView removeFromSuperview];
    SafeMemberRelease(_repeatView);
}

- (void)repeatView:(CDRepeatView*)repeatView alterRepeatRange:(CDRepeatAlterType)type{
    CDDoubleRange range = _audioSharer.audioPlayer.repeatRange;
    switch (type) {
        case CDRepeatAlterTypeStartPlus:{
            range.location += 1;
            range.length -= 1;
        }break;
        case CDRepeatAlterTypeStartMinus:{
            range.location -= 1;
            range.length += 1;
        }break;
        case CDRepeatAlterTypeEndPlus:{
            range.length += 1;
        }break;
        case CDRepeatAlterTypeEndMinus:{
            range.length -= 1;
        }break;
        default:
            break;
    }
    [_audioSharer repeatIn:range];
}

#pragma mark - Rates
- (void)prepareToChangeRate{
    if (_ratesView == nil) {
        CGFloat topMargin = 80.0f;
        CGFloat bottomMargin = 5.0f;
        CGRect frame = self.view.bounds;
        frame.origin.y = topMargin;
        frame.size.height = frame.size.height / 2 - topMargin - bottomMargin;
        self.ratesView = [[CDRatesView alloc] initWithFrame:frame rates:_audioSharer.rates delegate:self];
        _ratesView.autoresizingMask = CDViewAutoresizingFloat;
        [self.view insertSubview:_ratesView belowSubview:_holder];
    }
    [_ratesView startScrolling];
}

- (void)ratesView:(CDRatesView *)rateView didChangeRateTo:(float)rate{
    [_audioSharer setRate:rate];
}

- (void)ratesViewDidHide:(CDRatesView *)rateView{
    [_ratesView removeFromSuperview];
    self.ratesView = nil;
}

@end
