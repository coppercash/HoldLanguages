//
//  CDProgress.m
//  HoldLanguages
//
//  Created by William Remaerd on 1/9/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDProgress.h"
@interface CDProgress (Private)
- (void)setupUpdater;
- (void)synchronize;
@end
@implementation CDProgress
@synthesize dataSource = _dataSource;
- (id)init{
    self = [super init];
    if (self){
        [self setupUpdater];
    }
    return self;
}

- (void)dealloc{
    [_updater invalidate];
}

- (void)setupUpdater{
    _updater = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:kUpdaterInterval target:self selector:@selector(synchronize) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_updater forMode:NSDefaultRunLoopMode];
}

- (void)registerDelegates:(NSArray *)delegates{
    if (delegates == nil || delegates.count == 0) return;
    if (_delegates == nil) {
        _delegates = [[NSArray alloc] initWithArray:delegates];
    }else{
        NSMutableArray *extendedArray = [[NSMutableArray alloc] init];
        for (id<CDPregressDelegate> delegate in _delegates) {
            if ([_delegates containsObject:delegate]) continue;
            [extendedArray addObject:delegate];
        }
        NSArray *newDelegates = [_delegates arrayByAddingObjectsFromArray:extendedArray];
        _delegates = newDelegates;
    }
}

- (void)registerDelegate:(id<CDPregressDelegate>)delegate{
    if (delegate == nil) return;
    if (_delegates == nil) {
        _delegates = [[NSArray alloc] initWithObjects:delegate, nil];
    }else if(![_delegates containsObject:delegate]){
        NSArray *newDelegates = [_delegates arrayByAddingObject:delegate];
        _delegates = newDelegates;
    }
}

- (float)progress{
    float progress = 0.0f;
    if (_dataSource && [_dataSource respondsToSelector:@selector(progress:)]) {
        progress = [_dataSource progress:self];
    }
    return progress;
}

- (void)synchronize{
    float progress = self.progress;
    for (id<CDPregressDelegate> delegate in _delegates) {
        if ([delegate respondsToSelector:@selector(progressDidUpdate:)]) {
            [delegate progressDidUpdate:progress];
        }
    }
}

@end

@interface CDAudioProgress (Private)
@end
@implementation CDAudioProgress
- (NSTimeInterval)playbackTime{
    NSTimeInterval playbackTime = 0.0f;
    id<CDAudioPregressDataSource> dataSource = (id<CDAudioPregressDataSource>)_dataSource;
    if (dataSource && [dataSource respondsToSelector:@selector(playbackTimeOfProgress:)]) {
        playbackTime = [dataSource playbackTimeOfProgress:self];
    }
    return playbackTime;
}

- (void)synchronize{
    float progress = self.progress;
    NSTimeInterval playbackTime = self.playbackTime;
    for (id<CDAudioPregressDelegate> delegate in _delegates) {
        if ([delegate respondsToSelector:@selector(progressDidUpdate:)]) {
            [delegate progressDidUpdate:progress];
        }
        if ([delegate respondsToSelector:@selector(playbackTimeDidUpdate:)]) {
            [delegate playbackTimeDidUpdate:playbackTime];
        }
    }
}

@end