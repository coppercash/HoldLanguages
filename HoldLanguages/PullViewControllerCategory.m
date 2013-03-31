//
//  PullViewControllerCategory.m
//  HoldLanguages
//
//  Created by William Remaerd on 3/28/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "PullViewControllerCategory.h"
#import "CDImageMetroCell.h"
#import "CDRepeatView.h"
#import "CDAudioSharer.h"
#import "CDItem.h"

#import "RepeatViewCategory.h"
#import "BackgroundViewCategory.h"
#import "IntroductionCategory.h"

@interface MainViewController ()

@end

@implementation MainViewController (PullViewControllerCategory)

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
            NSString* title = nil;
            if (_item) {
                title = _item.title;
            }else{
                title = [self.audioSharer valueForProperty:MPMediaItemPropertyTitle];
            }
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
    switch (direction) {
        case CDDirectionRight:
            _panViewController.leftViewController = [_panViewController createSubController:_panViewController.leftControllerClass];
            break;
        case CDDirectionLeft:
            _panViewController.rightViewController = [_panViewController createSubController:_panViewController.rightControllerClass];
            break;
        default:
            break;
    }
}

- (CGFloat)topBarContinuePulling:(CDPullTopBar *)topBar onDirection:(CDDirection)direction shouldMove:(CGFloat)increment{
    if (_barsHidden) return 0.0f;
    CGFloat superIncrement = [super topBarContinuePulling:topBar onDirection:direction shouldMove:increment];
    if (superIncrement != 0.0f) return superIncrement;
    
    switch (direction) {
        case CDDirectionRight:
            [_panViewController panRootControllerWithIncrement:CGPointMake(increment, 0.0f)];
            break;
        case CDDirectionLeft:
            [_panViewController panRootControllerWithIncrement:CGPointMake(increment, 0.0f)];
            break;
        default:
            break;
    }
    
    /*
     if (direction == CDDirectionRight) {
     [_panViewController panRootControllerWithIncrement:CGPointMake(increment, 0.0f)];
     }*/
    return 0.0;
}

- (void)topBarFinishPulling:(CDPullTopBar*)topBar onDirection:(CDDirection)direction{
    [super topBarFinishPulling:topBar onDirection:direction];
    switch (direction) {
        case CDDirectionRight:
            [_panViewController showLeftController:YES];
            break;
        case CDDirectionLeft:
            [_panViewController showRightController:YES];
            break;
        default:
            break;
    }
}

- (void)topBarCancelPulling:(CDPullTopBar*)topBar onDirection:(CDDirection)direction{
    [super topBarCancelPulling:topBar onDirection:direction];
    if (direction == CDDirectionRight) {
        [_panViewController showRootController:YES];
    }
}

- (void)topBar:(CDPullTopBar *)topBar buttonTouched:(NSUInteger)position{
    switch (position) {
        case 0:{
            _panViewController.leftViewController = [_panViewController createSubController:_panViewController.leftControllerClass];
            [_panViewController showLeftController:YES];
        }break;
        case 1:{
            _panViewController.rightViewController = [_panViewController createSubController:_panViewController.rightControllerClass];
            [_panViewController showRightController:YES];
        }
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
    _topBar.rightButton.contentMode = UIViewContentModeCenter;
    [_topBar.rightButton setImage:[UIImage pngImageWithName:@"TopBariTunes"] forState:UIControlStateNormal];
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
                        [self prepareToRepeat:CDDirectionRight];
                        [_audioSharer setRepeatA];
                    }
                }
            }
        }break;
        case 3:{
            [self switchIntroductionView];
        }break;
        default:
            break;
    }
}

- (void)bottomBar:(CDPullBottomBar *)bottomButton sliderValueChangedAs:(float)sliderValue{
    NSTimeInterval playbackTime = sliderValue * _audioSharer.audioPlayer.currentDuration;
    [self.audioSharer playbackAt:playbackTime];
    [_progress synchronize:nil];
}

- (NSTimeInterval)bottomBarAskForDuration:(CDPullBottomBar*)bottomButton{
    return _audioSharer.audioPlayer.currentDuration;
}

#pragma mark - Events
- (void)switchBarsHidden{
    [self setBarsHidden:!_barsHidden animated:YES];
}

@end
