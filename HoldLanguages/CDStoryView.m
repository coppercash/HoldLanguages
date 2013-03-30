//
//  CDStoryView.m
//  HoldLanguages
//
//  Created by William Remaerd on 3/22/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDStoryView.h"
#import "CDItem.h"
#import "CoreDataModels.h"

@interface CDStoryView ()
- (void)setXOffset:(CGFloat)xOffset animated:(BOOL)animated;
@end

@implementation CDStoryView
@synthesize item = _item;
@synthesize pageIndex = _pageIndex;
@dynamic pageOnScreen;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.color = [UIColor whiteColor];
        self.dataSource = self;
        [self.pageControl removeFromSuperview];
        self.pageControl = nil;
        
        CGFloat fontSize = 20.0f;
        self.columnCount = 1;
        self.font = [UIFont systemFontOfSize:fontSize];
        self.spacing = fontSize;
        self.columnInset = CGPointMake(fontSize, 2 * fontSize);
    }
    return self;
}

- (void)dealloc{
    self.dataSource = nil;
}

#pragma mark - Content
- (void)setItem:(Item *)item{
    _item = item;
    self.text = item.content.content;
}

#pragma mark - AKOMultiColumnTextViewDataSource
- (UIView *)akoMultiColumnTextView:(AKOMultiColumnTextView *)textView viewForColumn:(NSInteger)column onPage:(NSInteger)page{
    NSArray *images = _item.images.allObjects;
    if (page < images.count) {
        Image *img = [images objectAtIndex:page];
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:img.absolutePath];
        return [[UIImageView alloc] initWithImage:image];
    }
    return nil;
}

#pragma mark - Scroll
- (void)scrollFor:(CGFloat)increment animated:(BOOL)animated{
    CGFloat xTarget = _scrollView.contentOffset.x + increment;
    [self setXOffset:xTarget animated:animated];
}

- (void)setXOffset:(CGFloat)xOffset animated:(BOOL)animated{
    CGFloat xMin = 0.0f;
    CGFloat xMax = _scrollView.contentSize.width - CGRectGetWidth(_scrollView.bounds);
    CGPoint offset = _scrollView.contentOffset;
    offset.x = limitedFloat(xOffset, xMin, xMax);
    //offset.x = xOffset;
    [_scrollView setContentOffset:offset animated:animated];
}

- (void)scrollToPage:(NSInteger)index animated:(BOOL)animated{
    CGFloat pageWidth = CGRectGetWidth(_scrollView.bounds);
    NSInteger min = 0;
    NSInteger max = _scrollView.contentSize.width / pageWidth;
    _pageIndex = limitedInteger(index, min, max);

    CGFloat x = _pageIndex * pageWidth;
    [self setXOffset:x animated:animated];
}

- (NSInteger)pageOnScreen{
    CGFloat pageWidth = CGRectGetWidth(_scrollView.bounds);
    CGFloat x = _scrollView.contentOffset.x + 0.5 * pageWidth;
    NSInteger index = x / pageWidth;
    return index;
}

@end

