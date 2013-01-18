//
//  CDProgress.h
//  HoldLanguages
//
//  Created by William Remaerd on 1/9/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kKeyDelegate @"Del"
#define kKeyTimes @"Tim"

@protocol CDProgressDataSource, CDProgressDelegate;
@interface CDProgress : NSObject {
    NSTimer *_updater;
    id<CDProgressDataSource> _dataSource;
    NSSet *_delegates;
    NSUInteger _counter;
    NSTimeInterval _updateInterval;
}
@property(strong, nonatomic)id<CDProgressDataSource> dataSource;
- (id)initWithUpdateInterval:(NSTimeInterval)interval;
- (void)setupUpdater;
- (void)stopUpdater;
- (void)synchronize:(NSTimer*)updater;
- (float)progress;
- (void)registerDelegate:(id<CDProgressDelegate>)delegate withTimes:(NSUInteger)times;
- (void)removeDelegate:(id<CDProgressDelegate>)delegate;
@end

@protocol CDProgressDataSource <NSObject>
@optional
- (float)progress:(CDProgress *)progress;
@end
@protocol CDProgressDelegate <NSObject>
@optional
- (void)progressDidUpdate:(float)progress withTimes:(NSUInteger)times;
@end

@protocol CDAudioProgressDataSource, CDAudioProgressDelegate;
@interface CDAudioProgress : CDProgress
- (NSTimeInterval)playbackTime;
@end
@protocol CDAudioProgressDataSource <CDProgressDataSource>
@optional
- (NSTimeInterval)playbackTimeOfProgress:(CDAudioProgress *)progress;
@end
@protocol CDAudioProgressDelegate <CDProgressDelegate>
@optional
- (void)playbackTimeDidUpdate:(NSTimeInterval)playbackTime withTimes:(NSUInteger)times;
@end
