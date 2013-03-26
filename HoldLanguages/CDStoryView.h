//
//  CDStoryView.h
//  HoldLanguages
//
//  Created by William Remaerd on 3/22/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FTCoreTextView;
@interface CDStoryView : UIScrollView {
    FTCoreTextView *_textView;
}
- (void)redrawContent;
- (void)setContentString:(NSString *)content;
- (void)scrollFor:(CGFloat)increment animated:(BOOL)animated;
@end

extern NSString * const gStroyTagHead;
extern NSString * const gStroyTagBody;
extern NSString * const gStroyTagImage;