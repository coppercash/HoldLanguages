//
//  CDLyricsViewCell.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/13/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>
//#define kReuseIdentifierOfStyleLyrics @"ReuseLyrics"
//#define kReuseIdentifierOfStyleHeader @"ReuseHeader"
//#define kReuseIdentifierOfStyleFooter @"ReuseFooter"
#define kHorizontalMarginRate 0.03
#define kVerticalMarginRate 0.2
#define kContentFontSize 17.0f
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
- (CGFloat)recommendHeight;
//- (void)setLyricsInfo:(NSArray*)info;
@end
