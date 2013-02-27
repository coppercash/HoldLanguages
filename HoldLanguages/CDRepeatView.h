//
//  CDRepeatView.h
//  HoldLanguages
//
//  Created by William Remaerd on 1/21/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDLazyScrollView.h"

typedef enum {
    CDRepeatAlterTypeStartPlus = 1,
    CDRepeatAlterTypeStartMinus,
    CDRepeatAlterTypeEndPlus,
    CDRepeatAlterTypeEndMinus
}CDRepeatAlterType;

@protocol CDRepeatViewDelegate;
@class CDCounterView, CDRepeaterView;
@interface CDRepeatView : CDLazyScrollView <CDLazyScrollViewDataSource, CDLazyScrollViewDelegate>{
    __weak id<CDRepeatViewDelegate> _repeatDelegate;
    CDDirection _repeatDirection;   //Left indicates repeat forward.
    BOOL _isPresented;
    
    CDCounterView *_counter;
    CDRepeaterView *_repeater;
}
@property(nonatomic, readonly)BOOL isPresented;
@property(nonatomic, assign)CDDirection repeatDirection;
@property(nonatomic, readonly)CDCounterView *counter;
@property(nonatomic, readonly)CDRepeaterView *repeater;
- (id)initWithFrame:(CGRect)frame delegate:(id<CDRepeatViewDelegate>)delegate;
- (void)present;
- (void)dismiss;
- (void)cancel;

- (void)setValueOfCounterView:(NSTimeInterval)value;

- (CDDirection)repeatDirection;
- (IBAction)buttonClicked:(id)sender;
@end

@protocol CDRepeatViewDelegate <NSObject>
@optional
- (void)repeatViewDidPresent:(CDRepeatView*)repeatView;
- (void)repeatViewDidDismiss:(CDRepeatView*)repeatView;
- (void)repeatView:(CDRepeatView*)repeatView alterRepeatRange:(CDRepeatAlterType)type;
@end