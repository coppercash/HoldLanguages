//
//  CDColorFinder.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/21/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDefaultAnimationDuration 0.1f
#define kDefaultTableViewCellAniamtion UITableViewRowAnimationMiddle

@interface CDColorFinder : NSObject

+ (UIColor *)colorOfDownloads;
+ (UIColor *)colorOfFileSharing;

+ (UIColor *)colorOfAudio;
+ (UIColor *)colorOfLyrics;

+ (UIColor *)colorOfRates;
+ (UIColor *)colorOfPages;
+ (UIColor *)colorOfRepeat;
+ (UIColor *)colorOfBackgroundDraw;

+ (UIColor *)colorOfBars;

@end

@interface UIView (Shadow)
- (void)shadowed;
- (void)deshadowed;
@end

@interface UITableViewController (Theme)
- (void)formated;
@end