//
//  Content.h
//  HoldLanguages
//
//  Created by William Remaerd on 3/19/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item;

@interface Content : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) Item *item;

@end
