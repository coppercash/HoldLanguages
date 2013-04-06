//
//  CDItemNetwork.m
//  HoldLanguages
//
//  Created by William Remaerd on 3/19/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDItemNetwork.h"
#import "CDItem.h"

@implementation CDItemNetwork
@synthesize keyOperation = _keyOperation;
- (id)initWithItem:(Item *)item{
    self = [super init];
    if (self) {
        self.item = item;
        [self addProgress:^(CDNetworkGroup *group, double progress) {
            item.progress = [[NSNumber alloc] initWithFloat:progress];
        } forKey:item.absolutePath];
    }
    return self;
}

- (void)removeOperation:(CDNKOperation *)operation error:(NSError *)error{
    if (operation == _keyOperation && error){
        [self error:error];
        return;
    }
    [super removeOperation:operation error:nil];
}

- (void)cancel{
    _item.status = [[NSNumber alloc] initWithInteger:ItemStatusInit];
    [super cancel];
}


@end
