//
//  CDBackgroundView.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/21/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDBackgroundView.h"
#import "Header.h"

@interface CDBackgroundView ()
- (void)createMissingLyricsView;
- (void)destroyMissingLyricsView;
@end

@implementation CDBackgroundView
@synthesize missingLyrics = _missingLyrics, audioName = _audioName;
@synthesize dataSource = _dataSource;
- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

- (void)switchViewWithKey:(CDBackgroundViewKey)key{
    switch (key) {
        case CDBackgroundViewKeyNone:{
            [self destroyMissingLyricsView];
        }break;
        case CDBackgroundViewKeyMissingLyrics:{
            [self createMissingLyricsView];
        }break;
        default:
            break;
    }
}

- (void)createMissingLyricsView{
    if (_missingLyrics == nil) {
        _missingLyrics = [UIView viewFromXibNamed:@"CDBackgroundView" owner:self atIndex:0];
        [self addSubview:_missingLyrics];
    }
    NSString* audioName = [_dataSource backgroundViewNeedsAudioName:self];
    _audioName.text = [[NSString alloc] initWithFormat:@"%@.lrc", audioName];
    _missingLyrics.backgroundColor = [UIColor clearColor];
    _missingLyrics.center = self.center;
}

- (void)destroyMissingLyricsView{
    [_missingLyrics removeFromSuperview];
    _missingLyrics = nil;
}

@end
