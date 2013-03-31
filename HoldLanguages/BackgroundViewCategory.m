//
//  BackgroundViewCategory.m
//  HoldLanguages
//
//  Created by William Remaerd on 3/28/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "BackgroundViewCategory.h"
#import "CDBackgroundView.h"
#import "CDLyricsView.h"

@interface MainViewController ()

@end

@implementation MainViewController (BackgroundViewCategory)
- (CDBackgroundView *)backgroundView{
    UIView *view = self.view;
    if (!_backgroundView) {
        _backgroundView = [[CDBackgroundView alloc] initWithFrame:view.bounds];
        _backgroundView.autoresizingMask = kViewAutoresizingNoMarginSurround;
    }
    if (!_backgroundView.superview) {
        [view addSubview:_backgroundView];
    }
    return _backgroundView;
}

- (void)setBackgroundView:(CDBackgroundView *)backgroundView{
    _backgroundView = backgroundView;
}

@end
