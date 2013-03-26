//
//  CDLoadMoreControl.h
//  HoldLanguages
//
//  Created by William Remaerd on 3/24/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDLoadMoreControl : UIControl {
    BOOL _isLoadingMore;
    UIActivityIndicatorView *_activity;
    UILabel *_label;
    NSString *_info;
}
@property(nonatomic, readonly, getter = isLoadingMore)BOOL loadingMore;
@property(nonatomic, copy)NSString *info;
- (void)testLoadingMore:(UIScrollView *)scrollView;
- (void)beginLoadingMore;
- (void)endLoadingMore;
- (void)showInfo;
- (void)hideInfo;

@end
