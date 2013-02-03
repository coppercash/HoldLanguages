//
//  CDRepeaterView.h
//  HoldLanguages
//
//  Created by William Remaerd on 1/23/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRepeatViewBackgroundColor [UIColor color255WithRed:133 green:166 blue:38 alpha:1.0f]

@class CDPlusButton, CDMinusButton;
@interface CDRepeaterView : UIView{
    CDPlusButton *_leftPlus;
    CDMinusButton *_leftMinus;
    CDPlusButton *_rightPlus;
    CDMinusButton *_rightMinus;
    UILabel *_start;
    UILabel *_end;
}
@property(nonatomic, strong)IBOutlet CDPlusButton *leftPlus;
@property(nonatomic, strong)IBOutlet CDMinusButton *leftMinus;
@property(nonatomic, strong)IBOutlet CDPlusButton *rightPlus;
@property(nonatomic, strong)IBOutlet CDMinusButton *rightMinus;
@property(nonatomic, strong)IBOutlet UILabel *start;
@property(nonatomic, strong)IBOutlet UILabel *end;
- (void)setRepeatRaneg:(CDTimeRange)repeatRange;
@end

@interface CDPlusButton : UIButton
@end
@interface CDMinusButton : UIButton
@end