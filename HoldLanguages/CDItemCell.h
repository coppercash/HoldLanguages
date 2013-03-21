//
//  CDItemCell.h
//  HoldLanguages
//
//  Created by William Remaerd on 3/21/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDiTunesViewCell.h"
@class Item;
@interface CDItemCell : CDiTunesViewCell
- (void)configureWithItem:(Item *)item;
@end
