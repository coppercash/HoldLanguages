//
//  CDAudioRepeater.m
//  HoldLanguages
//
//  Created by William Remaerd on 1/18/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDAudioRepeater.h"

@implementation CDAudioRepeater
- (id)initWithPlayer:(id<CDAudioRepeaterSource>)player progress:(CDAudioProgress*)progress{
    self = [super init];
    if (self) {
        _player = player;
        _progress = progress;
    }
    return self;
}

- (void)repeatIn:(CDTimeRange)range{
    if (range.length <= 0) return;
    CDTimeRange wholeRange = CDMakeTimeRange(0.0f, _player.currentDuration);
    range = CDIntersectionTimeRange(range, wholeRange);
    
    _repeatRange = range;
    _rangeEnd = CDTimeRangeGetEnd(_repeatRange);
    [_progress registerDelegate:self withTimes:1];

    NSTimeInterval location = _repeatRange.location;
    if (location + _repeatRange.length  < _player.currentPlaybackTime) {
        [_player playbackAt:location];
    }
}

- (void)stopRepeating{
    [_progress removeDelegate:self];
}

- (CDTimeRange)repeatRange{
    return _repeatRange;
}

#pragma mark - CDAudioPregressDelegate
- (void)playbackTimeDidUpdate:(NSTimeInterval)playbackTime withTimes:(NSUInteger)times{
    if (playbackTime > _rangeEnd)
        [_player playbackAt:_repeatRange.location];
}

@end
