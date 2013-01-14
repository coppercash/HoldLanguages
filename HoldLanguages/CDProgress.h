//
//  CDProgress.h
//  HoldLanguages
//
//  Created by William Remaerd on 1/9/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kUpdaterInterval 0.1f
#define kKeyDelegate @"Del"
#define kKeyTimes @"Tim"

@protocol CDProgressDataSource, CDProgressDelegate;
@interface CDProgress : NSObject {
    NSTimer *_updater;
    id<CDProgressDataSource> _dataSource;
    NSSet *_delegates;
    NSUInteger _counter;
}
@property(strong, nonatomic)id<CDProgressDataSource> dataSource;
- (void)setupUpdater;
- (void)stopUpdater;
- (void)synchronize;
- (float)progress;
- (void)registerDelegate:(id<CDProgressDelegate>)delegate withTimes:(NSUInteger)times;
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
