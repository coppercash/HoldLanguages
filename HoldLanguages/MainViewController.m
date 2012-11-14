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

@interface MainViewController ()
- (BOOL)isLyricsUsable;
@end
@implementation MainViewController
@synthesize audioSharer = _audioSharer, lyrics = _lyrics;

- (void)test{
    MPMediaPickerController *picker =
    [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAnyAudio];
	
	picker.delegate						= self;
	//picker.allowsPickingMultipleItems	= YES;
	picker.prompt						= NSLocalizedString (@"AddSongsPrompt", @"Prompt to user to choose some songs to play");
	
	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault animated:YES];
	[self presentModalViewController: picker animated: YES];
}


#pragma mark - ViewController Methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.audioSharer = [CDAudioSharer sharedAudioPlayer];
        [self.audioSharer registAsDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    CGRect windowBounds = appDelegate.windowBounds;
    self.view.frame = CGRectMake(windowBounds.origin.x, windowBounds.origin.y - 20.0f, windowBounds.size.width, windowBounds.size.height);
    
    
    // Do any additional setup after loading the view from its nib.
    self.lyricsView = [[CDLyricsView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.lyricsView];
    self.lyricsView.lyricsSource = self;
    DLogRect(self.view.bounds);
    
    CDHolder* holder = [[CDHolder alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:holder];
    holder.delegate = self;
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(10.0f, 10.0f, 100.0f, 100.0f);
    [self.view addSubview:button];
    [button addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"笑红尘" ofType:@"lrc"];
    self.lyrics = [[CDLRCLyrics alloc] initWithFile:path];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MPMediaPickerControllerDelegate
- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection {
    
	[self dismissModalViewControllerAnimated: YES];
	//[self.delegate updatePlayerQueueWithMediaCollection: mediaItemCollection];
	//[self.mediaItemCollectionTable reloadData];
    
    [self.audioSharer openQueueWithItemCollection:mediaItemCollection];
    
	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque animated:YES];
}

- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker {
    
	[self dismissModalViewControllerAnimated: YES];
    
	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque animated:YES];
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
    NSUInteger focusIndex = [self.lyrics indexOfStampNearTime:playbackTime];
    [self.lyricsView setFocusIndex:focusIndex];
}

#pragma mark - Lyrics
- (BOOL)isLyricsUsable{
    return YES;
}

@end
