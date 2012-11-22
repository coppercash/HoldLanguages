//
//  CDStateButton.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/21/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kEffectiveRectInset -50.0f

typedef enum {
    CDStateButtonShouldChangeMaskKeep = -1,
    CDStateButtonShouldChangeMaskNext = -2
}CDStateButtonShouldChangeMask;

@protocol CDStateButtonDelegate;
@interface CDStateButton : UIControl
@property(nonatomic, readonly, strong)NSArray* images;
@property(nonatomic, readonly, strong)UIImageView* backgound;
@property(nonatomic)NSUInteger state;
@property(nonatomic, weak)id<CDStateButtonDelegate> delegate;
- (void)addImagesForStateNormal:(UIImage*)normalImage forHighlighted:(UIImage*)highlightedImage;
- (void)addPNGFilesNormal:(NSString*)normalName highlighted:(NSString*)highlightedName;
@end

@protocol CDStateButtonDelegate
- (NSInteger)shouldStateButtonChangedValue:(CDStateButton*)stateButton;
@end
