//
//  CDPullTopBar.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/16/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDPullTopBar.h"
#import "Header.h"

@interface CDPullTopBar ()
- (void)initialize;
- (CGRect)pullButtonFrame;
- (void)touchPullButtonDown;
- (void)touchPullButtonUpInside;
- (void)touchPullButtonUpOutside;
@end
@implementation CDPullTopBar
@synthesize pullButton = _pullButton;
@synthesize delegate = _delegate;
#pragma mark - UIView Method
- (void)initialize{
    self.backgroundColor = [UIColor clearColor];
    _pullButton = [[UIImageView alloc] initWithPNGImageNamed:kPullButtonImageName];
    _pullButton.frame = self.pullButtonFrame;
    [self addSubview:_pullButton];
    _pullButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
}

- (id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CDColorFinder* colorFinder = [[CDColorFinder alloc] init];
    UIColor * startColor = colorFinder.colorOfBarDark;
    UIColor * endColor = colorFinder.colorOfBarLight;
    //UIColor * startColor = [UIColor colorWithHex:0x4a4b4a];
    //UIColor * endColor = [UIColor colorWithHex:0x282928];
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
    
    //NSString* pullButtonPath = [[NSBundle mainBundle] pathForResource:@"PullButton" ofType:@"png"];
    //UIImage* pullButton = [[UIImage alloc] initWithContentsOfFile:pullButtonPath];
    //[pullButton drawInRect:self.pullButtonFrame];
    //CGContextFillRect(context, self.pullButtonFrame);
    //CGContextSetFillColorWithColor(context, kDebugColor.CGColor);
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

