//
//  CDSliderThumb.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/16/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDSliderThumb.h"
#import "Header.h"
@interface CDSliderThumb ()
- (void)initialize;
- (void)updateThumbLocationWithValue:(float)value;
- (void)endOrCancelTracking;
@end
@implementation CDSliderThumb

#pragma mark - UIControl Methods
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize{
    _thumbImageView = [[UIImageView alloc] initWithPathForResource:kThumbImageName ofType:@"png"];
    [self addSubview:_thumbImageView];
    _thumbImageView.frame = CGRectMake(0.0f, 0.0f, kThumbWidth, kThumbHeight);
    
    self.backgroundColor = kDebugColor;
}

#pragma mark - Value Change
- (void)setValue:(float)value{
    if (value < 0) value = 0;
    if (value > 1) value = 1;
    [self updateThumbLocationWithValue:value];
    _value = value;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)updateThumbLocationWithValue:(float)value{
    CGFloat destination = (self.bounds.size.width - kThumbWidth) * value + kThumbWidth / 2;
    CGPoint destinationPoint = CGPointMake(destination, _thumbImageView.center.y);
    _thumbImageView.center = destinationPoint;
}

#pragma mark - Touch events handling
- (BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchPoint = [touch locationInView:self];
    if(CGRectContainsPoint(_thumbImageView.frame, touchPoint)){
        _thumbOn = YES;
    }else {
        _thumbOn = NO;
    }
    return _thumbOn;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchPoint = [touch locationInView:self];
    float newValue = (touchPoint.x - kThumbWidth / 2) / (self.bounds.size.width - kThumbWidth);
    self.value = newValue;
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchPoint = [touch locationInView:self];
    float newValue = (touchPoint.x - kThumbWidth / 2) / (self.bounds.size.width - kThumbWidth);
    self.value = newValue;
    [self endOrCancelTracking];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event{
    [self endOrCancelTracking];
}

- (void)endOrCancelTracking {
    _thumbOn = NO;
}


@end
