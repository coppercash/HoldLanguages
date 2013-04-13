//
//  HLOLRootController.h
//  HoldLanguages
//
//  Created by William Remaerd on 4/12/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MKNetworkOperation;
@interface HLOLRootController : UITableViewController {
    NSString *_link;
    NSArray *_groups;
    __weak MKNetworkOperation *_network;
}

@end
