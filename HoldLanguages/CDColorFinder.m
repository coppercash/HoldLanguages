//
//  CDColorFinder.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/21/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDColorFinder.h"

@implementation CDColorFinder

+ (UIColor *)colorOfDownloads{
    return [UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0];
}

+ (UIColor *)colorOfFileSharing{
    return [UIColor purpleColor];
}

+ (UIColor *)colorOfAudio{
    return [UIColor redColor];
}

+ (UIColor *)colorOfLyrics{
    return [UIColor yellowColor];
}

+ (UIColor *)colorOfRates{
    return [UIColor color255WithRed:240.0f green:130.0f blue:51.0f alpha:1.0f];
}

+ (UIColor *)colorOfPages{
    return kDebugColor;
}

+ (UIColor *)colorOfRepeat{
    return [UIColor color255WithRed:133 green:166 blue:38 alpha:1.0f];
}

+ (UIColor *)colorOfBars{
    return [UIColor color255WithRed:0.0f green:115.0f blue:180.0f alpha:1.0f];
}

@end

@implementation UIView (Shadow)

- (void)shadowed{
    CALayer *layer = self.layer;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOpacity = 0.7f;
    layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
    layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectInset(self.bounds, - 2.0f, - 2.0f)].CGPath;
}

- (void)deshadowed{
    CALayer *layer = self.layer;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOpacity = 0.0f;
    layer.shadowOffset = CGSizeMake(0.0, - 3.0);
    layer.shadowPath = nil;
}

@end