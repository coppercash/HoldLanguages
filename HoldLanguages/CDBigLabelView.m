//
//  CDBigLabelView.m
//  HoldLanguages
//
//  Created by William Remaerd on 1/20/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDBigLabelView.h"

@implementation CDBigLabelView
@synthesize bigLabel = _bigLabel;


- (void)initialize{
    _bigLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _bigLabel.font = [UIFont boldSystemFontOfSize:30];
    _bigLabel.textColor = [UIColor whiteColor];
    _bigLabel.backgroundColor = [UIColor clearColor];
    _bigLabel.autoresizingMask = CDViewAutoresizingNoMaigin;
    _bigLabel.textAlignment = UITextAlignmentCenter;
    [self addSubview:_bigLabel];
}

- (id)initWithText:(NSString*)text;{
    self = [super init];
    if (self) {
        [self initialize];
        _bigLabel.text = text;
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame text:(NSString*)text{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
        _bigLabel.text = text;
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
