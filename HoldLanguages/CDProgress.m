//
//  CDProgress.m
//  HoldLanguages
//
//  Created by William Remaerd on 1/9/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDProgress.h"
@interface CDProgress ()
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

- (void)stopUpdater{
    [_updater invalidate];
    SafeMemberRelease(_updater);
}

- (void)registerDelegate:(id<CDProgressDelegate>)delegate withTimes:(NSUInteger)times{
    if (delegate == nil) return;
    if (times == 0) times = 1;
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:delegate, kKeyDelegate, [NSNumber numberWithInteger:times], kKeyTimes, nil];
    if (_delegates == nil) {
        _delegates = [[NSSet alloc] initWithObjects:dic, nil];
    }else{
        NSSet *newDelegates = [_delegates setByAddingObject:dic];
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
    for (NSDictionary *dic in _delegates) {
        NSUInteger times = [[dic objectForKey:kKeyTimes] unsignedIntegerValue];
        if (_counter % times == 0) {
            id<CDProgressDelegate> delegate = [dic objectForKey:kKeyDelegate];
            if ([delegate respondsToSelector:@selector(progressDidUpdate:withTimes:)]) {
                [delegate progressDidUpdate:progress withTimes:times];
            }
        }
    }
    _counter++;
}

@end

@interface CDAudioProgress (Private)
@end
@implementation CDAudioProgress
- (NSTimeInterval)playbackTime{
    NSTimeInterval playbackTime = 0.0f;
    id<CDAudioProgressDataSource> dataSource = (id<CDAudioProgressDataSource>)_dataSource;
    if (dataSource && [dataSource respondsToSelector:@selector(playbackTimeOfProgress:)]) {
        playbackTime = [dataSource playbackTimeOfProgress:self];
    }
    return playbackTime;
}

- (void)synchronize{
    float progress = self.progress;
    NSTimeInterval playbackTime = self.playbackTime;
    for (NSDictionary *dic in _delegates) {
        NSUInteger times = [[dic objectForKey:kKeyTimes] unsignedIntegerValue];
        if (_counter % times == 0 || _updater == nil) {
            id<CDAudioProgressDelegate> delegate = [dic objectForKey:kKeyDelegate];
            if ([delegate respondsToSelector:@selector(progressDidUpdate:withTimes:)]) {
                [delegate progressDidUpdate:progress withTimes:times];
            }
            if ([delegate respondsToSelector:@selector(playbackTimeDidUpdate:withTimes:)]) {
                [delegate playbackTimeDidUpdate:playbackTime withTimes:times];
            }
        }
    }
    _counter++;
}

@end