//
//  HLModelsGroup.h
//  HoldLanguages
//
//  Created by William Remaerd on 4/12/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LMHModelsGroup.h"

@interface HLModelsGroup : LMHModelsGroup {
    NSString *_name;
}
@property(nonatomic, copy)NSString *name;
@property(nonatomic, readonly)BOOL isPenultDegree;
@property(nonatomic, readonly)BOOL isRootDegree;
@property(nonatomic, readonly)LAHOperation *itemOperation;
@end

extern NSString * const gHLMGKeyName;
extern NSString * const gHLMGKeyTitle;
extern NSString * const gHLMGKeyLink;
extern NSString * const gHLMGKeyURL;
extern NSString * const gHLMGKeyCommand;
extern NSString * const gHLMGKeyOperation;
