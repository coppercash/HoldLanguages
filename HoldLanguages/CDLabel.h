#import <Foundation/Foundation.h>
#import "MarqueeLabel.h"

#define kDefaultRate 20.0f
#define kDefaultFadeLength 10.0f

@interface CDLabel : MarqueeLabel

- (id)initWithUILable:(UILabel*)templateLabel rate:(CGFloat)pixelsPerSec fadeLength:(CGFloat)fadeLength;
- (id)initWithUILable:(UILabel*)templateLabel;
- (void)setNonemptyText:(NSString *)text;

@end
