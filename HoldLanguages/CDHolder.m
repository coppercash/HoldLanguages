//
//  CDHolder.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/10/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDHolder.h"

@interface CDHolder (Private)
- (void)initialize;
- (CDDirection)determineDirection:(CGPoint)location;
- (void)beginTracking:(CGPoint)location;
- (void)continueTracking:(CGPoint)location;
- (void)endTracking:(CGPoint)location;
- (void)endOrCancelTracking;
@end

@implementation CDHolder

@synthesize tapGesture = _tapGesture, swipeLeftGesture = _swipeLeftGesture, swipeRightGesture = _swipeRightGesture, longPressGesture = _longPressGesture;
@synthesize delegate = _delegate;
@synthesize isBeingTouched = _isBeingTouched;

#pragma mark - UIView methods
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.backgroundColor = [UIColor clearColor];
    self.numberOfRows = 1;
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    _tapGesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:_tapGesture];
    
    _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    _longPressGesture.minimumPressDuration = 1.0f;
    [self addGestureRecognizer:_longPressGesture];
}

#pragma mark - Handle Gesture
- (void)handleTap:(UITapGestureRecognizer *)tapGesture {
    if (tapGesture.state == UIGestureRecognizerStateEnded){
        if (_delegate && [_delegate respondsToSelector:@selector(holderTapDouble:)]) {
            [_delegate holderTapDouble:self];
        }
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer*)longPressGesture {
    if ([longPressGesture state] == UIGestureRecognizerStateBegan) {
        if (_delegate && [_delegate respondsToSelector:@selector(holderLongPressed:)]) {
            [_delegate holderLongPressed:self];
        }
    }
}

#pragma mark - Tracking
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    _isBeingTouched = YES;
    _startPoint = _lastPoint = [touch locationInView:self];

    CGFloat rowHeight = CGRectGetHeight(self.bounds) / _numberOfRows;
    for (_indexOfRow = 0; _indexOfRow < _numberOfRows; _indexOfRow++) {
        CGFloat topDistance = rowHeight * (_indexOfRow + 1);
        if (topDistance > _lastPoint.y) break;
    }

    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [touch locationInView:self];
    [self beginTracking:location];
    [self continueTracking:location];
    _lastPoint = location;
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [touch locationInView:self];
    [self continueTracking:location];
    [self endTracking:location];
    [self endOrCancelTracking];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    if (_delegate != nil) {
        if ((_swipeDirection & CDDirectionHorizontal) && [_delegate respondsToSelector:@selector(holder:cancelSwipingHorizontallyOnDirection:onRow:)]) {
            [_delegate holder:self cancelSwipingHorizontallyOnDirection:_swipeDirection onRow:_indexOfRow];
        }else if ((_swipeDirection & CDDirectionVertical) && [_delegate respondsToSelector:@selector(holder:cancelSwipingVerticallyOnDirection:)]){
            [_delegate holder:self cancelSwipingVerticallyOnDirection:_swipeDirection];
        }
    }
    [self endOrCancelTracking];
}

- (void)beginTracking:(CGPoint)location{
    if (_delegate == nil) return;
    if (_swipeDirection == CDDirectionNone) {
        _swipeDirection = [self determineDirection:location];
        if ((_swipeDirection & CDDirectionHorizontal) && [_delegate respondsToSelector:@selector(holder:beginSwipingHorizontallyOnDirection:onRow:)]) {
            [_delegate holder:self beginSwipingHorizontallyOnDirection:_swipeDirection onRow:_indexOfRow];
        }else if ((_swipeDirection & CDDirectionVertical) && [_delegate respondsToSelector:@selector(holder:beginSwipingVerticallyOnDirection:)]){
            [_delegate holder:self beginSwipingVerticallyOnDirection:_swipeDirection];
        }
    }
}

- (void)continueTracking:(CGPoint)location{
    if (_delegate == nil) return;
    if (_swipeDirection & CDDirectionHorizontal) {
        if ([_delegate respondsToSelector:@selector(holder:continueSwipingHorizontallyFromStart:onRow:)]) {
            CGFloat distance = location.x - _startPoint.x;
            [_delegate holder:self continueSwipingHorizontallyFromStart:distance onRow:_indexOfRow];
        }
    }else if (_swipeDirection & CDDirectionVertical){
        if ([_delegate respondsToSelector:@selector(holder:continueSwipingVerticallyFor:)]) {
            CGFloat increment = location.y - _lastPoint.y;
            [_delegate holder:self continueSwipingVerticallyFor:increment];
        }
    }
}

- (void)endTracking:(CGPoint)location{
    if (_delegate == nil) return;
    if (_swipeDirection & CDDirectionHorizontal) {
        CGFloat distance = location.x - _startPoint.x;
        if ([_delegate respondsToSelector:@selector(holder:endSwipingHorizontallyFromStart:onRow:)]) {
            [_delegate holder:self endSwipingHorizontallyFromStart:distance onRow:_indexOfRow];
        }
    }else if (_swipeDirection & CDDirectionVertical){
        CGFloat distance = location.y - _startPoint.y;
        if ([_delegate respondsToSelector:@selector(holder:endSwipingVerticallyFromStart:)]) {
            [_delegate holder:self endSwipingVerticallyFromStart:distance];
        }
    }
}

- (void)endOrCancelTracking{
    _isBeingTouched = NO;
    _indexOfRow = 0;
    _startPoint = _lastPoint = CGPointZero;
    _swipeDirection = CDDirectionNone;
}

- (CDDirection)determineDirection:(CGPoint)location{
    CGFloat xIncrement = location.x - _lastPoint.x;
    CGFloat yIncrement = location.y - _lastPoint.y;
    if (_swipeDirection == CDDirectionNone) {
        if (fabsf(xIncrement) > fabsf(yIncrement)) {
            if (xIncrement < 0) return CDDirectionLeft;
            else return CDDirectionRight;
        }else{
            if (yIncrement < 0) return CDDirectionUp;
            else return CDDirectionDown;
        }
    }else if (_swipeDirection & (CDDirectionUp | CDDirectionDown)) {
        if (yIncrement < 0) return CDDirectionUp;
        else return CDDirectionDown;
    }else if (_swipeDirection & (CDDirectionLeft | CDDirectionRight)) {
        if (xIncrement < 0) return CDDirectionLeft;
        else return CDDirectionRight;
    }
    return CDDirectionNone;
}

@end
