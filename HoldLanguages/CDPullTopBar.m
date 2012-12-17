#import "CDPullTopBar.h"
#import "CDLabel.h"
#import "Header.h"

@interface CDPullTopBar ()
- (void)initialize;
- (CGRect)pullButtonFrame;
- (void)touchPullButtonDown;
- (void)touchPullButtonUpInside;
- (void)touchPullButtonUpOutside;
@end
@implementation CDPullTopBar
@synthesize artistTemplate = _artistTemplate, titleTemplate = _titleTemplate, albumTitleTemplate = _albumTitleTemplate, artist = _artist, title = _title, albumTitle = _albumTitle;
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
    
    _artist = [[CDLabel alloc] initWithUILable:_artistTemplate];
    [self addSubview:_artist];
    
    _title = [[CDLabel alloc] initWithUILable:_titleTemplate];
    [self addSubview:_title];
    
    _albumTitle = [[CDLabel alloc] initWithUILable:_albumTitleTemplate];
    [self addSubview:_albumTitle];

    [_artistTemplate removeFromSuperview], _artistTemplate = nil;
    [_titleTemplate removeFromSuperview], _titleTemplate = nil;
    [_albumTitleTemplate removeFromSuperview], _albumTitleTemplate = nil;
    
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
    if (CGRectContainsPoint(self.pullButtonFrame, location)) {
        [self touchPullButtonDown];
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint location = [touch locationInView:self];
    if (CGRectContainsPoint(self.pullButtonFrame, location)) {
        [self touchPullButtonUpInside];
    }else{
        [self touchPullButtonUpOutside];
    }
}

- (void)cancelTrackingWithEvent:(UIEvent *)event{
    
}

#pragma mark - Pull Button
- (CGRect)pullButtonFrame{
    CGRect frame = CGRectMake(self.center.x - kPullButtonEffectiveWidth / 2,
                              CGRectGetMaxY(self.bounds) - kPullButtonEffectiveHeight,
                              kPullButtonEffectiveWidth,
                              kPullButtonEffectiveHeight);
    return frame;
}

- (void)touchPullButtonDown{
    [_delegate topBarTouchedDown:self];
}

- (void)touchPullButtonUpInside{
    [_delegate topBarTouchedUpInside:self];
}

- (void)touchPullButtonUpOutside{
    
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
    [_artist setNonemptyText:[_dataSource topBarNeedsArtist:self]];
    [_title setNonemptyText:[_dataSource topBarNeedsTitle:self]];
    [_albumTitle setNonemptyText:[_dataSource topBarNeedsAlbumTitle:self]];
    [_assistButton changeStateTo:0];
}

@end

