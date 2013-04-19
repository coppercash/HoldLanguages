//
//  HLCatagoryTableCell.h
//  HoldLanguages
//
//  Created by William Remaerd on 4/15/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDScrollLabel.h"

@interface HLCategoryTableCell : UITableViewCell <CDScrollLabelDelegate>{
    CDScrollLabel *_title;
}
- (id)initWithReuseIdentifier:(NSString *)identifier;
@property(strong, nonatomic)IBOutlet CDScrollLabel *title;

@end
