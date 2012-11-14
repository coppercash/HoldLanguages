//
//  CDLyricsViewCell.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/13/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDLyricsViewCell.h"
#import "Header.h"

@implementation CDLyricsViewCell
@synthesize style = _style;
@synthesize content = _content;

- (id)initWithLyricsStyle:(CDLyricsViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        _style = style;
        [self initialize];
    }
    return self;
}

- (void)initialize{
    switch (self.style) {
        case CDLyricsViewCellStyleHeader:{
            
        }break;
        case CDLyricsViewCellStyleLyrics:{
            _content = [[UILabel alloc] init];
            [self.contentView addSubview:_content];
            _content.frame = self.contentView.bounds;
            
            _content.backgroundColor = kDebugColor;
        }break;
        case CDLyricsViewCellStyleFooter:{
            self.contentView.backgroundColor = [UIColor blackColor];
        }break;
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
