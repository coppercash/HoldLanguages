//
//  MainViewController.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/11/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "MainViewController.h"
#import "Header.h"
#import "CDHolder.h"
#import "CDiPodPlayer.h"
#import "CDAudioSharer.h"

#import "CDLRCLyrics.h"

@interface MainViewController ()
@end

@implementation MainViewController
@synthesize audioSharer = _audioSharer;

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
        //self.audioSharer = [CDAudioSharer sharedAudioPlayer];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CDHolder* holder = [[CDHolder alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:holder];
    holder.delegate = self;
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(10.0f, 10.0f, 100.0f, 100.0f);
    [self.view addSubview:button];
    [button addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    
    /*
    NSString* string = @"[00:53.81]只是可怜 瘦马未得好歇 ";
    NSCharacterSet* set = [NSCharacterSet characterSetWithCharactersInString:@"[]"];
    NSArray* cos = [string componentsSeparatedByCharactersInSet:set];
    for (NSString* co in cos) {
        DLog(@"%@", co);
    }
     */
    /*
    NSString* testString = @"00:53.81";
    NSString* string = @"[00:53.81]只是可怜 瘦马未得好歇 ";
    NSRange range = [string rangeOfString:testString];
    NSString* h = [string substringWithRange:NSMakeRange(range.location, 1)];
    NSString* t = [string substringWithRange:NSMakeRange(range.location + range.length, 1)];
     */
    NSString* path = [[NSBundle mainBundle] pathForResource:@"Breathing" ofType:@"lrc"];
    CDLRCLyrics* lyrics = [[CDLRCLyrics alloc] initWithFile:path];
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

- (void)holder:(CDHolder*)holder swipeVerticallyFor:(CGFloat)distance{
    
}

- (void)holder:(CDHolder *)holder endSwipingVerticallyAt:(CGFloat)distance{
    float rate = self.audioSharer.playbackRate;
    NSTimeInterval playbackTime = - rate * distance;
    [self.audioSharer playbackFor:playbackTime];
}

- (void)holderCancelSwipingVertically:(CDHolder*)holder{
    
}

- (void)holder:(CDHolder*)holder swipeHorizontallyToDirection:(UISwipeGestureRecognizerDirection)direction{
    
}

- (void)holderTapDouble:(CDHolder *)holder{
    [self.audioSharer playOrPause];
}

@end
