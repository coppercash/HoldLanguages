//
//  CDSliderProgressView.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/16/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDSliderProgressView.h"

@implementation CDSliderProgressView

- (void)setProgress:(float)value{
    self.currentProgressValue = value * 100;
}

- (void)setup{
    if (maxValue == 0.0) {
        maxValue = 100.0;
    }
    
    leftValue = minValue;
    rightValue = maxValue;
    
    slider = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"BJRangeSliderGreen.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:4]];
    [self addSubview:slider];
    
    rangeImage = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"BJRangeSliderEmpty.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:4]];
    [self addSubview:rangeImage];
    
    progressImage = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"BJRangeSliderRed.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:4]];
    [self addSubview:progressImage];
    
    [self setDisplayMode:BJRSWPAudioPlayMode];
}

- (void)setDisplayMode:(BJRangeSliderWithProgressDisplayMode)mode {
    switch (mode) {
        case BJRSWPAudioRecordMode:
            self.showThumbs = NO;
            self.showRange = NO;
            self.showProgress = YES;
            progressImage.image = [[UIImage imageNamed:@"BJRangeSliderRed.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:4];
            break;
            
        case BJRSWPAudioSetTrimMode:
            self.showThumbs = YES;
            self.showRange = YES;
            self.showProgress = NO;
            break;
            
        case BJRSWPAudioPlayMode:
            self.showThumbs = NO;
            self.showRange = YES;
            self.showProgress = YES;
            progressImage.image = [[UIImage imageNamed:@"BJRangeSliderBlue.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:4];
        default:
            break;
    }
    
    [self setNeedsLayout];
}

@end
