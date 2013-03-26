//
//  CDLyricsView.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/13/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDLyricsView.h"
#import "CDLyricsViewCell.h"
#import "CDLRCLyrics.h"
#import "CDString.h"

@interface CDLyricsView ()
@property(nonatomic, strong) UITableView* lyricsTable;
@property(nonatomic, strong) UIImageView* cursor;
@property(nonatomic, copy)NSString *lyricsInfo;
- (void)initialize;
- (CGFloat)yOffset;
- (void)setYOffset:(CGFloat)yOffset animated:(BOOL)animated;
- (void)setFocusIndex:(NSUInteger)focusIndex animated:(BOOL)animated;
- (BOOL)isFocusAccurate;
@end

@implementation CDLyricsView
@synthesize focusIndex = _focusIndex, lyricsSource = _lyricsSource;
@synthesize lyricsTable = _lyricsTable, cursor = _cursor;
@synthesize lyricsInfo = _lyricsInfo;

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize{
    _animateTagetingIndex = NSUIntegerMax;
    
    self.lyricsTable = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    [self addSubview:_lyricsTable];
    _lyricsTable.dataSource = self;
    _lyricsTable.delegate = self;
    _lyricsTable.allowsSelection = NO;
    _lyricsTable.backgroundColor = [UIColor clearColor];
    _lyricsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _lyricsTable.autoresizingMask = CDViewAutoresizingNoMaigin;
    _lyricsTable.scrollsToTop = NO;
        
    self.cursor = [[UIImageView alloc] initWithPNGImageNamed:kCursorImageName];
    [self addSubview:_cursor];
    _cursor.frame = CGRectMake(self.bounds.origin.x, (self.bounds.size.height - kCursorHeight) / 2, self.bounds.size.width, kCursorHeight);
    _cursor.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
}

- (void)setLyricsSource:(id<CDLyricsViewLyricsSource>)lyricsSource{
    _lyricsSource = lyricsSource;
    [self reloadData];
}

- (void)reloadData{
    if (_lyricsSource && [_lyricsSource respondsToSelector:@selector(lyricsViewNeedsLyricsInfo:)]) {
        self.lyricsInfo = [_lyricsSource lyricsViewNeedsLyricsInfo:self];
    }
    
    [self.lyricsTable reloadData];
    [self setYOffset:0.0f animated:NO];
}

#pragma mark - Focus
- (void)setFocusIndex:(NSUInteger)focusIndex{
    [self setFocusIndex:focusIndex animated:YES];
}

- (void)setFocusIndex:(NSUInteger)focusIndex animated:(BOOL)animated{
    NSUInteger currentIndex = self.focusIndex;
    if (focusIndex == currentIndex && self.isFocusAccurate) return;
    if (animated && (focusIndex == _animateTagetingIndex)) return;
    NSUInteger maxIndexIncrement = 10;
    BOOL shouldAnimated = abs(focusIndex - currentIndex) < maxIndexIncrement;
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:focusIndex inSection:1];
    [_lyricsTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:animated && shouldAnimated];
    if (animated && shouldAnimated) _animateTagetingIndex = focusIndex;
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
static NSString *reuseIdentifierLyrics = @"ReuseLyrics";
static NSString *reuseIdentifierHeader = @"ReuseHeader";
static NSString *reuseIdentifierFooter = @"ReuseFooter";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CDLyricsViewCell* cell = nil;
    switch (indexPath.section) {
        case 0:{
            cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierHeader];
            if (cell == nil) cell = [[CDLyricsViewCell alloc] initWithLyricsStyle:CDLyricsViewCellStyleHeader reuseIdentifier:reuseIdentifierHeader];
            cell.content.text = _lyricsInfo;
        }break;
        case 1:{
            cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLyrics];
            if (cell == nil) cell = [[CDLyricsViewCell alloc] initWithLyricsStyle:CDLyricsViewCellStyleLyrics reuseIdentifier:reuseIdentifierLyrics];
            NSString* content = [self.lyricsSource lyricsView:self stringForRowAtIndex:indexPath.row];
            cell.content.text = content;
        }break;
        case 2:{
            cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierFooter];
            if (cell == nil) cell = [[CDLyricsViewCell alloc] initWithLyricsStyle:CDLyricsViewCellStyleFooter reuseIdentifier:reuseIdentifierFooter];
        }break;
        default:
            break;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger numberOfRows = 1;
    switch (section) {
        case 0:
            break;
        case 1:
            numberOfRows = (NSInteger)[self.lyricsSource numberOfLyricsRowsInView:self];;
            break;
        case 2:
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
    CGFloat (^heightWithString)(NSString *) = ^(NSString *string){
        CGFloat width = CGRectGetWidth(tableView.bounds); width *= 1 - 2 * kHorizontalMarginRate;
        CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:kContentFontSize]
                              constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                                  lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat height = size.height; height *= 1 + 2 * kVerticalMarginRate;
        return height;
    };
    
    CGFloat height = 0.0f;
    switch (indexPath.section) {
        case 0:{
            height = heightWithString(_lyricsInfo);
            
            CGFloat min = (_lyricsTable.bounds.size.height - kCellOfStyleLyricsHeihgt) / 2;
            if (height < min)  height = min;
            
            return height;
        }break;
        case 1:{
            
            NSString* content = [_lyricsSource lyricsView:self stringForRowAtIndex:indexPath.row];
            height = heightWithString(content);

            return height;
        }break;
        case 2:{
            height = (_lyricsTable.bounds.size.height - kCellOfStyleLyricsHeihgt) / 2;
        }break;
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
    //CGFloat yMin = 0.0f;
    //CGFloat yMax = _lyricsTable.contentSize.height - CGRectGetHeight(_lyricsTable.bounds);
    CGPoint offset = _lyricsTable.contentOffset;
    offset.y = limitedFloat(yOffset,
                            0.0f,
                            _lyricsTable.contentSize.height - CGRectGetHeight(_lyricsTable.bounds)
                            );
    /*
    if (yOffset < yMin) {
        offset.y = yMin;
    }else if (yOffset > yMax) {
        offset.y = yMax;
    }else{
        offset.y = yOffset;
    }*/
    [_lyricsTable setContentOffset:offset animated:animated];
}

- (void)scrollFor:(CGFloat)increment animated:(BOOL)animated{
    CGFloat yTarget = _lyricsTable.contentOffset.y + increment;
    [self setYOffset:yTarget animated:animated];
}

@end

NSString * convertedLyricsInfo(NSArray *lyricsInfos){
    NSMutableString *collector = [[NSMutableString alloc] init];
    BOOL first = YES;
    for (NSDictionary *dic in lyricsInfos) {
        NSString *content = [dic valueForKey:gKeyStampContent]; if (content.isVisuallyEmpty) continue;
        
        NSString *type = [dic valueForKey:gKeyStampType];

        if (first)
            first = NO;
        else
            [collector appendString:@"\n\n"];

        NSString *text = [[NSString alloc] initWithFormat:@"%@:\t\t%@", type, content];
        [collector appendString:text];
    }
    NSString *cS = [[NSString alloc] initWithString:collector];
    return cS;
}