//
//  CDiTunesViewCell.h
//  HoldLanguages
//
//  Created by William Remaerd on 1/13/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kCDiTunesViewCell @"CDiTunesViewCell"
#define kFileIconDirectory @"FileIconDirectory"
#define kFileIconDirectoryOpened @"FileIconDirectoryOpened"
#define kFileIconLRC @"FileIconLRC"

@class CDFileItem;
@interface CDiTunesViewCell : UITableViewCell
- (id)initWithReuseIdentifier:(NSString *)identifier;
- (void)setupWithItem:(CDFileItem *)item;
@property(strong, readonly, nonatomic)IBOutlet UIImageView *icon;
@property(strong, readonly, nonatomic)IBOutlet UILabel *name;
@end
