//
//  CDLyricsView.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/13/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CDLyricsViewLyricsSource;

@interface CDLyricsView : UIView <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic) NSUInteger focusIndex;
@property(nonatomic, weak) id<CDLyricsViewLyricsSource> lyricsSource;
@property(nonatomic, readonly, strong) UITableView* lyricsTable;
@property(nonatomic, readonly, strong) UIImageView* cursor;
- (void)scrollFor:(CGFloat)distance animated:(BOOL)animated;
@end

@protocol CDLyricsViewLyricsSource
@required
- (NSUInteger)numberOfLyricsRowsInView:(CDLyricsView *)lyricsView;
- (NSString*)lyricsView:(CDLyricsView *)lyricsView stringForRowAtIndex:(NSUInteger)index;
@end