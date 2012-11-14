//
//  CDLyrics.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/12/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDLyrics.h"

@implementation CDLyrics
- (id)initWithFile:(NSString*)filePath{
    self = [super init];
    return self;
}
- (NSString*)contentAtIndex:(NSUInteger)index{
    return @"CDLyrics is a abstract Class";
}
- (NSTimeInterval)timeAtIndex:(NSUInteger)index{
    return 0.0f;
}
- (NSUInteger)indexOfStampNearTime:(NSTimeInterval)time{
    return NSUIntegerMax;
}
@end
