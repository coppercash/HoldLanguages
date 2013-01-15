//
//  CDLyricsView.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/13/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDLyricsView.h"
#import "CDLyricsViewCell.h"

@interface CDLyricsView ()
- (void)initialize;
- (CGFloat)yOffset;
- (void)setYOffset:(CGFloat)yOffset animated:(BOOL)animated;
- (void)setFocusIndex:(NSUInteger)focusIndex animated:(BOOL)animated;
- (BOOL)isFocusAccurate;
@end

@implementation CDLyricsView
@synthesize focusIndex = _focusIndex, lyricsSource = _lyricsSource;
@synthesize lyricsTable = _lyricsTable, cursor = _cursor;

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize{
    _lyricsTable = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    [self addSubview:_lyricsTable];
    _lyricsTable.dataSource = self;
    _lyricsTable.delegate = self;
    _lyricsTable.allowsSelection = NO;
    _lyricsTable.backgroundColor = [UIColor clearColor];
    _lyricsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _lyricsTable.autoresizingMask = kViewAutoresizingNoMarginSurround;
    _lyricsTable.scrollsToTop = NO;
    
    _cursor = [[UIImageView alloc] initWithPNGImageNamed:kCursorImageName];
    [self addSubview:_cursor];
    _cursor.frame = CGRectMake(self.bounds.origin.x, (self.bounds.size.height - kCursorHeight) / 2, self.bounds.size.width, kCursorHeight);
    _cursor.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
}

- (void)reloadData{
    [self.lyricsTable reloadData];
    [self setYOffset:0.0f animated:NO];
}

#pragma mark - Focus
- (void)setFocusIndex:(NSUInteger)focusIndex{
    [self setFocusIndex:focusIndex animated:YES];
}

- (void)setFocusIndex:(NSUInteger)focusIndex animated:(BOOL)animated{
    NSUInteger maxIndexIncrement = 10;
    NSUInteger currentIndex = self.focusIndex;
    if (focusIndex == currentIndex && self.isFocusAccurate) return;
    BOOL shouldAnimated = abs(focusIndex - currentIndex) < maxIndexIncrement;
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:focusIndex inSection:1];
    [_lyricsTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:animated && shouldAnimated];
}

- (NSUInteger)focusIndex{
    CGPoint focusPoint = CGPointMake(CGRectGetMidX(_lyricsTable.bounds), CGRectGetMidY(_lyricsTable.bounds));
    NSIndexPath* indexPath = [_lyricsTable indexPathForRowAtPoint:focusPoint];
    NSUInteger focusIndex = indexPath.row;
    
    return focusIndex;
}

- (BOOL)isFocusAccurate{
    CGPoint focusPoint = CGPointMake(CGRectGetMidX(_lyricsTable.bounds), CGRectGetMidY(_lyricsTable.bounds));
    NSIndexPath* indexPath = [_lyricsTable indexPathForRowAtPoint:focusPoint];
    UITableViewCell *cell = [_lyricsTable cellForRowAtIndexPath:indexPath];
    
    BOOL isAccurate = CGPointEqualToPoint(cell.center, focusPoint);
    return isAccurate;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CDLyricsViewCell* cell = nil;
    switch (indexPath.section) {
        case 0:{
            cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifierOfStyleHeader];
            if (cell == nil) cell = [[CDLyricsViewCell alloc] initWithLyricsStyle:CDLyricsViewCellStyleHeader reuseIdentifier:kReuseIdentifierOfStyleHeader];
        }break;
        case 1:{
            cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifierOfStyleLyrics];
            if (cell == nil) cell = [[CDLyricsViewCell alloc] initWithLyricsStyle:CDLyricsViewCellStyleLyrics reuseIdentifier:kReuseIdentifierOfStyleLyrics];
            NSString* content = [self.lyricsSource lyricsView:self stringForRowAtIndex:indexPath.row];
            cell.content.text = content;
        }break;
        case 2:{
            cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifierOfStyleFooter];
            if (cell == nil) cell = [[CDLyricsViewCell alloc] initWithLyricsStyle:CDLyricsViewCellStyleFooter reuseIdentifier:kReuseIdentifierOfStyleFooter];
        }break;
        default:
            break;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger numberOfRows = 0;
    switch (section) {
        case 0:
            numberOfRows = 1;
            break;
        case 1:
            numberOfRows = (NSInteger)[self.lyricsSource numberOfLyricsRowsInView:self];;
            break;
        case 2:
            numberOfRows = 1;
            break;
        default:
            break;
    }
    return numberOfRows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = kCellOfStyleLyricsHeihgt;
    switch (indexPath.section) {
        case 0:
            height = (_lyricsTable.bounds.size.height - kCellOfStyleLyricsHeihgt) / 2;
            break;
        case 2:
            height = (_lyricsTable.bounds.size.height - kCellOfStyleLyricsHeihgt) / 2;
            break;
        default:
            break;
    }
    return height;
}

#pragma mark - Scroll in Horizontal
- (CGFloat)yOffset{
    CGFloat yOffset = _lyricsTable.contentOffset.y;
    return yOffset;
}

- (void)setYOffset:(CGFloat)yOffset animated:(BOOL)animated{
    CGFloat yMin = 0.0f;
    CGFloat yMax = _lyricsTable.contentSize.height - CGRectGetHeight(_lyricsTable.bounds);
    CGPoint offset = _lyricsTable.contentOffset;
    if (yOffset < yMin) {
        offset.y = yMin;
    }else if (yOffset > yMax) {
        offset.y = yMax;
    }else{
        offset.y = yOffset;
    }
    [_lyricsTable setContentOffset:offset animated:animated];
}

- (void)scrollFor:(CGFloat)increment animated:(BOOL)animated{
    CGFloat yTarget = _lyricsTable.contentOffset.y + increment;
    [self setYOffset:yTarget animated:animated];
}

@end
