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
#import "CDPullControllerMetro.h"

@interface MainViewController ()

@end

@implementation MainViewController (RepeatViewCategory)

#pragma mark - Repeat
- (CDRepeatView *)repeatView{
    if (!_repeatView) {
        CGRect frame = self.view.bounds;
        frame = CGRectMake(kMargin,
                           0.5f * CGRectGetHeight(frame) + 0.5 * kMarginSecondary,
                           CGRectGetWidth(frame) - 2 * kMargin,
                           0.5f * CGRectGetHeight(frame) - 2 * kMarginSecondary - kBottimBarHeight - kMarginSecondary);
        _repeatView = [[CDRepeatView alloc] initWithFrame:frame delegate:self];
        _repeatView.autoresizingMask = CDViewAutoresizingFloat;
    }
    if (!_repeatView.superview) {
        [self.view insertSubview:_repeatView aboveSubview:_holder];
    }
    return _repeatView;
}

- (void)setRepeatView:(CDRepeatView *)repeatView{
    _repeatView = repeatView;
}

- (void)prepareToRepeat:(CDDirection)direction{
    if (_audioSharer.canRepeating) {
        [self repeatView];
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
- (CDRatesView *)ratesView{
    if (!_ratesView) {
        CGRect frame = self.view.bounds;
        frame = CGRectMake(0.0f,
                           kMargin,
                           CGRectGetWidth(frame),
                           0.25f * CGRectGetHeight(frame) - kMargin - 0.5 * kMarginSecondary);
        _ratesView = [[CDRatesView alloc] initWithFrame:frame rates:_audioSharer.rates delegate:self];
        _ratesView.autoresizingMask = CDViewAutoresizingFloat;
    }
    if (!_ratesView.superview) {
        [self.view insertSubview:_ratesView belowSubview:_holder];
    }
    [_ratesView startScrolling];    //Ignite
    return _ratesView;
}

- (void)ratesView:(CDRatesView *)rateView didChangeRateTo:(float)rate{
    [_audioSharer setRate:rate];
}

- (void)ratesViewDidHide:(CDRatesView *)rateView{
    [_ratesView removeFromSuperview];
    _ratesView = nil;
}

- (void)setRatesView:(CDRatesView *)ratesView{
    _ratesView = ratesView;
}

@end
