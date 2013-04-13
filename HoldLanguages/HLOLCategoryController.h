//
//  CDCategoryViewController.h
//  HoldLanguages
//
//  Created by William Remaerd on 4/1/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDPanViewController.h"

@class HLModelsGroup, LAHOperation;
@class CDLoadMoreControl;
@interface HLOLCategoryController : UITableViewController {
    //Models
    NSMutableArray *_itemList;
    __weak HLModelsGroup *_models;
    __weak LAHOperation *_network;
    
    //Joiner
    NSUInteger _pageCapacity;
    NSUInteger _entireCapacity;
    NSString *_firstPage;
    NSString *_currentPage;
    NSInteger _indexOfPage;
    NSInteger _indexInPage;

    //Subviews
    CDLoadMoreControl *_loader;
}
@property(nonatomic, weak)HLModelsGroup *models;

#pragma mark - 
#pragma mark Protected
@property(nonatomic, strong)NSMutableArray *itemList;
@property(nonatomic, weak)LAHOperation *network;

@property(nonatomic, assign)NSUInteger pageCapacity;
@property(nonatomic, assign)NSUInteger entireCapacity;
@property(nonatomic, copy)NSString *firstPage;
@property(nonatomic, copy)NSString *currentPage;
@property(nonatomic, assign)NSInteger indexOfPage;
@property(nonatomic, assign)NSInteger indexInPage;

@property(nonatomic, strong)CDLoadMoreControl *loader;

#pragma mark - Swipe
- (void)swipe:(UISwipeGestureRecognizer *)swiper;
#pragma mark - Refresh & Load More
- (void)refresh;
- (void)didRefreshWith:(NSArray *)newItems;
- (void)loadMore;
- (void)didLoadMoreWith:(NSArray *)newItems;
- (void)didReceiveResponse:(id)response;

@end

#define kRefreshCapacity 20
#define kNumberOfCategories 17
