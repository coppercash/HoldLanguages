//
//  CDOnlineViewController.h
//  HoldLanguages
//
//  Created by William Remaerd on 3/15/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDPanViewController.h"

@class CD51VOA, CDLoadMoreControl;
@interface CDOnlineViewController : UITableViewController <CDSubPanViewController> {
    //Subviews
    CDLoadMoreControl *_loader;
    
    //Models
    NSMutableArray *_itemList;
    CD51VOA *_VOA51;
    NSMutableDictionary *_trash;
    
    //Joiner
    NSUInteger _pageCapacity;
    NSInteger _indexOfPage;
    NSString *_currentPage;
    NSInteger _indexInPage;
}

@end

#define kRefreshCapacity 20