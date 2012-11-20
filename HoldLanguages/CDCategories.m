//
//  CDCategories.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/15/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDCategories.h"

@implementation UIColor (CDColor)
+ (UIColor*) colorWithHex:(long)hexColor{
    return [UIColor colorWithHex:hexColor alpha:1.];
}

+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity{
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:opacity];
}
@end

@implementation UIImageView (CDImageView)
- (id)initWithPathForResource:(NSString *)name ofType:(NSString *)extension{
    NSString* imagePath = [[NSBundle mainBundle] pathForResource:name ofType:extension];
    UIImage* image = [UIImage imageWithContentsOfFile:imagePath];
    self = [self initWithImage:image];
    return self;
}

- (id)initWithPNGImageNamed:(NSString *)imageName{
    NSString* imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
    UIImage* image = [UIImage imageWithContentsOfFile:imagePath];
    self = [self initWithImage:image];
    return self;
}

@end

@implementation UIImage (CDImage)
+ (UIImage*)pngImageWithName:(NSString*)imageName{
    NSString* imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
    UIImage* image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}
@end