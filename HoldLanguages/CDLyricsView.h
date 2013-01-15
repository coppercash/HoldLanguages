//
//  CDLyricsView.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/13/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCursorHeight 10.0f
#define kCursorImageName @"Cursor"

@protocol CDLyricsViewLyricsSource;

@interface CDLyricsView : UIView <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property(nonatomic) NSUInteger focusIndex;
@property(nonatomic, weak) id<CDLyricsViewLyricsSource> lyricsSource;
@property(nonatomic, readonly, strong) UITableView* lyricsTable;
@property(nonatomic, readonly, strong) UIImageView* cursor;
- (void)scrollFor:(CGFloat)increment animated:(BOOL)animated;
- (void)reloadData;
@end

@protocol CDLyricsViewLyricsSource
@required
- (NSUInteger)numberOfLyricsRowsInView:(CDLyricsView *)lyricsView;
- (NSString*)lyricsView:(CDLyricsView *)lyricsView stringForRowAtIndex:(NSUInteger)index;
@end