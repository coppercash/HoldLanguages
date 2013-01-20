//
//  MainViewController.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/11/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDPullViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CDHolder.h"
#import "CDLyricsView.h"
#import "CDAudioSharer.h"
#import "CDBackgroundView.h"
#import "CDProgress.h"
#import "CDPanViewController.h"
#import "CDLazyScrollView.h"

@class CDAudioSharer, CDLyrics, CDBackgroundView, CDLazyScrollView;
@interface MainViewController : CDPullViewController <MPMediaPickerControllerDelegate, CDHolderDelegate, CDLyricsViewLyricsSource, CDAudioPlayerDelegate, CDBackgroundViewDatasource, CDAudioProgressDelegate, CDSubPanViewController, CDLazyScrollViewDataSource, CDLazyScrollViewDelegate>{
    CDDirection _lastRepeatDirection;
}
@property(nonatomic, strong)CDPanViewController *panViewController;
@property(nonatomic, strong)CDHolder* holder;
@property(nonatomic, strong)CDLyricsView* lyricsView;
@property(nonatomic, readonly, strong)CDBackgroundView* backgroundView;
@property(nonatomic, strong)CDAudioSharer* audioSharer;
@property(nonatomic, strong)CDLyrics* lyrics;
@property(nonatomic, strong)MPMediaPickerController* mediaPicker;
@property(nonatomic, strong)CDAudioProgress *progress;
@property(nonatomic, strong)CDLazyScrollView *ratesView;
@end
