//
//  MainViewController.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/11/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//
#import "MainViewController.h"
#import "CDColorFinder.h"

#import "LyricsCategory.h"
#import "PullViewControllerCategory.h"
#import "AudioCategory.h"
#import "HolderCategory.h"    

@implementation MainViewController
@synthesize panViewController = _panViewController;
@dynamic holder, backgroundView;
@dynamic lyricsView, storyView, introductionView;
@dynamic repeatView, ratesView;
@synthesize audioSharer = _audioSharer, lyrics = _lyrics, item = _item, introductionRevert = _introductionRevert;
@synthesize mediaPicker = _mediaPicker;
@synthesize progress = _progress;

#pragma mark - ViewController Methods
- (void)initialize{
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    self.progress = appDelegate.progress;
    [_progress registerDelegate:self withTimes:3];
    
    self.audioSharer = appDelegate.audioSharer;
    [_audioSharer registAsDelegate:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initialize];
    }
    return self;
}

- (void)loadView{
    [super loadView];
    
    self.wantsFullScreenLayout = YES;
    
    [self backgroundView];
    [self holder];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _bottomBar.backgroundColor = [CDColorFinder colorOfBars];
    
    [_progress registerDelegate:self.bottomBar withTimes:kLabelsUpdateTimes];
    [_progress registerDelegate:self.bottomBar withTimes:kProgressViewUpdateTimes];

    [self endOfViewDidLoad];
}

- (void)didReceiveMemoryWarning{
    // Test self.view can be release (on the screen or not).
    if (self.view.window == nil){
        // Preserve data stored in the views that might be needed later.
        
        // Clean up other strong references to the view in the view hierarchy.
        self.backgroundView = nil;
        self.storyView = nil;
        self.holder = nil;
        self.lyricsView = nil;
        
        self.repeatView = nil;
        self.ratesView = nil;
        
        //Release self.view
        self.view = nil;
    }
    
    // iOS6 & later did nothing.
    // iOS5 & earlier test self.view == nil, if not viewWillUnload -> release self.view -> viewDidUnload.
    // In this implementation self.view is always nil, so iOS5 & earlier should do nothing.
    [super didReceiveMemoryWarning];
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
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return toInterfaceOrientation == UIInterfaceOrientationMaskPortrait;
}

/*
- (BOOL)shouldAutorotate{
    BOOL should = !self.topBar.isRotationLocked;
    return should;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}*/

#pragma mark - CDSubPanViewController
- (void)willPresentWithUserInfo:(id)userInfo{
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

@end
