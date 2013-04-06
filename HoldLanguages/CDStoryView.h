//
//  CDStoryView.h
//  HoldLanguages
//
//  Created by William Remaerd on 3/22/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKOMultiPageTextView.h"
@class Item;
@interface CDStoryView : AKOMultiPageTextView <AKOMultiColumnTextViewDataSource> {
    Item *_item;
    NSInteger _pageIndex;
}
@property(nonatomic, strong)Item *item;
@property(nonatomic, readonly)NSInteger pageIndex;
@property(nonatomic, getter = pageOnScreen)NSInteger pageOnScreen;
//- (void)redrawContent;
//- (void)setContentString:(NSString *)content;
- (void)scrollFor:(CGFloat)increment animated:(BOOL)animated;
- (void)scrollToPage:(NSInteger)index animated:(BOOL)animated; 
@end