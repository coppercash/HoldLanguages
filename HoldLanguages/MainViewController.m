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
//#import "CDProgress.h"
#import "CDLazyScrollView.h"
#import "CDBigLabelView.h"
#import "CDRepeaterView.h"
#import "CDMasterButton.h"
#import "CDImageMetroCell.h"

@interface MainViewController ()
- (BOOL)openLyricsAtPath:(NSString *)path;
- (void)switchBarsHidden;
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

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.wantsFullScreenLayout = YES;
    _bottomBar.backgroundColor = [UIColor color255WithRed:0.0f green:115.0f blue:180.0f alpha:1.0f];
    
    [_progress registerDelegate:self.bottomBar withTimes:kLabelsUpdateTimes];
    [_progress registerDelegate:self.bottomBar withTimes:kProgressViewUpdateTimes];

    _backgroundView = [[CDBackgroundView alloc] initWithFrame:self.view.bounds];
    _backgroundView.autoresizingMask = kViewAutoresizingNoMarginSurround;
    _backgroundView.dataSource = self;
    
    self.holder = [[CDHolder alloc] initWithFrame:self.view.bounds];
    _holder.numberOfRows = 2;
    _holder.delegate = self;
    _holder.autoresizingMask = kViewAutoresizingNoMarginSurround;
    
    [self.view addSubview:_backgroundView];
    [self.view addSubview:self.holder];
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
/*
#pragma mark - Rotation Events
- (BOOL)shouldAutorotate{
    BOOL should = !self.topBar.isRotationLocked;
    return should;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationPortrait;
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
}*/

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
            if (title == nil) title = NSLocalizedString(@"TapHere", @"Tap here !");
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

- (void)topBarStartPulling:(CDPullTopBar*)topBar onDirection:(CDDirection)direction{
    if (_barsHidden) return;
    [super topBarStartPulling:topBar onDirection:direction];
    if (direction == CDDirectionRight) {
        //DLogCurrentMethod;
        _panViewController.leftViewController = [_panViewController createSubController:_panViewController.leftControllerClass];
    }
}

