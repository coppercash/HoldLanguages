//
//  StoryViewCategory.h
//  HoldLanguages
//
//  Created by William Remaerd on 3/22/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController (StoryViewCategory)
- (void)createStoryViewIn:(UIView *)view;
- (CDStoryView *)createStoryViewWihtFrame:(CGRect)frame;
- (BOOL)openText:(NSString *)text;
@end
