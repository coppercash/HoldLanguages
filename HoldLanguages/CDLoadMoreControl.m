//
//  CDLoadMoreControl.m
//  HoldLanguages
//
//  Created by William Remaerd on 3/24/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDLoadMoreControl.h"

@interface CDLoadMoreControl ()
@property(nonatomic, strong)UIActivityIndicatorView *activity;
@property(nonatomic, strong)UILabel *label;
@end

@implementation CDLoadMoreControl
@synthesize activity = _activity;
@synthesize label = _label, info = _info;
- (id)init{
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    if (self) {
        CGFloat size = 20.0f;
        CGRect bounds = self.bounds;
        CGRect aF = CGRectMake(CGRectGetMidX(bounds) - 0.5 * size,
                               CGRectGetMidY(bounds) - 0.5 * size, size, size);
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:aF];
        activity.autoresizingMask = CDViewAutoresizingCenter;
        activity.color = [UIColor lightGrayColor];
        
        self.activity = activity;
        [self addSubview:activity];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)testLoadingMore:(UIScrollView *)scrollView{
    CGFloat threshold = 70.0;
    CGFloat dFB = scrollView.contentSize.height - scrollView.contentOffset.y - CGRectGetHeight(scrollView.bounds);  //dictance from bottom
    //DLog(@"contentHeight:%f\tcontentOffset:%f\theght:%f", scrollView.contentSize.height, scrollView.contentOffset.y, CGRectGetHeight(scrollView.bounds));
    //DLog(@"%f\t%f", threshold, dFB);
    if (dFB < threshold) {
        [self beginLoadingMore];
    }
}

- (BOOL)isLoadingMore{
    return _isLoadingMore;
}

- (void)beginLoadingMore{
    if (_isLoadingMore) return;
    _isLoadingMore = YES;
    [self hideInfo];
    [self.activity startAnimating];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)endLoadingMore{
    if (!_isLoadingMore) return;
    _isLoadingMore = NO;
    [self.activity stopAnimating];
}

#pragma mark - Info
- (void)showInfo{
    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    label.font = [UIFont boldSystemFontOfSize:17.0f];
    label.textColor = [UIColor lightGrayColor];
    label.backgroundColor = [UIColor clearColor];
    label.text = _info;
    
    self.label = label;
    [self addSubview:label];
}

- (void)hideInfo{
    [_label removeFromSuperview];
    self.label = nil;
}

@end
