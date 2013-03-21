//
//  CDItem.h
//  HoldLanguages
//
//  Created by William Remaerd on 3/19/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "Item.h"
#define kItemDescription(context) ([NSEntityDescription entityForName:NSStringFromClass([Item class]) inManagedObjectContext:context])
typedef enum{
    ItemStatusInit = 0,
    ItemStatusDownloaded = 1
}ItemStatus;

typedef void(^CDItemCompletion)(Item *item);
typedef void(^CDItemCorrector)(Item *item, NSError *error);

@interface Item (Enhance)
+ (Item *)newItemWithDictionary:(NSDictionary *)dictionary path:(NSString *)path;
+ (NSArray *)itemsOfAbsolutePath:(NSString *)path;
+ (NSArray *)itemsDownloaded;
+ (BOOL)exixtsItemWithSameAbsolutePath:(NSString *)path;
- (void)configureWithDictionary:(NSDictionary *)dictionary path:(NSString *)path forced:(BOOL)isForced;
- (NSString *)hostName;
- (Image *)anyImage;
@end
