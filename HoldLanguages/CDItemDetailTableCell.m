//
//  CDItemDetailTableCell.m
//  HoldLanguages
//
//  Created by William Remaerd on 3/27/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDItemDetailTableCell.h"
#import "CDItem.h"
#import "CoreDataModels.h"
#import "CDColorFinder.h"

@interface CDItemTableCell ()
@property(nonatomic, strong)IBOutlet UIView *detailsView;
@property(nonatomic, strong)IBOutlet UILabel *content;
@property(nonatomic, strong)IBOutlet UIImageView *image;
@property(nonatomic, strong)IBOutlet UIImageView *audioSymbol;
@property(nonatomic, strong)IBOutlet UIImageView *lyricsSymbol;
+ (CGFloat)heightOfTitleWithItem:(Item *)item;
@end


@implementation CDItemDetailTableCell
@synthesize
detailsView = _detailsView,
content = _content,
image = _image,
audioSymbol = _audioSymbol,
lyricsSymbol = _lyricsSymbol;

#pragma mark - Class Basic
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _isProgressive = YES;   //For progressLabel in the xib is convenient to edit when it is progressive.
        
        UIView *view = [UIView viewFromXibNamed:NSStringFromClass(self.class) owner:self];
        view.frame = self.contentView.bounds;
        _audioSymbol.backgroundColor = [CDColorFinder colorOfAudio];
        _lyricsSymbol.backgroundColor = [CDColorFinder colorOfLyrics];
        _progressLabel.backgroundColor = [CDColorFinder colorOfDownloads];
        
        self.stageView = view;
        [self.contentView addSubview:view];
    }
    return self;
}

#pragma mark - Configure
- (void)configureWithItem:(Item *)item{
    
    _title.text = item.title;
    
    CGRect frame = _title.frame; frame.size.height = [CDItemDetailTableCell heightOfTitleWithItem:item];
    _title.frame = frame;
    _title.numberOfLines = _title.numberOfLinesFitsWidth;
    
    _content.text = item.content.content;
    
    Image *image = item.anyImage;
    _image.image = [[UIImage alloc] initWithContentsOfFile:item.anyImage.absolutePath];
    CGRect cFrame = _content.frame; //Content frame
    if (image) {
        cFrame.origin.x = 98.0f;
        cFrame.size.width = 121.0f;
        _content.frame = frame;
    }else{
        cFrame.origin.x = 0.0f;
        cFrame.size.width = 219.0f;
    }
    _content.frame = cFrame;

    _audioSymbol.hidden = item.audio == nil;
    _lyricsSymbol.hidden = item.lyrics == nil;

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

- (void)loadImage:(UIImage *)image{
    _image.image = image;
}

#pragma mark - Progressive
- (void)setIsProgressive:(BOOL)isProgressive animated:(BOOL)animated{
    if (_isProgressive == isProgressive) return;
    _isProgressive = isProgressive;
    
    UILabel *label = self.progressLabel;
    CGPoint oringnal = CGPointMake(0.5 * CGRectGetWidth(label.bounds), 0.5 * CGRectGetHeight(label.bounds));
    if (isProgressive) {
        
        if (animated) {
            [UIView animateWithDuration:0.3f animations:^{
                label.center = oringnal;
            }];
        }else{
            label.center = oringnal;
        }
        
        self.progress = 0;
    
    }else{
        oringnal.x += CGRectGetWidth(label.bounds);
        if (animated) {
            [UIView animateWithDuration:0.3f animations:^{
                label.center = oringnal;
            }];
        }else{
            label.center = oringnal;
        }
    }
}

#pragma mark - Height
+ (CGFloat)heightOfTitleWithItem:(Item *)item{
    UIFont *titleFont = [UIFont boldSystemFontOfSize:17.0f];
    CGFloat titleWidth = 252.0f;
    
    NSString *title = item.title;
    CGSize size = [title sizeWithFont:titleFont constrainedToSize:CGSizeMake(titleWidth, CGFLOAT_MAX)];

    //CGSize size = [title sizeWithFont:titleFont forWidth:titleWidth lineBreakMode:NSLineBreakByWordWrapping];
    
    return size.height;
}


+ (CGFloat)heightWithItem:(Item *)item{
    CGFloat restHeight = 120.0f;
    CGFloat titleHeight = [CDItemDetailTableCell heightOfTitleWithItem:item];
    
    return titleHeight + restHeight;
}

@end
