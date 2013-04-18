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
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
        
        _reachability = [Reachability reachabilityForInternetConnection];
        
    }
    
    return _reachability;
}

- (void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if(![reach isReachable]){
        [self alertUnreachable];
    }
}

- (void)alertUnreachable{
    DLogCurrentMethod;
    if (_isReachabilyAlert) return;
    _isReachabilyAlert = YES;
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:NSLocalizedString(@"NetworkError", @"NetworkError")
                          message:nil
                          delegate:self
                          cancelButtonTitle:NSLocalizedString(@"GetIt", @"GetIt")
                          otherButtonTitles:nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    _isReachabilyAlert = NO;
}

@end
