//
//  CDHolder.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/10/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CDHolderDelegate;

@interface CDHolder : UIControl {
    CGFloat _startY;
    CGFloat _lastY;
    BOOL _isBeingTouched;
    BOOL _swipedHorizontally;
}

@property(nonatomic, readonly)BOOL isBeingTouched;

@property(nonatomic, readonly, strong)UITapGestureRecognizer* tapGesture;
@property(nonatomic, readonly, strong)UISwipeGestureRecognizer* swipeLeftGesture;
@property(nonatomic, readonly, strong)UISwipeGestureRecognizer* swipeRightGesture;
@property(nonatomic, readonly, strong)UILongPressGestureRecognizer* longPressGesture;

@property(nonatomic, weak)id<CDHolderDelegate> delegate;

@end


@protocol CDHolderDelegate
@required
- (void)holderBeginSwipingVertically:(CDHolder*)holder;
- (void)holder:(CDHolder*)holder swipeVerticallyFor:(CGFloat)increament;
- (void)holder:(CDHolder*)holder endSwipingVerticallyFor:(CGFloat)increament fromStart:(CGFloat)distance;
- (void)holderCancelSwipingVertically:(CDHolder*)holder;
- (void)holder:(CDHolder*)holder swipeHorizontallyToDirection:(UISwipeGestureRecognizerDirection)direction;
- (void)holderTapDouble:(CDHolder*)holder;
- (void)holderLongPressed:(CDHolder*)holder;
@end