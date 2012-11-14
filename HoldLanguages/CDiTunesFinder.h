//
//  CDiTunesFinder.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/14/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDiTunesFinder : NSObject
NSString* documentsPath();
+ (NSString*)findFileWithName:(NSString*)name ofType:(NSString*)extension;

@end
