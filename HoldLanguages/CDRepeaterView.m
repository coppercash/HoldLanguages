//
//  CDRepeaterView.m
//  HoldLanguages
//
//  Created by William Remaerd on 1/23/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDRepeaterView.h"
#import "UIBezierPath+Symbol.h"
#import "CDColorFinder.h"

@implementation CDRepeaterView
@synthesize leftPlus = _leftPlus, leftMinus = _leftMinus, rightPlus = _rightPlus, rightMinus = _rightMinus;
@synthesize start = _start, end = _end;

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [CDColorFinder colorOfRepeat];
    }
    return self;
}

- (void)setRepeatRaneg:(CDDoubleRange)repeatRange{
    NSString *start = textWithTimeInterval(repeatRange.location);
    _start.text = start;
    NSString *end = textWithTimeInterval(CDMaxDoubleRange(repeatRange));
    _end.text = end;
}

@end

@implementation CDPlusButton
- (void)drawRect:(CGRect)rect{
    [[UIColor whiteColor] setFill];
    [[UIBezierPath customBezierPathOfPlusSymbolWithRect:rect scale:1] fill];
}
@end

@implementation CDMinusButton
- (void)drawRect:(CGRect)rect{
    [[UIColor whiteColor] setFill];
    [[UIBezierPath customBezierPathOfMinusSymbolWithRect:rect scale:1] fill];
}
@end