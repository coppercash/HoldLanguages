//
//  MainViewController.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/11/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CDHolder.h"
#import "CDLyricsView.h"
#import "CDAudioSharer.h"

@class CDAudioSharer, CDLyrics;
@interface MainViewController : UIViewController <MPMediaPickerControllerDelegate, CDHolderDelegate, CDLyricsViewLyricsSource, CDAudioPlayerDelegate>

@property(nonatomic, strong)CDLyricsView* lyricsView;
@property(nonatomic, strong)CDAudioSharer* audioSharer;
@property(nonatomic, strong)CDLyrics* lyrics;
@end
