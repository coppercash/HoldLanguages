//
//  HLCatagoryTableCell.m
//  HoldLanguages
//
//  Created by William Remaerd on 4/15/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "HLCategoryTableCell.h"

@implementation HLCategoryTableCell
@synthesize title = _title;

- (id)initWithReuseIdentifier:(NSString *)identifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (self) {
        [self loadSubviewsFromXib];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _title.textColor = [UIColor whiteColor];
        _title.font = [UIFont boldSystemFontOfSize:17];
        _title.textAlignment = UITextAlignmentLeft;
        _title.delegate = self;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - CDScrollLabelDelegate
#define kAnimationInterval 5.0f
- (NSTimeInterval)scrollLabelShouldStartAnimating:(CDScrollLabel *)scrollLabel{
    return kAnimationInterval;
}

- (NSTimeInterval)scrollLabelShouldContinueAnimating:(CDScrollLabel *)scrollLabel{
    return kAnimationInterval;
}

@end
