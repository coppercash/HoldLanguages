//
//  CDAudioRepeater.h
//  HoldLanguages
//
//  Created by William Remaerd on 1/18/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDProgress.h"
@protocol CDAudioRepeaterSource;
@interface CDAudioRepeater : NSObject <CDAudioProgressDelegate>{
    id<CDAudioRepeaterSource> _player;
    CDAudioProgress *_progress;
    CDTimeRange _repeatRange;
    NSTimeInterval _rangeEnd;
}
- (id)initWithPlayer:(id<CDAudioRepeaterSource>)player progress:(CDAudioProgress*)progress;
- (void)repeatIn:(CDTimeRange)range;
- (void)stopRepeating;
- (CDTimeRange)repeatRange;
@end

@protocol CDAudioRepeaterSource <NSObject>
@required
- (NSTimeInterval)currentPlaybackTime;
- (NSTimeInterval)currentDuration;
- (void)playbackAt:(NSTimeInterval)playbackTime;
@end