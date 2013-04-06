//
//  CDIntroductionView.m
//  HoldLanguages
//
//  Created by William Remaerd on 3/28/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDIntroductionView.h"

@implementation CDIntroductionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect bounds = self.bounds;
        
        UIScrollView *view = (UIScrollView *)[UIView viewFromXibNamed:NSStringFromClass(self.class) owner:self];
        view.center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
        
        CGFloat height = MAX(CGRectGetHeight(bounds), CGRectGetHeight(view.frame));
        CGSize contentSize = CGSizeMake(CGRectGetWidth(bounds), height);
        self.contentSize = contentSize;
        view.backgroundColor = [UIColor clearColor];
        view.autoresizingMask = CDViewAutoresizingNoMaigin;
        
        [self addSubview:view];
    }
    return self;
}


@end
