//
//  HLOLRootController.h
//  HoldLanguages
//
//  Created by William Remaerd on 4/12/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDNetwork.h"
@class MKNetworkOperation, CDFileItem;
@interface HLOLRootController : UITableViewController <UIAlertViewDelegate>{
    NSString *_link;
    NSMutableArray *_groups;
    CDFileItem *_documents;
    CDNKEngine *_engine;
    __weak CDNKOperation *_network;
}

@end
