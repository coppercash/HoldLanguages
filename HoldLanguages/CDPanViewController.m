//
//  CDPanViewController.m
//  HoldLanguages
//
//  Created by William Remaerd on 1/12/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDPanViewController.h"
#define kMenuFullWidth self.view.bounds.size.width * 0.7f
#define kMenuDisplayedWidth self.view.bounds.size.width * 0.7f
#define kMenuOverlayWidth (self.view.bounds.size.width - kMenuDisplayedWidth)
#define kMenuBounceOffset 10.0f
#define kMenuBounceDuration .3f
#define kMenuSlideDuration .3f


@interface CDPanViewController ()
- (void)showShadow:(BOOL)val;
- (void)didSwitchToControllerType:(CDPanViewControllerType)type;
- (UIViewController<CDSubPanViewController> *)createSubController:(Class)controllerClass;
@end

@implementation CDPanViewController
@synthesize leftViewController=_left, rightViewController=_right, rootViewController=_root;
@synthesize userInfo = _userInfo;

- (id)initWithRootViewController:(UIViewController<CDSubPanViewController> *)controller{
    self = [super initWithRootViewController:controller];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.wantsFullScreenLayout = YES;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Rotation
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    [_root motionEnded:motion withEvent:event];
}

- (BOOL)shouldAutorotate{
    return [_root shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations{
    return [_root supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [_root preferredInterfaceOrientationForPresentation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if (_root == nil) {
        return toInterfaceOrientation == UIInterfaceOrientationMaskPortrait;
    }
    return [_root shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [_root willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [_root didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self showShadow:YES];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[_root willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

#pragma mark - Shadow
- (void)showShadow:(BOOL)val {
    if (!_root) return;
    
    _root.view.layer.shadowOpacity = val ? 0.8f : 0.0f;
    if (val) {
        _root.view.layer.cornerRadius = 4.0f;
        _root.view.layer.shadowOffset = CGSizeZero;
        _root.view.layer.shadowRadius = 4.0f;
        _root.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
    }
}

#pragma mark - Set Controller
- (void)setRightViewController:(UIViewController<CDSubPanViewController> *)rightController{
    _right = rightController;
    _menuFlags.canShowRight = (self.rightViewController != nil);
}

- (void)setLeftViewController:(UIViewController<CDSubPanViewController> *)leftController{
    _left = leftController;
    UIView *view = self.leftViewController.view;
	CGRect frame = self.view.bounds;
	frame.size.width = kMenuFullWidth;
    view.frame = frame;
    [self.view insertSubview:view atIndex:0];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    _menuFlags.canShowLeft = (self.leftViewController != nil);
}

- (void)setRootViewController:(UIViewController<CDSubPanViewController> *)rootViewController{
    if (rootViewController == nil) return;
    if (_right && _right.view.superview) [_root.view removeFromSuperview];
    
    _root = rootViewController;
    if ([_root respondsToSelector:@selector(setPanViewController:)]) {
        [_root setPanViewController:self];
    }
    _root.view.frame = self.view.bounds;
    [self.view addSubview:_root.view];
}

#pragma mark - GestureRecognizers
- (void)panRootControllerWithIncrement:(CGPoint)increment{
    CGFloat maxLeft = _menuFlags.canShowLeft ? CGRectGetMaxX(_left.view.frame) : 0.0f;
    CGFloat maxRight = _menuFlags.canShowRight ? CGRectGetMinX(_right.view.frame) : 0.0f;
    
    CGRect targetFrame = CGRectOffset(_root.view.frame, increment.x, increment.y);
    CGPoint center = _root.view.center;
    if (CGRectGetMinX(targetFrame) >= maxLeft) {
        center.x = maxLeft + CGRectGetMidX(_root.view.bounds);
    }else if (CGRectGetWidth(_root.view.bounds) - CGRectGetMaxX(targetFrame) >= maxRight) {
        center.x = (CGRectGetWidth(_root.view.bounds) - maxRight) - CGRectGetMidX(_root.view.bounds);
    }else{
        center.x += increment.x;
    }
    _root.view.center = center;
}

#pragma mark - Controller Switch
- (void)showRootController:(BOOL)animated {
    [_tap setEnabled:NO];
    _root.view.userInteractionEnabled = YES;
    
    CGRect frame = _root.view.frame;
    frame.origin.x = 0.0f;
    
    BOOL _enabled = [UIView areAnimationsEnabled];
    if (!animated) {
        [UIView setAnimationsEnabled:NO];
    }
    
    [UIView animateWithDuration:.3 animations:^{
        
        _root.view.frame = frame;
        
    } completion:^(BOOL finished) {
        
        if (_left && _left.view.superview) {
            [_left.view removeFromSuperview];
        }
        
        if (_right && _right.view.superview) {
            [_right.view removeFromSuperview];
        }
        
        _menuFlags.showingLeftView = NO;
        _menuFlags.showingRightView = NO;
        
        [self showShadow:NO];
        
        [self didSwitchToControllerType:CDPanViewControllerTypeRoot];
    }];
    
    if (!animated) {
        [UIView setAnimationsEnabled:_enabled];
        [self didSwitchToControllerType:CDPanViewControllerTypeRoot];
    }
    
}

- (void)showLeftController:(BOOL)animated {
    if (!_menuFlags.canShowLeft) return;
    
    if (_right && _right.view.superview) {
        [_right.view removeFromSuperview];
        _menuFlags.showingRightView = NO;
    }
    
    if (_menuFlags.respondsToWillShowViewController) {
        [self.delegate menuController:self willShowViewController:self.leftViewController];
    }
    _menuFlags.showingLeftView = YES;
    [self showShadow:YES];
    
    [self.leftViewController viewWillAppear:animated];
    
    CGPoint center = _root.view.center;
    center.x = CGRectGetMaxX(_left.view.frame) + CGRectGetMidX(_root.view.bounds);
    
    _root.view.userInteractionEnabled = NO;
    if (animated) {
        [UIView animateWithDuration:.3 animations:^{
            _root.view.center = center;
        } completion:^(BOOL finished) {
            [_tap setEnabled:YES];
            [self didSwitchToControllerType:CDPanViewControllerTypeLeft];
        }];
    }else{
        _root.view.center = center;
        [_tap setEnabled:YES];
        [self didSwitchToControllerType:CDPanViewControllerTypeLeft];
    }
}

- (void)showRightController:(BOOL)animated {
    if (!_menuFlags.canShowRight) return;
    
    if (_left && _left.view.superview) {
        [_left.view removeFromSuperview];
        _menuFlags.showingLeftView = NO;
    }
    
    if (_menuFlags.respondsToWillShowViewController) {
        [self.delegate menuController:self willShowViewController:self.rightViewController];
    }
    _menuFlags.showingRightView = YES;
    [self showShadow:YES];
    
    UIView *view = self.rightViewController.view;
    CGRect frame = self.view.bounds;
	frame.origin.x += frame.size.width - kMenuFullWidth;
	frame.size.width = kMenuFullWidth;
    view.frame = frame;
    [self.view insertSubview:view atIndex:0];
    
    frame = _root.view.frame;
    frame.origin.x = -(frame.size.width - kMenuOverlayWidth);
    
    BOOL _enabled = [UIView areAnimationsEnabled];
    if (!animated) {
        [UIView setAnimationsEnabled:NO];
    }
    
    _root.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:.3 animations:^{
        _root.view.frame = frame;
    } completion:^(BOOL finished) {
        [_tap setEnabled:YES];
        [self didSwitchToControllerType:CDPanViewControllerTypeRight];
    }];
    
    if (!animated) {
        [UIView setAnimationsEnabled:_enabled];
        [self didSwitchToControllerType:CDPanViewControllerTypeRight];
    }
}

- (void)didSwitchToControllerType:(CDPanViewControllerType)type{
    switch (type) {
        case CDPanViewControllerTypeRoot:{
            _root.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            _left = nil;
        }break;
        case CDPanViewControllerTypeLeft:{
            _root.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
        }break;
        default:
            break;
    }
}

- (void)switchToController:(CDPanViewControllerType)type withUserInfo:(id)userInfo{
    self.userInfo = userInfo;
    switch (type) {
        case CDPanViewControllerTypeRoot:{
            if ([_root respondsToSelector:@selector(willPresentWithUserInfo:)]) {
                [_root willPresentWithUserInfo:_userInfo];
            }
            [self showRootController:YES];
        }break;
        case CDPanViewControllerTypeLeft:{
            if ([_left respondsToSelector:@selector(willPresentWithUserInfo:)]) {
                [_left willPresentWithUserInfo:_userInfo];
            }
            [self showLeftController:YES];
        }break;
        case CDPanViewControllerTypeRight:{
            if ([_right respondsToSelector:@selector(willPresentWithUserInfo:)]) {
                [_right willPresentWithUserInfo:_userInfo];
            }
            [self showRightController:YES];
        }break;
        default:
            break;
    }
    self.userInfo = nil;
}

#pragma mark - Controller Switch
- (UIViewController<CDSubPanViewController> *)createSubController:(Class)controllerClass{
    UIViewController<CDSubPanViewController> *controller = [[controllerClass alloc] init];
    if ([controller respondsToSelector:@selector(setPanViewController:)]) {
        [controller setPanViewController:self];
    }
    return controller;
}
@end
