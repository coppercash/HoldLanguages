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
#define kPullButtonImageName @"PullButton"
@protocol CDPullTopBarDelegate, CDPullTopBarDataSource;
@interface CDPullTopBar : UIControl
@property(nonatomic, readonly, strong)IBOutlet UILabel* artist;
@property(nonatomic, readonly, strong)IBOutlet UILabel* title;
@property(nonatomic, readonly, strong)IBOutlet UILabel* albumTitle;
@property(nonatomic, readonly, strong)UIImageView* pullButton;
@property(nonatomic, weak)id<CDPullTopBarDelegate> delegate;
@property(nonatomic, weak)id<CDPullTopBarDataSource> dataSource;
- (void)reloadData;
@end
@protocol CDPullTopBarDelegate
@required
- (void)topBarTouchedDown:(CDPullTopBar*)topBar;
- (void)topBarTouchedUpInside:(CDPullTopBar*)topBar;
@end
@protocol CDPullTopBarDataSource
- (NSString*)topBarNeedsArtist:(CDPullTopBar*)topBar;
- (NSString*)topBarNeedsTitle:(CDPullTopBar*)topBar;
- (NSString*)topBarNeedsAlbumTitle:(CDPullTopBar*)topBar;
@required
@end