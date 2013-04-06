//
//  LyricsCategory.h
//  HoldLanguages
//
//  Created by William Remaerd on 3/28/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "MainViewController.h"
#import "CDLyricsView.h"

@interface MainViewController (LyricsCategory) <CDLyricsViewLyricsSource>
- (void)removeLyricsView;
- (BOOL)openLyricsAtPath:(NSString *)path;
@end
