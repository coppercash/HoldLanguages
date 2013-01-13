//
//  CDiTunesViewController.h
//  HoldLanguages
//
//  Created by William Remaerd on 1/13/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDPanViewController.h"
@class CDFileItem;
@interface CDiTunesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CDSubPanViewController>
@property(strong, readonly, nonatomic)CDFileItem *documents;
@property(strong, readonly, nonatomic)UITableView *tableView;
@property(strong, nonatomic)CDPanViewController *panViewController;
@end
