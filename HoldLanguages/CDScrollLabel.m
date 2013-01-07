//
//  CDScrollLabel.m
//  CDScrollLabel
//
//  Created by William Remaerd on 1/5/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDScrollLabel.h"
#import "CDMemAssist.h"
#import "Header.h"

#define kMarginBetweenLabels 30.0f
#define kIntervalBetweenAnimations 3.0f
#define kScrollSpeed 40.0f
#define kFadeLength 10.0f


@interface CDScrollLabel (Private)
- (void)start;
- (void)scrollAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
- (void)timerFire:(NSTimer*)theTimer;
- (void)cancelAnimation;

- (CGFloat)textWidth;
- (CGFloat)scrollOffset;
- (CGRect)labelFrameStart:(BOOL)start;
- (CGRect)assistLabelFrameStart:(BOOL)start;
- (BOOL)determineMode;

- (void)setupGradientMask;
@end

@implementation CDScrollLabel

#pragma Life Cycle
- (void)initialize{
    self.clipsToBounds = YES;
    
    _label = [[UILabel alloc] init];
    [self addSubview:_label];
    _label.textAlignment = UITextAlignmentCenter;
    _label.backgroundColor = [UIColor clearColor];
    _label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (id)initWithFrame:(CGRect)frame text:(NSString *)text{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
        self.text = text;
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

- (void)dealloc{
    [_timer invalidate];
    SafeMemberRelease(_timer);
    [_label removeFromSuperview];
    SafeMemberRelease(_label);
    [_assistLabel removeFromSuperview];
    SafeMemberRelease(_assistLabel);
    SafeSuperDealloc();
}

#pragma mark - Getter & Setter
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setupGradientMask];
    [self determineMode];
}

- (void)setText:(NSString *)text{
    _label.text = text;
    if ([self determineMode]) {
        _assistLabel.text = text;
    }
}

- (void)setTextAlignment:(UITextAlignment)textAlignment{
    _label.textAlignment = textAlignment;
    _assistLabel.textAlignment = textAlignment;
}

- (void)setFont:(UIFont *)font{
    _label.font = font;
    _assistLabel.font = font;
}

- (void)setTextColor:(UIColor *)textColor{
    _label.textColor = textColor;
    _assistLabel.textColor = textColor;
}

#pragma mark - Animations
#define kKeyOfAnimation @"AnimationScroll"
- (void)start{
    if (!_canAnimate || _isAnimating || _timer != nil) return;
    _isAnimating = YES;

    _label.frame = [self labelFrameStart:YES];
    _assistLabel.frame = [self assistLabelFrameStart:YES];
    
    NSTimeInterval duration = self.scrollOffset / kScrollSpeed;
    [UIView beginAnimations:kKeyOfAnimation context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:duration];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(scrollAnimationDidStop:finished:context:)];
    
    _label.frame = [self labelFrameStart:NO];
    _assistLabel.frame = [self assistLabelFrameStart:NO];
    
	[UIView commitAnimations];
}

- (void)scrollAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    _isAnimating = NO;
    if ([animationID isEqualToString:kKeyOfAnimation] && [finished boolValue]) {
        if (_delegate && [_delegate respondsToSelector:@selector(scrollLabelShouldContinueAnimating:)]) {
            NSTimeInterval interval = [_delegate scrollLabelShouldContinueAnimating:self];
            if (interval > 0) {
                [self animateAfterDelay:interval];
            }
        }
    }
}

