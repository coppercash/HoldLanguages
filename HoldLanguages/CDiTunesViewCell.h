//
//  CDiTunesViewCell.h
//  HoldLanguages
//
//  Created by William Remaerd on 1/13/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDScrollLabel.h"
#define kCDiTunesViewCell @"CDiTunesViewCell"
#define kFileIconDirectory @"FileDir"
#define kFileIconDirectoryOpened @"FileDirOpened"
#define kFileIconLRC @"FileLRC"

@class CDFileItem;
@interface CDiTunesViewCell : UITableViewCell <CDScrollLabelDelegate>
- (id)initWithReuseIdentifier:(NSString *)identifier;
- (void)setupWithItem:(CDFileItem *)item;
@property(strong, readonly, nonatomic)IBOutlet UIImageView *icon;
@property(strong, readonly, nonatomic)IBOutlet CDScrollLabel *name;
@end
