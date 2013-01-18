//
//  CDAudioRepeater.m
//  HoldLanguages
//
//  Created by William Remaerd on 1/18/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDAudioRepeater.h"

@implementation CDAudioRepeater
@synthesize range = _range;
- (id)initWithPlayer:(id<CDAudioRepeaterSource>)player progress:(CDAudioProgress*)progress{
    self = [super init];
    if (self) {
        _player = player;
        _progress = progress;
    }
    return self;
}

- (void)repeatIn:(CDTimeRange)range{
    CDTimeRange wholeRange = CDMakeTimeRange(0.0f, _player.currentDuration);
    range = CDIntersectionTimeRange(range, wholeRange);
    
    self.range = range;
    _rangeEnd = CDTimeRangeGetEnd(_range);
    [_progress registerDelegate:self withTimes:1];

    NSTimeInterval location = _range.location;
    if (location + _range.length  < _player.currentPlaybackTime) {
        [_player playbackAt:location];
    }
}

- (void)stopRepeating{
    [_progress removeDelegate:self];
}

#pragma mark - CDAudioPregressDelegate
- (void)playbackTimeDidUpdate:(NSTimeInterval)playbackTime withTimes:(NSUInteger)times{
    if (playbackTime > _rangeEnd)
        [_player playbackAt:_range.location];
}

@end
