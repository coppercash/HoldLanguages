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
static CGPoint gIconCenter;
static CGRect gNameFrame;
- (id)initWithReuseIdentifier:(NSString *)identifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (self) {
        [self loadSubviewsFromXib];
        gIconCenter = _icon.center;
        gNameFrame = _name.frame;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupWithItem:(CDFileItem *)item{
    NSString *fileName = item.name;
    _name.text = fileName;
    self.selectionStyle = UITableViewCellSelectionStyleBlue;
    [self setDegree:item.degree];
    if (item.isDirectory) {
        _icon.image = [UIImage pngImageWithName:item.isOpened ? kFileIconDirectoryOpened : kFileIconDirectory];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if ([fileName.pathExtension isEqualToString:@"lrc"]){
        _icon.image = [UIImage pngImageWithName:kFileIconLRC];
    }
}

- (void)setDegree:(NSUInteger)degree{
    CGFloat indentation = 20.0f * (degree - 1);
    if (_icon.center.x == gIconCenter.x + indentation) return;
    
    CGPoint center = _icon.center;
    center.x = gIconCenter.x + indentation;
    _icon.center = center;
    
    CGRect frame = _name.frame;
    frame.origin.x = CGRectGetMinX(gNameFrame) + indentation;
    frame.size.width = CGRectGetWidth(gNameFrame) - indentation;
    _name.frame = frame;
}

@end
