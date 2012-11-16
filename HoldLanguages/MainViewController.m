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

@interface MainViewController ()
- (void)openedAudioNamed:(NSString*)audioName;
- (BOOL)isLyricsUsable;
- (void)switchBarsHidden;
@end
@implementation MainViewController
@synthesize holder = _holder, lyricsView = _lyricsView;
@synthesize audioSharer = _audioSharer, lyrics = _lyrics;
@synthesize mediaPicker = _mediaPicker;

- (void)test{
    /*
     MPMediaPickerController *picker =
     [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAnyAudio];
     
     picker.delegate						= self;
     //picker.allowsPickingMultipleItems	= YES;
     picker.prompt						= NSLocalizedString (@"AddSongsPrompt", @"Prompt to user to choose some songs to play");
     
     [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault animated:YES];
     [self presentModalViewController: picker animated: YES];
     */
    
    
    if (self.barsHidden) {
        [self setBarsHidden:NO animated:YES];
    }else{
        [self setBarsHidden:YES animated:YES];
    }
    /*
    if ([[UIApplication sharedApplication] isStatusBarHidden]) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        [self setBarsHidden:NO animated:YES];
    }else{
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        [self setBarsHidden:YES animated:YES];
    }
    */
}

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
    //self.view.autoresizingMask = kViewAutoresizingNoMarginSurround;

    self.lyricsView = [[CDLyricsView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.lyricsView];
    self.lyricsView.lyricsSource = self;
    self.lyricsView.autoresizingMask = kViewAutoresizingNoMarginSurround;
    
    self.holder = [[CDHolder alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.holder];
    self.holder.delegate = self;
    self.holder.autoresizingMask = kViewAutoresizingNoMarginSurround;
    
    _mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAnyAudio];
    _mediaPicker.view.autoresizingMask = kViewAutoresizingNoMarginSurround;
    /*
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(10.0f, 10.0f, 100.0f, 100.0f);
    [self.view addSubview:button];
    [button addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"笑红尘" ofType:@"lrc"];
    self.lyrics = [[CDLRCLyrics alloc] initWithFile:path];
    self.view.backgroundColor = [UIColor blueColor];
    */
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
    if (!self.holder.isBeingTouched) {
        NSUInteger focusIndex = [self.lyrics indexOfStampNearTime:playbackTime];
        [self.lyricsView setFocusIndex:focusIndex];
    }
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
    
    NSString* lyricsPath = [CDiTunesFinder findFileWithName:audioName ofType:kLRCExtension];
    if (lyricsPath == nil) {
        self.lyrics = nil;
    }else{
        CDLRCLyrics* newLyrics = [[CDLRCLyrics alloc] initWithFile:lyricsPath];
        self.lyrics = newLyrics;
    }
}

- (void)switchBarsHidden{
    if (self.barsHidden) {
        [self setBarsHidden:!self.barsHidden animated:YES];
    }else{
        [self setBarsHidden:!self.barsHidden animated:YES];
    }
}


@end
