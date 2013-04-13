//
//  CDColorFinder.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/21/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDColorFinder.h"

@implementation CDColorFinder

+ (UIColor *)colorOfDownloads{
    return [UIColor color255WithRed:51.0f green:153.0f blue:51.0f alpha:1.0f];
}

+ (UIColor *)colorOfFileSharing{
    return [UIColor color255WithRed:27.0f green:161.0f blue:226.0f alpha:1.0f];
}

+ (UIColor *)colorOfAudio{
    return [UIColor color255WithRed:229.0f green:20.0f blue:0.0f alpha:1.0f];
}

+ (UIColor *)colorOfLyrics{
    return [UIColor color255WithRed:222.0f green:147.0f blue:23.0f alpha:1.0f];
}

+ (UIColor *)colorOfRates{
    return [UIColor color255WithRed:240.0f green:130.0f blue:51.0f alpha:1.0f];
}

+ (UIColor *)colorOfPages{
    return [UIColor color255WithRed:3.0f green:72.0f blue:136.0f alpha:1.0f];
}

+ (UIColor *)colorOfRepeat{
    return [UIColor color255WithRed:150.0f green:178.0f blue:50.0f alpha:1.0f];
}

+ (UIColor *)colorOfBackgroundDraw{
    return [UIColor darkGrayColor];
}

+ (UIColor *)colorOfBars{
    return [UIColor color255WithRed:0.0f green:115.0f blue:180.0f alpha:1.0f];
}

@end


@implementation UIView (Shadow)

- (void)shadowed{
    CALayer *layer = self.layer;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOpacity = 0.7f;
    layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
    layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectInset(self.bounds, - 2.0f, - 2.0f)].CGPath;
}

- (void)deshadowed{
    CALayer *layer = self.layer;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOpacity = 0.0f;
    layer.shadowOffset = CGSizeMake(0.0, - 3.0);
    layer.shadowPath = nil;
}

@end


@implementation UITableViewController (Theme)
- (void)formated{
    UITableView *tableView = self.tableView;
    tableView.separatorColor = [UIColor darkGrayColor];
    tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage pngImageWithName:@"iTunesColorPattern"]];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [tableView addGestureRecognizer:swipe];
    
    UIRefreshControl *refresher = [[UIRefreshControl alloc] init];
    self.refreshControl = refresher;
    [refresher addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
}
@end