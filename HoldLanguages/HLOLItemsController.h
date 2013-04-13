//
//  CDOnlineViewController.h
//  HoldLanguages
//
//  Created by William Remaerd on 3/15/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "HLOLCategoryController.h"
#import "CDNetwork.h"

@class CD51VOA, CDLoadMoreControl;
@interface HLOLItemsController : HLOLCategoryController {
    //Detail
    NSIndexPath *_detailIndex;
    __weak CDNKOperation *_imageNetwork;   //For cancel it after canceling detail mode.
}
@end

#define kRefreshCapacity 20
#define kDefaultCellAnimationType UITableViewRowAnimationMiddle