- (void)animateAfterDelay:(NSTimeInterval)timeInterval{
    if (!_canAnimate || _isAnimating || _timer != nil) return;
    _timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:timeInterval] interval:0.0f target:self selector:@selector(timerFire:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

- (void)timerFire:(NSTimer*)theTimer{
    [_timer invalidate];
    SafeMemberRelease(_timer);
    [self start];
}

- (void)cancelAnimation{
    _isAnimating = NO;
    [_timer invalidate];
    SafeMemberRelease(_timer);
    [_label.layer removeAllAnimations];
    [_assistLabel.layer removeAllAnimations];
}

#pragma mark - Frames
- (CGFloat)textWidth{
    CGSize textSize = [_label.text sizeWithFont:_label.font constrainedToSize:CGSizeMake(CGFLOAT_MAX, self.frame.size.height) lineBreakMode:UILineBreakModeWordWrap];
    return textSize.width;
}

- (CGFloat)scrollOffset{
    CGFloat offset = _label.frame.size.width + kMarginBetweenLabels + 2 * kFadeLength;
    return offset;
}

- (CGRect)labelFrameStart:(BOOL)start{
    CGRect frame = CGRectMake(kFadeLength,
                              0.0f,
                              self.textWidth,
                              self.bounds.size.height);;
    if (!start) {
        frame = CGRectOffset(frame, -self.scrollOffset, 0.0f);
    }
    
    return frame;
}

- (CGRect)assistLabelFrameStart:(BOOL)start{
    CGRect frame = CGRectMake(3 * kFadeLength + self.textWidth + kMarginBetweenLabels,
                              0.0f,
                              self.textWidth,
                              self.bounds.size.height);;
    if (!start) {
        frame = CGRectOffset(frame, -self.scrollOffset, 0.0f);
    }
    
    return frame;
}

- (BOOL)determineMode{
    [self cancelAnimation];
    
    if ((_canAnimate = self.textWidth > self.bounds.size.width)) {
        _label.frame = [self labelFrameStart:YES];
        
        if (_assistLabel == nil) _assistLabel = [_label copy];
        _assistLabel.frame = [self assistLabelFrameStart:YES];
        [self addSubview:_assistLabel];
        
        if (_delegate && [_delegate respondsToSelector:@selector(scrollLabelShouldStartAnimating:)]) {
            NSTimeInterval interval = [_delegate scrollLabelShouldStartAnimating:self];
            if (interval > 0) {
                [self animateAfterDelay:interval];
            }
        }
        return YES;
    }else{
        _label.frame = self.bounds;
        
        [_assistLabel removeFromSuperview];
        SafeMemberRelease(_assistLabel);
        
        return NO;
    }
}

#pragma mark - Gradient Mask
- (void)setupGradientMask{
    if (kFadeLength * 2 < self.frame.size.width) {
        CAGradientLayer *gradientMask = [[CAGradientLayer alloc] init];
        
        gradientMask.bounds = self.layer.bounds;
        gradientMask.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        
        gradientMask.shouldRasterize = YES;
        gradientMask.rasterizationScale = [UIScreen mainScreen].scale;
        
        NSObject *transparent = (NSObject *)[[UIColor clearColor] CGColor];
        NSObject *opaque = (NSObject *)[[UIColor blackColor] CGColor];
        
        gradientMask.startPoint = CGPointMake(0.0, CGRectGetMidY(self.frame));
        gradientMask.endPoint = CGPointMake(1.0, CGRectGetMidY(self.frame));
        CGFloat fadePoint = kFadeLength / self.frame.size.width;
        [gradientMask setColors: [NSArray arrayWithObjects: transparent, opaque, opaque, transparent, nil]];
        [gradientMask setLocations: [NSArray arrayWithObjects:
                                     [NSNumber numberWithDouble: 0.0],
                                     [NSNumber numberWithDouble: fadePoint],
                                     [NSNumber numberWithDouble: 1 - fadePoint],
                                     [NSNumber numberWithDouble: 1.0],
                                     nil]];
        self.layer.mask = gradientMask;
        SafeRelease(gradientMask);
    }
}

@end

@implementation UILabel (Copy)
- (UILabel *)copy{
    UILabel *label = [[UILabel alloc] initWithFrame:self.frame];
    label.text = self.text;
    label.textColor = self.textColor;
    label.font = self.font;
    label.textAlignment = self.textAlignment;
    label.numberOfLines = self.numberOfLines;
    label.baselineAdjustment = self.baselineAdjustment;
    label.lineBreakMode = self.lineBreakMode;
    label.adjustsFontSizeToFitWidth = self.adjustsFontSizeToFitWidth;
    label.backgroundColor = self.backgroundColor;
    label.autoresizingMask = self.autoresizingMask;
    return label;
}
@end
