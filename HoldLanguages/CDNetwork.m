//
//  CDNetwork.m
//  HoldLanguages
//
//  Created by William Remaerd on 3/19/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDNetwork.h"
#import "CDiTunesFinder.h"
#import "CoreDataModels.h"
#import "CDItemNetwork.h"

@interface CDNetwork ()
@property(nonatomic, strong)NSMutableArray* downloadingItems;
- (void)addDownloadingItem:(id<CDNetworkItem>)item;
- (void)removeDownloadingItem:(id<CDNetworkItem>)item;
@end

@implementation CDNetwork
#pragma mark - Class Basic
- (id)initWithHostName:(NSString *)hostName{
    self = [super initWithHostName:@""];
    if (self) {
        self.downloadingItems = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Management
- (void)addDownloadingItem:(id<CDNetworkItem>)item{
    [_downloadingItems addObject:item];
}

- (void)removeDownloadingItem:(id<CDNetworkItem>)item{
    [_downloadingItems removeObject:item];
    DLogCurrentMethod;
}

#pragma mark - Item
- (CDItemNetwork *)downloadItem:(Item *)item{
    item.status = [[NSNumber alloc] initWithInteger:ItemStatusDownloading];
    CDItemNetwork *network = [[CDItemNetwork alloc] initWithItem:item];
    CDNKOperation *audio = [self downloadItemComponent:item.audio network:network];
    [self downloadItemComponent:item.lyrics network:network];
    for (Image *img in item.images) {
        [self downloadItemComponent:img network:network];
    }
    
    __weak CDNetwork *bSelf = self;
    network.keyOperation = audio;
    network.releaser = ^(CDNetworkGroup *group) {
        [bSelf removeDownloadingItem:group];
    };
    [network addCompletion:^(CDNetworkGroup *group) {
        item.status = [[NSNumber alloc] initWithInteger:ItemStatusDownloaded];
    } forKey:self];
    
    item.downloadTry = [[NSDate alloc] init];
    
    [self addDownloadingItem:network];
    return network;
}

- (CDNKOperation *)downloadItemComponent:(id<CDNetworkTrans>)transfer network:(CDItemNetwork *)network{
    if (transfer == nil || network == nil) return nil;
    NSString *http = @"http://";
    NSString *link = transfer.link;
    if (![link hasPrefix:http]) {
        link = [http stringByAppendingString:[transfer.hostName stringByAppendingPathComponent:link]];
    }
    
    NSString *path = directoryDocuments(transfer.path);

    CDNKOperation *operation = [self download:link to:path completion:^(MKNetworkOperation *operation, NSData *data) {
        [network removeOperation:operation error:nil];
    } corrector:^(MKNetworkOperation *operation, NSError *error) {
        [network removeOperation:operation error:error];
    }];
    [network addOperation:operation];
    
    return operation;
}

- (void)cancelDownloadWithItem:(Item *)item{
    CDItemNetwork *i = nil;
    for (i in _downloadingItems) {
        if (![i isKindOfClass:[CDItemNetwork class]]) continue;
        if ([i.item isEqualToItem:item]) break;
    }
    [i cancel];
    [_downloadingItems removeObject:i];
}

#pragma mark - Download
- (CDNKOperation *)download:(NSString *)link to:(NSString *)path{
    MKNetworkOperation *ope = [self operationWithURLString:link];
    [ope addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSData *data = completedOperation.responseData;
        NSError *dataErr = nil;
        [data writeToFile:path options:NSDataWritingAtomic error:&dataErr];
    } errorHandler:nil];
    
    [self enqueueOperation:ope];
    return ope;
}

- (CDNKOperation *)download:(NSString *)link to:(NSString *)path completion:(CDDownload)completion corrector:(CDError)corrector{
    MKNetworkOperation *ope = [self operationWithURLString:link];
    [ope addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSData *data = completedOperation.responseData;
        NSError *dataErr = nil;
        BOOL success = [data writeToFile:path options:NSDataWritingAtomic error:&dataErr];
        
        if (success) {
            if (completion)  completion(completedOperation, data);
        }else{
            if (corrector)  corrector(completedOperation, dataErr);
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        if (corrector) corrector(completedOperation, error);
    }];
    
    [self enqueueOperation:ope];
    return ope;
}

@end