- (CGFloat)topBarContinuePulling:(CDPullTopBar *)topBar onDirection:(CDDirection)direction shouldMove:(CGFloat)increment{
    if (_barsHidden) return 0.0f;
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

- (void)topBar:(CDPullTopBar *)topBar buttonTouched:(NSUInteger)position{
    switch (position) {
        case 0:{
            _panViewController.leftViewController = [_panViewController createSubController:_panViewController.leftControllerClass];
            [_panViewController showLeftController:YES];
        }break;
        default:
            break;
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

- (void)presentTopBarAnimated:(BOOL)animated{
    [super presentTopBarAnimated:animated];
    _topBar.leftButton.contentMode = UIViewContentModeCenter;
    [_topBar.leftButton setImage:[UIImage pngImageWithName:@"TopBariTunes"] forState:UIControlStateNormal];
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

#pragma mark - CDPullBottomBarDelegate & DataSource
- (CDMetroCell *)bottomBar:(CDPullBottomBar *)bottomBar cellAtIndex:(NSUInteger)index boundIn:(CGRect)frame{
    CDMetroCell *cell = nil;
    switch (index) {
        case 2:{
            cell = [[CDImageMetroCell alloc] initWithFrame:frame];
            ((CDImageMetroCell*)cell).imageName = @"BottomCellRepeat";
        }break;
        case 3:{
            cell = [[CDImageMetroCell alloc] initWithFrame:frame];
            ((CDImageMetroCell*)cell).imageName = @"BottomCellAssist";
        }break;
        default:{
            cell = [super bottomBar:bottomBar cellAtIndex:index boundIn:frame];
        }break;
    }
    return cell;
}

- (void)bottomBar:(CDPullBottomBar *)bottomBar touchCellAtIndex:(NSUInteger)index{
    [super bottomBar:bottomBar touchCellAtIndex:index];
    switch (index) {
        case NSUIntegerMax:{
            [_audioSharer playOrPause];
        }break;
        case 0:{
            NSTimeInterval playbackTime = - _audioSharer.playbackRate * CGRectGetHeight(self.view.bounds) * 0.5;
            [_audioSharer playbackFor:playbackTime];
        }break;
        case 1:{
            NSTimeInterval playbackTime = _audioSharer.playbackRate * CGRectGetHeight(self.view.bounds) * 0.5;
            [_audioSharer playbackFor:playbackTime];
        }break;
        case 2:{
            BOOL iR = [_audioSharer.audioPlayer isRepeating];   //is repeating
            if (iR) {
                [_audioSharer stopRepeating];
            }else{
                BOOL iW = [_audioSharer.audioPlayer isWaitingForPointB];    //is waiting for point B
                if (iW) {
                    [_audioSharer setRepeatB];
                }else{
                    if (_audioSharer.canRepeating) {
                        [self loadRepeatView];
                        _repeatView.repeatDirection = CDDirectionRight;
                        [_repeatView show];
                        [_audioSharer setRepeatA];
                    }
                }
            }
        }break;
        case 3:{
            [self switchAssistHidden];
        }break;
        default:
            break;
    }
    DLog(@"%d", index);
}

- (void)bottomBar:(CDPullBottomBar *)bottomButton sliderValueChangedAs:(float)sliderValue{
    NSTimeInterval playbackTime = sliderValue * _audioSharer.audioPlayer.currentDuration;
    [self.audioSharer playbackAt:playbackTime];
    [_progress synchronize:nil];
}

- (NSTimeInterval)bottomBarAskForDuration:(CDPullBottomBar*)bottomButton{
    return _audioSharer.audioPlayer.currentDuration;
}

#pragma mark - CDHolderDelegate
- (void)holder:(CDHolder *)holder beginSwipingOnDirection:(CDDirection)direction index:(NSUInteger)index{
    if (direction & CDDirectionHorizontal) {
        switch (index) {
            case 0:{
                [self prepareToChangeRate];
            }break;
            case 1:{
                [self prepareToRepeat:direction];
            }break;
            default:
                break;
        }
    }
}

- (void)holder:(CDHolder *)holder continueSwipingOnDirection:(CDDirection)direction forIncrement:(CGFloat)increment fromStart:(CGFloat)distance index:(NSUInteger)index{
    if (direction & CDDirectionHorizontal) {
        switch (index) {
            case 0:{
                [_ratesView scrollFor:-increment animated:NO];
            }break;
            case 1:{
                [self countRepeatTimeWithDistance:distance];
            }
            default:
                break;
        }
    }else if (direction & CDDirectionVertical){
        [self.lyricsView scrollFor:-increment animated:NO];
    }
}

- (void)holder:(CDHolder *)holder endSwipingOnDirection:(CDDirection)direction fromStart:(CGFloat)distance index:(NSUInteger)index{
    if (direction & CDDirectionHorizontal) {
        switch (index) {
            case 0:{
                [_ratesView endScrolling];
                return;
            }break;
            case 1:{
                [self repeatWithDirection:direction distance:distance];
                return;
            }break;
            default:
                break;
        }
    }else if (direction & CDDirectionVertical){
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
        return;
    }
    if (!_barsHidden) [self setBarsHidden:YES animated:YES];
}

- (void)holder:(CDHolder *)holder cancelSwipingOnDirection:(CDDirection)direction index:(NSUInteger)index{
    if (direction & CDDirectionHorizontal) {
        switch (index) {
            case 0:{
                [_ratesView cancelScrolling];
             }break;
            case 1:{
                [_repeatView cancel];
                DLog(@"Release Repeat View");
            }break;
            default:
                break;
        }
    }
}

- (void)holder:(CDHolder *)holder handleTap:(NSUInteger)count{
    switch (count) {
        case 1:{
            [self setBarsHidden:YES animated:YES];
        }break;
        case 2:{
            [self.audioSharer playOrPause];
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

#pragma mark - Lyrics
- (BOOL)openLyricsAtPath:(NSString *)path{
    CDLRCLyrics* newLyrics = [[CDLRCLyrics alloc] initWithFile:path];
    if (!newLyrics.isReady) return NO;
    self.lyrics = newLyrics;
    if (_lyricsView == nil) [self createLyricsView];
    else [_lyricsView reloadData];
    return YES;
}

#pragma mark - CDAudioPlayerDelegate
- (void)audioSharer:(CDAudioSharer *)audioSharer stateDidChange:(CDAudioPlayerState)state{
    switch (state) {
        case CDAudioPlayerStatePlaying:{
            _bottomBar.masterButton.isPlaying = YES;
            [_progress setupUpdater];
        }break;
        case CDAudioPlayerStatePaused:{
            _bottomBar.masterButton.isPlaying = NO;
            [_progress stopUpdater];
        }break;
        case CDAudioPlayerStateStopped:{
            _bottomBar.masterButton.isPlaying = NO;
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
    }else{
        BOOL success = [self openLyricsAtPath:lyricsPath];
        if (success) [self.backgroundView switchViewWithKey:CDBackgroundViewKeyNone];
    }
    if (_audioSharer.audioPlayer.isRepeating) [_audioSharer stopRepeating];
    [self.topBar reloadData];
    [self.bottomBar reloadData];
}

- (void)audioSharer:(CDAudioSharer *)audioSharer didRepeatInRange:(CDTimeRange)range{
    [_repeatView.repeater setRepeatRaneg:range];
    [_bottomBar setRepeatRanege:range withDuration:audioSharer.audioPlayer.currentDuration];
    [_repeatView present];
}

- (void)audioSharer:(CDAudioSharer *)audioSharer didSetRepeatA:(NSTimeInterval)pointA{
    
}

- (void)audioSharerDidCancelRepeating:(CDAudioSharer *)audioSharer{
    if (_repeatView != nil) [_repeatView dismiss];
    [_bottomBar cleanRepeatRange];
    DLog(@"Repeat stop");
}

#pragma mark - CDBackgroundViewDatasource
- (NSString*)backgroundViewNeedsAudioName:(CDBackgroundView*)backgroundView{
    NSString *audioTitle = [self.audioSharer valueForProperty:MPMediaItemPropertyTitle];
    return audioTitle;
}

#pragma mark - Events
- (void)switchBarsHidden{
    [self setBarsHidden:!_barsHidden animated:YES];
}

- (void)switchAssistHidden{
    CDBackgroundViewKey state = _backgroundView.state;
    
    if (state == CDBackgroundViewKeyNone) {
        if (_lyrics != nil) {
            [UIView animateWithDuration:0.3f animations:^{
                self.lyricsView.alpha = 0.0f;
            }];
        }
        [self.backgroundView switchViewWithKey:CDBackgroundViewKeyAssist];

    }else{
        if (_lyrics != nil) {
            [UIView animateWithDuration:0.3f animations:^{
                self.lyricsView.alpha = 1.0f;
            }];
        }
        [self.backgroundView switchViewWithKey:CDBackgroundViewKeyNone];
    }

      /*
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
    }*/
}

#pragma mark - CDAudioPregressDelegate
- (void)playbackTimeDidUpdate:(NSTimeInterval)playbackTime withTimes:(NSUInteger)times{
    if (!_holder.isBeingTouched) {
        NSUInteger focusIndex = [self.lyrics indexOfStampNearTime:playbackTime];
        [_lyricsView setFocusIndex:focusIndex];
    }
    if (_repeatView && _audioSharer.audioPlayer.isWaitingForPointB) {
        NSTimeInterval value = playbackTime - _audioSharer.audioPlayer.pointA;
        [_repeatView setValueOfCounterView:value];
    }
}

#pragma mark - CDSubPanViewController
- (void)willPresentWithUserInfo:(id)userInfo{
    NSString *lrcPath = (NSString *)userInfo;
    BOOL success = [self openLyricsAtPath:lrcPath];
    if (success) [self.backgroundView switchViewWithKey:CDBackgroundViewKeyNone];
}

#pragma mark - Rates
- (void)prepareToChangeRate{
    if (_ratesView == nil) {
        CGFloat topMargin = 80.0f;
        CGFloat bottomMargin = 5.0f;
        CGRect frame = self.view.bounds;
        frame.origin.y = topMargin;
        frame.size.height = frame.size.height / 2 - topMargin - bottomMargin;
        self.ratesView = [[CDRatesView alloc] initWithFrame:frame rates:_audioSharer.rates delegate:self];
         _ratesView.autoresizingMask = CDViewAutoresizingFloat;
        [self.view insertSubview:_ratesView belowSubview:_holder];
    }
    [_ratesView startScrolling];
}

- (void)ratesView:(CDRatesView *)rateView didChangeRateTo:(float)rate{
    [_audioSharer setRate:rate];
}

- (void)ratesViewDidHide:(CDRatesView *)rateView{
    [_ratesView removeFromSuperview];
    self.ratesView = nil;
}

#pragma mark - Repeat
- (void)loadRepeatView{
    if (_repeatView != nil) [_repeatView removeFromSuperview];
    
    CGFloat hI = (1 - 0.96) / 2 * CGRectGetWidth(self.view.bounds);  //horizontal inset
    CGRect frame = CGRectInset(self.view.bounds, hI, 0.0f);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    CGFloat topMagin = 0.02 * height;
    CGFloat bottomMagin = 0.17 * height;
    frame.origin.y = height / 2 + topMagin;
    frame.size.height = frame.size.height / 2 - topMagin - bottomMagin;

    _repeatView = [[CDRepeatView alloc] initWithFrame:frame delegate:self];
    _repeatView.autoresizingMask = CDViewAutoresizingFloat;
    [self.view insertSubview:_repeatView aboveSubview:_holder];
}

- (void)prepareToRepeat:(CDDirection)direction{
    if (_audioSharer.canRepeating) {
        if (_repeatView == nil) [self loadRepeatView];
        _repeatView.repeatDirection = direction;
        [_repeatView show];
        DLog(@"Create Repeat View");
    }
}

- (void)countRepeatTimeWithDistance:(CGFloat)distance{
    if (!_audioSharer.audioPlayer.isRepeating) {
        float rate = _audioSharer.repeatRate;
        NSTimeInterval length = rate * distance;
        [_repeatView setValueOfCounterView:length];
        DLog(@"Will repeat for %f", length);
    }
}

- (void)repeatWithDirection:(CDDirection)direction distance:(CGFloat)distance{
    CDDirection currentDirection = CDDirectionNone;
    if (distance < 0) currentDirection = CDDirectionLeft;
    if (distance > 0) currentDirection = CDDirectionRight;
    BOOL sameDirection = direction == currentDirection;
    
    if (sameDirection && !_audioSharer.audioPlayer.isRepeating ) {
        float rate = _audioSharer.repeatRate;
        NSTimeInterval length = rate * distance;
        NSTimeInterval location = _audioSharer.currentPlaybackTime;
        if (length < 0) {
            //Length is nagitive, so add it indicates repeat in forward range.
            location += length;
        }
        CDTimeRange repeatRange = CDMakeTimeRange(location, length);
        
        [_audioSharer repeatIn:repeatRange];
    }
}

#pragma mark - CDRepeatViewDelegate
/*
- (void)repeatViewDidPresent:(CDRepeatView*)repeatView{
    [repeatView.repeater setRepeatRaneg:_audioSharer.repeatRange];
    [_bottomBar setRepeatRanege:_audioSharer.repeatRange withDuration:_audioSharer.currentDuration];
}*/

- (void)repeatViewDidDismiss:(CDRepeatView*)repeatView{
    [_audioSharer stopRepeating];

    [_repeatView removeFromSuperview];
    SafeMemberRelease(_repeatView);
}

- (void)repeatView:(CDRepeatView*)repeatView alterRepeatRange:(CDRepeatAlterType)type{
    CDTimeRange range = _audioSharer.audioPlayer.repeatRange;
    switch (type) {
        case CDRepeatAlterTypeStartPlus:{
            range.location += 1;
            range.length -= 1;
        }break;
        case CDRepeatAlterTypeStartMinus:{
            range.location -= 1;
            range.length += 1;
        }break;
        case CDRepeatAlterTypeEndPlus:{
            range.length += 1;
        }break;
        case CDRepeatAlterTypeEndMinus:{
            range.length -= 1;
        }break;
        default:
            break;
    }
    [_audioSharer repeatIn:range];
}

@end
