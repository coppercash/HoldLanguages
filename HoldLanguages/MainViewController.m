//
//  MainViewController.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/11/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "MainViewController.h"
#import "CDLyrics.h"
#import "CDLRCLyrics.h"
#import "CDiTunesFinder.h"
#import "CDBackgroundView.h"
#import "CDSliderProgressView.h"
#import "CDProgress.h"

@interface MainViewController ()
- (void)openedAudioNamed:(NSString*)audioName;
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
        self.progress = [[CDAudioProgress alloc] init];
        [_progress registerDelegate:self withTimes:3];
        
        AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        self.audioSharer = appDelegate.audioSharer;
        [self.audioSharer registAsDelegate:self];
        _progress.dataSource = _audioSharer;
    }

    return self;
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
    _holder.numberOfRows = 3;
    _holder.delegate = self;
    _holder.autoresizingMask = kViewAutoresizingNoMarginSurround;
    
    [self endOfViewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (event.type == UIEventSubtypeMotionShake)
    {
        [self switchBarsHidden];        
    }
}

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

- (NSString*)topBarNeedsArtist:(CDPullTopBar*)topBar{
    NSString* artist = [self.audioSharer valueForProperty:MPMediaItemPropertyArtist];
    if (artist == nil) 
        artist = [self.audioSharer valueForProperty:MPMediaItemPropertyAlbumArtist];
    return artist;
}

- (NSString*)topBarNeedsTitle:(CDPullTopBar*)topBar{
    NSString* title = [self.audioSharer valueForProperty:MPMediaItemPropertyTitle];
    return title;
}

- (NSString*)topBarNeedsAlbumTitle:(CDPullTopBar*)topBar{
    NSString* albumTitle = [self.audioSharer valueForProperty:MPMediaItemPropertyAlbumTitle];
    return albumTitle;
}

- (BOOL)topBarShouldLockRotation:(CDPullTopBar *)topBar{
    return YES;
}

- (void)topBarLeftButtonTouched:(CDPullTopBar*)topBar{
    [self switchAssistHidden];
}

#pragma mark - CDPullViewController Bottom Bar Methods
- (void)bottomBar:(CDPullBottomBar *)bottomButton sliderValueChangedAs:(float)sliderValue{
    NSTimeInterval playbackTime = sliderValue * self.audioSharer.currentDuration;
    [self.audioSharer playbackAt:playbackTime];
}

- (void)bottomBar:(CDPullBottomBar *)bottomButton buttonFire:(CDBottomBarButtonType)buttonType{
    switch (buttonType) {
        case CDBottomBarButtonTypePlay:{
            [self.audioSharer playOrPause];
        }break;
        case CDBottomBarButtonTypeBackward:{
            [self.audioSharer playbackFor:- self.playbackTimeByButton];
        }break;
        case CDBottomBarButtonTypeForward:{
            [self.audioSharer playbackFor:self.playbackTimeByButton];
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
    
    NSString* itemName = [self.audioSharer openQueueWithItemCollection:mediaItemCollection];
    [self openedAudioNamed:itemName];
}

- (void)mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker {
    [self setPullViewPresented:NO animated:YES];
}

#pragma mark - CDHolderDelegate
- (void)holder:(CDHolder *)holder beginSwipingOnDirection:(UISwipeGestureRecognizerDirection)direction{
}

- (void)holder:(CDHolder *)holder continueSwipingVerticallyFor:(CGFloat)increment{
    [self.lyricsView scrollFor:-increment animated:NO];
}

- (void)holder:(CDHolder *)holder endSwipingVerticallyFromStart:(CGFloat)distance{
    if (_lyrics) {
        NSUInteger focusIndex = self.lyricsView.focusIndex;
        NSTimeInterval playbackTime = [self.lyrics timeAtIndex:focusIndex];
        [self.audioSharer playbackAt:playbackTime];
    }else{
        float rate = self.audioSharer.playbackRate;
        NSTimeInterval playbackTime = - rate * distance;
        [self.audioSharer playbackFor:playbackTime];
    }
}

- (void)holder:(CDHolder *)holder continueSwipingHorizontallyFromStart:(CGFloat)distance onRow:(NSUInteger)index{
}

- (void)holder:(CDHolder *)holder endSwipingHorizontallyFromStart:(CGFloat)distance onRow:(NSUInteger)index{
}

- (void)holder:(CDHolder *)holder cancelSwipingOnDirection:(UISwipeGestureRecognizerDirection)direction{
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

#pragma mark - CDAudioPlayerDelegate
- (void)audioSharer:(CDAudioSharer *)audioSharer stateDidChange:(CDAudioPlayerState)state{
    switch (state) {
        case CDAudioPlayerStatePlaying:{
            self.bottomBar.playButtonState = CDBottomBarPlayButtonStatePlaying;
            self.bottomBar.progressView.animated = YES;
        }break;
        case CDAudioPlayerStatePaused:{
            self.bottomBar.playButtonState = CDBottomBarPlayButtonStatePaused;
            self.bottomBar.progressView.animated = NO;
        }break;
        case CDAudioPlayerStateStopped:{
            self.bottomBar.playButtonState = CDBottomBarPlayButtonStatePaused;
            self.bottomBar.progressView.animated = NO;
        }break;
        default:
            break;
    }
}

- (void)audioSharerNowPlayingItemDidChange:(CDAudioSharer*)audioSharer{
    NSString* lyricsPath = [CDiTunesFinder findFileWithName:self.audioSharer.audioName ofType:kLRCExtension];
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
    NSString* audioName = self.audioSharer.audioName;
    return audioName;
}

#pragma mark - Events
- (void)openedAudioNamed:(NSString*)audioName{
    [self.audioSharer stop];
    [self.audioSharer play];
}

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
    if (!self.holder.isBeingTouched) {
        NSUInteger focusIndex = [self.lyrics indexOfStampNearTime:playbackTime];
        [self.lyricsView setFocusIndex:focusIndex];
    }
}

- (void)progressDidUpdate:(float)progress withTimes:(NSUInteger)times{
    //DLog(@"%f", progress);
}

#pragma mark - CDSubPanViewController
- (void)willPresentWithUserInfo:(id)userInfo{
    NSString *lrcPath = (NSString *)userInfo;
    BOOL success = [self openLyricsAtPath:lrcPath];
    if (success) [self.backgroundView switchViewWithKey:CDBackgroundViewKeyNone];
}
@end
