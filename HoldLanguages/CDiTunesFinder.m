//
//  CDiTunesFinder.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/14/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDiTunesFinder.h"

static NSString * const gDirDownload = @"Download";

@implementation CDiTunesFinder
- (id)init{
    self = [super init];
    if (self) {
        _rootPath = directoryDocuments(nil);
        _fileManager = [NSFileManager defaultManager];
    }
    return self;
}

#pragma mark - Quick Method
NSString* directoryDocuments(NSString *subpath){
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSString *documents = delegate.applicationDocumentsDirectory.path;
    NSString *path = [documents stringByAppendingPathComponent:subpath];
    return path;
}

NSString* directoryRelativeDownload(NSString *subpath){
    NSString *path = [gDirDownload stringByAppendingPathComponent:subpath];
    return path;
}

NSString* directoryAbsoluteDownload(NSString *subpath){
    NSString *path = directoryDocuments(directoryRelativeDownload(subpath));
    return path;
}

+ (NSString*)findFileWithName:(NSString*)name ofType:(NSString*)extension{
    NSString* itunesPath = directoryDocuments(nil);
    NSString* pathWithName = [itunesPath stringByAppendingPathComponent:name];
    NSString* fullPath = [pathWithName stringByAppendingPathExtension:extension];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:fullPath]){
        return fullPath;
    }else{
        return nil;
    }
}

+ (void)organizeiTunesFileSharing{
    NSFileManager *manager = [[NSFileManager alloc] init];
    NSString *path = directoryDocuments(gDirDownload);
    BOOL isDir;
    if (![manager fileExistsAtPath:path isDirectory:&isDir]) {
        NSError *error = nil;
        [manager createDirectoryAtPath:directoryDocuments(gDirDownload) withIntermediateDirectories:NO attributes:nil error:&error];
        DLog(@"Download Directory Created.")
        NSAssert(error == nil, @"organizeiTunesFileSharing fail: %@", error.userInfo);
    }
}
@end
