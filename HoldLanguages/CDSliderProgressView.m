//
//  CDSliderProgressView.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/16/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDSliderProgressView.h"
#import "ARCMacro.h"
#import "CDColorFinder.h"

@interface YLProgressBar ()
@property (nonatomic, assign)               double      progressOffset;
@property (nonatomic, assign)               CGFloat     cornerRadius;
@property (nonatomic, SAFE_ARC_PROP_RETAIN) NSTimer*    animationTimer;

/** Init the progress bar. */
- (void)initializeProgressBar;

/** Build the stripes. */
- (UIBezierPath *)stripeWithOrigin:(CGPoint)origin bounds:(CGRect)frame;

/** Draw the background (track) of the slider. */
- (void)drawBackgroundWithRect:(CGRect)rect;
/** Draw the progress bar. */
- (void)drawProgressBarWithRect:(CGRect)rect;
/** Draw the gloss into the given rect. */
- (void)drawGlossWithRect:(CGRect)rect;
/** Draw the stipes into the given rect. */
- (void)drawStripesWithRect:(CGRect)rect;

@end

@implementation CDSliderProgressView

- (void)initializeProgressBar
{
    self.progressOffset     = 0;
    self.animationTimer     = nil;
    self.animated           = NO;
}

- (void)drawBackgroundWithRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    {
        // Draw the white shadow
        [[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.2] set];
        
        UIBezierPath* shadow        = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.5, 0, rect.size.width - 1, rect.size.height - 1)
                                                                 cornerRadius:cornerRadius];
        [shadow stroke];
        
        // Draw the track
        CDColorFinder* colorFinder = [[CDColorFinder alloc] init];
        [colorFinder.colorOfProgressViewBackground set];
        
        UIBezierPath* roundedRect   = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, rect.size.width, rect.size.height-1) cornerRadius:cornerRadius];
        [roundedRect fill];
        
        // Draw the inner glow
        [colorFinder.colorOfProgressViewBackgroundGlow set];
        
        CGMutablePathRef glow       = CGPathCreateMutable();
        CGPathMoveToPoint(glow, NULL, cornerRadius, 0);
        CGPathAddLineToPoint(glow, NULL, rect.size.width - cornerRadius, 0);
        CGContextAddPath(context, glow);
        CGContextDrawPath(context, kCGPathStroke);
        CGPathRelease(glow);
    }
    CGContextRestoreGState(context);
}

- (void)drawProgressBarWithRect:(CGRect)rect
{
    CGContextRef context        = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef colorSpace  = CGColorSpaceCreateDeviceRGB();
    
    CGContextSaveGState(context);
    {
        UIBezierPath *progressBounds    = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
        CGContextAddPath(context, [progressBounds CGPath]);
        CGContextClip(context);
        
        size_t num_locations            = 2;
        CGFloat locations[]             = {0.0, 1.0};
        CDColorFinder* colorFinder = [[CDColorFinder alloc] init];
        CGFloat progressComponents[8];
        [colorFinder gradientComponentsProgressView:progressComponents];
        //CGFloat progressComponents[]    = YLProgressBarGradientProgress;
        CGGradientRef gradient          = CGGradientCreateWithColorComponents (colorSpace, progressComponents, locations, num_locations);
        
        CGContextDrawLinearGradient(context, gradient, CGPointMake(rect.origin.x, rect.origin.y), CGPointMake(rect.origin.x + rect.size.width, rect.origin.y), (kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation));
        
        CGGradientRelease(gradient);
    }
    CGContextRestoreGState(context);
    
    CGColorSpaceRelease(colorSpace);
}

@end
