//
//  CDPullBottomBar.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/16/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDPullBottomBar.h"
#import "Header.h"
#import "CDSliderProgressView.h"
#import "CDSliderThumb.h"
#import "CDPlayButton.h"

@interface CDPullBottomBar ()
- (void)initialize;
- (CGRect)progressViewFrameWithHidding:(BOOL)hidding;
- (CGRect)sliderThumbFrame;
- (void)sliderThumbChangedValue:(id)sender;
- (CGRect)playButtonFrame;
- (CGRect)backwardButtonFrame;
- (CGRect)forwardButtonFrame;
- (void)buttonTouchedUpInside:(id)sender;
- (CGRect)playbackTimeLabelFrame;
- (CGRect)remainingTimeLabelFrame;
void configureLabel(UILabel* label);
NSString* textWithTimeInterval(NSTimeInterval timeInterval);
@end
@implementation CDPullBottomBar
@synthesize hidden = _hidden;
@synthesize sliderThumb = _sliderThumb, progressView = _progressView;
@synthesize playButton = _playButton, backwardButton = _backwardButton, forwardButton = _forwardButton, playbackTimeLabel = _playbackTimeLabel, remainingTimeLabel = _remainingTimeLabel;
@synthesize delegate = _delegate;
@synthesize playButtonState = _playButtonState;

- (void)setHidden:(BOOL)hidden{
    _progressView.frame = [self progressViewFrameWithHidding:hidden];
    if (hidden) {
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        _progressView.alpha = kBarAlpha;
    }else{
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        _progressView.alpha = 1.0f;
    }
    self.userInteractionEnabled = !hidden;
    _hidden = hidden;
}

