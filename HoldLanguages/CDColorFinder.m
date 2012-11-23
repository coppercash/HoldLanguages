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

- (UIColor*)colorOfRotatingCircle{
    UIColor* color = [UIColor color255WithRed:77. green:144. blue:153. alpha:kBarAlpha];
    return color;
}

- (UIColor*)colorOfProgressViewBackground{
    UIColor* color = [UIColor colorWithRed:0.0980f green:0.1137f blue:0.1294f alpha:1.0f];
    return color;
}

- (UIColor*)colorOfProgressViewBackgroundGlow{
    UIColor* color = [UIColor colorWithRed:0.0666f green:0.0784f blue:0.0901f alpha:1.0f];
    return color;
}

- (void)gradientComponentsProgressView:(CGFloat*)progressComponents{
    UIColor* startColor = [UIColor color255WithRed:111. green:170. blue:184. alpha:1.0f];
    UIColor* endColor = [UIColor color255WithRed:242. green:220. blue:119. alpha:1.0f];
    //UIColor* startColor = [UIColor color255WithRed:77. green:144. blue:153. alpha:1.0f];
    //UIColor* endColor = [UIColor color255WithRed:111. green:170. blue:184. alpha:1.0f];
    [startColor getRed:progressComponents green:progressComponents + 1 blue:progressComponents + 2 alpha:progressComponents + 3];
    [endColor getRed:progressComponents + 4 green:progressComponents + 5 blue:progressComponents + 6 alpha:progressComponents + 7];
}

@end
