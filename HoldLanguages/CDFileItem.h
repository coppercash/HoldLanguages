//
//  CDiTunesItem.h
//  HoldLanguages
//
//  Created by William Remaerd on 1/12/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDFileItem : NSObject {
    NSString *_name;
    __weak CDFileItem *_superItem;
    NSArray *_subItems;
    
    NSArray *_visibleExtension;
    
    BOOL _isOpened;
    NSUInteger _degree;
}
@property(nonatomic, readonly)NSString *name;
@property(nonatomic, readonly)NSArray *subItems;
@property(nonatomic, strong)NSArray *visibleExtension;
@property(nonatomic, assign)BOOL isOpened;
@property(nonatomic, assign)NSUInteger degree;

- (id)initWithName:(NSString *)name;
- (NSString *)absolutePath;
- (BOOL)isDirectory;
- (NSUInteger)count;
- (CDFileItem *)itemWithIndex:(NSInteger)index;
- (void)removeFileOfItemAtIndex:(NSInteger)index;
@end

extern NSString * const CDFIIsDir;