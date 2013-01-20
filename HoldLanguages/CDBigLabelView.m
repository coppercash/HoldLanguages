//
//  CDBigLabelView.m
//  HoldLanguages
//
//  Created by William Remaerd on 1/20/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDBigLabelView.h"

@implementation CDBigLabelView
@synthesize text = _text;

- (void)initialize{
    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    label.font = [UIFont boldSystemFontOfSize:30];
    label.textColor = [UIColor whiteColor];
    label.text = _text;
    label.backgroundColor = [UIColor clearColor];
    label.autoresizingMask = kViewAutoresizingNoMarginSurround;
    label.textAlignment = UITextAlignmentCenter;
    [self addSubview:label];
}

- (id)initWithText:(NSString*)text;{
    self = [super init];
    if (self) {
        self.text = text;
        [self initialize];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame text:(NSString*)text{
    self = [super initWithFrame:frame];
    if (self) {
        self.text = text;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
