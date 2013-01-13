//
//  CDPanViewController.h
//  HoldLanguages
//
//  Created by William Remaerd on 1/12/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "DDMenuController.h"
typedef enum {
    CDPanViewControllerTypeRoot,
    CDPanViewControllerTypeLeft,
    CDPanViewControllerTypeRight,
}CDPanViewControllerType;
@protocol CDSubPanViewController;
@interface CDPanViewController : DDMenuController <UIGestureRecognizerDelegate>
@property(strong, nonatomic)id userInfo;
@property(nonatomic, strong) UIViewController<CDSubPanViewController> *leftViewController;
@property(nonatomic, strong) UIViewController<CDSubPanViewController> *rightViewController;
@property(nonatomic, strong) UIViewController<CDSubPanViewController> *rootViewController;
@property(nonatomic, strong) Class leftControllerClass;

- (id)initWithRootViewController:(UIViewController<CDSubPanViewController> *)controller;
- (void)switchToController:(CDPanViewControllerType)type withUserInfo:(id)userInfo;
@end

@protocol CDSubPanViewController <NSObject>
@optional
- (UIView*)panView;
- (void)setPanViewController:(CDPanViewController*)panController;
- (void)willPresentWithUserInfo:(id)userInfo;
@end

