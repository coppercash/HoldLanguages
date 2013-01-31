//
//  CDCounterView.m
//  HoldLanguages
//
//  Created by William Remaerd on 1/23/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDCounterView.h"

@implementation CDCounterView
@synthesize icon = _icon, number = _number;
@synthesize direction = _direction;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _image = [UIImage pngImageWithName:kRepeatIconName];
        _icon = [[UIImageView alloc] init];
        _icon.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        _icon.contentMode = UIViewContentModeCenter;
        
        _number = [[UILabel alloc] init];
        _number.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        _number.font = [UIFont boldSystemFontOfSize:30];
        _number.textColor = [UIColor whiteColor];
        _number.backgroundColor = [UIColor clearColor];
        _number.adjustsFontSizeToFitWidth = YES;

        //_icon.backgroundColor = _number.backgroundColor = kDebugColor;
        
        _direction = CDDirectionNone;
        
        [self addSubview:_icon];
        [self addSubview:_number];
    }
    return self;
}

- (void)setDirection:(CDDirection)direction{
    if (direction == _direction) return;
    _direction = direction;
    
    CGRect bounds = self.bounds;
    
    CGFloat stageWidth = CGRectGetWidth(bounds) * 0.4;
    CGFloat size = 40.0f;
    
    CGFloat leftMargin = (CGRectGetWidth(bounds) - stageWidth) / 2;
    CGFloat topMargin = (CGRectGetHeight(bounds) - size) / 2;
    
    switch (direction) {
        case CDDirectionLeft:{
            //Forward, icon at left
            _icon.frame = CGRectMake(leftMargin, topMargin, size, size);
            UIImage *flip = [[UIImage alloc] initWithCGImage:_image.CGImage scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationUpMirrored];
            _icon.image = flip;
            
            CGRect numberFrame = _icon.frame;
            numberFrame.origin.x = CGRectGetMaxX(numberFrame);
            numberFrame.size.width = stageWidth - size;
            _number.frame = numberFrame;
            _number.textAlignment = UITextAlignmentRight;
        }break;
        case CDDirectionRight:{
            //Backward, icon at right
            _number.frame = CGRectMake(leftMargin, topMargin, stageWidth - size, size);
            _number.textAlignment = UITextAlignmentLeft;
            
            CGRect icon = _number.frame;
            icon.origin.x = CGRectGetMaxX(icon);
            icon.size.width = size;
            _icon.frame = icon;
            _icon.image = _image;
        }break;

        default:
            break;
    }
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval{
    NSString *text = [[NSString alloc] initWithFormat:@"%2.1lfs", timeInterval];
    _number.text = text;
}
/*
- (void)setFrame:(CGRect)frame{
    _boundsView.center = CGPointMake(CGRectGetWidth(frame) / 2, CGRectGetHeight(frame) / 2);
    [super setFrame:frame];;
}*/

@end
