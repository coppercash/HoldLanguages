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
    NSUInteger _animateTagetingIndex;
    
    NSString *_lyricsInfo;
}
@property(nonatomic) NSUInteger focusIndex;
@property(nonatomic, weak) id<CDLyricsViewLyricsSource> lyricsSource;
@property(nonatomic, readonly) UITableView* lyricsTable;
@property(nonatomic, readonly) UIImageView* cursor;
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