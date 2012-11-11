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

@class CDAudioSharer;
@interface MainViewController : UIViewController <MPMediaPickerControllerDelegate, CDHolderDelegate>

@property(nonatomic, strong)CDAudioSharer* audioSharer;

@end
