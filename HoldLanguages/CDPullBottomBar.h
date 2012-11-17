//
//  CDPullBottomBar.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/16/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBottomBarHeight 100.0f
#define kBottomProgressHeight 20.0f
#define kSliderMargin 15.0f
#define kSliderProgressViewHeight 10.0f
#define kSliderProgressViewOffsetY 70.0f
@class CDSliderProgressView, CDSliderThumb;
@protocol CDPullBottomBarDelegate;
@interface CDPullBottomBar : UIView
@property(nonatomic, readonly, strong)CDSliderProgressView* progressView;
@property(nonatomic, readonly, strong)CDSliderThumb* sliderThumb;
@property(nonatomic, weak)id<CDPullBottomBarDelegate> delegate;
- (void)setSliderValue:(float)sliderValue;
@end

@protocol CDPullBottomBarDelegate
@required
- (BOOL)bottomBarAskForHiddenState:(CDPullBottomBar*)bottomButton;
- (void)bottomBar:(CDPullBottomBar*)bottomButton sliderValueChangedAs:(float)sliderValue;
@end