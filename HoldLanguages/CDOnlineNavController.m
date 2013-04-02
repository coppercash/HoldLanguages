//
//  CDOnlineNavController.m
//  HoldLanguages
//
//  Created by William Remaerd on 4/2/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDOnlineNavController.h"
#import "CDCategoryViewController.h"
#import "CD51VOA.h"
#import "CDPullControllerMetro.h"
#import "CDColorFinder.h"

@interface CDOnlineNavController ()
@property(nonatomic, strong)CD51VOA *VOA51;
@property(nonatomic, strong)UIButton *backButton;
- (void)backButtonClicked:(UIButton *)button;
@end

@implementation CDOnlineNavController
@synthesize panViewController = _panViewController;
@synthesize backButton = _backButton;
- (id)init{
    CDCategoryViewController *category = [[CDCategoryViewController alloc] init];
    self = [super initWithRootViewController:category];
    return self;
}

- (void)loadView{
    self.wantsFullScreenLayout = NO;
    [super loadView];
    
    self.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = [[UIScreen mainScreen] applicationFrame];
    
    self.VOA51 = [[CD51VOA alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)destroyBackButton{
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

@end
