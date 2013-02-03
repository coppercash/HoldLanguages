//
//  CDAssitMetroCell.h
//  HoldLanguages
//
//  Created by William Remaerd on 1/31/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDMetroCell.h"

@interface CDImageMetroCell : CDMetroCell{
    UIImageView *_imageView;
    NSString* _imageName;
}
@property(nonatomic, copy)NSString* imageName;
@end
