//
//  AppDelegate.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/10/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController, CDAudioSharer;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(strong, nonatomic) UIWindow *window;
@property(strong, nonatomic) MainViewController* mainViewController;
@property(strong, nonatomic) CDAudioSharer* audioSharer;

@end
