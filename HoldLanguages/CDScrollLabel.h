//
//  CDScrollLabel.h
//  CDScrollLabel
//
//  Created by William Remaerd on 1/5/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CDScrollLabelDelegate;
@interface CDScrollLabel : UIView{
    UILabel *_label;
    UILabel *_assistLabel;
    NSTimer *_timer;
    BOOL _canAnimate;
}
@property(assign, nonatomic)NSString *text;
@property(assign, nonatomic)UITextAlignment textAlignment;
@property(assign, nonatomic)UIFont *font;
@property(assign, nonatomic)UIColor *textColor;
@property(assign, nonatomic, readonly)BOOL isAnimating;
@property(assign, nonatomic)IBOutlet id<CDScrollLabelDelegate> delegate;

- (id)initWithFrame:(CGRect)frame text:(NSString *)text;
- (void)animateAfterDelay:(NSTimeInterval)timeInterval;
@end

@protocol CDScrollLabelDelegate <NSObject>
- (NSTimeInterval)scrollLabelShouldStartAnimating:(CDScrollLabel *)scrollLabel;
- (NSTimeInterval)scrollLabelShouldContinueAnimating:(CDScrollLabel *)scrollLabel;
@end

@interface UILabel (Copy)
- (UILabel *)copy;
@end