//
//  CDLyricsViewCell.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/13/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kReuseIdentifierOfStyleLyrics @"ReuseLyrics"
#define kReuseIdentifierOfStyleHeader @"ReuseHeader"
#define kReuseIdentifierOfStyleFooter @"ReuseFooter"
#define kCellOfStyleLyricsHeihgt 30.0f
typedef enum{
    CDLyricsViewCellStyleLyrics,
    CDLyricsViewCellStyleHeader,
    CDLyricsViewCellStyleFooter
}CDLyricsViewCellStyle;

@interface CDLyricsViewCell : UITableViewCell
@property(nonatomic, readonly)CDLyricsViewCellStyle style;
@property(nonatomic, strong)UILabel* content;

- (id)initWithLyricsStyle:(CDLyricsViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setLyricsInfo:(NSArray*)info;
@end
