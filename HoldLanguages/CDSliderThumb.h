//
//  CDSliderThumb.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/16/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//


#import <UIKit/UIKit.h>
#define kThumbImageName @"thumb"
#define kThumbHeight 20.0f
#define kThumbWidth 91.f * kThumbHeight / 98.f
@interface CDSliderThumb : UIControl{
    BOOL _thumbOn;                              // track the current touch state of the slider
    UIImageView* _thumbImageView;               // the slide knob
}
@property(nonatomic) float value;               // default 0.0. this value will be pinned to min/max
@property(nonatomic) BOOL thumbOn;
@end
