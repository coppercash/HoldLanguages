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
- (id)initWithUpdateInterval:(NSTimeInterval)interval{
    self = [super init];
    if (self){
        //[self setupUpdater];
        _updateInterval = interval;
    }
    return self;
}

- (void)dealloc{
    [_updater invalidate];
}

- (void)setupUpdater{
    _updater = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:_updateInterval target:self selector:@selector(synchronize:) userInfo:nil repeats:YES];
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

- (void)removeDelegate:(id<CDProgressDelegate>)delegate{
    if (delegate == nil || _delegates == nil) return;
    NSDictionary *dic = nil;
    for (dic in _delegates) {
        if ([dic objectForKey:kKeyDelegate] == delegate) break;
    }
    if (dic == nil) return;
    
    NSMutableSet *tempSet = [[NSMutableSet alloc] initWithSet:_delegates];
    [tempSet removeObject:dic];
    _delegates = [[NSSet alloc] initWithSet:tempSet];
}


- (float)progress{
    float progress = 0.0f;
    if (_dataSource && [_dataSource respondsToSelector:@selector(progress:)]) {
        progress = [_dataSource progress:self];
    }
    return progress;
}

- (void)synchronize:(NSTimer*)updater{
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

- (void)synchronize:(NSTimer*)updater{
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