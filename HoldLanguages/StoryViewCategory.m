//
//  StoryViewCategory.m
//  HoldLanguages
//
//  Created by William Remaerd on 3/22/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "StoryViewCategory.h"
#import "CDStoryView.h"
#import "CDBackgroundView.h"
#import "CDHolder.h"
#import "CDItem.h"
#import "CoreDataModels.h"

#import "IntroductionCategory.h"
#import "LyricsCategory.h"

@implementation MainViewController (StoryViewCategory)

- (CDStoryView *)storyView{
    if (!_storyView) {
        self.storyView = [[CDStoryView alloc] initWithFrame:self.view.bounds];
        _storyView.autoresizingMask = kViewAutoresizingNoMarginSurround;
        [_storyView setItem:_item];
        //[_storyView setContentString:_story];
    }
    if (!_storyView.superview) {
        _storyView.alpha = 0.0f;
        [self.view insertSubview:_storyView belowSubview:_holder];
        [UIView animateWithDuration:kSubviewsSwitchDuration animations:^{
            _storyView.alpha = 1.0f;
        }];
        
        [self removeLyricsView];
        [self removeIntroductionView];
    }
    return _storyView;
}

- (void)removeStoryView{
    [UIView animateWithDuration:kSubviewsSwitchDuration animations:^{
        _storyView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        if (finished) {
            [_storyView removeFromSuperview];
            self.storyView = nil;
        }
    }];
}

- (void)setStoryView:(CDStoryView *)storyView{
    _storyView = storyView;
}

- (BOOL)openItem:(Item *)item{
    self.item = item;
    if (![self openLyricsAtPath:item.lyrics.absolutePath]) {
        [self.storyView setItem:item];
    }
    return YES;
}
/*
- (BOOL)openText:(NSString *)text{
    self.story = text;
    [self.storyView setContentString:text];
    return YES;
}*/

@end
