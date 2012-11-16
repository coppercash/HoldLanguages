//
//  CDView.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/15/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDView.h"
#import "Header.h"

@implementation UIView (CDView)
- (void)setBackgroundLayer:(CALayer *)backgroundLayer;
{
    CALayer * oldBackground = [[self.layer sublayers] objectAtIndex:0];
    if (oldBackground){
        [self.layer replaceSublayer:oldBackground with:backgroundLayer];
    }else{
        [self.layer insertSublayer:backgroundLayer atIndex:0];
    }
}
@end
