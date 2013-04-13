//
//  HLModelsGroup.m
//  HoldLanguages
//
//  Created by William Remaerd on 4/12/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "HLModelsGroup.h"
#import "LAHInterpreter.h"

@implementation HLModelsGroup 
@synthesize name = _name;
@dynamic isPenultDegree, itemOperation, ranger, initRange;

- (void)setupOperationWithString:(NSString *)string key:(NSString *)key{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [LAHInterpreter interpretString:string intoDictionary:dictionary];
    NSMutableArray *collector = [[NSMutableArray alloc] initWithCapacity:dictionary.count];
    
    NSString *strOpe = key.copy;
    NSString *strRange = gHLMGKeyRange;
    LAHOperation *ope = nil;
    do {
        
        NSString *keyOpe = [[NSString alloc] initWithFormat:@"%@%d",strOpe , collector.count];
        ope = [dictionary objectForKey:keyOpe];
        if (!ope) continue;
        
        ope.delegate = self;
        
        NSMutableDictionary *dicCollector = [[NSMutableDictionary alloc] initWithObjectsAndKeys:ope, gHLMGKeyOperation, nil];
        
        NSString *keyRange = [[NSString alloc] initWithFormat:@"%@%d",strRange , collector.count];
        LAHRecognizer *ranger = [dictionary objectForKey:keyRange];
        
        if (ranger) {
            [dicCollector setObject:ranger forKey:gHLMGKeyRange];
            [dicCollector setObject:[NSValue valueWithRange:ranger.range] forKey:gHLMGKeyRangeInitValue];
        }
        
        [collector addObject:dicCollector];

    } while (ope);
    
    NSAssert(collector.count > 0, @"%@ needs at least 1 %@", NSStringFromClass(self.class), key);
    
    self.operations = [[NSArray alloc] initWithArray:collector];
    
}

- (LAHOperation *)operationAtIndex:(NSInteger)index{
    if (index < 0 || _operations.count <= index) return nil;
    NSDictionary *dic = [_operations objectAtIndex:index];
    LAHOperation *ope = [dic objectForKey:gHLMGKeyOperation];
    [ope refresh];
    [self resetRange];
    return ope;
}

- (LAHRecognizer *)ranger{
    NSDictionary *dic = [_operations objectAtIndex:_currentIndex];
    LAHRecognizer *ranger = [dic objectForKey:gHLMGKeyRange];
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
    self.ranger.range = self.initRange;
}

- (BOOL)isPenultDegree{
    BOOL is = _currentIndex == _operations.count - 2;
    return is;
}

- (LAHOperation *)itemOperation{
    LAHOperation *itemOpe = [self operationAtIndex:_operations.count - 1];
    return itemOpe;
}

@end

NSString * const gHLMGKeyName = @"name";
NSString * const gHLMGKeyTitle = @"title";
NSString * const gHLMGKeyLink = @"link";
NSString * const gHLMGKeyURL = @"url";
NSString * const gHLMGKeyCommand = @"comm";
NSString * const gHLMGKeyOperation = @"ope";
NSString * const gHLMGKeyRange = @"range";
NSString * const gHLMGKeyRangeInitValue = @"RIV";
