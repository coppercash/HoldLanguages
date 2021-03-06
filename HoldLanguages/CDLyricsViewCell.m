//
//  CDLyricsViewCell.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/13/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDLyricsViewCell.h"
#import "CDLRCLyrics.h"

@implementation CDLyricsViewCell
@synthesize style = _style;
@synthesize content = _content;

- (id)initWithLyricsStyle:(CDLyricsViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        _style = style;
        [self initialize];
    }
    return self;
}

- (void)initialize{
    UILabel * (^initContent)(void) = ^{
        CGFloat hM = CGRectGetWidth(self.contentView.bounds) * kHorizontalMarginRate;   //horizontal Margin
        CGRect cF = CGRectInset(self.contentView.bounds, hM, 0.0f);
        UILabel *content = [[UILabel alloc] initWithFrame:cF];
        content.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        content.textAlignment = NSTextAlignmentLeft;
        content.backgroundColor = [UIColor clearColor];
        content.font = [UIFont systemFontOfSize:kContentFontSize];
        content.numberOfLines = _content.numberOfLinesFitsWidth;

        return content;
    };
    
    self.contentView.backgroundColor = [UIColor clearColor];
    switch (self.style) {
        case CDLyricsViewCellStyleHeader:{
            _content = initContent();
            _content.textColor = [UIColor darkGrayColor];
            [self.contentView addSubview:_content];

        }break;
        case CDLyricsViewCellStyleLyrics:{
            _content = initContent();
            _content.textColor = [UIColor whiteColor];
            [self.contentView addSubview:_content];
        }break;
        case CDLyricsViewCellStyleFooter:{
            
        }break;
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (CGFloat)recommendHeight{
    CGFloat rH = _content.heightFitsWidth;  //Recommend Height
    return rH;
}
/*
- (void)setLyricsInfo:(NSArray*)info{
    if (_style != CDLyricsViewCellStyleHeader) return;
    if (info == nil) return;
    
    UIView *contentView = self.contentView;
    
    //Return exist label, or alloc new one if no available label. 
    NSArray *subviews = contentView.subviews;
    __block NSUInteger indicater = 0;
    UILabel *(^getLabel)(void) = ^{
        UILabel *label = nil;
        if (indicater < subviews.count) {
            label = [subviews objectAtIndex:indicater];
            indicater ++;
        }else{
            label = [[UILabel alloc] init];
        }
        return label;
    };
    
    CGFloat height = CGRectGetHeight(contentView.bounds);
    CGFloat margin = height * 0.2f;
    CGFloat labelHeight = (height - 2 * margin) / info.count;
    void (^configLabel)(UILabel*, NSUInteger, NSDictionary*) =
    ^(UILabel *label, NSUInteger index, NSDictionary *dic){
        CGRect frame = contentView.bounds;
        frame.size.height = labelHeight;
        frame.origin.y = index * labelHeight + margin;
        label.frame = frame;
        
        NSString *type = [dic valueForKey:gKeyStampType];
        NSString *content = [dic valueForKey:gKeyStampContent];
        label.text = [[NSString alloc] initWithFormat:@"%@:\t%@", type, content];
        
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.adjustsFontSizeToFitWidth = YES;
    };
    
    //Refer to "info" array, configure the label.
    int index = 0;
    for (NSDictionary *dic in info) {
        UILabel *label = getLabel();
        configLabel(label, index, dic);
        [contentView addSubview:label];
        
        index ++;
    }
    
    //If number of info is less than number of exist labels, release the unnecessary. 
    for (; indicater < subviews.count; indicater++) {
        UILabel *label = [subviews objectAtIndex:indicater];
        [label removeFromSuperview];
    }
}
*/
@end
