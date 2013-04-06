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

@interface CDLyricsView : UIView <UITableViewDataSource, UITableViewDelegate>{
    NSString *_lyricsInfo;
    __weak id<CDLyricsViewLyricsSource> _lyricsSource;
    
    UITableView *_yricsTable;
    UIImageView *_cursor;
    
    NSUInteger _focusIndex;
    NSUInteger _animateTagetingIndex;
}
@property(nonatomic, weak) id<CDLyricsViewLyricsSource> lyricsSource;
@property(nonatomic, readonly) UITableView *lyricsTable;
@property(nonatomic, readonly) UIImageView *cursor;
@property(nonatomic, assign) NSUInteger focusIndex;

- (void)scrollFor:(CGFloat)increment animated:(BOOL)animated;
- (void)reloadData;

@end

@protocol CDLyricsViewLyricsSource <NSObject>
@optional
- (NSString *)lyricsViewNeedsLyricsInfo:(CDLyricsView *)lyricsView;
@required
- (NSUInteger)numberOfLyricsRowsInView:(CDLyricsView *)lyricsView;
- (NSString*)lyricsView:(CDLyricsView *)lyricsView stringForRowAtIndex:(NSUInteger)index;
@end

NSString * convertedLyricsInfo(NSArray *lyricsInfos);