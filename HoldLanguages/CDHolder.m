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

@synthesize tapGesture = _tapGesture, swipeLeftGesture = _swipeLeftGesture, swipeRightGesture = _swipeRightGesture;
@synthesize delegate = _delegate;

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
}

#pragma mark - Handle Gesture
- (void)handleTap:(UITapGestureRecognizer *)tapGesture {
    if (tapGesture.state == UIGestureRecognizerStateEnded){
        [_delegate holderTapDouble:self];
    }
}

- (void)handleSwipe:(UISwipeGestureRecognizer*)swipeGesture {
    /*
     switch (swipeGesture.direction) {
     case UISwipeGestureRecognizerDirectionLeft:{
     NSLog(@"Left");
     }break;
     case UISwipeGestureRecognizerDirectionRight:{
     NSLog(@"Right");
     }break;
     default:
     break;
     }
     */
    [_delegate holder:self swipeHorizontallyToDirection:swipeGesture.direction];
    _swipedHorizontally = YES;
}

#pragma mark - Tracking
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint startLocation = [touch locationInView:self];
    _startY = startLocation.y;
    [_delegate holderBeginSwipingVertically:self];
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [touch locationInView:self];
    CGFloat increament = location.y - _startY;
    [_delegate holder:self swipeVerticallyFor:increament];
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [touch locationInView:self];
    CGFloat increament = location.y - _startY;
    [_delegate holder:self endSwipingVerticallyAt:increament];
    
    [self endOrCancelTracking];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    [_delegate holderCancelSwipingVertically:self];
    
    [self endOrCancelTracking];
}

- (void)endOrCancelTracking {
    _startY = 0.0f;
    _swipedHorizontally = NO;
}



@end
