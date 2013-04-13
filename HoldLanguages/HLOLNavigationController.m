//
//  CDOnlineNavController.m
//  HoldLanguages
//
//  Created by William Remaerd on 4/2/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "HLOLNavigationController.h"
#import "HLOLRootController.h"
#import "HLOLCategoryController.h"
#import "HLOLItemsController.h"
#import "HLModelsGroup.h"
#import "CDPullControllerMetro.h"
#import "CDColorFinder.h"
#import "CDStack.h"

@interface HLOLNavigationController ()
@property(nonatomic, strong)UIButton *backButton;
- (void)backButtonClicked:(UIButton *)button;
@end

@implementation HLOLNavigationController
@synthesize panViewController = _panViewController;
@synthesize backButton = _backButton;
- (id)init{
    HLOLRootController *category = [[HLOLRootController alloc] init];
    self = [super initWithRootViewController:category];
    return self;
}

- (void)loadView{
    self.wantsFullScreenLayout = NO;
    [super loadView];
    
    self.navigationBarHidden = YES;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.frame = [[UIScreen mainScreen] applicationFrame];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    NSError *error = nil;
    [kMOContext save:&error];
    AssertError(error);
}

#pragma mark - Back Button
- (UIButton *)backButton{
    UIView *view = self.view;
    if (!_backButton) {

        CGFloat bBSize = 44.0f;
        CGRect bBF = CGRectMake(kMargin, CGRectGetHeight(view.bounds) - bBSize - kMargin, bBSize, bBSize);
        UIButton *backButton = [[UIButton alloc] initWithFrame:bBF];
        backButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        backButton.backgroundColor = [CDColorFinder colorOfBars];
        [backButton setImage:[UIImage pngImageWithName:@"BackButton"] forState:UIControlStateNormal];
        [backButton shadowed];
        [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

        self.backButton = backButton;
    }
    
    if (!_backButton.superview) {
        _backButton.alpha = 0.0f;
        [view addSubview:_backButton];
        [UIView animateWithDuration:kDefaultAnimationDuration animations:^{
            _backButton.alpha = 1.0f;
        }];
    }
    
    [self.view bringSubviewToFront:_backButton];
    
    return _backButton;
}

- (void)removeBackButton{
    [UIView animateWithDuration:kDefaultAnimationDuration delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        _backButton.alpha = 0.0f;

    } completion:^(BOOL finished) {
        
        if (!finished) return;
        [_backButton removeFromSuperview];
        self.backButton = nil;
    
    }];
}

#pragma mark - Events
- (void)backButtonClicked:(UIButton *)button{
    [self popViewControllerAnimated:YES];
}

#pragma mark - Pop
- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    HLOLCategoryController *controller = (HLOLCategoryController *)[super popViewControllerAnimated:animated];
    [controller.models pop];
    return controller;
}

- (void)pushWithModelsGroup:(HLModelsGroup *)group link:(NSString *)link{
    NSAssert(group != nil, @"%@ can't push view controller without group.", NSStringFromClass(self.class));
    
    if (self.viewControllers.count > 1) [group pushWithLink:link];
    
    HLOLCategoryController *controller = nil;
    if (group.isPenultDegree) {
        controller = [[HLOLItemsController alloc] init];
    }else{
        controller = [[HLOLCategoryController alloc] init];
    }
    controller.models = group;
    
    [self pushViewController:controller animated:YES];
}

@end
