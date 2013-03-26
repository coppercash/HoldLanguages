//
//  CDNetworkGroup.m
//  HoldLanguages
//
//  Created by William Remaerd on 3/20/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDNetworkGroup.h"

@interface CDNetworkGroup ()
@property(nonatomic, strong)NSMutableArray *operations;
@property(nonatomic, strong)NSMutableArray *holder;
@property(nonatomic, strong)NSMutableDictionary *completions;
@property(nonatomic, strong)NSMutableDictionary *correctors;
@property(nonatomic, strong)NSMutableDictionary *progresses;
- (long long)expectedContentLength;
- (long long)downloadedContentLength;
- (void)progress:(double)progress changedBy:(CDNKOperation *)operation;
- (void)complete;
- (void)error:(NSError *)error;
@end

@implementation CDNetworkGroup
@synthesize operations = _operations, holder = _holder;
@synthesize completions = _completions, correctors = _correctors, progresses = _progresses, releaser = _releaser;
- (id)init{
    self = [super init];
    if (self) {
        self.operations = [[NSMutableArray alloc] init];
        self.holder = [[NSMutableArray alloc] init];
        self.completions = [[NSMutableDictionary alloc] init];
        self.correctors = [[NSMutableDictionary alloc] init];
        self.progresses = [[NSMutableDictionary alloc] init];
    }
    return self;
}

static NSString * const gKeyOperation = @"ope";
static NSString * const gKeyDowloaded = @"dow";

#pragma mark - Operations
- (void)addOperation:(CDNKOperation *)operation{
    [_operations addObject:operation];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:operation, gKeyOperation, nil];
    [_holder addObject:dic];
    
    __weak CDNetworkGroup *bSelf = self;
    __weak CDNKOperation *bOperation = operation;
    __weak NSMutableDictionary *bDic = dic;
    [operation onDownloadProgressChanged:^(double progress) {
        NSNumber *downloaded = [[NSNumber alloc] initWithLongLong:progress * bOperation.readonlyResponse.expectedContentLength];
        [bDic setObject:downloaded forKey:gKeyDowloaded];
        double allProgress = (double)self.downloadedContentLength / (double)self.expectedContentLength;
        [bSelf progress:allProgress changedBy:bOperation];
    }];
}

- (void)removeOperation:(CDNKOperation *)operation error:(NSError *)error{
    if (error) {
        [self error:error];
        return;
    }
    [_operations removeObject:operation];
    if (_operations.count == 0) {
        [self complete];
    }
}

- (void)cancel{
    for (NSDictionary *dic in _holder) {
        CDNKOperation *ope = [dic objectForKey:gKeyOperation];
        [ope cancel];
    }
    DLogCurrentMethod;
}

#pragma mark - Download Infor
- (long long)expectedContentLength{
    long long amount = 0;
    for (NSDictionary *dic in _holder) {
        CDNKOperation *ope = [dic objectForKey:gKeyOperation];
        NSAssert(ope != nil, @"%@\tope can't be nil.", NSStringFromSelector(_cmd));
        amount += ope.readonlyResponse.expectedContentLength;
        if (amount == NSURLResponseUnknownLength || amount == 0) {
            amount = NSUIntegerMax;
            break;
        }
    }
    return amount;
}

- (long long)downloadedContentLength{
    long long amount = 0;
    for (NSDictionary *dic in _holder) {
        NSNumber *dowloaded = [dic objectForKey:gKeyDowloaded];
        if (dowloaded) {
            amount += dowloaded.longLongValue;
        }
    }
    return amount <= 0 ? NSUIntegerMax : amount;
}


#pragma mark - Handlers
- (void)addCompletion:(CDNKGroupCompletion)completion forKey:(id)key{
    [_completions setObject:[completion copy] forKey:addressStringFromObject(key)];
}

- (void)removeCompletionForKey:(id)key{
    [_completions removeObjectForKey:key];
}

- (void)addCorrector:(CDNKGroupCorrector)corrector forKey:(id)key{
    [_correctors setObject:[corrector copy] forKey:addressStringFromObject(key)];
}

- (void)removeCorrectorForKey:(id)key{
    [_correctors removeObjectForKey:key];
}

- (void)addProgress:(CDNKGroupProgress)progress forKey:(id)key{
    [_progresses setObject:[progress copy] forKey:addressStringFromObject(key)];
}

- (void)removeProgressForKey:(id)key{
    [_progresses removeObjectForKey:addressStringFromObject(key)];
}

#pragma mark - Event
- (void)progress:(double)progress changedBy:(CDNKOperation *)operation{
    for (NSString *key in _progresses.allKeys) {
        CDNKGroupProgress p = [_progresses objectForKey:key];
        p(self, progress);
    }
}

- (void)complete{
    for (NSString *key in _completions.allKeys) {
        CDNKGroupCompletion c = [_completions objectForKey:key];
        c(self);
    }
    if (_releaser) _releaser(self);
}

- (void)error:(NSError *)error{
    for (NSString *key in _correctors.allKeys) {
        CDNKGroupCorrector c = [_correctors objectForKey:key];
        c(self, error);
    }
    if (_releaser) _releaser(self);
}

@end

NSString *addressStringFromObject(id object){
    return [NSString stringWithFormat:@"%p", object];
}

