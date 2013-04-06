//
//  RepeatViewCategory.h
//  HoldLanguages
//
//  Created by William Remaerd on 3/28/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "MainViewController.h"
#import "CDRepeatView.h"
#import "CDRatesView.h"

@interface MainViewController (RepeatViewCategory) <CDRepeatViewDelegate, CDRatesViewDelegate>

- (void)prepareToRepeat:(CDDirection)direction;
- (void)countRepeatTimeWithDistance:(CGFloat)distance;
- (void)repeatWithDirection:(CDDirection)direction distance:(CGFloat)distance;

@end
