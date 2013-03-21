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
@interface CDiTunesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, CDSubPanViewController>{
    UITableView *_tableView;
    CDFileItem *_documents;
    NSFetchedResultsController *_items;
    __weak CDPanViewController *_panViewController;
}
@property(nonatomic, weak)CDPanViewController *panViewController;
@end
