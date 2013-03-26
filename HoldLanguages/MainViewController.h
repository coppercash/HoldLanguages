//
//  MainViewController.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/11/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CDPullControllerMetro.h"
#import "CDHolder.h"
#import "CDLyricsView.h"
#import "CDAudioSharer.h"
#import "CDProgress.h"
#import "CDPanViewController.h"
#import "CDRatesView.h"
#import "CDRepeatView.h"

@class CDAudioSharer, CDLyrics, CDBackgroundView, CDStoryView;
@interface MainViewController : CDPullControllerMetro<MPMediaPickerControllerDelegate, CDHolderDelegate, CDLyricsViewLyricsSource, CDAudioPlayerDelegate, CDAudioProgressDelegate, CDSubPanViewController, CDRatesViewDelegate, CDRepeatViewDelegate>{
    //Subviews
    CDBackgroundView *_backgroundView;
    CDStoryView *_storyView;
    CDHolder *_holder;
    CDLyricsView *_lyricsView;
    
    CDRatesView *_ratesView;
    CDRepeatView *_repeatView;
    
    CDAudioSharer *_audioSharer;
    CDLyrics *_lyrics;
    
    MPMediaPickerController *_mediaPicker;
    
    CDAudioProgress *_progress;
}
@property(nonatomic, strong)CDPanViewController *panViewController;
@property(nonatomic, strong)CDHolder *holder;
@property(nonatomic, strong)CDLyricsView *lyricsView;
@property(nonatomic, strong)CDBackgroundView *backgroundView;
@property(nonatomic, strong)CDAudioSharer *audioSharer;
@property(nonatomic, strong)CDLyrics* lyrics;
@property(nonatomic, strong)MPMediaPickerController *mediaPicker;
@property(nonatomic, strong)CDAudioProgress *progress;
@property(nonatomic, strong)CDRatesView *ratesView;
@property(nonatomic, strong)CDRepeatView *repeatView;
@property(nonatomic, strong)CDStoryView *storyView;
- (BOOL)openLyricsAtPath:(NSString *)path;
- (void)switchBarsHidden;
- (void)createLyricsView;
- (void)destroyLyricsView;
- (void)switchAssistHidden;

- (void)prepareToChangeRate;
- (void)prepareToRepeat:(CDDirection)direction;
- (void)countRepeatTimeWithDistance:(CGFloat)distance;
- (void)repeatWithDirection:(CDDirection)direction distance:(CGFloat)distance;
@end
