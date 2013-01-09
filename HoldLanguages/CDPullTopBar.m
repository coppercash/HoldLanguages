#import "CDPullTopBar.h"
#import "Header.h"

@interface CDPullTopBar ()
- (void)initialize;
- (CGRect)pullButtonFrame;
@end
@implementation CDPullTopBar
@synthesize artist = _artist, title = _title, albumTitle = _albumTitle;
@synthesize pullButton = _pullButton, rotationLock = _rotationLock, assistButton = _assistButton;
@synthesize delegate = _delegate, dataSource = _dataSource;
#pragma mark - UIView Method
- (void)initialize{
    
    self.backgroundColor = [UIColor clearColor];
    /*
    self.layer.shadowColor = UIColor.blackColor.CGColor;
    self.layer.shadowOffset = CGSizeMake(0., 5.);
    self.layer.shadowOpacity = .8;
    UIBezierPath* path = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.shadowPath = path.CGPath;
    */
    
    _pullButton = [[UIImageView alloc] initWithPNGImageNamed:kPullButtonImageName];
    _pullButton.frame = self.pullButtonFrame;
    [self addSubview:_pullButton];
    _pullButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    _pullButton.alpha = kBarAlpha;
    
    [self loadSubviewsFromXibNamed:@"CDPullTopBar"];
    
    _title.textColor = [UIColor whiteColor];
    _artist.textColor = _albumTitle.textColor = [UIColor lightGrayColor];
    UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
    _title.font = _artist.font = _albumTitle.font = font;
    
    _rotationLock.delegate = self;
    [_rotationLock addPNGFilesNormal:@"RotationLock" highlighted:@"RotationLockDown"];
    [_rotationLock addPNGFilesNormal:@"RotationUnlock" highlighted:@"RotationUnlockDown"];
    
    _assistButton.delegate = self;
    [_assistButton addPNGFilesNormal:@"AssistButton" highlighted:@"AssistButtonDown"];
    [_assistButton addPNGFilesNormal:@"AssistButtonDown" highlighted:@"AssistButton"];
}

- (id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    DLogRect(frame);
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CDColorFinder* colorFinder = [[CDColorFinder alloc] init];
    UIColor * startColor = colorFinder.colorOfBarDark;
    UIColor * endColor = colorFinder.colorOfBarLight;

    NSArray* colors = [NSArray arrayWithObjects:(id)[startColor CGColor], (id)[endColor CGColor], nil];
    CGGradientRef gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(),
                                                        (__bridge CFArrayRef)colors,
                                                        NULL);
    CGContextDrawLinearGradient(context,
                                gradient,
                                CGPointMake(rect.origin.x, rect.origin.y),
                                CGPointMake(rect.origin.x, kTopBarVisualHeight),
                                0);
    CGGradientRelease(gradient);
}

#pragma mark - Touch
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint location = [touch locationInView:self];
    _yStartOffset = location.y;
    if (_delegate && [_delegate respondsToSelector:@selector(topBarStartPulling:)]) {
        [_delegate topBarStartPulling:self];
    }
    return YES; 
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    //CGPoint location = [touch locationInView:self];
    CGPoint locationInSuperView = [touch locationInView:self.superview];
    _yLastOffset = locationInSuperView.y;
    if (_delegate && [_delegate respondsToSelector:@selector(topBarContinuePulling:shouldMoveTo:)]) {
        CGFloat yOffset = locationInSuperView.y - _yStartOffset;
        BOOL shouldMove = [_delegate topBarContinuePulling:self shouldMoveTo:yOffset];
        if (shouldMove) {
            self.center = CGPointMake(self.center.x, yOffset + CGRectGetHeight(self.frame) / 2);
        }
    }
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint locationInSuperView = [touch locationInView:self.superview];
    BOOL isDownward = locationInSuperView.y > _yLastOffset;
    if (isDownward) {
        if (_delegate && [_delegate respondsToSelector:@selector(topBarFinishPulling:)]) {
            [_delegate topBarFinishPulling:self];
        }
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(topBarCancelPulling:)]) {
            [_delegate topBarCancelPulling:self];
        }
    }
    _yStartOffset = 0.0f;
    _yLastOffset = 0.0f;
}

- (void)cancelTrackingWithEvent:(UIEvent *)event{
    _yStartOffset = 0.0f;
    _yLastOffset = 0.0f;
    if (_delegate && [_delegate respondsToSelector:@selector(topBarCancelPulling:)]) {
        [_delegate topBarCancelPulling:self];
    }
}

#pragma mark - Pull Button
- (CGRect)pullButtonFrame{
    CGRect frame = CGRectMake(self.center.x - kPullButtonEffectiveWidth / 2,
                              CGRectGetMaxY(self.bounds) - kPullButtonEffectiveHeight,
                              kPullButtonEffectiveWidth,
                              kPullButtonEffectiveHeight);
    return frame;
}
#pragma mark - Rotation Lock & Assist Button
- (NSInteger)shouldStateButtonChangedValue:(CDStateButton*)stateButton{
    if (stateButton == _rotationLock) {
        BOOL should = [_delegate topBarShouldLockRotation:self];
        if (should) {
            return CDStateButtonShouldChangeMaskNext;
        }else{
            return CDStateButtonShouldChangeMaskKeep;
        }
    } else if (stateButton == _assistButton) {
        [_delegate topBarLeftButtonTouched:self];
        return CDStateButtonShouldChangeMaskNext;
    }
    return CDStateButtonShouldChangeMaskKeep;
}

- (BOOL)isRotationLocked{
    if (_rotationLock.state == 0) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - Reload
- (void)reloadData{
    _artist.text = [_dataSource topBarNeedsArtist:self];
    _title.text = [_dataSource topBarNeedsTitle:self];
    _albumTitle.text = [_dataSource topBarNeedsAlbumTitle:self];
    [_assistButton changeStateTo:0];
}

#pragma mark - CDScrollLabelDelegate
#define kAnimationInterval 3.0f
- (NSTimeInterval)scrollLabelShouldStartAnimating:(CDScrollLabel *)scrollLabel{
    return kAnimationInterval;
}

- (NSTimeInterval)scrollLabelShouldContinueAnimating:(CDScrollLabel *)scrollLabel{
    if (!_artist.isAnimating && !_title.isAnimating && !_albumTitle.isAnimating) {
        [_artist animateAfterDelay:kAnimationInterval];
        [_title animateAfterDelay:kAnimationInterval];
        [_albumTitle animateAfterDelay:kAnimationInterval];
    }
    return -1.0f;
}

@end

