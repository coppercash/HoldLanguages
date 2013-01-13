//
//  CDPanViewController.m
//  HoldLanguages
//
//  Created by William Remaerd on 1/12/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDPanViewController.h"
#define kMenuFullWidth 320.0f
#define kMenuDisplayedWidth 280.0f
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
    return [_root shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [_root willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [_root didRotateFromInterfaceOrientation:fromInterfaceOrientation];
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
    _menuFlags.canShowLeft = (self.leftViewController != nil);
}

- (void)setRootViewController:(UIViewController<CDSubPanViewController> *)rootViewController{
    if (rootViewController == nil) return;
    [_root.view removeFromSuperview];
    _root = rootViewController;
    _root.view.frame = self.view.bounds;
    [self.view addSubview:_root.view];
    
    if ([rootViewController respondsToSelector:@selector(panView)]) {
        UIView *panView = rootViewController.panView;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        pan.delegate = self;
        [panView addGestureRecognizer:pan];
        _pan = pan;
    }
}

#pragma mark - GestureRecognizers
- (void)pan:(UIPanGestureRecognizer*)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        [self showShadow:YES];
        _panOriginX = self.view.frame.origin.x;
        _panVelocity = CGPointMake(0.0f, 0.0f);
        
        if([gesture velocityInView:self.view].x > 0) {
            _panDirection = DDMenuPanDirectionRight;
            if (_left == nil) {
                UIViewController<CDSubPanViewController> *left = [self createSubController:_leftControllerClass];
                [self setLeftViewController:left];
            }
        } else {
            _panDirection = DDMenuPanDirectionLeft;
        }
    }
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        
        CGPoint velocity = [gesture velocityInView:self.view];
        if((velocity.x*_panVelocity.x + velocity.y*_panVelocity.y) < 0) {
            _panDirection = (_panDirection == DDMenuPanDirectionRight) ? DDMenuPanDirectionLeft : DDMenuPanDirectionRight;
        }
        
        _panVelocity = velocity;
        CGPoint translation = [gesture translationInView:self.view];
        CGRect frame = _root.view.frame;
        frame.origin.x = _panOriginX + translation.x;
        
        if (frame.origin.x > 0.0f && !_menuFlags.showingLeftView) {
            
            if(_menuFlags.showingRightView) {
                _menuFlags.showingRightView = NO;
                [self.rightViewController.view removeFromSuperview];
            }
            
            if (_menuFlags.canShowLeft) {
                
                _menuFlags.showingLeftView = YES;
                CGRect frame = self.view.bounds;
				frame.size.width = kMenuFullWidth;
                self.leftViewController.view.frame = frame;
                [self.view insertSubview:self.leftViewController.view atIndex:0];
                
            } else {
                frame.origin.x = 0.0f; // ignore right view if it's not set
            }
            
        } else if (frame.origin.x < 0.0f && !_menuFlags.showingRightView) {
            
            if(_menuFlags.showingLeftView) {
                _menuFlags.showingLeftView = NO;
                [self.leftViewController.view removeFromSuperview];
            }
            
            if (_menuFlags.canShowRight) {
                
                _menuFlags.showingRightView = YES;
                CGRect frame = self.view.bounds;
				frame.origin.x += frame.size.width - kMenuFullWidth;
				frame.size.width = kMenuFullWidth;
                self.rightViewController.view.frame = frame;
                [self.view insertSubview:self.rightViewController.view atIndex:0];
                
            } else {
                frame.origin.x = 0.0f; // ignore left view if it's not set
            }
            
        }
        
        _root.view.frame = frame;
        
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        
        //  Finishing moving to left, right or root view with current pan velocity
        [self.view setUserInteractionEnabled:NO];
        
        DDMenuPanCompletion completion = DDMenuPanCompletionRoot; // by default animate back to the root
        
        if (_panDirection == DDMenuPanDirectionRight && _menuFlags.showingLeftView) {
            completion = DDMenuPanCompletionLeft;
        } else if (_panDirection == DDMenuPanDirectionLeft && _menuFlags.showingRightView) {
            completion = DDMenuPanCompletionRight;
        }
        
        CGPoint velocity = [gesture velocityInView:self.view];
        if (velocity.x < 0.0f) {
            velocity.x *= -1.0f;
        }
        BOOL bounce = (velocity.x > 800);
        CGFloat originX = _root.view.frame.origin.x;
        CGFloat width = _root.view.frame.size.width;
        CGFloat span = (width - kMenuOverlayWidth);
        CGFloat duration = kMenuSlideDuration; // default duration with 0 velocity
        
        
        if (bounce) {
            duration = (span / velocity.x); // bouncing we'll use the current velocity to determine duration
        } else {
            duration = ((span - originX) / span) * duration; // user just moved a little, use the defult duration, otherwise it would be too slow
        }
        
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            if (completion == DDMenuPanCompletionLeft) {
                [self showLeftController:NO];
            } else if (completion == DDMenuPanCompletionRight) {
                [self showRightController:NO];
            } else {
                [self showRootController:NO];
            }
            [_root.view.layer removeAllAnimations];
            [self.view setUserInteractionEnabled:YES];
        }];
        
        CGPoint pos = _root.view.layer.position;
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        
        NSMutableArray *keyTimes = [[NSMutableArray alloc] initWithCapacity:bounce ? 3 : 2];
        NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:bounce ? 3 : 2];
        NSMutableArray *timingFunctions = [[NSMutableArray alloc] initWithCapacity:bounce ? 3 : 2];
        
        [values addObject:[NSValue valueWithCGPoint:pos]];
        [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        [keyTimes addObject:[NSNumber numberWithFloat:0.0f]];
        if (bounce) {
            
            duration += kMenuBounceDuration;
            [keyTimes addObject:[NSNumber numberWithFloat:1.0f - ( kMenuBounceDuration / duration)]];
            if (completion == DDMenuPanCompletionLeft) {
                
                [values addObject:[NSValue valueWithCGPoint:CGPointMake(((width/2) + span) + kMenuBounceOffset, pos.y)]];
                
            } else if (completion == DDMenuPanCompletionRight) {
                
                [values addObject:[NSValue valueWithCGPoint:CGPointMake(-((width/2) - (kMenuOverlayWidth-kMenuBounceOffset)), pos.y)]];
                
            } else {
                
                // depending on which way we're panning add a bounce offset
                if (_panDirection == DDMenuPanDirectionLeft) {
                    [values addObject:[NSValue valueWithCGPoint:CGPointMake((width/2) - kMenuBounceOffset, pos.y)]];
                } else {
                    [values addObject:[NSValue valueWithCGPoint:CGPointMake((width/2) + kMenuBounceOffset, pos.y)]];
                }
                
            }
            
            [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            
        }
        if (completion == DDMenuPanCompletionLeft) {
            [values addObject:[NSValue valueWithCGPoint:CGPointMake((width/2) + span, pos.y)]];
        } else if (completion == DDMenuPanCompletionRight) {
            [values addObject:[NSValue valueWithCGPoint:CGPointMake(-((width/2) - kMenuOverlayWidth), pos.y)]];
        } else {
            [values addObject:[NSValue valueWithCGPoint:CGPointMake(width/2, pos.y)]];
        }
        
        [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [keyTimes addObject:[NSNumber numberWithFloat:1.0f]];
        
        animation.timingFunctions = timingFunctions;
        animation.keyTimes = keyTimes;
        //animation.calculationMode = @"cubic";
        animation.values = values;
        animation.duration = duration;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        [_root.view.layer addAnimation:animation forKey:nil];
        [CATransaction commit];
    }    
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
    
    UIView *view = self.leftViewController.view;
	CGRect frame = self.view.bounds;
	frame.size.width = kMenuFullWidth;
    view.frame = frame;
    [self.view insertSubview:view atIndex:0];
    [self.leftViewController viewWillAppear:animated];
    
    frame = _root.view.frame;
    frame.origin.x = CGRectGetMaxX(view.frame) - (kMenuFullWidth - kMenuDisplayedWidth);
    
    _root.view.userInteractionEnabled = NO;
    if (animated) {
        [UIView animateWithDuration:.3 animations:^{
            _root.view.frame = frame;
        } completion:^(BOOL finished) {
            [_tap setEnabled:YES];
            [self didSwitchToControllerType:CDPanViewControllerTypeLeft];
        }];
    }else{
        _root.view.frame = frame;
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
            _left = nil;
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
