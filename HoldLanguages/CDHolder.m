//
//  CDHolder.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/10/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDHolder.h"
#import "Header.h"

@interface CDHolder (Private)
- (void)initialize;
- (void)endOrCancelTracking;
@end

@implementation CDHolder

@synthesize tapGesture = _tapGesture, swipeLeftGesture = _swipeLeftGesture, swipeRightGesture = _swipeRightGesture, longPressGesture = _longPressGesture;
@synthesize delegate = _delegate;
@synthesize isBeingTouched = _isBeingTouched;

#pragma mark - UIView methods
- (id)initWithFrame:(CGRect)frame
{
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
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    _tapGesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:_tapGesture];
    
    _swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    _swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:_swipeLeftGesture];
    
    _swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    _swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:_swipeRightGesture];
    
    _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    _longPressGesture.minimumPressDuration = 1.0f;
    [self addGestureRecognizer:_longPressGesture];
}

#pragma mark - Handle Gesture
- (void)handleTap:(UITapGestureRecognizer *)tapGesture {
    if (tapGesture.state == UIGestureRecognizerStateEnded){
        [_delegate holderTapDouble:self];
    }
}

- (void)handleSwipe:(UISwipeGestureRecognizer*)swipeGesture {
    [_delegate holder:self swipeHorizontallyToDirection:swipeGesture.direction];
    _swipedHorizontally = YES;
}

- (void)handleLongPress:(UILongPressGestureRecognizer*)longPressGesture {
    if ([longPressGesture state] == UIGestureRecognizerStateBegan) {
        [_delegate holderLongPressed:self];
    }
}

#pragma mark - Tracking
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    _isBeingTouched = YES;
    CGPoint startLocation = [touch locationInView:self];
    _startY = startLocation.y;
    _lastY = startLocation.y;
    [_delegate holderBeginSwipingVertically:self];
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [touch locationInView:self];
    CGFloat increament = location.y - _lastY;
    _lastY = location.y;
    [_delegate holder:self swipeVerticallyFor:increament];
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [touch locationInView:self];
    CGFloat increament = location.y - _lastY;
    CGFloat distance = location.y - _startY;
    [_delegate holder:self endSwipingVerticallyFor:increament fromStart:distance];
    [self endOrCancelTracking];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    [_delegate holderCancelSwipingVertically:self];
    
    [self endOrCancelTracking];
}

- (void)endOrCancelTracking {
    _isBeingTouched = NO;
    _startY = 0.0f;
    _lastY = 0.0f;
    _swipedHorizontally = NO;
}



@end
