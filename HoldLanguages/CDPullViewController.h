//
//  CDPullViewController.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/15/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDPullTopBar.h"
#import "CDPullBottomBar.h"

#define kHiddingAniamtionDuration 0.3f

@interface CDPullViewController : UIViewController <CDPullTopBarDelegate, CDPullTopBarDataSource, CDPullBottomBarDelegate>
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

