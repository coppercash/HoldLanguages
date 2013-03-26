//
//  CDStoryView.m
//  HoldLanguages
//
//  Created by William Remaerd on 3/22/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDStoryView.h"
#import "FTCoreTextView.h"

@interface CDStoryView ()
@property(nonatomic, strong)FTCoreTextView *textView;
@end

@implementation CDStoryView
@synthesize textView = _textView;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.textView = [[FTCoreTextView alloc] initWithFrame:CGRectInset(self.bounds, 20.0f, 0.0f)];
        _textView.autoresizingMask = CDViewAutoresizingCenter;
        
        FTCoreTextStyle *tS = [FTCoreTextStyle styleWithName:@"head"];   //Title Style
        tS.textAlignment = FTCoreTextAlignementCenter;
        tS.font = [UIFont fontWithName:@"TimesNewRomanPSMT" size:40.f];
        tS.color = [UIColor whiteColor];
        tS.paragraphInset = UIEdgeInsetsMake(0, 0, 25, 0);
        
        FTCoreTextStyle *bS = [FTCoreTextStyle styleWithName:@"body"];   //Body Style
        bS.font = [UIFont fontWithName:@"TimesNewRomanPSMT" size:20.f];
        bS.color = [UIColor whiteColor];
        bS.paragraphInset = UIEdgeInsetsMake(10, 0, 10, 0);
        
        FTCoreTextStyle *iS = [FTCoreTextStyle new];    //Image Style
        iS.name = FTCoreTextTagImage;
        iS.textAlignment = FTCoreTextAlignementCenter;
        iS.paragraphInset = UIEdgeInsetsMake(0,0,0,0);
        
        NSArray *styles = [[NSArray alloc] initWithObjects:tS, bS, iS, nil];
        [_textView addStyles:styles];
        
        [self addSubview:_textView];
    }
    return self;
}

#pragma mark - Content
- (void)redrawContent{
    [_textView redraw];
}

- (void)setContentString:(NSString *)content{
    DLog(@"%@", content);
    _textView.text = content;
    [_textView fitToSuggestedHeight];
    self.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(_textView.frame));
}

- (void)setYOffset:(CGFloat)yOffset animated:(BOOL)animated{
    CGPoint offset = self.contentOffset;
    offset.y = yOffset;
    [self setContentOffset:offset animated:animated];
}

- (void)scrollFor:(CGFloat)increment animated:(BOOL)animated{
    CGFloat yTarget = self.contentOffset.y + increment;
    [self setYOffset:yTarget animated:animated];
}


@end

NSString * const gStroyTagHead = @"head";
NSString * const gStroyTagBody = @"body";
NSString * const gStroyTagImage = @"_image";
