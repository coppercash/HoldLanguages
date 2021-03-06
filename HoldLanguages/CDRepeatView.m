//
//  CDRepeatView.m
//  HoldLanguages
//
//  Created by William Remaerd on 1/21/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDRepeatView.h"
#import "CDCounterView.h"
#import "CDRepeaterView.h"
#import "CDColorFinder.h"

@interface CDRepeatView ()
@end

@implementation CDRepeatView
@synthesize isPresented = _isPresented, repeatDirection = _repeatDirection;
@synthesize counter = _counter, repeater = _repeater;
- (id)initWithFrame:(CGRect)frame delegate:(id<CDRepeatViewDelegate>)delegate{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentSize = frame.size;
        _repeatDelegate = delegate;
        self.lazyDelegate = self;
        self.dataSource = self;
        _repeatDirection = CDDirectionNone;
        self.animatedShowing = YES;
        
        _counter = [[CDCounterView alloc] initWithFrame:self.bounds];
        _counter.backgroundColor = [CDColorFinder colorOfRepeat];
        
        _repeater = (CDRepeaterView*)[UIView viewFromXibNamed:NSStringFromClass([CDRepeaterView class]) owner:self];
        
        _middleView = [self addSubviewAtPosition:CDLazyScrollViewPositionMiddle];
        _middleView.frame = self.bounds;
    }
    return self;
}
- (void)setRepeatDirection:(CDDirection)repeatDirection{
    if (repeatDirection == _repeatDirection) return;
    _repeatDirection = repeatDirection;
    [_counter setDirection:repeatDirection];
}

#pragma mark - Present & Dismiss
- (void)present{
    if (self.isPresented) return;
    [self scrollToDirection:_repeatDirection];
    _isPresented = YES;
}

- (void)dismiss{
    if (!self.isPresented) return;
    CDDirection target = CDDirectionNone;
    switch (_repeatDirection) {
        case CDDirectionLeft:
            target = CDDirectionRight;
            break;
        case CDDirectionRight:
            target = CDDirectionLeft;
            break;
        default:
            break;
    }
    [self scrollToDirection:target];
    _isPresented = NO;
}

- (void)cancel{
    [super cancel];
    _repeatDirection = CDDirectionNone;
}

#pragma mark - Count
- (void)setValueOfCounterView:(NSTimeInterval)value{
    CDDirection currentDirection = CDDirectionNone;
    if (value < 0) currentDirection = CDDirectionLeft;
    if (value > 0) currentDirection = CDDirectionRight;
    if (_repeatDirection == currentDirection) {
        [_counter setTimeInterval:fabs(value)];
        if (self.alpha == 0.0f) [self show];
    }else{
        [_counter setTimeInterval:0.0f];
        if (self.alpha == 1.0f) [self hide];
    }
}

#pragma mark - Repeat
- (CDDirection)repeatDirection{
    return _repeatDirection;
}

- (IBAction)buttonClicked:(id)sender{
    if (_repeatDelegate == nil || ![_repeatDelegate respondsToSelector:@selector(repeatView:alterRepeatRange:)]) return;
    CDRepeatAlterType type = 0;
    if (sender == _repeater.leftPlus) {
        type = CDRepeatAlterTypeStartPlus;
    }else if (sender == _repeater.leftMinus) {
        type = CDRepeatAlterTypeStartMinus;
    }else if (sender == _repeater.rightPlus) {
        type = CDRepeatAlterTypeEndPlus;
    }else if (sender == _repeater.rightMinus) {
        type = CDRepeatAlterTypeEndMinus;
    }
    [_repeatDelegate repeatView:self alterRepeatRange:type];
}

#pragma mark - CDLazyScrollViewDataSource, CDLazyScrollViewDelegate
- (UIView*)subViewAtPosition:(CDLazyScrollViewPosition)position inLazyScrollView:(CDLazyScrollView*)lazyScrollView{
    UIView *view = nil;
    if (self.isPresented) {
        //Did present
        switch (position) {
            case CDLazyScrollViewPositionMiddle:{
                view = _repeater;
            }break;
            default:
                break;
        }
    }else{
        //Not present yet.
        switch (position) {
            case CDLazyScrollViewPositionMiddle:{
                view = _counter;
            }break;
            case CDLazyScrollViewPositionLeft:{
                view = _repeater;
            }break;
            case CDLazyScrollViewPositionRight:{
                view = _repeater;
            }break;
            default:
                break;
        }
    }
    return view;
}

- (void)lazyScrollViewDidFinishScroll:(CDLazyScrollView*)lazyScrollView onDirection:(CDDirection)direction{
    if (self.isPresented) {
        [_counter removeFromSuperview];
        SafeMemberRelease(_counter);
        
        UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        switch (direction) {
            case CDDirectionLeft:{
                recognizer.direction = UISwipeGestureRecognizerDirectionRight;
            }break;
            case CDDirectionRight:{
                recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
            }break;
            default:
                break;
        }
        [_repeater addGestureRecognizer:recognizer];
        self.userInteractionEnabled = YES;

        if (_repeatDelegate && [_repeatDelegate respondsToSelector:@selector(repeatViewDidPresent:)]) {
            [_repeatDelegate repeatViewDidPresent:self];
        }
    }
}

- (void)lazyScrollViewDidHide:(CDLazyScrollView*)lazyScrollView{
    if (!self.isPresented) {
        if (_repeatDelegate && [_repeatDelegate respondsToSelector:@selector(repeatViewDidDismiss:)]) {
            [_repeatDelegate repeatViewDidDismiss:self];
        }
    }
}

@end
