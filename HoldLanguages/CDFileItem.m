//
//  CDiTunesItem.m
//  HoldLanguages
//
//  Created by William Remaerd on 1/12/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDFileItem.h"
@interface CDFileItem()
- (NSArray *)openDirectory:(NSString *)path;
@end

@implementation CDFileItem
- (id)initWithName:(NSString *)name{
    self = [super init];
    if (self) {
        _name = name;
    }
    return self;
}

- (BOOL)isDirectory{
    NSFileManager *fileManeger = [NSFileManager defaultManager];
    BOOL isDir = NO;
    [fileManeger fileExistsAtPath:self.absolutePath isDirectory:&isDir];
    return isDir;
}

- (void)setIsOpened:(BOOL)isOpened{
    if (_isOpened == isOpened) return;
    if (self.isDirectory) {
        if (_isOpened) _subItems = nil;
        else _subItems = [self openDirectory:self.absolutePath];
    }
    _isOpened = isOpened;
}

- (NSArray *)openDirectory:(NSString *)path{
    NSFileManager *fileManeger = [NSFileManager defaultManager];
    NSURL *url = [NSURL fileURLWithPath:path isDirectory:YES];
    NSArray *subFiles = [fileManeger contentsOfDirectoryAtURL:url
                                   includingPropertiesForKeys:nil
                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                        error:nil];
    
    NSMutableArray *newSubFiles = [[NSMutableArray alloc] initWithCapacity:subFiles.count];
    for (NSURL *url in subFiles) {
        BOOL isVisible = NO;
        BOOL isDirectory = NO;
        [fileManeger fileExistsAtPath:url.path isDirectory:&isDirectory];
        if (isDirectory) {
            isVisible |= [_visibleExtension containsObject:CDFIIsDir];
        }else{
            isVisible |= [_visibleExtension containsObject:url.pathExtension];
        }
        
        /*
        BOOL isVisible = [_visibleExtension containsObject:url.pathExtension];
        
        if (!isVisible) {
            BOOL isDirectory = NO;
            [fileManeger fileExistsAtPath:url.path isDirectory:&isDirectory];
            if (isDirectory) isVisible |= [_visibleExtension containsObject:CDFIIsDir];
        }*/
        
        
        if (!isVisible) continue;
        CDFileItem *item = [[CDFileItem alloc] initWithName:url.lastPathComponent];
        item.superItem = self;
        item.degree = _degree + 1;
        item.visibleExtension = _visibleExtension;
        [newSubFiles addObject:item];
    }
    return [[NSArray alloc] initWithArray:newSubFiles];
}

- (NSString *)absolutePath{
    NSString *path = nil;
    if (_superItem != nil) {
        NSString *superPath = _superItem.absolutePath;
        path = [superPath stringByAppendingPathComponent:_name];
    }else{
        path = self.name;
    }
    return path;
}

- (NSUInteger)count{
    NSUInteger count = 1;
    for (CDFileItem *item in _subItems) {
        NSUInteger pCount = item.count;
        count += pCount;
    }
    return count;
}

- (CDFileItem *)itemWithIndex:(NSInteger)index{
    if (index == 0) return self;
    for (CDFileItem *item in _subItems) {
        if (index - 1 < item.count) {
            return [item itemWithIndex:index - 1];
        }else{
            index -= item.count;
        }
    }
    return nil ;
}

@end

NSString * const CDFIIsDir = @"_dir";