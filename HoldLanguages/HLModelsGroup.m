//
//  HLModelsGroup.m
//  HoldLanguages
//
//  Created by William Remaerd on 4/12/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "HLModelsGroup.h"

@implementation HLModelsGroup 
@synthesize name = _name;
@dynamic isPenultDegree, isRootDegree, itemOperation;

- (BOOL)isRootDegree{
    BOOL is = _currentIndex == 0;
    return is;
}

- (BOOL)isPenultDegree{
    BOOL is = _currentIndex == _operations.count - 2;
    return is;
}

- (LAHOperation *)itemOperation{
    LAHOperation *itemOpe = [_operations objectAtIndex:_operations.count - 1];
    [itemOpe refresh];
    return itemOpe;
}

@end

NSString * const gHLMGKeyName = @"name";
NSString * const gHLMGKeyTitle = @"title";
NSString * const gHLMGKeyLink = @"link";
NSString * const gHLMGKeyURL = @"url";
NSString * const gHLMGKeyCommand = @"comm";
NSString * const gHLMGKeyOperation = @"ope";