#pragma mark - SuperClass Methods
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize{
    
    self.backgroundColor = [UIColor clearColor];
    /*
    self.layer.shadowColor = UIColor.blackColor.CGColor;
    self.layer.shadowOffset = CGSizeMake(0., -1.);
    self.layer.shadowOpacity = .8;
    */
    
    _playButton = [[CDPlayButton alloc] initWithFrame:self.playButtonFrame];
    [self addSubview:_playButton];
    _playButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [_playButton addTarget:self action:@selector(buttonTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    _backwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backwardButton.frame = self.backwardButtonFrame;
    [_backwardButton setImage:[UIImage pngImageWithName:kBackwardButtonName] forState:UIControlStateNormal];
    [_backwardButton setImage:[UIImage pngImageWithName:kBackwardButtonDownName] forState:UIControlStateHighlighted];
    [self addSubview:_backwardButton];
    _backwardButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [_backwardButton addTarget:self action:@selector(buttonTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    _forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];    
    _forwardButton.frame = self.forwardButtonFrame;
    [_forwardButton setImage:[UIImage pngImageWithName:kForwardButtonName] forState:UIControlStateNormal];
    [_forwardButton setImage:[UIImage pngImageWithName:kForwardButtonDownName] forState:UIControlStateHighlighted];
    [self addSubview:_forwardButton];
    _forwardButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [_forwardButton addTarget:self action:@selector(buttonTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    _progressView = [[CDSliderProgressView alloc] initWithFrame:[self progressViewFrameWithHidding:NO]];
    [self addSubview:_progressView];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    _sliderThumb = [[CDSliderThumb alloc] initWithFrame:self.sliderThumbFrame];
    [self addSubview:_sliderThumb];
    _sliderThumb.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [_sliderThumb addTarget:self action:@selector(sliderThumbChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    _playbackTimeLabel = [[UILabel alloc] initWithFrame:self.playbackTimeLabelFrame];
    [self addSubview:_playbackTimeLabel];
    _playbackTimeLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _playbackTimeLabel.text = @"00:00:00";
    configureLabel(_playbackTimeLabel);
    
    _remainingTimeLabel = [[UILabel alloc] initWithFrame:self.remainingTimeLabelFrame];
    [self addSubview:_remainingTimeLabel];
    _remainingTimeLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _remainingTimeLabel.text = @"-00:00:00";
    configureLabel(_remainingTimeLabel);

    //_progressView.backgroundColor = kDebugColor;
    
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CDColorFinder* colorFinder = [[CDColorFinder alloc] init];
    UIColor * startColor = colorFinder.colorOfBarDark;
    UIColor * endColor = colorFinder.colorOfBarLight;
    //UIColor* startColor = [UIColor colorWithHex:0x4a4b4a];
    //UIColor* endColor = [UIColor colorWithHex:0x282928];
    NSArray* colors = [NSArray arrayWithObjects:(id)[startColor CGColor], (id)[endColor CGColor], nil];
    CGGradientRef gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(),
                                                        (__bridge CFArrayRef)colors,
                                                        NULL);
    CGContextDrawLinearGradient(context,
                                gradient,
                                CGPointMake(rect.origin.x, rect.origin.y + kBottomProgressHeight),
                                CGPointMake(rect.origin.x, rect.origin.y + kBottomProgressHeight + kBottomBarHeight),
                                0);
    CGGradientRelease(gradient);
}

#pragma mark - Slider
- (CGRect)progressViewFrameWithHidding:(BOOL)hidding{
    CGRect frame = CGRectZero;
    if (hidding) {
        frame = CGRectMake(0.0f, 1.0f, self.bounds.size.width, kSliderProgressViewHeight);
        frame = CGRectInset(frame, - kSliderProgressThumbWidth / 2, 0.0f);
    }else{
        frame = CGRectInset(self.sliderThumbFrame,
                            (kThumbWidth - kSliderProgressThumbWidth) / 2,
                            0.0f);
        frame = CGRectMake(frame.origin.x, kSliderProgressViewOffsetY, frame.size.width, kSliderProgressViewHeight);
    }
    return frame;
}

- (CGRect)sliderThumbFrame{
    CGRect frame = CGRectMake(kSliderLeftAndRightMargin,
                              kSliderProgressViewOffsetY - (kThumbHeight - kSliderProgressViewHeight) / 2,
                              self.bounds.size.width - 2 * kSliderLeftAndRightMargin,
                              kThumbHeight);
    return frame;
}

- (void)sliderThumbChangedValue:(id)sender {
    float value = [(CDSliderThumb*)sender value];
    if (_sliderThumb.thumbOn) {
        [_progressView setProgress:value];    //When thumbOn is YES, the progress depends on thumb.
        
        NSTimeInterval duration = [_delegate bottomBarAskForDuration:self];
        NSTimeInterval playbackTime = value * duration;
        [self setLabelsPlaybackTime:playbackTime];
    }else{
        [_delegate bottomBar:self sliderValueChangedAs:value];  //When thumbOn is NO, the value can be sent to instance outside.
    }
}

- (void)setSliderValue:(float)sliderValue{
    if (!_sliderThumb.thumbOn) {
        [_progressView setProgress:sliderValue];    //When thumbOn is NO, the progress depends on player.
        _sliderThumb.value = sliderValue;   //When thumbOn is NO, the value can be set by outside instance.
        
    }
}

#pragma mark - Buttons
- (CGRect)playButtonFrame{
    CGRect frame = CGRectMake(self.center.x - kPlayButtonSize / 2,
                              kBottomProgressHeight + kPlayButtonTopMargin, kPlayButtonSize, kPlayButtonSize);
    return frame;
}

- (CGRect)backwardButtonFrame{
    CGRect frame = CGRectMake(CGRectGetMinX(_playButton.frame) - kOtherButtonsGapFromPlayButton - kOtherButtonsSize,
                              _playButton.center.y - kOtherButtonsSize / 2
                              , kOtherButtonsSize, kOtherButtonsSize);
    return frame;
}

- (CGRect)forwardButtonFrame{
    CGRect frame = CGRectMake(CGRectGetMaxX(_playButton.frame) + kOtherButtonsGapFromPlayButton,
                              _playButton.center.y - kOtherButtonsSize / 2,
                              kOtherButtonsSize, kOtherButtonsSize);
    return frame;
}

- (void)buttonTouchedUpInside:(id)sender {
    if (sender == _playButton) {
        [_delegate bottomBar:self buttonFire:CDBottomBarButtonTypePlay];
    }else if (sender == _backwardButton) {
        [_delegate bottomBar:self buttonFire:CDBottomBarButtonTypeBackward];
    }else if (sender == _forwardButton){
        [_delegate bottomBar:self buttonFire:CDBottomBarButtonTypeForward];
    }
}

- (void)setPlayButtonState:(CDBottomBarPlayButtonState)playButtonState{
    switch (playButtonState) {
        case CDBottomBarPlayButtonStatePlaying:
            self.playButton.buttonState = ZenPlayerButtonStatePlaying;
            break;
        case CDBottomBarPlayButtonStatePaused:
            self.playButton.buttonState = ZenPlayerButtonStateNormal;
            break;
        default:
            break;
    }
    _playButtonState = playButtonState;
}

#pragma mark - Labels
- (CGRect)playbackTimeLabelFrame{
    CGPoint progressViewCenter = self.progressView.center;
    CGRect frame = CGRectMake(kLabelHorizontalMargin,
                              progressViewCenter.y - (kLabelHeight) / 2,
                              kLabelWidth, kLabelHeight);
    return frame;
}

- (CGRect)remainingTimeLabelFrame{
    CGPoint progressViewCenter = self.progressView.center;
    CGRect frame = CGRectMake(self.bounds.size.width - kLabelHorizontalMargin - kLabelWidth,
                              progressViewCenter.y - (kLabelHeight) / 2,
                              kLabelWidth, kLabelHeight);
    return frame;
}

void configureLabel(UILabel* label){
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = kDebugColor;
    UIFont* font = [UIFont boldSystemFontOfSize:12.0f];
    label.font = font;
    label.textAlignment = NSTextAlignmentCenter;
}

NSString* textWithTimeInterval(NSTimeInterval timeInterval){
    NSString* string = nil;
    if (timeInterval < 0) {
        timeInterval = - timeInterval;
        if (timeInterval < 3600) {
            string = [NSString stringWithFormat:@"-%02li:%02li",
                      lround(floor(timeInterval / 60.)) % 60,
                      lround(floor(timeInterval)) % 60];
        }else{
            string = [NSString stringWithFormat:@"-%02li:%02li:%02li",
                      lround(floor(timeInterval / 3600.)) % 100,
                      lround(floor(timeInterval / 60.)) % 60,
                      lround(floor(timeInterval)) % 60];
        }
    }else{
        if (timeInterval < 3600) {
            string = [NSString stringWithFormat:@"%02li:%02li",
                      lround(floor(timeInterval / 60.)) % 60,
                      lround(floor(timeInterval)) % 60];
        }else{
            string = [NSString stringWithFormat:@"%02li:%02li:%02li",
                      lround(floor(timeInterval / 3600.)) % 100,
                      lround(floor(timeInterval / 60.)) % 60,
                      lround(floor(timeInterval)) % 60];
        }
    }
    return string;
}

- (void)setLabelsPlaybackTime:(NSTimeInterval)playbackTime{
    NSTimeInterval duration = [_delegate bottomBarAskForDuration:self];
    NSTimeInterval remainingTime = playbackTime - duration;
    _playbackTimeLabel.text = textWithTimeInterval(playbackTime);
    _remainingTimeLabel.text = textWithTimeInterval(remainingTime);
    //DLog(@"%@   %@",_playbackTimeLabel.text, _remainingTimeLabel.text);
}

#pragma mark - Reload
- (void)reloadData{

}

@end
