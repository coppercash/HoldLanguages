//
//  CDBackgroundView.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/21/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDBackgroundView.h"

@interface CDBackgroundView ()
@end

@implementation CDBackgroundView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        _noizeImage = [UIImage pngImageWithName:@"noise"];
        
        CGRect bounds = self.bounds;
        CGRect f = CGRectInset(bounds, 0.0f, (CGRectGetHeight(bounds) - CGRectGetWidth(bounds)) / 2);
        _spotlight = [[CDSpotlightView alloc] initWithFrame:f];
        //_spotlight.backgroundColor = [UIColor clearColor];
        [self addSubview:_spotlight];
        //self.backgroundColor = [UIColor color255WithRed:68.0 green:68.0 blue:68.0 alpha:1.0];
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
