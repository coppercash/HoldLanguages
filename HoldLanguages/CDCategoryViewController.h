//
//  CDCategoryViewController.h
//  HoldLanguages
//
//  Created by William Remaerd on 4/1/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDPanViewController.h"

@class CD51VOA;
@interface CDCategoryViewController : UITableViewController <CDSubPanViewController> {
    //Models
    NSMutableArray *_itemList;
    CD51VOA *_VOA51;
}
@end

#define kNumberOfCategories 17
