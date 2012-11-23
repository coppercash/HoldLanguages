//
//  CDPullViewController.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/15/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDPullViewController.h"
#import "Header.h"

@interface CDPullViewController ()
- (void)initialize;
- (CGRect)topBarFrameWithHidding:(BOOL)hidding;
- (CGRect)bottomBarFrameWithHidding:(BOOL)hidding;
- (CGRect)pulledViewFrameWithPresented:(BOOL)presented;
- (void)createPulledView;
- (void)destroyPulledView;
- (NSString*)keyOfTopBarAnimation;
- (NSString*)keyOfBottomBarAnimation;
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag;
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
    
    _topBar = [[CDPullTopBar alloc] initWithFrame:[self topBarFrameWithHidding:NO]];
    [self.view addSubview:_topBar];
    _topBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    _topBar.delegate = self;
    _topBar.dataSource = self;
    
    _bottomBar = [[CDPullBottomBar alloc] initWithFrame:[self bottomBarFrameWithHidding:NO]];
    [self.view addSubview:_bottomBar];
    _bottomBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _bottomBar.delegate = self;
    
    //_topBar.backgroundColor = kDebugColor;
    //_bottomBar.backgroundColor = kDebugColor;
    
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
    _barsHidden = barsHidden;
    _topBar.frame = [self topBarFrameWithHidding:barsHidden];
    _bottomBar.frame = [self bottomBarFrameWithHidding:barsHidden];
    [_bottomBar setHidden:barsHidden];
    //[_topBar reloadData];
    //[_bottomBar reloadData];
}

- (void)setBarsHidden:(BOOL)barsHidden animated:(BOOL)animated{
    if (animated) {
        [[UIApplication sharedApplication] setStatusBarHidden:barsHidden withAnimation:UIStatusBarAnimationSlide];
        _barsHidden = barsHidden;
        CABasicAnimation* topBarAnimation = [self animationOfBar:_topBar withHidden:barsHidden];
        [_topBar.layer addAnimation:topBarAnimation forKey:self.keyOfTopBarAnimation];
        CABasicAnimation* bottomBarAnimation = [self animationOfBar:_bottomBar withHidden:barsHidden];
        [_bottomBar.layer addAnimation:bottomBarAnimation forKey:self.keyOfBottomBarAnimation];
        [_bottomBar setHidden:_barsHidden animated:YES];

    }else{
        [[UIApplication sharedApplication] setStatusBarHidden:barsHidden];
        [self setBarsHidden:barsHidden];
    }
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

- (BOOL)topBarShouldLockRotation:(CDPullTopBar *)topBar{
    return YES;
}

#pragma mark - CDPullTopBarDataSource
- (NSString*)topBarNeedsArtist:(CDPullTopBar*)topBar{
    return @"CDPullViewController";
}

- (NSString*)topBarNeedsTitle:(CDPullTopBar*)topBar{
    return @"CDPullViewController";
}

- (NSString*)topBarNeedsAlbumTitle:(CDPullTopBar*)topBar{
    return @"CDPullViewController";
}

#pragma mark - CDPullBottomBarDelegate
- (NSTimeInterval)bottomBarAskForDuration:(CDPullBottomBar*)bottomButton{
    return 0.;
}

- (NSTimeInterval)bottomBarAskForPlaybackTime:(CDPullBottomBar*)bottomButton{
    return 0.;
}

- (void)bottomBar:(CDPullBottomBar *)bottomButton sliderValueChangedAs:(float)sliderValue{
}

- (void)bottomBar:(CDPullBottomBar*)bottomButton buttonFire:(CDBottomBarButtonType)buttonType{
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

#pragma mark - Animation
- (CABasicAnimation*)animationOfBar:(id)target withHidden:(BOOL)barsHidden{
    CABasicAnimation* barAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    CGFloat from, to;
    if (target == _topBar) {
        from = CGRectGetMidY([self topBarFrameWithHidding:!barsHidden]);
        to = CGRectGetMidY([self topBarFrameWithHidding:barsHidden]);
    }else if (target == _bottomBar) {
        from = CGRectGetMidY([self bottomBarFrameWithHidding:!barsHidden]);
        to = CGRectGetMidY([self bottomBarFrameWithHidding:barsHidden]);
    }
    //NSNumber* fromValue = [[NSNumber alloc] initWithFloat:from];
    //barAnimation.fromValue = fromValue;
    NSNumber* toValue = [[NSNumber alloc] initWithFloat:to];
    barAnimation.toValue = toValue;
    barAnimation.duration = kHiddingAniamtionDuration;
    barAnimation.removedOnCompletion = NO;
    barAnimation.delegate = self;
    barAnimation.fillMode = kCAFillModeForwards;
    //barAnimation.repeatCount = 1;
    //barAnimation.autoreverses = NO;
    return barAnimation;
}

- (NSString*)keyOfTopBarAnimation{
    return @"topAnimationKey";
}

- (NSString*)keyOfBottomBarAnimation{
    return @"bottomAnimationKey";
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
    CAAnimation * topBarAnimation = [_topBar.layer animationForKey:self.keyOfTopBarAnimation];
    CAAnimation * bottomBarAnimation = [_bottomBar.layer animationForKey:self.keyOfBottomBarAnimation];
    if (theAnimation == topBarAnimation) {
        //DLogRect(_topBar.layer.frame);
        _topBar.frame = [self topBarFrameWithHidding:_barsHidden];
        [_topBar.layer removeAnimationForKey:self.keyOfTopBarAnimation];
    }else if (theAnimation == bottomBarAnimation){
        //DLogRect(_bottomBar.layer.frame);
        _bottomBar.frame = [self bottomBarFrameWithHidding:_barsHidden];
        [_bottomBar.layer removeAnimationForKey:self.keyOfBottomBarAnimation];
        //[_bottomBar setHidden:_barsHidden animated:YES];
    }
}


@end
