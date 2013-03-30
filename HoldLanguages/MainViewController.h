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
#import "CDPanViewController.h"

@class CDLyricsView, CDBackgroundView, CDStoryView, CDIntroductionView;
@class CDHolder;
@class CDRepeatView, CDRatesView;
@class CDAudioSharer, CDLyrics;
@interface MainViewController : CDPullControllerMetro<MPMediaPickerControllerDelegate, CDSubPanViewController>{
    __weak CDPanViewController *_panViewController;
    
    //Subviews
    CDHolder *_holder;
    
    CDLyricsView *_lyricsView;
    CDLyrics *_lyrics;
    
    CDStoryView *_storyView;
    Item *_item;
    //NSString *_story;
    
    CDIntroductionView *_introductionView;
    SEL _introductionRevert;
    BOOL _isIntroOn;

    CDBackgroundView *_backgroundView;

    
    CDRatesView *_ratesView;
    CDRepeatView *_repeatView;
    
    MPMediaPickerController *_mediaPicker;

    CDAudioSharer *_audioSharer;
    CDAudioProgress *_progress;
}
@property(nonatomic, weak)CDPanViewController *panViewController;

@property(nonatomic, strong)CDHolder *holder;
@property(nonatomic, strong)CDLyricsView *lyricsView;
@property(nonatomic, strong)CDStoryView *storyView;
@property(nonatomic, strong)CDIntroductionView *introductionView;
@property(nonatomic, strong)CDBackgroundView *backgroundView;

@property(nonatomic, strong)CDRatesView *ratesView;
@property(nonatomic, strong)CDRepeatView *repeatView;

@property(nonatomic, strong)MPMediaPickerController *mediaPicker;

@property(nonatomic, strong)CDAudioSharer *audioSharer;
@property(nonatomic, strong)CDAudioProgress *progress;
@property(nonatomic, strong)CDLyrics* lyrics;
@property(nonatomic, strong)Item* item;
//@property(nonatomic, copy)NSString *story;
@property(nonatomic, assign)SEL introductionRevert;

@end

#define kSubviewsSwitchDuration 0.3f