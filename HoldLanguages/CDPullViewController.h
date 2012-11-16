//
//  CDPullViewController.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/15/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTopBarVisualHeight 44.0f
#define kTopBarPullButtonHeight 20.0f
#define kPullButtonEffectiveWidth 40.0f
#define kPullButtonEffectiveHeight 40.0f
@protocol CDPullTopBarDelegate;
@interface CDPullTopBar : UIControl
@property(nonatomic, weak)id<CDPullTopBarDelegate> delegate;
@end
@protocol CDPullTopBarDelegate
@required
- (void)topBarTouchedDown:(CDPullTopBar*)topBar;
- (void)topBarTouchedUpInside:(CDPullTopBar*)topBar;
@end

#define kBottomBarHeight 100.0f
#define kBottomProgressHeight 20.0f
@interface CDPullBottomBar : UIView

@end

@interface CDPullViewController : UIViewController <CDPullTopBarDelegate>
@property(nonatomic)BOOL barsHidden;
@property(nonatomic)BOOL pulledViewPresented;
@property(nonatomic, readonly, strong)UIView* pulledView;
@property(nonatomic, readonly, strong)CDPullTopBar* topBar;
@property(nonatomic, readonly, strong)CDPullBottomBar* bottomBar;
- (void)endOfViewDidLoad;
- (void)setBarsHidden:(BOOL)barsHidden animated:(BOOL)animated;
- (void)loadPulledView:(UIView*)pulledView;
- (void)setPullViewPresented:(BOOL)pullViewPresented animated:(BOOL)animated;
@end

