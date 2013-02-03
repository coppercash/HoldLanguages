//
//  AppDelegate.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/10/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CDPanViewController, CDAudioSharer, CDAudioProgress;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(strong, nonatomic) UIWindow *window;
@property(strong, nonatomic) CDPanViewController *panViewController;
@property(strong, nonatomic) CDAudioSharer *audioSharer;
@property(strong, nonatomic) CDAudioProgress *progress;

@end
