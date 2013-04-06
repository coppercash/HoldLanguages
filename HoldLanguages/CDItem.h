//
//  CDItem.h
//  HoldLanguages
//
//  Created by William Remaerd on 3/19/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "Item.h"

typedef enum{
    ItemStatusInit = 0,
    ItemStatusDownloading = 1,
    ItemStatusDownloaded = 2
}ItemStatus;

typedef void(^CDItemCompletion)(Item *item);
typedef void(^CDItemCorrector)(Item *item, NSError *error);

@interface Item (Enhance)
#pragma mark - Fetch
+ (Item *)fetchOrCreatItem:(NSDictionary *)dictionary;
+ (Item *)newItemWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)itemsOfAbsolutePath:(NSString *)path;
+ (NSArray *)itemsDownloaded;
+ (BOOL)exixtsItemWithSameAbsolutePath:(NSString *)path;
#pragma mark - Configure
- (void)configureWithDictionary:(NSDictionary *)dictionary forced:(BOOL)isForced;
#pragma mark - Delete
- (void)removeResource;
+ (void)removeInitItems;
#pragma mark - Getter
- (NSString *)hostName;
- (NSString *)relativePath;
- (Image *)anyImage;
//- (NSString *)contentWithTitle;
- (BOOL)isEqualToItem:(Item *)anotherItem;
@end

#define kItemDescription(context) ([NSEntityDescription entityForName:NSStringFromClass([Item class]) inManagedObjectContext:context])
