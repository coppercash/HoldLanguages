//
//  StoryViewCategory.m
//  HoldLanguages
//
//  Created by William Remaerd on 3/22/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "StoryViewCategory.h"
#import "CDStoryView.h"
#import "CDBackgroundView.h"

@interface MainViewController ()
@end

@implementation MainViewController (StoryViewCategory)
- (CDStoryView *)createStoryViewWihtFrame:(CGRect)frame{
    self.storyView = [[CDStoryView alloc] initWithFrame:frame];
    return _storyView;
}

- (void)createStoryViewIn:(UIView *)view{
    self.storyView = [[CDStoryView alloc] initWithFrame:view.bounds];
    //_holder.brother = _storyView;
    //[_holder addSubview:_storyView];
    [view insertSubview:_storyView belowSubview:_holder];
}

- (BOOL)openText:(NSString *)text{
    if (_storyView == nil) [self createStoryViewIn:self.view];
    [_storyView setContentString:text];
    return YES;
}

@end
