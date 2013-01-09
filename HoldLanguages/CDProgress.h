//
//  CDProgress.h
//  HoldLanguages
//
//  Created by William Remaerd on 1/9/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kUpdaterInterval 1.0f

@protocol CDPregressDataSource, CDPregressDelegate;
@interface CDProgress : NSObject {
    NSTimer *_updater;
    id<CDPregressDataSource> _dataSource;
    NSArray *_delegates;
}
@property(strong, nonatomic)id<CDPregressDataSource> dataSource;
- (float)progress;
- (void)registerDelegates:(NSArray *)delegates;
- (void)registerDelegate:(id<CDPregressDelegate>)delegate;
@end
@protocol CDPregressDataSource <NSObject>
- (float)progress:(CDProgress *)progress;
@end
@protocol CDPregressDelegate <NSObject>
- (void)progressDidUpdate:(float)progress;
@end

@protocol CDAudioPregressDataSource, CDAudioPregressDelegate;
@interface CDAudioProgress : CDProgress
- (NSTimeInterval)playbackTime;
@end
@protocol CDAudioPregressDataSource <CDPregressDataSource>
- (NSTimeInterval)playbackTimeOfProgress:(CDAudioProgress *)progress;
@end
@protocol CDAudioPregressDelegate <CDPregressDelegate>
- (void)playbackTimeDidUpdate:(NSTimeInterval)playbackTime;
@end
