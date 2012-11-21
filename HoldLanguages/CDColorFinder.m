//
//  CDColorFinder.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/21/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDColorFinder.h"
#import "Header.h"

@implementation CDColorFinder
- (UIColor*)colorOfBarLight{
    UIColor* color = [UIColor color255WithRed:31. green:57. blue:72. alpha:kBarAlpha];
    return color;
}
- (UIColor*)colorOfBarDark{
    UIColor* color = [UIColor color255WithRed:38. green:94. blue:129. alpha:kBarAlpha];
    return color;
}
@end
