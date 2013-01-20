//
//  CDBigLabelView.h
//  HoldLanguages
//
//  Created by William Remaerd on 1/20/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDBigLabelView : UIView{
    NSString *_text;
}
@property(nonatomic, copy)NSString *text;
- (id)initWithFrame:(CGRect)frame text:(NSString*)text;
- (id)initWithText:(NSString*)text;
@end
