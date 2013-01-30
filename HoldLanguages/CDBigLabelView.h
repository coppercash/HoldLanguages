//
//  CDBigLabelView.h
//  HoldLanguages
//
//  Created by William Remaerd on 1/20/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDBigLabelView : UIView{
    UILabel *_bigLabel;
}
@property(nonatomic, readonly)UILabel *bigLabel;
- (id)initWithFrame:(CGRect)frame text:(NSString*)text;
- (id)initWithText:(NSString*)text;
@end
