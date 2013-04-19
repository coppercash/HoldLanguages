//
//  CDNetwork.h
//  HoldLanguages
//
//  Created by William Remaerd on 3/19/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "MKNetworkEngine.h"
#import "CDItem.h"

@protocol CDNetworkTrans;
@class Item, CDItemNetwork;

typedef MKNetworkEngine CDNKEngine;
typedef MKNetworkOperation CDNKOperation;
typedef void (^CDDownload) (CDNKOperation *operation, NSData* data);
typedef void (^CDError) (CDNKOperation *operation, NSError* error);

@interface CDNetwork : MKNetworkEngine{
    NSMutableArray *_downloadingItems;
}
#pragma mark - Item
- (CDItemNetwork *)downloadItem:(Item *)item;
- (CDNKOperation *)downloadItemComponent:(id<CDNetworkTrans>)transfer network:(CDItemNetwork *)network;
- (void)cancelDownloadWithItem:(Item *)item;
#pragma mark - Download
- (CDNKOperation *)download:(NSString *)link to:(NSString *)path;
- (CDNKOperation *)download:(NSString *)link to:(NSString *)path completion:(CDDownload)completion corrector:(CDError)corrector;
@end

@protocol CDNetworkTrans <NSObject>
- (NSString *)link;
- (NSString *)absoluteLink;
- (NSString *)path;
- (NSString *)absolutePath;
- (NSString *)hostName;
- (BOOL)fileExists;
@end

@protocol CDNetworkItem <NSObject>
- (void)cancel;
@end




