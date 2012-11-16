//
//  CDPullViewController.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/15/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDPullViewController.h"
#import "Header.h"

@interface CDPullTopBar ()
- (void)initialize;
- (CGRect)pullButtonFrame;
- (void)touchPullButtonDown;
- (void)touchPullButtonUpInside;
- (void)touchPullButtonUpOutside;
@end
@implementation CDPullTopBar
@synthesize delegate = _delegate;
#pragma mark - UIView Method
- (void)initialize{
}

- (id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor * startColor = [UIColor colorWithHex:0x4a4b4a];
    UIColor * endColor = [UIColor colorWithHex:0x282928];
    NSArray* colors = [NSArray arrayWithObjects:(id)[startColor CGColor], (id)[endColor CGColor], nil];
    CGGradientRef gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(),
                                                        (__bridge CFArrayRef)colors,
                                                        NULL);
    CGContextDrawLinearGradient(context,
                                gradient,
                                CGPointMake(rect.origin.x, rect.origin.y),
                                CGPointMake(rect.origin.x, kTopBarVisualHeight),
                                0);
    CGGradientRelease(gradient);
    
    CGContextFillRect(context, self.pullButtonFrame);
    CGContextSetFillColorWithColor(context, kDebugColor.CGColor);
}

#pragma mark - Touch
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint location = [touch locationInView:self];
    if (CGRectContainsPoint(self.pullButtonFrame, location)) {
        [self touchPullButtonDown];
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint location = [touch locationInView:self];
    if (CGRectContainsPoint(self.pullButtonFrame, location)) {
        [self touchPullButtonUpInside];
    }else{
        [self touchPullButtonUpOutside];
    }
}

- (void)cancelTrackingWithEvent:(UIEvent *)event{
    
}

#pragma mark - Pull Button
- (CGRect)pullButtonFrame{
    CGRect frame = CGRectMake(self.center.x - kPullButtonEffectiveWidth / 2,
                              CGRectGetMaxY(self.bounds) - kPullButtonEffectiveHeight,
                              kPullButtonEffectiveWidth,
                              kPullButtonEffectiveHeight);
    return frame;
}

- (void)touchPullButtonDown{
    [_delegate topBarTouchedDown:self];
}

- (void)touchPullButtonUpInside{
    [_delegate topBarTouchedUpInside:self];
}

- (void)touchPullButtonUpOutside{
    
}

@end

@implementation CDPullBottomBar

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();

    UIColor * startColor = [UIColor colorWithHex:0x4a4b4a];
    UIColor * endColor = [UIColor colorWithHex:0x282928];
    NSArray* colors = [NSArray arrayWithObjects:(id)[startColor CGColor], (id)[endColor CGColor], nil];
    CGGradientRef gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(),
                                                        (__bridge CFArrayRef)colors,
                                                        NULL);
    CGContextDrawLinearGradient(context,
                                gradient,
                                CGPointMake(rect.origin.x, rect.origin.y + kBottomProgressHeight),
                                CGPointMake(rect.origin.x, rect.origin.y + kBottomProgressHeight + kBottomBarHeight),
                                0);
    CGGradientRelease(gradient);
}

@end

@interface CDPullViewController ()
- (void)initialize;
- (CGRect)topBarFrameWithHidding:(BOOL)hidding;
- (CGRect)bottomBarFrameWithHidding:(BOOL)hidding;
- (CGRect)pulledViewFrameWithPresented:(BOOL)presented;
- (void)createPulledView;
- (void)destroyPulledView;
@end
@implementation CDPullViewController
@synthesize barsHidden = _barsHidden, pulledViewPresented = _pullViewPresented;
@synthesize topBar = _topBar, bottomBar = _bottomBar;
#pragma mark - UIViewController Methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize{
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    
    _topBar = [[CDPullTopBar alloc] init];
    [self.view addSubview:_topBar];
    _topBar.frame = [self topBarFrameWithHidding:NO];
    _topBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    _topBar.delegate = self;
    
    _bottomBar = [[CDPullBottomBar alloc] init];
    [self.view addSubview:_bottomBar];
    _bottomBar.frame = [self bottomBarFrameWithHidding:NO];
    _bottomBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    _topBar.backgroundColor = kDebugColor;
    _bottomBar.backgroundColor = kDebugColor;
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)endOfViewDidLoad{
    [self.view bringSubviewToFront:_bottomBar];
    [self.view bringSubviewToFront:_topBar];
}

