//
//  LyricsCategory.m
//  HoldLanguages
//
//  Created by William Remaerd on 3/28/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LyricsCategory.h"
#import "CDLyrics.h"
#import "CDLRCLyrics.h"
#import "CDBackgroundView.h"

#import "HolderCategory.h"
#import "StoryViewCategory.h"
#import "IntroductionCategory.h"

@interface MainViewController ()

@end

@implementation MainViewController (LyricsCategory)

- (CDLyricsView *)lyricsView{
    if (!_lyricsView) {
        self.lyricsView = [[CDLyricsView alloc] initWithFrame:self.view.bounds];
        _lyricsView.autoresizingMask = CDViewAutoresizingNoMaigin;
        _lyricsView.lyricsSource = self;
    }
    if (!_lyricsView.superview) {
        _lyricsView.alpha = 0.0f;
        [self.view insertSubview:_lyricsView belowSubview:_holder];
        [UIView animateWithDuration:kSubviewsSwitchDuration animations:^{
            _lyricsView.alpha = 1.0f;
        }];

        [self removeStoryView];
        [self removeIntroductionView];
    }
    return _lyricsView;
}

- (void)removeLyricsView{
    [UIView animateWithDuration:kSubviewsSwitchDuration animations:^{
        _lyricsView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        if (finished) {
            self.lyrics = nil;
            [_lyricsView removeFromSuperview];
            self.lyricsView = nil;
        }
    }];
}

- (void)setLyricsView:(CDLyricsView *)lyricsView{
    _lyricsView = lyricsView;
}

#pragma mark - CDLyricsViewLyricsSource
- (NSUInteger)numberOfLyricsRowsInView:(CDLyricsView *)lyricsView{
    NSUInteger number = self.lyrics.numberOfLyricsRows;
    return number;
}

- (NSString*)lyricsView:(CDLyricsView *)lyricsView stringForRowAtIndex:(NSUInteger)index{
    NSString* string = [self.lyrics contentAtIndex:index];
    return string;
}

- (NSString *)lyricsViewNeedsLyricsInfo:(CDLyricsView *)lyricsView{
    NSString *cI = convertedLyricsInfo(_lyrics.lyricsInfo); //converted information
    return cI;
}

#pragma mark - Lyrics
- (BOOL)openLyricsAtPath:(NSString *)path{
    //Data prepare
    CDLRCLyrics* newLyrics = [[CDLRCLyrics alloc] initWithFile:path];
    if (!newLyrics.isReady) return NO;
    self.lyrics = newLyrics;
    
    [self.lyricsView reloadData];
    
    return YES;
}

@end
