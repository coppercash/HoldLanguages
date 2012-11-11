//
//  CDHolder.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/10/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CDHolder;
@protocol CGHolderDelegate <NSObject>
- (void)holderBeginSwipingVertically:(CDHolder*)holder;
- (void)holder:(CDHolder*)holder swipeVerticallyFor:(CGFloat)distance;
- (void)holderEndSwipingVertically:(CDHolder*)holder;
- (void)holderCancelSwipingVertically:(CDHolder*)holder;
- (void)holder:(CDHolder*)holder swipeHorizontallyToDirection:(UISwipeGestureRecognizerDirection)direction;
@end

@interface CDHolder : UIControl {
    CGFloat _startY;
    BOOL _swipedHorizontally;
}

@property(nonatomic, readonly, strong)UITapGestureRecognizer* tapGesture;
@property(nonatomic, readonly, strong)UISwipeGestureRecognizer* swipeLeftGesture;
@property(nonatomic, readonly, strong)UISwipeGestureRecognizer* swipeRightGesture;

@property(nonatomic, weak)id delegate;

@end
