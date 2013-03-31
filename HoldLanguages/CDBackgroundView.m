//
//  CDBackgroundView.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/21/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDBackgroundView.h"
#import "CDPullControllerMetro.h"
#import "CDColorFinder.h"

@interface CDBackgroundView ()
@property(nonatomic, strong)UIImageView *leftPage;
@property(nonatomic, strong)UIImageView *rightPage;
@end

@implementation CDBackgroundView
@dynamic leftPage, rightPage;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        _noizeImage = [UIImage pngImageWithName:@"noise"];
        
        CGRect bounds = self.bounds;
        CGRect f = CGRectInset(bounds, 0.0f, (CGRectGetHeight(bounds) - CGRectGetWidth(bounds)) / 2);
        _spotlight = [[CDSpotlightView alloc] initWithFrame:f];
        [self addSubview:_spotlight];
        self.backgroundColor = [UIColor color255WithRed:32.0 green:36.0 blue:41.0 alpha:1.0];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGSize textureSize = _noizeImage.size;
    CGContextDrawTiledImage(context, CGRectMake(0, 0, textureSize.width, textureSize.height), _noizeImage.CGImage);
}

#pragma mark - Animation
- (void)moveWithValue:(CGFloat)distance{
    CDAnimationState target = CDAnimationStateReset;
    if (distance < 0) target = CDAnimationStateUp;
    if (distance > 0) target = CDAnimationStateDown;
    [self move:target];
}

- (void)move:(CDAnimationState)target{
    CGRect bounds = self.bounds;
    CGRect frame = CGRectInset(bounds, 0.0f, (CGRectGetHeight(bounds) - CGRectGetWidth(bounds)) / 2);
    switch (target) {
        case CDAnimationStateReset:{
            if (_animationState == CDAnimationStateReset) return;
            _animationState = CDAnimationStateReset;
        }break;
        case CDAnimationStateUp:{
            if (_animationState == CDAnimationStateUp) return;
            _animationState = CDAnimationStateUp;
            frame = CGRectOffset(frame, 0.0f, -kOffsetMax);
        }break;
        case CDAnimationStateDown:{
            if (_animationState == CDAnimationStateDown) return;
            _animationState = CDAnimationStateDown;
            frame = CGRectOffset(frame, 0.0f, kOffsetMax);
        }break;

        default:
            break;
    }
    [UIView animateWithDuration:1.5f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _spotlight.frame = frame;
                     } completion:nil];
}

#pragma mark - Page
- (UIImageView *)leftPage{
    if (!_leftPage) {
        CGRect frame = self.bounds;
        frame = CGRectMake(0.0f, 0.25 * CGRectGetHeight(frame),
                           0.23 * CGRectGetWidth(frame), 0.25 * CGRectGetHeight(frame));
        frame = CGRectInset(frame, 0.0f, kMarginSecondary);
        frame = CGRectOffset(frame, kMargin, 0.0f);
        _leftPage = [[UIImageView alloc] initWithFrame:frame];
        _leftPage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
        _leftPage.backgroundColor = [CDColorFinder colorOfPages];
    }
    if (!_leftPage.superview) {
        _leftPage.alpha = 0.0f;
        [self addSubview:_leftPage];
    }
    return _leftPage;
}

- (UIImageView *)rightPage{
    if (!_rightPage) {
        CGRect frame = self.bounds;
        frame = CGRectMake(0.77 * CGRectGetWidth(frame), 0.25 * CGRectGetHeight(frame),
                           0.23 * CGRectGetWidth(frame), 0.25 * CGRectGetHeight(frame));
        frame = CGRectInset(frame, 0.0f, kMarginSecondary);
        frame = CGRectOffset(frame, - kMargin, 0.0f);
        _rightPage = [[UIImageView alloc] initWithFrame:frame];
        _rightPage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
        _rightPage.backgroundColor = [CDColorFinder colorOfPages];

    }
    if (!_rightPage.superview) {
        _rightPage.alpha = 0.0f;
        [self addSubview:_rightPage];
    }
    return _rightPage;
}

- (void)igniteLeftPage{
    UIImageView *leftPage = self.leftPage;
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        leftPage.alpha = 1.0f;
    } completion:^(BOOL finished) {
        if (!finished) return;
        [UIView animateWithDuration:0.5f delay:0.3f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            leftPage.alpha = 0.0f;
        } completion:^(BOOL finished) {
            if (!finished) return;
            [leftPage removeFromSuperview];
            _leftPage = nil;
        }];
    }];
}

- (void)igniteRightPage{
    UIImageView *rightPage = self.rightPage;
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        rightPage.alpha = 1.0f;
    } completion:^(BOOL finished) {
        if (!finished) return;
        [UIView animateWithDuration:0.5f delay:0.3f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            rightPage.alpha = 0.0f;
        } completion:^(BOOL finished) {
            if (!finished) return;
            [rightPage removeFromSuperview];
            _rightPage = nil;
        }];
    }];
}

@end

@implementation CDSpotlightView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    size_t num_locations = 2;
    CGFloat locations[3] = {1.0, 0.1}; //Edge to center
    CGFloat colorComponents[12] = {
        255.0/255.0, 255.0/255.0, 220.0/255.0, 0.2,   //Cneter
        200.0/255.0, 200.0/255.0, 170.0/255.0, 0.0  //Edge
    };
    CGColorSpaceRef myColorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient =
    CGGradientCreateWithColorComponents (myColorspace, colorComponents, locations, num_locations);
    
    CGPoint centerPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    
    // Draw the gradient
    CGContextDrawRadialGradient(context, gradient, centerPoint, rect.size.width / 2, centerPoint, 0, (kCGGradientDrawsBeforeStartLocation));
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(myColorspace);
}

@end
