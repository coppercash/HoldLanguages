#import "CDLabel.h"

@implementation CDLabel

- (id)initWithUILable:(UILabel*)templateLabel rate:(CGFloat)pixelsPerSec fadeLength:(CGFloat)fadeLength{
    self = [super initWithFrame:templateLabel.frame rate:pixelsPerSec andFadeLength:fadeLength];
    if (self) {
        self.numberOfLines = templateLabel.numberOfLines;
        self.textAlignment = templateLabel.textAlignment;
        self.textColor = templateLabel.textColor;
        self.backgroundColor = templateLabel.backgroundColor;
        self.font = templateLabel.font;
        self.autoresizingMask = templateLabel.autoresizingMask;
        self.shadowOffset = templateLabel.shadowOffset;
        
        self.opaque = NO;
        self.enabled = YES;
    }
    return self;
}

- (id)initWithUILable:(UILabel*)templateLabel{
    self = [self initWithUILable:templateLabel rate:kDefaultRate fadeLength:kDefaultFadeLength];
    if (self) {
        
    }
    return self;
}

- (void)setNonemptyText:(NSString *)text{
    if (text == nil) return;
    self.text = text;
}

@end
