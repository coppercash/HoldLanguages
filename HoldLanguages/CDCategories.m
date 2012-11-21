//
//  CDCategories.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/15/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDCategories.h"
#import "Header.h"

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

+ (UIColor*)color255WithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha{
    UIColor* color = [UIColor colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:alpha];
    return color;
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

@implementation UIView (CDView)
- (void)setBackgroundLayer:(CALayer *)backgroundLayer;
{
    CALayer * oldBackground = [[self.layer sublayers] objectAtIndex:0];
    if (oldBackground){
        [self.layer replaceSublayer:oldBackground with:backgroundLayer];
    }else{
        [self.layer insertSublayer:backgroundLayer atIndex:0];
    }
}

- (void)loadSubviewsFromXibNamed:(NSString*)xibName{
    NSArray* xibViews = [[NSBundle mainBundle] loadNibNamed:xibName owner:self options:nil];
    if (xibViews.count != 1) NSLog(@"Wrong number(%d) of xib views.", xibViews.count);
    UIView *rootView = [xibViews objectAtIndex:0];
    if (!CGSizeEqualToSize(self.bounds.size, rootView.bounds.size)) NSLog(@"Incompatible bounds between self's %f,%f and xib's %f,%f", self.bounds.size.width, self.bounds.size.height, rootView.bounds.size.width, rootView.bounds.size.height);
    for (UIView* subview in rootView.subviews) {
        [self addSubview:subview];
    }
}
@end

@implementation UILabel (CDLabel)
- (void)setNonemptyText:(NSString *)text{
    if (text == nil) return;
    self.text = text;
}
@end