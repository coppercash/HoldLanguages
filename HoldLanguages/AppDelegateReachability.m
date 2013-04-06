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
- (void)registerReachabilityNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.reachability = [Reachability reachabilityForInternetConnection] ;
    [_reachability startNotifier];
}

- (void)reachabilityChanged:(NSNotification *)note{
    Reachability *currReach = [note object];
    NSParameterAssert([currReach isKindOfClass:[Reachability class]]);
    
    NetworkStatus status = [currReach currentReachabilityStatus];
    if(status == NotReachable)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"NetworkError", @"NetworkError")
                              message:nil
                              delegate:self
                              cancelButtonTitle:NSLocalizedString(@"GetIt", @"GetIt")
                              otherButtonTitles:nil];
        [alert show];
    }
}

@end
