//
//  IntroductionCategory.m
//  HoldLanguages
//
//  Created by William Remaerd on 3/28/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "IntroductionCategory.h"
#import "CDIntroductionView.h"
#import "CDStoryView.h"
#import "CDLyricsView.h"

#import "HolderCategory.h"
#import "StoryViewCategory.h"
#import "LyricsCategory.h"

@interface MainViewController ()

@end

@implementation MainViewController (IntroductionCategory)

- (CDIntroductionView *)introductionView{
    if (!_introductionView) {
        self.introductionView = [[CDIntroductionView alloc] initWithFrame:self.view.bounds];
        _introductionView.autoresizingMask = kViewAutoresizingNoMarginSurround;
    }
    if (!_introductionView.superview) {
        _introductionView.alpha = 0.0f;
        [self.view insertSubview:_introductionView belowSubview:_holder];
        [UIView animateWithDuration:kSubviewsSwitchDuration animations:^{
            _introductionView.alpha = 1.0f;
        }];
        
    }
    return _introductionView;
}

- (void)removeIntroductionView{
    [UIView animateWithDuration:kSubviewsSwitchDuration animations:^{
        _introductionView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        if (finished) {
            [_introductionView removeFromSuperview];
            self.introductionView = nil;
        }
    }];
}

- (void)setIntroductionView:(CDIntroductionView *)introductionView{
    _introductionView = introductionView;
}

- (void)switchIntroductionView{
    if (_isIntroOn) {
        _isIntroOn = NO;
        
        if (_introductionRevert) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:_introductionRevert];
#pragma clang diagnostic pop
            self.introductionRevert = nil;
        }else{
            [self removeIntroductionView];
        }
    }else{
        _isIntroOn = YES;
        
        if (_lyricsView) {
            
            self.introductionRevert = @selector(lyricsView);
            [UIView animateWithDuration:kSubviewsSwitchDuration animations:^{
                _lyricsView.alpha = 0.0f;
            } completion:^(BOOL finished) {
                if (finished) {
                    [_lyricsView removeFromSuperview];
                }
            }];
        
        }else if (_storyView){
           
            self.introductionRevert = @selector(storyView);
            [UIView animateWithDuration:kSubviewsSwitchDuration animations:^{
                _storyView.alpha = 0.0f;
            } completion:^(BOOL finished) {
                if (finished) {
                    [_storyView removeFromSuperview];
                }
            }];
        
        }
        [self introductionView];
    }
}

@end
