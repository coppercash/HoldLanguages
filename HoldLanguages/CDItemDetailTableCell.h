//
//  CDItemDetailTableCell.h
//  HoldLanguages
//
//  Created by William Remaerd on 3/27/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDItemTableCell.h"

@interface CDItemDetailTableCell : CDItemTableCell {
    UIView *_detailsView;
    UILabel *_content;
    UIImageView *_image;
    UIImageView *_audioSymbol;
    UIImageView *_lyricsSymbol;
}
#pragma mark - Height
+ (CGFloat)heightWithItem:(Item *)item;
@end
