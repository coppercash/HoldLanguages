//
//  CDPullBottomBar.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/16/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDPullBottomBar.h"
#import "Header.h"
#import "CDSliderProgressView.h"
#import "CDSliderThumb.h"

@interface CDPullBottomBar ()
- (void)initialize;
- (CGRect)progressViewFrame;
- (CGRect)sliderThumbFrame;
- (void)sliderThumbChangedValue:(id)sender;
@end
@implementation CDPullBottomBar
@synthesize sliderThumb = _sliderThumb, progressView = _progressView;
@synthesize delegate = _delegate;
#pragma mark - SuperClass Methods
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize{
    _progressView = [[CDSliderProgressView alloc] initWithFrame:self.progressViewFrame];
    [self addSubview:_progressView];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;

    _sliderThumb = [[CDSliderThumb alloc] initWithFrame:self.sliderThumbFrame];
    [self addSubview:_sliderThumb];
    _sliderThumb.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [_sliderThumb addTarget:self action:@selector(sliderThumbChangedValue:) forControlEvents:UIControlEventValueChanged];

     _progressView.backgroundColor = kDebugColor;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor* startColor = [UIColor colorWithHex:0x4a4b4a];
    UIColor* endColor = [UIColor colorWithHex:0x282928];
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

#pragma mark - Slider
- (CGRect)progressViewFrame{
    BOOL hidden = [_delegate bottomBarAskForHiddenState:self];
    CGRect frame = CGRectZero;
    if (hidden) {
        
    }else{
        frame = CGRectInset(self.sliderThumbFrame,
                            abs(kThumbWidth - BJRANGESLIDER_THUMB_SIZE) / 2,
                            0.0f);
        frame = CGRectMake(frame.origin.x, kSliderProgressViewOffsetY, frame.size.width, kSliderProgressViewHeight);
    }
    return frame;
}

- (CGRect)sliderThumbFrame{
    CGFloat offsetYFromProgressView = 5.0f;
    CGRect frame = CGRectMake(kSliderMargin,
                                kSliderProgressViewOffsetY + offsetYFromProgressView,
                                self.bounds.size.width - 2 * kSliderMargin,
                                kThumbHeight);
    return frame;
}

- (void)sliderThumbChangedValue:(id)sender {
    float value = [(CDSliderThumb*)sender value];
    [_progressView setProgress:value];
    [_delegate bottomBar:self sliderValueChangedAs:value];
}

- (void)setSliderValue:(float)sliderValue{
    _sliderThumb.value = sliderValue;
}

@end
