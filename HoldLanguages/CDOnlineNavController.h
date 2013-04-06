//
//  CDOnlineNavController.h
//  HoldLanguages
//
//  Created by William Remaerd on 4/2/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDPanViewController.h"

@class CD51VOA;
@interface CDOnlineNavController : UINavigationController <CDSubPanViewController> {
    __weak CDPanViewController *_panViewController;
    CD51VOA *_VOA51;
    UIButton *_backButton;
}
@property(nonatomic, weak)CDPanViewController *panViewController;
@property(nonatomic, readonly)CD51VOA *VOA51;
@property(nonatomic, readonly)UIButton *backButton;
- (void)destroyBackButton;
@end
