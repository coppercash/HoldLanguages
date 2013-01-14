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
    BOOL _isBeingTouched;
    
    CGPoint _startPoint;
    CGPoint _lastPoint;
    NSUInteger _indexOfRow;
    UISwipeGestureRecognizerDirection _swipeDirection;
}

@property(nonatomic, readonly)BOOL isBeingTouched;
@property(nonatomic, assign)NSUInteger numberOfRows;

@property(nonatomic, readonly, strong)UITapGestureRecognizer* tapGesture;
@property(nonatomic, readonly, strong)UISwipeGestureRecognizer* swipeLeftGesture;
@property(nonatomic, readonly, strong)UISwipeGestureRecognizer* swipeRightGesture;
@property(nonatomic, readonly, strong)UILongPressGestureRecognizer* longPressGesture;

@property(nonatomic, weak)id<CDHolderDelegate> delegate;

@end


@protocol CDHolderDelegate <NSObject>
@optional
- (void)holder:(CDHolder *)holder beginSwipingOnDirection:(UISwipeGestureRecognizerDirection)direction;
- (void)holder:(CDHolder *)holder continueSwipingVerticallyFor:(CGFloat)increment;
- (void)holder:(CDHolder *)holder endSwipingVerticallyFromStart:(CGFloat)distance;
- (void)holder:(CDHolder *)holder continueSwipingHorizontallyFromStart:(CGFloat)distance onRow:(NSUInteger)index;
- (void)holder:(CDHolder *)holder endSwipingHorizontallyFromStart:(CGFloat)distance onRow:(NSUInteger)index;
- (void)holder:(CDHolder *)holder cancelSwipingOnDirection:(UISwipeGestureRecognizerDirection)direction;

- (void)holderTapDouble:(CDHolder*)holder;
- (void)holderLongPressed:(CDHolder*)holder;
@end