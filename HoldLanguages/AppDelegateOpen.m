//
//  AppDelegateOpen.m
//  HoldLanguages
//
//  Created by William Remaerd on 3/21/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "AppDelegateOpen.h"
#import "CDItem.h"
#import "CoreDataModels.h"
#import "CDAudioSharer.h"
#import "CDPanViewController.h"
#import "MainViewController.h"
#import "StoryViewCategory.h"

@implementation AppDelegate (AppDelegateOpen)
- (BOOL)openItem:(Item *)item{
    if (item.status.integerValue != ItemStatusDownloaded) return NO;
    BOOL success = NO;
    //[self openText:item.contentWithTitle];

    
    if (![self openLyricsAt:item.lyrics.absolutePath]) {
        [self openText:item.contentWithTitle];
    }
    success = [self openAudioAt:item.audio.absolutePath];
    return success;
}

- (BOOL)openAudioAt:(NSString *)path{
    NSFileManager *manager = [[NSFileManager alloc] init];
    BOOL exist = [manager fileExistsAtPath:path];
    if (!exist) return NO;
    
    [_audioSharer openiTunesSharedFile:path];
    [self.audioSharer play];
    
    return exist;
}

- (BOOL)openLyricsAt:(NSString *)path{
    MainViewController *con = (MainViewController *)_panViewController.rootViewController;
    return [con openLyricsAtPath:path];
}

- (BOOL)openText:(NSString *)text{
    MainViewController *con = (MainViewController *)_panViewController.rootViewController;
    return [con openText:text];
}

@end
