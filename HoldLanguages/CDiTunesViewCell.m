//
//  CDiTunesViewCell.m
//  HoldLanguages
//
//  Created by William Remaerd on 1/13/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDiTunesViewCell.h"
#import "CDFileItem.h"

@implementation CDiTunesViewCell

- (id)initWithReuseIdentifier:(NSString *)identifier item:(CDFileItem *)item{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (self) {
        [self loadSubviewsFromXib];
        _name.text = item.name;
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
