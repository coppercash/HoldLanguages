//
//  CDItemNetwork.h
//  HoldLanguages
//
//  Created by William Remaerd on 3/19/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDNetworkGroup.h"
@class Item, Audio;
@interface CDItemNetwork : CDNetworkGroup {
    Item *_item;
    __weak CDNKOperation *_keyOperation;
}
@property(nonatomic, strong)Item *item;
@property(nonatomic, weak)CDNKOperation *keyOperation;
- (id)initWithItem:(Item *)item;
@end
