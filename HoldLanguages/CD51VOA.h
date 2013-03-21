//
//  CD51VOA.h
//  HoldLanguages
//
//  Created by William Remaerd on 3/15/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAH_MKNetwork_Hpple.h"

@interface CD51VOA : LAH_MKNetworkKit_Hpple
- (LAHOperation *)homePage;
- (LAHOperation *)itemAtPath:(NSString *)path;
@end
