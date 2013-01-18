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
+ (UIColor*)colorWithHex:(long)hexColor alpha:(float)opacity;
+ (UIColor*)color255WithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
@end


@interface UIImageView (CDImageView)
- (id)initWithPathForResource:(NSString *)name ofType:(NSString *)extension;
- (id)initWithPNGImageNamed:(NSString *)imageName;
@end

@interface UIImage (CDImage)
+ (UIImage*)pngImageWithName:(NSString*)imageName;
@end

@interface UIView (CDView)
- (void)setBackgroundLayer:(CALayer *)backgroundLayer;
- (void)loadSubviewsFromXibNamed:(NSString*)xibName;
+ (UIView*)viewFromXibNamed:(NSString*)xibName owner:(id)owner atIndex:(NSUInteger)index;
+ (UIView*)viewFromXibNamed:(NSString*)xibName owner:(id)owner;
@end

@interface UILabel (CDLabel)
- (void)setNonemptyText:(NSString *)text;
@end

@interface NSArray (CDArray)
- (NSUInteger)lastIndex;
@end

@interface UITableViewCell (CDTableViewCell)
- (void)loadSubviewsFromXib;
@end

@interface CDCycleArray : NSObject{
    NSUInteger _index;
    NSArray *_array;
}
@property(nonatomic, assign)NSUInteger index;
- (id)initWithArray:(NSArray *)array index:(NSUInteger)index;
- (id)current;
- (id)next;
- (id)previous;
@end