//
//  CDStack.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/13/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDStack.h"

@implementation NSMutableArray (CDStack)
- (void)push:(id)object{
    [self addObject:object];
}

- (id)pop{
    id lastObject = [self lastObject];
    [self removeLastObject];
    return lastObject;
}

- (BOOL)isEmpty{
    BOOL isEmpty = [self count] == 0;
    return isEmpty;
}
@end
