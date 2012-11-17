//
//  CDPullTopBar.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/16/12.
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