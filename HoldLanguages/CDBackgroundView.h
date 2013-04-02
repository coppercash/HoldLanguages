//
//  CDBackgroundView.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/21/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSwitchAnimationDuration 0.3f
#define kOffsetMax 40.0f

typedef enum {
    CDAnimationStateReset,
    CDAnimationStateUp,
    CDAnimationStateDown
}CDAnimationState;

@class CDSpotlightView, CDMasterPlayerDraw;
@protocol CDBackgroundViewDatasource;
@interface CDBackgroundView : UIView {
    CDSpotlightView *_spotlight;
    UIImage *_noizeImage;
    CDAnimationState _animationState;
    
    UIImageView *_leftPage;
    UIImageView *_rightPage;
    CDMasterPlayerDraw *_playerDraw;
}

- (void)moveWithValue:(CGFloat)distance;
- (void)move:(CDAnimationState)target;

- (void)igniteLeftPage;
- (void)igniteRightPage;
- (void)ignitePlayerDraw:(BOOL)isPlaying;
@end


@interface CDSpotlightView : UIView
@end