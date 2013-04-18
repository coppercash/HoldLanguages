//
//  AppDelegate.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/10/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppStatus.h"

@class CDPanViewController, CDAudioSharer, CDAudioProgress, CDNetwork, Reachability;
@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    CDPanViewController *_panViewController;
    CDAudioSharer *_audioSharer;
    CDAudioProgress *_progress;
    CDNetwork *_network;
    Reachability *_reachability;
    BOOL _isReachabilyAlert;
    
    AppStatus *_status;
}

@property(strong, nonatomic) UIWindow *window;
@property(strong, nonatomic) CDPanViewController *panViewController;
@property(strong, nonatomic) CDAudioSharer *audioSharer;
@property(strong, nonatomic) CDAudioProgress *progress;
@property(strong, nonatomic) CDNetwork *network;
@property(nonatomic, readonly) Reachability *reachability;
@property(nonatomic, assign) AppStatus *status;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
