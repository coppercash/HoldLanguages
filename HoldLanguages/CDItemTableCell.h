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
@interface CDItemTableCell : UITableViewCell {
    //CDScrollLabel *_title;
    UILabel *_title;
    UIView *_stageView;
    UILabel *_label;
    
    BOOL _isProgressAvailable;
    BOOL _isProgressive;
    
    __weak NSTimer *_updater;
}
//@property(nonatomic, readonly)UILabel *title;
@property(nonatomic, assign)BOOL isProgressAvailable;
@property(nonatomic, assign)BOOL isProgressive;
@property(nonatomic, setter = setProgress:)float progress;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)configureWithDictionary:(NSDictionary *)dictionary;
- (void)configureWithItem:(Item *)item;
- (void)setIsProgressive:(BOOL)isProgressive animated:(BOOL)animated;
#pragma mark - Updater
- (void)setupUpdaterWithItem:(Item *)item;
- (void)invalidateUpdater;
#pragma mark - Height
+ (CGFloat)heightWithDictionary:(NSDictionary *)dictionary;
+ (CGFloat)heightWithItem:(Item *)item;
@end
