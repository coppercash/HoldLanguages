//
//  CDAssitMetroCell.m
//  HoldLanguages
//
//  Created by William Remaerd on 1/31/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDImageMetroCell.h"

@implementation CDImageMetroCell
@synthesize imageName = _imageName;
- (void)loadContentView:(UIView *)contentView{
    UIImage *i = [UIImage pngImageWithName:_imageName];   //image
    if (i == nil) return;
    
    _imageView = [[UIImageView alloc] initWithFrame:contentView.bounds];
    _imageView.contentMode = UIViewContentModeCenter;
    _imageView.image = i;
    [contentView addSubview:_imageView];
}

- (void)cleanContentView{
    if (_imageName == nil) return;
    [_imageView removeFromSuperview];
    SafeMemberRelease(_imageView);
}
@end

