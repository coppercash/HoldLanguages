//
//  CDItemTableCell.h
//  HoldLanguages
//
//  Created by William Remaerd on 3/24/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDScrollLabel.h"

@class CDScrollLabel, Item;
@interface CDItemTableCell : UITableViewCell <CDScrollLabelDelegate>{
    CDScrollLabel *_title;
    UIView *_stageView;
    UILabel *_label;
    BOOL _isProgressive;
    
    __weak NSTimer *_updater;
}
@property(nonatomic)BOOL isProgressive;
@property(nonatomic, setter = setProgress:)float progress;
- (void)setIsProgressive:(BOOL)isProgressive animated:(BOOL)animated;
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)refreshWhenReusing;
- (void)configureWithDictionary:(NSDictionary *)dictionary;
- (void)configureWithItem:(Item *)item;
#pragma mark - Updater
- (void)setupUpdaterWithItem:(Item *)item;
- (void)invalidateUpdater;
@end
