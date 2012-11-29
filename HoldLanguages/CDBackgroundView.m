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
- (void)createAssistView;
- (void)destroyAssistView;
@end

@implementation CDBackgroundView
@synthesize missingLyrics = _missingLyrics, audioName = _audioName, assistView = _assistView;
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
            [self destroyAssistView];
        }break;
        case CDBackgroundViewKeyMissingLyrics:{
            [self destroyAssistView];
            
            [self createMissingLyricsView];
        }break;
        case CDBackgroundViewKeyAssist:{
            [self destroyMissingLyricsView];
            
            [self createAssistView];
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
    _missingLyrics.backgroundColor = [UIColor clearColor];
    _missingLyrics.center = self.center;
    _missingLyrics.alpha = 0.0f;
    NSString* audioName = [_dataSource backgroundViewNeedsAudioName:self];
    _audioName.text = [[NSString alloc] initWithFormat:@"%@.lrc", audioName];
    
    void(^animations)(void) = ^(void){
        _missingLyrics.alpha = 1.0f;
    };
    [UIView animateWithDuration:kSwitchAnimationDuration animations:animations];
}

- (void)destroyMissingLyricsView{
    if (_missingLyrics == nil) return;
    void(^animations)(void) = ^(void){
        _missingLyrics.alpha = 0.0f;
    };
    void(^completion)(BOOL) = ^(BOOL finished){
        [_missingLyrics removeFromSuperview];
        _missingLyrics = nil;
    };
    [UIView animateWithDuration:kSwitchAnimationDuration animations:animations completion:completion];
}

- (void)createAssistView{
    if (_assistView == nil) {
        _assistView = [UIView viewFromXibNamed:@"CDBackgroundView" owner:self atIndex:1];
        [self addSubview:_assistView];
    }
    _assistView.backgroundColor = [UIColor clearColor];
    _assistView.frame = CGRectMake(0.0f,
                                   CGRectGetMidY(self.frame) - _assistView.bounds.size.height / 2,
                                   self.bounds.size.width,
                                   _assistView.bounds.size.height);
    _assistView.alpha = 0.0f;

    void(^animations)(void) = ^(void){
        _assistView.alpha = 1.0f;
    };
    [UIView animateWithDuration:kSwitchAnimationDuration animations:animations];
}

- (void)destroyAssistView{
    if (_assistView == nil) return;
    void(^animations)(void) = ^(void){
        _assistView.alpha = 0.0f;
    };
    void(^completion)(BOOL) = ^(BOOL finished){
        [_assistView removeFromSuperview];
        _assistView = nil;
    };
    [UIView animateWithDuration:kSwitchAnimationDuration animations:animations completion:completion];
}

@end
