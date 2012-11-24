//
//  CDBackgroundView.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/21/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLBackgroundView.h"

typedef enum {
    CDBackgroundViewKeyNone,
    CDBackgroundViewKeyMissingLyrics,
}CDBackgroundViewKey;
@protocol CDBackgroundViewDatasource;
@interface CDBackgroundView : YLBackgroundView 
@property(nonatomic, readonly, strong)UIView* missingLyrics;
@property(nonatomic, weak)id<CDBackgroundViewDatasource> dataSource;

@property(nonatomic, strong)IBOutlet UILabel* audioName;

- (void)switchViewWithKey:(CDBackgroundViewKey)key;
@end

@protocol CDBackgroundViewDatasource
- (NSString*)backgroundViewNeedsAudioName:(CDBackgroundView*)backgroundView;
@end