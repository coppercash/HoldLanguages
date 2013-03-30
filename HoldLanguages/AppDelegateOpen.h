//
//  AppDelegateOpen.h
//  HoldLanguages
//
//  Created by William Remaerd on 3/21/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "AppDelegate.h"
@class Item;
@interface AppDelegate (AppDelegateOpen)
- (BOOL)openItem:(Item *)item;
- (BOOL)openAudioAt:(NSString *)path;
- (BOOL)openLyricsAt:(NSString *)path;
//- (BOOL)openText:(NSString *)text;
@end

#define App ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define kMOContext [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]
#define kSingletonNetwork [(AppDelegate *)[[UIApplication sharedApplication] delegate] network]
