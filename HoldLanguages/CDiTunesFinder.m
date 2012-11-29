//
//  CDiTunesFinder.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/14/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDiTunesFinder.h"

@implementation CDiTunesFinder

NSString* documentsPath(){
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return documentsPath;
}

+ (NSString*)findFileWithName:(NSString*)name ofType:(NSString*)extension{
    NSString* itunesPath = documentsPath();
    NSString* pathWithName = [itunesPath stringByAppendingPathComponent:name];
    NSString* fullPath = [pathWithName stringByAppendingPathExtension:extension];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:fullPath]){
        return fullPath;
    }else{
        return nil;
    }
}
@end
