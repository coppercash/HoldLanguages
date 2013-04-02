//
//  CDiTunesViewCell.h
//  HoldLanguages
//
//  Created by William Remaerd on 1/13/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDScrollLabel.h"

#define kFileIconDirectory @"FileDir"
#define kFileIconDirectoryOpened @"FileDirOpened"
#define kFileIconLRC @"FileLRC"
#define kFileIconAudio @"FileAudio"

@class CDFileItem;
@interface CDiTunesViewCell : UITableViewCell <CDScrollLabelDelegate>{
    UIImageView *_icon;
    CDScrollLabel *_name;
}
- (id)initWithReuseIdentifier:(NSString *)identifier;
- (void)configureWithItem:(CDFileItem *)item;
@property(strong, nonatomic)IBOutlet UIImageView *icon;
@property(strong, nonatomic)IBOutlet CDScrollLabel *name;
@end
