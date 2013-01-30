//
//  CDRatesView.h
//  HoldLanguages
//
//  Created by William Remaerd on 1/21/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDLazyScrollView.h"
#import "CDLazyScrollView.h"
@protocol CDRatesViewDelegate;
@class CDCycleArray;
@interface CDRatesView : CDLazyScrollView <CDLazyScrollViewDataSource, CDLazyScrollViewDelegate>{
    CDCycleArray *_rates;
    id<CDRatesViewDelegate> _ratesDelegate;
}
- (id)initWithFrame:(CGRect)frame rates:(CDCycleArray*)rates delegate:(id<CDRatesViewDelegate>)delegate;
@end

@protocol CDRatesViewDelegate <NSObject>
- (void)ratesView:(CDRatesView*)rateView didChangeRateTo:(float)rate;
- (void)ratesViewDidHide:(CDRatesView*)rateView;
@end
