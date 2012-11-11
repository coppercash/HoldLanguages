//
//  CDHorizontalScrollView.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/10/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDHorizontalScrollView.h"

@interface CDHorizontalScrollView (Private)
- (void)initialize;
- (CGFloat)yOffset;
- (void)setYOffset:(CGFloat)yOffset animated:(BOOL)animated;
- (void)scrollFor:(CGFloat)distance;

@end

@implementation CDHorizontalScrollView

#pragma mark - UIScrollView methods
- (void)initialize{
    
}

- (void)setContentSize:(CGSize)contentSize{
    CGSize size = CGSizeMake(self.bounds.size.width, contentSize.height);
    [super setContentSize:size];
}

#pragma mark - Scroll in Horizontal
//- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated;
//- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated

- (CGFloat)yOffset{
    CGFloat yOffset = self.contentOffset.y;
    return yOffset;
}

- (void)setYOffset:(CGFloat)yOffset animated:(BOOL)animated{
    CGPoint offset = CGPointMake(0.0f, yOffset);
    [self setContentOffset:offset animated:animated];
}

- (void)scrollFor:(CGFloat)distance animated:(BOOL)animated{
    CGFloat destination = self.yOffset + distance;
    [self setYOffset:destination animated:animated];
}

@end
