//
//  CDBackgroundView.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/21/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "YLBackgroundView.h"

#define kSwitchAnimationDuration 0.3f

#define kOffsetMax 40.0f
//#define kResetSpeed 2.0f
//#define kStep 5.0f

typedef enum {
    CDBackgroundViewKeyNone,
    CDBackgroundViewKeyMissingLyrics,
    CDBackgroundViewKeyAssist
}CDBackgroundViewKey;
typedef enum {
    CDAnimationStateReset,
    CDAnimationStateUp,
    CDAnimationStateDown
}CDAnimationState;
@class CDSpotlightView;
@protocol CDBackgroundViewDatasource;
@interface CDBackgroundView : UIView {
    CDBackgroundViewKey _state;
    
    CDSpotlightView *_spotlight;
    UIImage *_noizeImage;
    CDAnimationState _animationState;
}
@property(nonatomic, readonly)CDBackgroundViewKey state;
@property(nonatomic, readonly)UIView* missingLyrics;
@property(nonatomic, readonly)UIView* assistView;
@property(nonatomic, weak)id<CDBackgroundViewDatasource> dataSource;
//@property(nonatomic, strong)IBOutlet UILabel* audioName;
//@property(nonatomic, assign)CGSize offset;
//- (void)setpVertically:(CGFloat)distance;
- (void)switchViewWithKey:(CDBackgroundViewKey)key;

- (void)moveWithValue:(CGFloat)distance;
- (void)move:(CDAnimationState)target;

@end

@protocol CDBackgroundViewDatasource
- (NSString*)backgroundViewNeedsAudioName:(CDBackgroundView*)backgroundView;
@end

@interface CDSpotlightView : UIView
@end