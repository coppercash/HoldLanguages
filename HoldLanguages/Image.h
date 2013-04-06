//
//  Image.h
//  HoldLanguages
//
//  Created by William Remaerd on 3/18/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item;

@interface Image : NSManagedObject

@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) Item *item;

@end
