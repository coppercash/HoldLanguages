//
//  CDiTunesItem.h
//  HoldLanguages
//
//  Created by William Remaerd on 1/12/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDFileItem : NSObject

@property(weak, nonatomic)CDFileItem *superItem;
@property(readonly, strong, nonatomic)NSString *name;
@property(readonly, strong, nonatomic)NSArray *subItems;
@property(assign, nonatomic)BOOL isOpened;
@property(assign, nonatomic)NSUInteger degree;
@property(strong, nonatomic)NSArray *visibleExtension;

- (id)initWithName:(NSString *)name;
- (NSString *)absolutePath;
- (BOOL)isDirectory;
- (NSUInteger)count;
- (CDFileItem *)itemWithIndex:(NSInteger)index;
@end

extern NSString * const CDFIIsDir;