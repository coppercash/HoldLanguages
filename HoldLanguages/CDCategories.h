//
//  CDCategories.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/15/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor (CDColor)
+ (UIColor*) colorWithHex:(long)hexColor;
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity;
@end


@interface UIImageView (CDImageView)
- (id)initWithPathForResource:(NSString *)name ofType:(NSString *)extension;
@end