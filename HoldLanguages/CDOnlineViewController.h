//
//  CDOnlineViewController.h
//  HoldLanguages
//
//  Created by William Remaerd on 3/15/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDPanViewController.h"
#import "CDNetwork.h"

@class CD51VOA, CDLoadMoreControl;
@interface CDOnlineViewController : UITableViewController <CDSubPanViewController> {
    __weak CDPanViewController *_panViewController;
    
    //Subviews
    CDLoadMoreControl *_loader;
    
    //Models
    NSMutableArray *_itemList;
    CD51VOA *_VOA51;
    NSString *_rootPage;
    
    //Joiner
    NSUInteger _pageCapacity;
    NSInteger _indexOfPage;
    NSString *_currentPage;
    NSInteger _indexInPage;
    
    //Detail
    NSIndexPath *_detailIndex;
    __weak CDNKOperation *_imageNetwork;   //For cancel it after canceling detail mode.
}
@property(nonatomic, weak)CDPanViewController *panViewController;
@property(nonatomic, strong)NSString *rootPage;
@end

#define kRefreshCapacity 20
#define kDefaultCellAnimationType UITableViewRowAnimationMiddle
