//
//  CDiTunesViewCell.m
//  HoldLanguages
//
//  Created by William Remaerd on 1/13/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDiTunesViewCell.h"
#import "CDFileItem.h"
#import "CDScrollLabel.h"

@implementation CDiTunesViewCell
@synthesize icon = _icon, name = _name;
static CGPoint gIconCenter;
static CGRect gNameFrame;
- (id)initWithReuseIdentifier:(NSString *)identifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (self) {
        [self loadSubviewsFromXib];
        gIconCenter = _icon.center;
        gNameFrame = _name.frame;
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _name.textColor = [UIColor whiteColor];
        _name.font = [UIFont boldSystemFontOfSize:17];
        _name.textAlignment = UITextAlignmentLeft;
        _name.delegate = self;
    }
    return self;
}

- (void)configureWithItem:(CDFileItem *)item{
    NSString *fileName = item.name;
    _name.text = fileName;
    
    self.selectionStyle = UITableViewCellSelectionStyleBlue;
    [self setDegree:item.degree];
    if (item.isDirectory) {
        _icon.image = [UIImage pngImageWithName:item.isOpened ? kFileIconDirectoryOpened : kFileIconDirectory];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if ([fileName.pathExtension caseInsensitiveCompare:@"lrc"] == NSOrderedSame){
        _icon.image = [UIImage pngImageWithName:kFileIconLRC];
    }else if ([fileName.pathExtension caseInsensitiveCompare:@"mp3"] == NSOrderedSame){
        _icon.image = [UIImage pngImageWithName:kFileIconAudio];
    }
}

- (void)setDegree:(NSUInteger)degree{
    CGFloat indentation = 20.0f * (degree - 1);
    if (_icon.center.x == gIconCenter.x + indentation) return;
    
    CGPoint center = _icon.center;
    center.x = gIconCenter.x + indentation;
    _icon.center = center;
    
    CGRect frame = _name.frame;
    frame.origin.x = CGRectGetMinX(gNameFrame) + indentation;
    frame.size.width = CGRectGetWidth(gNameFrame) - indentation;
    _name.frame = frame;
}

#pragma mark - CDScrollLabelDelegate
#define kAnimationInterval 5.0f
- (NSTimeInterval)scrollLabelShouldStartAnimating:(CDScrollLabel *)scrollLabel{
    return kAnimationInterval;
}

- (NSTimeInterval)scrollLabelShouldContinueAnimating:(CDScrollLabel *)scrollLabel{
    return kAnimationInterval;
}

@end
