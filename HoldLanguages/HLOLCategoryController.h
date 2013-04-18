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
@interface HLOLCategoryController : UITableViewController <UIAlertViewDelegate> {
    //Models
    NSMutableArray *_itemList;
    HLModelsGroup *_models;
    __weak LAHOperation *_network;
    
    //Joiner
    NSMutableArray* _joiner;
    NSUInteger _breakCapacity;
    NSUInteger _entireCapacity;
    NSString *_firstPage;
    NSString *_currentPage;
    NSInteger _indexOfPage;
    NSInteger _indexInPage;

    //Subviews
    CDLoadMoreControl *_loader;
}
@property(nonatomic, strong)HLModelsGroup *models;

#pragma mark - 
#pragma mark Protected
@property(nonatomic, strong)NSMutableArray *itemList;
@property(nonatomic, weak)LAHOperation *network;

@property(nonatomic, strong)NSMutableArray *joiner;
@property(nonatomic, assign)NSUInteger breakCapacity;
@property(nonatomic, assign)NSUInteger entireCapacity;
@property(nonatomic, copy)NSString *firstPage;
@property(nonatomic, copy)NSString *currentPage;
@property(nonatomic, assign)NSInteger indexOfPage;
@property(nonatomic, assign)NSInteger indexInPage;

@property(nonatomic, strong)CDLoadMoreControl *loader;
#pragma mark - Joiner
- (BOOL)joinItemsWithResponse:(id)response;
- (void)fillListWithItems:(NSArray *)items;
#pragma mark - Swipe
- (void)swipe:(UISwipeGestureRecognizer *)swiper;
#pragma mark - Refresh & Load More
- (void)refresh;
- (void)didRefreshWith:(id)response;
- (void)loadMore;
- (void)loadMore:(NSUInteger)count;
- (void)didLoadMoreWith:(id)response;
#pragma mark - Alert
- (void)alertNetworkError;
- (void)alertVIewDismissWithTitle:(NSString *)title;
@end

#define kRefreshCapacity 20
