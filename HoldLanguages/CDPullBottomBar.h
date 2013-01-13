//
//  CDPullBottomBar.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/16/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDProgress.h"

#define kPlayButtonTopMargin 10.0f
#define kPlayButtonSize 80.0f
#define kOtherButtonsGapFromPlayButton 40.0f
#define kOtherButtonsSize 60.0f
#define kBackwardButtonName @"BackwardButton"
#define kBackwardButtonDownName @"BackwardButtonDown"
#define kForwardButtonName @"ForwardButton"
#define kForwardButtonDownName @"ForwardButtonDown"

#define kSliderLeftAndRightMargin 60.0f
#define kSliderProgressViewHeight 10.0f
#define kSliderProgressViewOffsetY 110.0f

#define kBottomBarHeight 130.0f
#define kBottomProgressHeight kSliderProgressViewHeight

#define kLabelHorizontalMargin 5.0f
#define kLabelWidth 53.0f
#define kLabelHeight kSliderProgressViewHeight + 3.0f

#define kLabelsUpdateTimes 10
#define kProgressViewUpdateTimes 5

typedef enum{
    CDBottomBarButtonTypePlay,
    CDBottomBarButtonTypeBackward,
    CDBottomBarButtonTypeForward
}CDBottomBarButtonType;

typedef enum{
    CDBottomBarPlayButtonStatePlaying,
    CDBottomBarPlayButtonStatePaused,
}CDBottomBarPlayButtonState;

@class CDSliderProgressView, CDSliderThumb, CDPlayButton;
@protocol CDPullBottomBarDelegate;
@interface CDPullBottomBar : UIView <CDAudioProgressDelegate>
@property(nonatomic)BOOL hidden;

@property(nonatomic, readonly, strong)CDSliderProgressView* progressView;
@property(nonatomic, readonly, strong)CDSliderThumb* sliderThumb;

@property(nonatomic, readonly, strong)CDPlayButton* playButton;
@property(nonatomic, readonly, strong)UIButton* backwardButton;
@property(nonatomic, readonly, strong)UIButton* forwardButton;
@property(nonatomic, readonly, strong)UILabel* playbackTimeLabel;
@property(nonatomic, readonly, strong)UILabel* remainingTimeLabel;

@property(nonatomic, weak)id<CDPullBottomBarDelegate> delegate;
@property(nonatomic) CDBottomBarPlayButtonState playButtonState;
- (void)setSliderValue:(float)sliderValue;
- (void)setLabelsPlaybackTime:(NSTimeInterval)playbackTime;
- (void)reloadData;
- (void)setHidden:(BOOL)hidden animated:(BOOL)animated;
@end

@protocol CDPullBottomBarDelegate
@required
- (NSTimeInterval)bottomBarAskForDuration:(CDPullBottomBar*)bottomButton;
- (void)bottomBar:(CDPullBottomBar*)bottomButton sliderValueChangedAs:(float)sliderValue;
- (void)bottomBar:(CDPullBottomBar*)bottomButton buttonFire:(CDBottomBarButtonType)buttonType;

@end