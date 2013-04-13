//
//  CDOnlineNavController.h
//  HoldLanguages
//
//  Created by William Remaerd on 4/2/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDPanViewController.h"

@class HLModelsGroup;
@interface HLOLNavigationController : UINavigationController <CDSubPanViewController> {
    __weak CDPanViewController *_panViewController;
    UIButton *_backButton;
}
@property(nonatomic, weak)CDPanViewController *panViewController;
@property(nonatomic, readonly)UIButton *backButton;
- (void)removeBackButton;
- (void)pushWithModelsGroup:(HLModelsGroup *)group link:(NSString *)link;
@end