#pragma mark - Bars
- (void)setBarsHidden:(BOOL)barsHidden{
    [[UIApplication sharedApplication] setStatusBarHidden:barsHidden withAnimation:UIStatusBarAnimationSlide];
    _topBar.frame = [self topBarFrameWithHidding:barsHidden];
    _bottomBar.frame = [self bottomBarFrameWithHidding:barsHidden];
    _barsHidden = barsHidden;
    
}

- (void)setBarsHidden:(BOOL)barsHidden animated:(BOOL)animated{
    [self setBarsHidden:barsHidden];
}

- (CGRect)topBarFrameWithHidding:(BOOL)hidding{
    CGFloat statusHeight = 20.0f;
    CGFloat topBarHeight = kTopBarVisualHeight;
    CGFloat pullButtonHeight = kTopBarPullButtonHeight;
    CGRect frame = CGRectZero;
    if (hidding) {
        frame = CGRectMake(self.view.bounds.origin.x,
                           self.view.bounds.origin.y - topBarHeight,
                           self.view.bounds.size.width,
                           topBarHeight + pullButtonHeight);
    }else{
        frame = CGRectMake(self.view.bounds.origin.x,
                           self.view.bounds.origin.y + statusHeight,
                           self.view.bounds.size.width,
                           topBarHeight + pullButtonHeight);
    }
    return frame;
}

- (CGRect)bottomBarFrameWithHidding:(BOOL)hidding{
    CGFloat bottomBarHeight = kBottomBarHeight;
    CGFloat proccessHeight = kBottomProgressHeight;
    CGRect frame = CGRectZero;
    if (hidding) {
        frame = CGRectMake(self.view.bounds.origin.x,
                           CGRectGetMaxY(self.view.bounds) - proccessHeight,
                           self.view.bounds.size.width,
                           proccessHeight + bottomBarHeight);
    }else{
        frame = CGRectMake(self.view.bounds.origin.x,
                           CGRectGetMaxY(self.view.bounds) - proccessHeight - bottomBarHeight,
                           self.view.bounds.size.width,
                           proccessHeight + bottomBarHeight);
    }
    return frame;
}

#pragma mark - CDPullTopBarDelegate
- (void)topBarTouchedDown:(CDPullTopBar*)topBar{
 }

- (void)topBarTouchedUpInside:(CDPullTopBar*)topBar{
    if (self.barsHidden) {
        [self setBarsHidden:NO animated:YES];
    }else{
        [self createPulledView];
        [self setPullViewPresented:YES animated:YES];
    }
}

#pragma mark - Pulled View
- (CGRect)pulledViewFrameWithPresented:(BOOL)presented{
    CGRect visualBounds = self.view.bounds;
    if (![[UIApplication sharedApplication] isStatusBarHidden]) {
        CGFloat statusBarHeight = 20.0f;
        visualBounds = CGRectInset(visualBounds, 0.0f, statusBarHeight / 2);
        visualBounds = CGRectOffset(visualBounds, 0.0f, statusBarHeight / 2);
    }
    CGRect frame = CGRectZero;
    if (presented) {
        frame = visualBounds;
    }else{
        CGFloat offset = - visualBounds.size.height;
        frame = CGRectOffset(visualBounds, 0.0f, offset);
    }
    return frame;
}

- (void)createPulledView{
    //Alloc and Configure pulledView.
    CGRect pullViewFrame = [self pulledViewFrameWithPresented:NO];
    _pulledView = [[UIView alloc] initWithFrame:pullViewFrame];
    [self.view addSubview:_pulledView];
    _pulledView.autoresizingMask = kViewAutoresizingNoMarginSurround;
    
    //Send to subclass to load subviews.
    [self loadPulledView:_pulledView];
    
    //[_pulledView setBackgroundColor:kDebugColor];
}

- (void)destroyPulledView{
    [_pulledView removeFromSuperview];
    _pulledView = nil;
}

- (void)loadPulledView:(UIView*)pulledView{
    
}

- (void)setPulledViewPresented:(BOOL)pulledViewPresented{
    _pulledView.frame = [self pulledViewFrameWithPresented:pulledViewPresented];
    _pullViewPresented = pulledViewPresented;
}

- (void)setPullViewPresented:(BOOL)pullViewPresented animated:(BOOL)animated{
    [self setPulledViewPresented:pullViewPresented];
    if (!pullViewPresented) {
        [self destroyPulledView];
     }
}

@end
