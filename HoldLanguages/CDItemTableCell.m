//
//  CDItemTableCell.m
//  HoldLanguages
//
//  Created by William Remaerd on 3/24/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDItemTableCell.h"
#import "CDScrollLabel.h"
#import "CDString.h"
#import "CDItem.h"
#import "CoreDataModels.h"

@interface CDItemTableCell ()

- (UIView *)initializeStandard;
- (UIView *)initializeDetail;

- (void)updateProgress:(NSTimer *)timer;
@end

@implementation CDItemTableCell
@synthesize title = _title, stageView = _stageView, progressLabel = _progressLabel;
@dynamic isProgressive;

#pragma mark - Class Basic
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *view = [self initializeStandard];
        
        [self.contentView addSubview:view];
    }
    return self;
}

- (UIView *)initializeStandard{
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.autoresizingMask = CDViewAutoresizingNoMaigin;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectInset(view.bounds, 10.0f, 0.0f)];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont boldSystemFontOfSize:17];
    title.textAlignment = UITextAlignmentLeft;
    title.autoresizingMask = CDViewAutoresizingNoMaigin;
    
    self.title = title;
    [view addSubview:title];
    
    self.stageView = view;
    
    return view;
}

#pragma mark - Configure
- (void)configureWithDictionary:(NSDictionary *)dictionary{
    self.isProgressive = NO;
    [self invalidateUpdater];

    NSString *title = [dictionary objectForKey:@"title"];
    NSAssert(title != nil, @"\n%@\nDictionary must contains object with key 'title'.", NSStringFromSelector(@selector(_cmd)));
    _title.text = title;
}

- (void)configureWithItem:(Item *)item{
    _title.text = item.title;
    
    ItemStatus status = item.status.integerValue;
    switch (status) {
        case ItemStatusInit:{
            self.isProgressive = NO;
            [self invalidateUpdater];
        }break;
        case ItemStatusDownloading:{
            self.isProgressive = YES;
            self.progress = item.progress.floatValue;
            [self setupUpdaterWithItem:item];
        }break;
        case ItemStatusDownloaded:{
            self.isProgressive = YES;
            self.progress = 1.0f;
            [self invalidateUpdater];
        }break;
        default:
            break;
    }
}

#pragma mark - Progress
- (void)setProgress:(float)progress{
    if (_progressLabel == nil) return;
    if (progress == 1.0f) {
        _progressLabel.text = @"√";
        return;
    }
    NSString *str = [[NSString alloc] initWithFormat:@"%2.0f%%", progress * 100];
    _progressLabel.text = str;
}

#pragma mark - Updater
- (void)setupUpdaterWithItem:(Item *)item{
    _updater = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateProgress:) userInfo:item repeats:YES];
}

- (void)invalidateUpdater{
    [_updater invalidate]; _updater = nil;
}

- (void)updateProgress:(NSTimer *)timer{
    Item *item = (Item *)timer.userInfo;
    self.progress = item.progress.floatValue;
}

#pragma mark - Progressive
- (void)setIsProgressive:(BOOL)isProgressive{
    [self setIsProgressive:isProgressive animated:NO];
}

- (void)setIsProgressive:(BOOL)isProgressive animated:(BOOL)animated{
    if (_isProgressive == isProgressive) return;
    _isProgressive = isProgressive;
    
    CGRect bounds = self.contentView.bounds;
    CGFloat indent = 55.0f;
    if (isProgressive) {
        CGRect lF = CGRectOffset(bounds, CGRectGetWidth(bounds), 0.0f); //label frame
        lF.size.width = indent;
        UILabel *label = [[UILabel alloc] initWithFrame:lF];
        label.font = [UIFont boldSystemFontOfSize:20.0f];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = UITextAlignmentCenter;
        label.backgroundColor = [UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        self.progressLabel = label;
        [self.contentView addSubview:label];
        
        CGRect sTF = _stageView.frame;
        sTF.size.width = CGRectGetWidth(sTF) - indent;
        CGRect lTF = CGRectOffset(lF, -indent, 0.0f);
        
        if (animated) {
            [UIView animateWithDuration:0.3f animations:^{
                _stageView.frame = sTF;
                _progressLabel.frame = lTF;
            }];
        }else{
            _stageView.frame = sTF;
            _progressLabel.frame = lTF;
        }
        
        self.progress = 0;
    }else{
        CGRect sTF = _stageView.frame;
        sTF.size.width = CGRectGetWidth(sTF) + indent;
        CGRect lTF = CGRectOffset(_progressLabel.frame, indent, 0.0f);
        
        if (animated) {
            [UIView animateWithDuration:0.3f animations:^{
                _stageView.frame = sTF;
                _progressLabel.frame = lTF;
            } completion:^(BOOL finished) {
                if (finished) {
                    [_progressLabel removeFromSuperview];
                    self.progressLabel = nil;
                }
            }];
        }else{
            _stageView.frame = sTF;
            _progressLabel.frame = lTF;
            [_progressLabel removeFromSuperview];
            self.progressLabel = nil;
        }
    }
}


@end
