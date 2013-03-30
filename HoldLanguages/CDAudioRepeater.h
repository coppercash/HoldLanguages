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
    CDDoubleRange _repeatRange;
    NSTimeInterval _rangeEnd;
}
- (id)initWithPlayer:(id<CDAudioRepeaterSource>)player progress:(CDAudioProgress*)progress;
- (void)repeatIn:(CDDoubleRange)range;
- (void)stopRepeating;
- (CDDoubleRange)repeatRange;
@end

@protocol CDAudioRepeaterSource <NSObject>
@required
- (NSTimeInterval)currentPlaybackTime;
- (NSTimeInterval)currentDuration;
- (void)playbackAt:(NSTimeInterval)playbackTime;
@end