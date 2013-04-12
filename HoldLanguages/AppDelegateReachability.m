//
//  AppDelegateReachability.m
//  HoldLanguages
//
//  Created by William Remaerd on 3/27/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "AppDelegateReachability.h"
#import "Reachability.h"

@interface AppDelegate ()
@end

@implementation AppDelegate (AppDelegateReachability)

- (Reachability *)reachability{
    if (!_reachability) {
        
        Reachability * reach = [Reachability reachabilityForInternetConnection];
        
        __weak AppDelegate *appDelegate = self;
        reach.unreachableBlock = ^(Reachability * reachability)
        {
            DLog(@"Unreachable block fired.");
            dispatch_async(dispatch_get_main_queue(), ^{
                [appDelegate alertUnreachable];
            });
        };
        
        _reachability = reach;

    }
    
    return _reachability;
}

- (void)alertUnreachable{
    DLogCurrentMethod;
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:NSLocalizedString(@"NetworkError", @"NetworkError")
                          message:nil
                          delegate:self
                          cancelButtonTitle:NSLocalizedString(@"GetIt", @"GetIt")
                          otherButtonTitles:nil];
    [alert show];
}

@end
