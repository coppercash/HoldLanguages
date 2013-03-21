//
//  CDItemCell.m
//  HoldLanguages
//
//  Created by William Remaerd on 3/21/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDItemCell.h"
#import "CDItem.h"
#import "CoreDataModels.h"
#import "CDiTunesFinder.h"
#import "CDString.h"

@implementation CDItemCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)configureWithItem:(Item *)item{
    NSAssert(item.title != nil, @"\n%@\nItem's property title can't be nil.", NSStringFromSelector(@selector(_cmd)));
    if (!item.title.isVisuallyEmpty) {
        _name.text = item.title;
    }
    
    Image *image = item.anyImage;
    if (image) {
        UIImage *img = [[UIImage alloc] initWithContentsOfFile:image.absolutePath];
        _icon.image = img;
    }
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
