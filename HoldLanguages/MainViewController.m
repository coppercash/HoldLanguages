//
//  MainViewController.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/11/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "MainViewController.h"
#import "CDLyrics.h"
#import "CDLRCLyrics.h"
#import "CDiTunesFinder.h"
#import "CDBackgroundView.h"
#import "CDSliderProgressView.h"
#import "CDProgress.h"
#import "CDLazyScrollView.h"
#import "CDBigLabelView.h"

@interface MainViewController ()
//- (void)openedAudioNamed:(NSString*)audioName;
- (BOOL)openLyricsAtPath:(NSString *)path;
- (void)switchBarsHidden;
- (NSTimeInterval)playbackTimeByButton;
- (void)createLyricsView;
- (void)destroyLyricsView;
- (void)switchAssistHidden;
@end
@implementation MainViewController
@synthesize holder = _holder, lyricsView = _lyricsView, backgroundView = _backgroundView;
@synthesize audioSharer = _audioSharer, lyrics = _lyrics;
@synthesize mediaPicker = _mediaPicker;
@synthesize progress = _progress;

#pragma mark - ViewController Methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        self.progress = appDelegate.progress;
        [_progress registerDelegate:self withTimes:3];

        self.audioSharer = appDelegate.audioSharer;
        [_audioSharer registAsDelegate:self];
    }

    return self;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.wantsFullScreenLayout = YES;

    [_progress registerDelegate:self.bottomBar withTimes:kLabelsUpdateTimes];
    [_progress registerDelegate:self.bottomBar withTimes:kProgressViewUpdateTimes];

    _backgroundView = [[CDBackgroundView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_backgroundView];
    _backgroundView.autoresizingMask = kViewAutoresizingNoMarginSurround;
    _backgroundView.dataSource = self;
    
    self.holder = [[CDHolder alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.holder];
    _holder.numberOfRows = 2;
    _holder.delegate = self;
    _holder.autoresizingMask = kViewAutoresizingNoMarginSurround;
    
    [self endOfViewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark - System Callback
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (event.type == UIEventSubtypeMotionShake)
    {
        [self switchBarsHidden];        
    }
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event{
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause:{
                [self.audioSharer playOrPause];
            }break;
            case UIEventSubtypeRemoteControlPreviousTrack:{
                [self.audioSharer previous];
            }break;
            case UIEventSubtypeRemoteControlNextTrack:{
                [self.audioSharer next];
            }break;
            case UIEventSubtypeRemoteControlPlay:{
                [self.audioSharer play];
            }break;
            case UIEventSubtypeRemoteControlPause:{
                [self.audioSharer pause];
            }break;
            case UIEventSubtypeRemoteControlStop:{
                [self.audioSharer stop];
            }break;
            default:
                break;  
        }  
    }
}

#pragma mark - Rotation Events
- (BOOL)shouldAutorotate{
    BOOL should = !self.topBar.isRotationLocked;
    return should;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    if (self.topBar.isRotationLocked) {
        return toInterfaceOrientation == self.interfaceOrientation;
    }else{
        return YES;
    }
}

#pragma mark - Flexible Subviews
- (void)createLyricsView{
    _lyricsView = [[CDLyricsView alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:_lyricsView aboveSubview:_backgroundView];
    _lyricsView.lyricsSource = self;
    _lyricsView.autoresizingMask = kViewAutoresizingNoMarginSurround;
}

- (void)destroyLyricsView{
    [_lyricsView removeFromSuperview];
    _lyricsView = nil;
}

#pragma mark - CDPullViewController Top Bar Methods
- (void)topBarStartPulling:(CDPullTopBar*)topBar onDirection:(CDDirection)direction{
    if (self.barsHidden) return;
    [super topBarStartPulling:topBar onDirection:direction];
    if (direction == CDDirectionRight) {
        //DLogCurrentMethod;
        _panViewController.leftViewController = [_panViewController createSubController:_panViewController.leftControllerClass];
    }
}

- (CGFloat)topBarContinuePulling:(CDPullTopBar *)topBar onDirection:(CDDirection)direction shouldMove:(CGFloat)increment{
    if (self.barsHidden) return 0.0f;
    CGFloat superIncrement = [super topBarContinuePulling:topBar onDirection:direction shouldMove:increment];
    if (superIncrement != 0.0f) return superIncrement;
    if (direction == CDDirectionRight) {
        [_panViewController panRootControllerWithIncrement:CGPointMake(increment, 0.0f)];
    }
    return 0.0;
}

- (void)topBarFinishPulling:(CDPullTopBar*)topBar onDirection:(CDDirection)direction{
    [super topBarFinishPulling:topBar onDirection:direction];
    if (direction == CDDirectionRight) {
        //DLogCurrentMethod;
        [_panViewController showLeftController:YES];
    }
}

- (void)topBarCancelPulling:(CDPullTopBar*)topBar onDirection:(CDDirection)direction{
    [super topBarCancelPulling:topBar onDirection:direction];
    if (direction == CDDirectionRight) {
        //DLogCurrentMethod;
        [_panViewController showRootController:YES];
    }
}

- (NSString*)topBarLabel:(CDPullTopBar *)topBar textAtIndex:(NSUInteger)index{
    switch (index) {
        case 0:{
            NSString* artist = [self.audioSharer valueForProperty:MPMediaItemPropertyArtist];
            if (artist == nil)
                artist = [self.audioSharer valueForProperty:MPMediaItemPropertyAlbumArtist];
            return artist;
        }break;
        case 1:{
            NSString* title = [self.audioSharer valueForProperty:MPMediaItemPropertyTitle];
            return title;
        }break;
        case 2:{
            NSString* albumTitle = [self.audioSharer valueForProperty:MPMediaItemPropertyAlbumTitle];
            return albumTitle;
        }break;
        default:
            break;
    }
    return nil;
}

- (BOOL)shouldTopBar:(CDPullTopBar *)topBar changeState:(CDDirection)direction{
    switch (direction) {
        case CDDirectionLeft:{
            [self switchAssistHidden];
            return YES;
        }break;
        case CDDirectionRight:{
            return YES;
        }break;
        default:
            break;
    }
    return NO;
}

- (void)createPulledView{
    [super createPulledView];
    if (_mediaPicker == nil) {
        _mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAnyAudio];
        _mediaPicker.view.autoresizingMask = kViewAutoresizingNoMarginSurround;
    }
    _mediaPicker.view.frame = self.pulledView.bounds;
    _mediaPicker.delegate = self;

    [self.pulledView addSubview:_mediaPicker.view];

    /*
    dispatch_queue_t queue = dispatch_queue_create("createPulledView", nil);
    dispatch_async(queue, ^{
        if (_mediaPicker == nil) {
            _mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAnyAudio];
            _mediaPicker.view.autoresizingMask = kViewAutoresizingNoMarginSurround;
        }
        _mediaPicker.view.frame = self.pulledView.bounds;
        _mediaPicker.delegate = self;
        _mediaPicker.prompt = NSLocalizedString (@"AddSongsPrompt", @"Prompt to user to choose some songs to play");
        
        NSLog(@"Finish asyn");
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.pulledView addSubview:_mediaPicker.view];
            NSLog(@"return to main");
        });
    });
    dispatch_release(queue);
     */
}

- (void)destroyPulledView{
    [_mediaPicker.view removeFromSuperview];
    _mediaPicker = nil;
    [super destroyPulledView];
    DLogCurrentMethod;
}

#pragma mark - CDPullViewController Bottom Bar Methods
- (void)bottomBar:(CDPullBottomBar *)bottomButton sliderValueChangedAs:(float)sliderValue{
    NSTimeInterval playbackTime = sliderValue * self.audioSharer.currentDuration;
    [self.audioSharer playbackAt:playbackTime];
    [_progress synchronize:nil];
}

- (void)bottomBar:(CDPullBottomBar *)bottomButton buttonFire:(CDBottomBarButtonType)buttonType{
    switch (buttonType) {
        case CDBottomBarButtonTypePlay:{
            [_audioSharer playOrPause];
        }break;
        case CDBottomBarButtonTypeBackward:{
            [_audioSharer playbackFor:- self.playbackTimeByButton];
        }break;
        case CDBottomBarButtonTypeForward:{
            [_audioSharer playbackFor:self.playbackTimeByButton];
        }break;
        default:
            break;
    }
}

- (NSTimeInterval)bottomBarAskForDuration:(CDPullBottomBar*)bottomButton{
    return self.audioSharer.currentDuration;
}

#pragma mark - MPMediaPickerControllerDelegate
- (void)mediaPicker:(MPMediaPickerController*)mediaPicker didPickMediaItems:(MPMediaItemCollection*) mediaItemCollection {
    [self setPullViewPresented:NO animated:YES];
    [self.audioSharer openQueueWithItemCollection:mediaItemCollection];
    [self.audioSharer play];
}

- (void)mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker {
    [self setPullViewPresented:NO animated:YES];
}

#pragma mark - CDHolderDelegate
- (void)holder:(CDHolder *)holder continueSwipingVerticallyFor:(CGFloat)increment{
    [self.lyricsView scrollFor:-increment animated:NO];
}

- (void)holder:(CDHolder *)holder endSwipingVerticallyFromStart:(CGFloat)distance{
    if (_lyrics) {
        NSUInteger focusIndex = _lyricsView.focusIndex;
        NSTimeInterval playbackTime = [_lyrics timeAtIndex:focusIndex];
        [self.audioSharer playbackAt:playbackTime];
        [_lyricsView setFocusIndex:focusIndex]; //For making focus accrute.
    }else{
        float rate = _audioSharer.playbackRate;
        NSTimeInterval playbackTime = - rate * distance;
        [self.audioSharer playbackFor:playbackTime];
    }
    [_progress synchronize:nil];
}
static CGFloat lastDistance = 0.0f;

- (void)holder:(CDHolder *)holder beginSwipingHorizontallyOnDirection:(CDDirection)direction onRow:(NSUInteger)index{
    switch (index) {
        case 0:{
            if (!_audioSharer.isRepeating) {
                DLog(@"Create Repeat View");
            }
        }break;
        case 1:{
            lastDistance = 0.0f;
            if (_ratesView == nil) {
                CGRect frame = self.view.bounds;
                frame.size.height /= 2;
                frame.origin.y = frame.size.height;
                self.ratesView = [[CDLazyScrollView alloc] initWithFrame:frame];
                [self.view insertSubview:_ratesView belowSubview:_holder];
                _ratesView.lazyDelegate = self;
                _ratesView.dataSource = self;
                _ratesView.autoresizingMask = kViewAutoresizingNoMarginSurround;
            }
            [_ratesView startScrolling];
        }break;
        default:
            break;
    }
}

- (void)holder:(CDHolder *)holder continueSwipingHorizontallyFromStart:(CGFloat)distance onRow:(NSUInteger)index{
    switch (index) {
        case 0:{
            if (!_audioSharer.isRepeating) {
                float rate = _audioSharer.repeatRate;
                NSTimeInterval length = rate * distance;
                DLog(@"Will repeat for %f", length);
            }
         }break;
        case 1:{
            [_ratesView scrollFor:-(distance - lastDistance) animated:NO];
            lastDistance = distance;

        }
        default:
            break;
    }
}

- (void)holder:(CDHolder *)holder endSwipingHorizontallyFromStart:(CGFloat)distance onRow:(NSUInteger)index{
    switch (index) {
        case 0:{
            if (_audioSharer.isRepeating) {
                CDDirection currentDirection = distance > 0 ? CDDirectionRight : CDDirectionLeft;
                if (currentDirection != _lastRepeatDirection) {
                    [_audioSharer stopRepeating];
                    DLog(@"Repeat stop");
                }
            }else{
                float rate = _audioSharer.repeatRate;
                NSTimeInterval length = rate * distance;
                NSTimeInterval location = _audioSharer.currentPlaybackTime;
                if (length < 0) {
                    //Length is nagitive, so add it indicates repeat in forward range.
                    location += length;
                }
                CDTimeRange repeatRange = CDMakeTimeRange(location, length);
                [_audioSharer repeatIn:repeatRange];
                DLog(@"Repeat range:%lf, %lf",repeatRange.location, repeatRange.length);
            }
        }break;
        case 1:{
            [_ratesView endScrolling];
        }break;
        default:
            break;
    }
}

- (void)holder:(CDHolder *)holder cancelSwipingHorizontallyOnDirection:(CDDirection)direction onRow:(NSUInteger)index{
    switch (index) {
        case 0:{
            DLog(@"Release Repeat View");
        }break;
        case 1:{
            [_ratesView cancelScrolling];
        }break;
        default:
            break;
    }
}

- (void)holderTapDouble:(CDHolder *)holder{
    [self.audioSharer playOrPause];
}

- (void)holderLongPressed:(CDHolder *)holder{
    [self switchBarsHidden];
}

#pragma mark - Lyrics
- (BOOL)openLyricsAtPath:(NSString *)path{
    CDLRCLyrics* newLyrics = [[CDLRCLyrics alloc] initWithFile:path];
    if (!newLyrics.isReady) return NO;
    self.lyrics = newLyrics;
    if (_lyricsView == nil) [self createLyricsView];
    else [_lyricsView reloadData];
    return YES;
}

#pragma mark - CDLyricsViewLyricsSource
- (NSUInteger)numberOfLyricsRowsInView:(CDLyricsView *)lyricsView{
    NSUInteger number = self.lyrics.numberOfLyricsRows;
    return number;
}

- (NSString*)lyricsView:(CDLyricsView *)lyricsView stringForRowAtIndex:(NSUInteger)index{
    NSString* string = [self.lyrics contentAtIndex:index];
    return string;
}

- (NSArray*)lyricsViewNeedsLyricsInfo:(CDLyricsView *)lyricsView{
    return _lyrics.lyricsInfo;
}

#pragma mark - CDAudioPlayerDelegate
- (void)audioSharer:(CDAudioSharer *)audioSharer stateDidChange:(CDAudioPlayerState)state{
    switch (state) {
        case CDAudioPlayerStatePlaying:{
            self.bottomBar.playButtonState = CDBottomBarPlayButtonStatePlaying;
            self.bottomBar.progressView.animated = YES;
            [_progress setupUpdater];
        }break;
        case CDAudioPlayerStatePaused:{
            self.bottomBar.playButtonState = CDBottomBarPlayButtonStatePaused;
            self.bottomBar.progressView.animated = NO;
            [_progress stopUpdater];
        }break;
        case CDAudioPlayerStateStopped:{
            self.bottomBar.playButtonState = CDBottomBarPlayButtonStatePaused;
            self.bottomBar.progressView.animated = NO;
            [_progress stopUpdater];
        }break;
        default:
            break;
    }
}

- (void)audioSharerNowPlayingItemDidChange:(CDAudioSharer*)audioSharer{
    NSString *audioTitle = [self.audioSharer valueForProperty:MPMediaItemPropertyTitle];
    NSString* lyricsPath = [CDiTunesFinder findFileWithName:audioTitle ofType:kLRCExtension];
    if (lyricsPath == nil) {
        self.lyrics = nil;
        [self destroyLyricsView];
        [self.backgroundView switchViewWithKey:CDBackgroundViewKeyMissingLyrics];
    }else{
        BOOL success = [self openLyricsAtPath:lyricsPath];
        if (success) [self.backgroundView switchViewWithKey:CDBackgroundViewKeyNone];
    }
    [self.topBar reloadData];
    [self.bottomBar reloadData];
}

#pragma mark - CDBackgroundViewDatasource
- (NSString*)backgroundViewNeedsAudioName:(CDBackgroundView*)backgroundView{
    NSString *audioTitle = [self.audioSharer valueForProperty:MPMediaItemPropertyTitle];
    return audioTitle;
}

#pragma mark - Events
/*
- (void)openedAudioNamed:(NSString*)audioName{
    [self.audioSharer stop];
    [self.audioSharer play];
}*/

- (void)switchBarsHidden{
    if (self.barsHidden) {
        [self setBarsHidden:!self.barsHidden animated:YES];
    }else{
        [self setBarsHidden:!self.barsHidden animated:YES];
    }
}

- (void)switchAssistHidden{
    NSUInteger state = self.topBar.assistButton.state;
    if (state == 0) {
        void(^animations)(void) = ^(void){
            self.lyricsView.alpha = 0.0f;
        };
        [UIView animateWithDuration:0.3f animations:animations];
        [self.backgroundView switchViewWithKey:CDBackgroundViewKeyAssist];
    } else if (state == 1) {
        if (self.lyricsView == nil) {
            [self.backgroundView switchViewWithKey:CDBackgroundViewKeyMissingLyrics];
        } else {
            void(^animations)(void) = ^(void){
                self.lyricsView.alpha = 1.0f;
            };
            [UIView animateWithDuration:0.3f animations:animations];
            [self.backgroundView switchViewWithKey:CDBackgroundViewKeyNone];
        }
    }
}

#pragma mark - Other Methods
- (NSTimeInterval)playbackTimeByButton{
    NSTimeInterval playbackTime = [self.audioSharer playbackRate] * self.view.bounds.size.height * 0.5;
    return playbackTime;
}

#pragma mark - CDAudioPregressDelegate
- (void)playbackTimeDidUpdate:(NSTimeInterval)playbackTime withTimes:(NSUInteger)times{
    if (!_holder.isBeingTouched) {
        NSUInteger focusIndex = [self.lyrics indexOfStampNearTime:playbackTime];
        [_lyricsView setFocusIndex:focusIndex];
    }
}

#pragma mark - CDSubPanViewController
- (void)willPresentWithUserInfo:(id)userInfo{
    NSString *lrcPath = (NSString *)userInfo;
    BOOL success = [self openLyricsAtPath:lrcPath];
    if (success) [self.backgroundView switchViewWithKey:CDBackgroundViewKeyNone];
}

#pragma mark - CDLazyScrollViewDataSource & CDLazyScrollViewDelegate
- (UIView*)subViewAtPosition:(CDLazyScrollViewPosition)position inLazyScrollView:(CDLazyScrollView*)lazyScrollView{
    NSString *rate = nil;
    switch (position) {
        case CDLazyScrollViewPositionLeft:{
            rate = [_audioSharer.rates.previousObject stringValue];
        }break;
        case CDLazyScrollViewPositionMiddle:{
            rate = [_audioSharer.rates.currentObject stringValue];
        }break;
        case CDLazyScrollViewPositionRight:{
            rate = [_audioSharer.rates.nextObject stringValue];
        }break;
        default:
            break;
    }
    UIView *view = [[CDBigLabelView alloc] initWithText:rate];
    [view setBackgroundColor:kDebugColor];
    return view;
}

- (void)lazyScrollViewDidFinishScroll:(CDLazyScrollView*)lazyScrollView onDirection:(CDDirection)direction{
    switch (direction) {
        case CDDirectionLeft:
            [_audioSharer.rates moveNext];
            [_audioSharer setRate:[_audioSharer.rates.currentObject floatValue]];
            break;
        case CDDirectionRight:
            [_audioSharer.rates movePrevious];
            [_audioSharer setRate:[_audioSharer.rates.currentObject floatValue]];
            break;
        default:
            break;
    }
}

- (void)lazyScrollViewDidHide:(CDLazyScrollView*)lazyScrollView{
    [_ratesView removeFromSuperview];
    self.ratesView = nil;
}

@end
