//
//  CDRatesView.m
//  HoldLanguages
//
//  Created by William Remaerd on 1/21/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDRatesView.h"
#import "CDCycleArray.h"
#import "CDBigLabelView.h"

@implementation CDRatesView

- (id)initWithFrame:(CGRect)frame rates:(CDCycleArray *)rates delegate:(id<CDRatesViewDelegate>)delegate{
    self = [super initWithFrame:frame];
    if (self) {
        _rates = rates;
        _ratesDelegate = delegate;
        
        self.lazyDelegate = self, self.dataSource = self;
        self.animatedHiding = YES, self.animatedShowing = YES;
        self.widthProportion = 0.9;
    }
    return self;
}

#pragma mark - CDLazyScrollViewDataSource & CDLazyScrollViewDelegate
- (UIView*)subViewAtPosition:(CDLazyScrollViewPosition)position inLazyScrollView:(CDLazyScrollView*)lazyScrollView{
    NSString *rate = nil;
    switch (position) {
        case CDLazyScrollViewPositionLeft:{
            rate = [_rates.previousObject stringValue];
        }break;
        case CDLazyScrollViewPositionMiddle:{
            rate = [_rates.currentObject stringValue];
        }break;
        case CDLazyScrollViewPositionRight:{
            rate = [_rates.nextObject stringValue];
        }break;
        default:
            break;
    }
    if ([rate isEqualToString:@"0.75"]) rate = @"3/4";
    rate = [rate stringByAppendingString:@" X"];
    
    UIView *view = [[CDBigLabelView alloc] initWithText:rate];
    [view setBackgroundColor:kDebugColor];
    return view;
}

- (void)lazyScrollViewDidFinishScroll:(CDLazyScrollView*)lazyScrollView onDirection:(CDDirection)direction{
    void (^fireDelegate)(void) = ^{
        if (_ratesDelegate && [_ratesDelegate respondsToSelector:@selector(ratesView:didChangeRateTo:)]) {
            float rate = [_rates.currentObject floatValue];
            [_ratesDelegate ratesView:self didChangeRateTo:rate];
        }
    };
    
    switch (direction) {
        case CDDirectionLeft:{
            [_rates moveNext];
            fireDelegate();
        }break;
        case CDDirectionRight:{
            [_rates movePrevious];
            fireDelegate();
        }break;
        default:
            break;
    }
}

- (void)lazyScrollViewDidHide:(CDLazyScrollView*)lazyScrollView{
    if (_ratesDelegate && [_ratesDelegate respondsToSelector:@selector(ratesViewDidHide:)]) {
        [_ratesDelegate ratesViewDidHide:self];
    }
}

@end
