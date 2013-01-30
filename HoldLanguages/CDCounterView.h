//
//  CDCounterView.h
//  HoldLanguages
//
//  Created by William Remaerd on 1/23/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kRepeatIconName @"FileIconLRC"

@interface CDCounterView : UIView {
    UIImageView *_icon;
    UILabel *_number;
    UIImage *_image;
    
    CDDirection _direction;
}
@property(nonatomic, readonly)IBOutlet UIImageView *icon;
@property(nonatomic, readonly)IBOutlet UILabel *number;
@property(nonatomic, assign)CDDirection direction;
- (void)setTimeInterval:(NSTimeInterval)timeInterval;
@end
