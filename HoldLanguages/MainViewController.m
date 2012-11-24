//
//  MainViewController.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/11/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "MainViewController.h"
#import "Header.h"
#import "CDLyrics.h"
#import "CDLRCLyrics.h"
#import "CDiTunesFinder.h"
#import "CDBackgroundView.h"
#import "CDSliderProgressView.h"

@interface MainViewController ()
- (void)openedAudioNamed:(NSString*)audioName;
- (BOOL)isLyricsUsable;
- (void)switchBarsHidden;
- (NSTimeInterval)playbackTimeByButton;
- (void)createLyricsView;
- (void)destroyLyricsView;
@end
@implementation MainViewController
@synthesize holder = _holder, lyricsView = _lyricsView, backgroundView = _backgroundView;
@synthesize audioSharer = _audioSharer, lyrics = _lyrics;
@synthesize mediaPicker = _mediaPicker;

#pragma mark - ViewController Methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        self.audioSharer = appDelegate.audioSharer;
        [self.audioSharer registAsDelegate:self];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.wantsFullScreenLayout = YES;
    _backgroundView = [[CDBackgroundView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_backgroundView];
    _backgroundView.autoresizingMask = kViewAutoresizingNoMarginSurround;
    _backgroundView.dataSource = self;
    
    [self createLyricsView];
    
    self.holder = [[CDHolder alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.holder];
    self.holder.delegate = self;
    self.holder.autoresizingMask = kViewAutoresizingNoMarginSurround;
    
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
    if (_lyricsView == nil) {
        _lyricsView = [[CDLyricsView alloc] initWithFrame:self.view.bounds];
        [self.view insertSubview:_lyricsView aboveSubview:_backgroundView];
    }
    _lyricsView.lyricsSource = self;
    _lyricsView.autoresizingMask = kViewAutoresizingNoMarginSurround;
}

- (void)destroyLyricsView{
    [_lyricsView removeFromSuperview];
    _lyricsView = nil;
}

#pragma mark - CDPullViewController Methods
- (void)loadPulledView:(UIView *)pulledView{
    if (_mediaPicker == nil) {
        _mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAnyAudio];
        _mediaPicker.view.autoresizingMask = kViewAutoresizingNoMarginSurround;
    }
    _mediaPicker.view.frame = pulledView.bounds;
	_mediaPicker.delegate = self;
	_mediaPicker.prompt = NSLocalizedString (@"AddSongsPrompt", @"Prompt to user to choose some songs to play");
	
    [pulledView addSubview:_mediaPicker.view];
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
- (void)holderBeginSwipingVertically:(CDHolder*)holder{
}

- (void)holder:(CDHolder*)holder swipeVerticallyFor:(CGFloat)increament{
    [self.lyricsView scrollFor:-increament animated:NO];
}

- (void)holder:(CDHolder*)holder endSwipingVerticallyFor:(CGFloat)increament fromStart:(CGFloat)distance{
    if (self.isLyricsUsable) {
        [self.lyricsView scrollFor:-increament animated:NO];
        NSUInteger focusIndex = self.lyricsView.focusIndex;
        NSTimeInterval playbackTime = [self.lyrics timeAtIndex:focusIndex];
        [self.audioSharer playbackAt:playbackTime];
    }else{
        float rate = self.audioSharer.playbackRate;
        NSTimeInterval playbackTime = - rate * distance;
        [self.audioSharer playbackFor:playbackTime];
    }
}

- (void)holderCancelSwipingVertically:(CDHolder*)holder{
}

- (void)holder:(CDHolder*)holder swipeHorizontallyToDirection:(UISwipeGestureRecognizerDirection)direction{
}

- (void)holderTapDouble:(CDHolder *)holder{
    [self.audioSharer playOrPause];
}

- (void)holderLongPressed:(CDHolder *)holder{
    [self switchBarsHidden];
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
- (void)audioSharer:(CDAudioSharer *)audioSharer refreshPlaybackTime:(NSTimeInterval)playbackTime{
    if (self.isLyricsUsable && !self.holder.isBeingTouched) {
        NSUInteger focusIndex = [self.lyrics indexOfStampNearTime:playbackTime];
        [self.lyricsView setFocusIndex:focusIndex];
    }
    float sliderValue = playbackTime / self.audioSharer.currentDuration;
    [self.bottomBar setSliderValue:sliderValue];
    [self.bottomBar setLabelsPlaybackTime:playbackTime];
}

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
        [self destroyLyricsView];
        self.lyrics = nil;
        [self.backgroundView switchViewWithKey:CDBackgroundViewKeyMissingLyrics];
    }else{
        CDLRCLyrics* newLyrics = [[CDLRCLyrics alloc] initWithFile:lyricsPath];
        self.lyrics = newLyrics;
        [self createLyricsView];
        [self.backgroundView switchViewWithKey:CDBackgroundViewKeyNone];
    }
    [self.lyricsView reloadData];
    [self.topBar reloadData];
    [self.bottomBar reloadData];
}

#pragma mark - CDBackgroundViewDatasource
- (NSString*)backgroundViewNeedsAudioName:(CDBackgroundView*)backgroundView{
    NSString* audioName = self.audioSharer.audioName;
    return audioName;
}

#pragma mark - Lyrics
- (BOOL)isLyricsUsable{
    BOOL isUsable = YES;
    if (self.lyrics == nil) isUsable = NO;
    if (!self.lyrics.isReady) isUsable = NO;
    return isUsable;
}

- (void)setLyrics:(CDLyrics *)lyrics{
    _lyrics = lyrics;
    [self.lyricsView reloadData];
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

#pragma mark - Other Methods
- (NSTimeInterval)playbackTimeByButton{
    NSTimeInterval playbackTime = [self.audioSharer playbackRate] * self.view.bounds.size.height * 0.5;
    return playbackTime;
}

@end
