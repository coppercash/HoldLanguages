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
@interface CDiTunesViewController : UITableViewController <NSFetchedResultsControllerDelegate, CDSubPanViewController>{
    __weak CDPanViewController *_panViewController;
    
    NSFetchedResultsController *_items;
    CDFileItem *_documents;
}
@property(nonatomic, weak)CDPanViewController *panViewController;
@end

#define kDefaultCellAnimationType UITableViewRowAnimationMiddle