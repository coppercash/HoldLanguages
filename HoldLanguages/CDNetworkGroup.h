//
//  CDNetworkGroup.h
//  HoldLanguages
//
//  Created by William Remaerd on 3/20/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDNetwork.h"

@class CDNetworkGroup;

typedef void (^CDNKGroupCompletion) (CDNetworkGroup *group);
typedef void (^CDNKGroupCorrector) (CDNetworkGroup *group, NSError* error);
typedef void (^CDNKGroupProgress) (CDNetworkGroup *group, double progress);

@interface CDNetworkGroup : NSObject <CDNetworkItem>{
    NSMutableArray *_operations;
    NSMutableArray *_holder;
    NSMutableDictionary *_completions;
    NSMutableDictionary *_correctors;
    NSMutableDictionary *_progresses;
    CDNKGroupCompletion _releaser;
}
@property(nonatomic, copy)CDNKGroupCompletion releaser;
- (void)addOperation:(CDNKOperation *)operation;
- (void)removeOperation:(CDNKOperation *)operation error:(NSError *)error;
- (void)addCompletion:(CDNKGroupCompletion)completion forKey:(id)key;
- (void)removeCompletionForKey:(id)key;
- (void)addCorrector:(CDNKGroupCorrector)corrector forKey:(id)key;
- (void)removeCorrectorForKey:(id)key;
- (void)addProgress:(CDNKGroupProgress)progress forKey:(id)key;
- (void)removeProgressForKey:(id)key;
#pragma mark - protected
- (void)error:(NSError *)error;
@end

NSString *addressStringFromObject(id object);


