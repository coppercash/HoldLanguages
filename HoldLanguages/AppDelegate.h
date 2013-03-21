//
//  AppDelegate.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/10/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kMOContext [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]
#define kSingletonContext [(AppDelegate *)[[UIApplication sharedApplication] delegate] network]
@class CDPanViewController, CDAudioSharer, CDAudioProgress, CDNetwork;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(strong, nonatomic) UIWindow *window;
@property(strong, nonatomic) CDPanViewController *panViewController;
@property(strong, nonatomic) CDAudioSharer *audioSharer;
@property(strong, nonatomic) CDAudioProgress *progress;
@property(strong, nonatomic) CDNetwork *network;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
