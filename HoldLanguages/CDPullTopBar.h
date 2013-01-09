//
//  CDPullTopBar.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/16/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDStateButton.h"
#import "CDScrollLabel.h"

#define kTopBarVisualHeight 44.0f
#define kTopBarPullButtonHeight 20.0f
#define kPullButtonEffectiveWidth 40.0f
#define kPullButtonEffectiveHeight 40.0f
#define kPullButtonImageName @"PullButton"
@protocol CDPullTopBarDelegate, CDPullTopBarDataSource;
@class CDStateButton, CDScrollLabel;
@interface CDPullTopBar : UIControl <CDStateButtonDelegate, CDScrollLabelDelegate>{
    CGFloat _yStartOffset;
    CGFloat _yLastOffset;
}
@property(nonatomic, readonly, strong)IBOutlet CDScrollLabel* artist;
@property(nonatomic, readonly, strong)IBOutlet CDScrollLabel* title;
@property(nonatomic, readonly, strong)IBOutlet CDScrollLabel* albumTitle;
@property(nonatomic, readonly, strong)IBOutlet CDStateButton* rotationLock;
@property(nonatomic, readonly, strong)IBOutlet CDStateButton* assistButton;
@property(nonatomic, readonly)BOOL isRotationLocked;
@property(nonatomic, readonly, strong)UIImageView* pullButton;
@property(nonatomic, weak)id<CDPullTopBarDelegate> delegate;
@property(nonatomic, weak)id<CDPullTopBarDataSource> dataSource;
- (void)reloadData;
@end
@protocol CDPullTopBarDelegate <NSObject>
@required
- (void)topBarStartPulling:(CDPullTopBar*)topBar;
- (BOOL)topBarContinuePulling:(CDPullTopBar*)topBar shouldMoveTo:(CGFloat)yOffset;
- (void)topBarFinishPulling:(CDPullTopBar*)topBar;
- (void)topBarCancelPulling:(CDPullTopBar*)topBar;

- (BOOL)topBarShouldLockRotation:(CDPullTopBar*)topBar;
- (void)topBarLeftButtonTouched:(CDPullTopBar*)topBar;
@end
@protocol CDPullTopBarDataSource
- (NSString*)topBarNeedsArtist:(CDPullTopBar*)topBar;
- (NSString*)topBarNeedsTitle:(CDPullTopBar*)topBar;
- (NSString*)topBarNeedsAlbumTitle:(CDPullTopBar*)topBar;
@required
@end