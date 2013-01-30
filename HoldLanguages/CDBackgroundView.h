//
//  CDBackgroundView.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/21/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLBackgroundView.h"

#define kSwitchAnimationDuration 0.3f

typedef enum {
    CDBackgroundViewKeyNone,
    CDBackgroundViewKeyMissingLyrics,
    CDBackgroundViewKeyAssist
}CDBackgroundViewKey;
@protocol CDBackgroundViewDatasource;
@interface CDBackgroundView : YLBackgroundView {
    CDBackgroundViewKey _state;
}
@property(nonatomic, readonly)CDBackgroundViewKey state;
@property(nonatomic, readonly, strong)UIView* missingLyrics;
@property(nonatomic, readonly, strong)UIView* assistView;
@property(nonatomic, weak)id<CDBackgroundViewDatasource> dataSource;

@property(nonatomic, strong)IBOutlet UILabel* audioName;

- (void)switchViewWithKey:(CDBackgroundViewKey)key;
@end

@protocol CDBackgroundViewDatasource
- (NSString*)backgroundViewNeedsAudioName:(CDBackgroundView*)backgroundView;
@end