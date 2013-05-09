//
//  HLModelsGroup.m
//  HoldLanguages
//
//  Created by William Remaerd on 4/12/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "HLModelsGroup.h"
#import "LAHInterpreter.h"
#import "LAHHeaders.h"

@interface HLModelsGroup ()
@property (nonatomic, assign)NSInteger currentIndex;
@end

@implementation HLModelsGroup 
@synthesize name = _name;
@synthesize currentIndex = _currentIndex;
@dynamic isPenultDegree, itemOperation, ranger, initRange;

- (id)initWithCommand:(NSString *)command key:(NSString *)key{
    self = [super initWithCommand:command key:key];
    if (self) {
        self.currentIndex = 0;
    }
    return self;
}

- (void)setupOperationWithString:(NSString *)string key:(NSString *)key{
    NSMutableArray *collector = [[NSMutableArray alloc] initWithCapacity:_containerCache.count];
    
    NSString *strOpe = key.copy;
    NSString *strRange = gHLMGKeyRange;
    LAHOperation *ope = nil;
    do {
        
        NSString *keyOpe = [[NSString alloc] initWithFormat:@"%@%d",strOpe , collector.count];
        ope = _containerCache[keyOpe];
        if (!ope) continue;
        
        NSString *keyRange = [[NSString alloc] initWithFormat:@"%@%d",strRange , collector.count];
        LAHTag *ranger = _containerCache[keyRange];

        NSMutableDictionary *dicCollector = [[NSMutableDictionary alloc] initWithObjectsAndKeys:ope, gHLMGKeyOperation, nil];
        if (ranger) {
            [dicCollector setObject:ranger forKey:gHLMGKeyRange];
            [dicCollector setObject:[NSValue valueWithRange:ranger.singleRange] forKey:gHLMGKeyRangeInitValue];
        }
        [collector addObject:dicCollector];

    } while (ope);
    
    NSAssert(collector.count > 0, @"%@ needs at least 1 %@", NSStringFromClass(self.class), key);
    
    self.operations = [[NSArray alloc] initWithArray:collector];
    
}

#pragma mark - Range
- (LAHTag *)ranger{
    NSDictionary *dic = [_operations objectAtIndex:_currentIndex];
    LAHTag *ranger = [dic objectForKey:gHLMGKeyRange];
    return ranger;
}

- (NSRange)initRange{
    NSDictionary *dic = [_operations objectAtIndex:_currentIndex];
    NSValue *value = [dic objectForKey:gHLMGKeyRangeInitValue];
    if (value) {
        return value.rangeValue;
    } else {
        return NSMakeRange(0, NSUIntegerMax);
    }
}

- (void)resetRange{
    self.ranger.singleRange = self.initRange;
}

#pragma mark - Degree
- (BOOL)isPenultDegree{
    BOOL is = _currentIndex == _operations.count - 2;
    return is;
}

#pragma mark - Operation
- (LAHOperation *)operationAtIndex:(NSInteger)index{
    if (index < 0 || _operations.count <= index) return nil;
    NSDictionary *dic = [_operations objectAtIndex:index];
    LAHOperation *ope = [dic objectForKey:gHLMGKeyOperation];
    [ope refresh];
    [self resetRange];
    return ope;
}

- (LAHOperation *)operation{
    LAHOperation *operation = [self operationAtIndex:_currentIndex];
    return operation;
}

- (LAHOperation *)itemOperation{
    LAHOperation *itemOpe = [self operationAtIndex:_operations.count - 1];
    return itemOpe;
}

#pragma mark - Push & Pop
- (void)pushWithLink:(NSString *)link{
    NSInteger target = _currentIndex + 1;
    LAHOperation *ope = [self operationAtIndex:target];
    if (ope) {
        self.currentIndex = target;
        if (link) ope.page.link = link;
    }
}

- (void)popNumberOfDegree:(NSUInteger)number{
    NSInteger target = _currentIndex - number;
    LAHOperation *ope = [self operationAtIndex:target];
    if (ope) {
        self.currentIndex = target;
    }
}

- (void)pop{
    [self popNumberOfDegree:1];
}

@end

NSString * const gHLMGJsonKeyName = @"Nam";
NSString * const gHLMGJsonKeyCommand = @"Cmd";
NSString * const gHLMGKeyTitle = @"title";
NSString * const gHLMGKeyLink = @"link";
NSString * const gHLMGKeyURL = @"url";
NSString * const gHLMGKeyOperation = @"ope";
NSString * const gHLMGKeyRange = @"range";
NSString * const gHLMGKeyRangeInitValue = @"RIV";
NSString * const gHLMGKeyItems = @"items";
NSString * const gHLMGKeyNextPage = @"next";
