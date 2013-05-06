//
//  HLOLRootController.m
//  HoldLanguages
//
//  Created by William Remaerd on 4/12/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "HLOLRootController.h"

#import "HLOLNavigationController.h"
#import "HLOLCategoryController.h"
#import "HLOLItemsController.h"
#import "HLCategoryTableCell.h"

#import "HLModelsGroup.h"
#import "CDFileItem.h"

#import "CDiTunesFinder.h"
#import "CDColorFinder.h"

@interface HLOLRootController ()
@property(nonatomic, copy)NSString *link;
@property(nonatomic, strong)NSMutableArray *groups;
@property(nonatomic, strong)CDNKEngine *engine;
@property(nonatomic, strong)CDFileItem *documents;
@property(nonatomic, weak)CDNKOperation *network;
- (void)refresh;
- (void)didRefreshWith:(id)response;
- (void)fillListWithItems:(NSArray *)items;
- (void)networkErrorAlert;
@end

@implementation HLOLRootController
@synthesize link = _link, groups = _groups, engine = _engine, documents = _documents, network = _network;

- (void)loadView{
    self.wantsFullScreenLayout = NO;
    [super loadView];
    
    [self formated];
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self documents];
    [self engine];
    [self groups];
    [self refresh];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_network cancel];
}

- (void)didReceiveMemoryWarning{
    // Test self.view can be release (on the screen or not).
    if (self.view.window == nil){
        // Preserve data stored in the views that might be needed later.
        
        // Clean up other strong references to the view in the view hierarchy.
        
        //Release self.view
        self.view = nil;
    }
    
    // iOS6 & later did nothing.
    // iOS5 & earlier test self.view == nil, if not viewWillUnload -> release self.view -> viewDidUnload.
    // In this implementation self.view is always nil, so iOS5 & earlier should do nothing.
    [super didReceiveMemoryWarning];
}

#pragma mark - Getter & Setter
- (NSMutableArray *)groups{
    if (!_groups) {
        _groups = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return _groups;
}

- (CDFileItem *)documents{
    if (!_documents) {
        _documents = [[CDFileItem alloc] initWithName:directoryDocuments(nil)];
        _documents.visibleExtension = @[@"lah"];
        _documents.isOpened = YES;
    }
    return _documents;
}

- (CDNKEngine *)engine{
    if (!_engine) {
        _engine = [[CDNKEngine alloc] initWithHostName:@"173.208.240.146:8081"
                                    customHeaderFields:@{@"holdlanguages-password" : @"holdlanguages-password-value"}];
        [_engine useCache];
    }
    return _engine;
}

#pragma mark - Refresh & Load More
- (void)refresh{    
    [self.refreshControl beginRefreshing];

    CDNKEngine *engine = _engine;
    CDNKOperation *ope = [engine operationWithPath:@"ModelsGroupList" params:nil httpMethod:nil ssl:YES];
    ope.clientCertificate = [[NSBundle mainBundle] pathForResource:@"HLClient" ofType:@"p12"];
    ope.clientCertificatePassword = @"811224";
    
    HLOLRootController *bSelf = self;
    [ope addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSInteger statusCode = completedOperation.HTTPStatusCode;
        if (statusCode / 100 != 2) {
            [self networkErrorAlert];
            return;
        }
        
        NSArray *modelsGroupList = completedOperation.responseJSON;
        [bSelf didRefreshWith:modelsGroupList];
    
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        [self networkErrorAlert];
        //AssertError(error);
    
    }];
    [engine enqueueOperation:ope];
    self.network = ope;
}

- (void)didRefreshWith:(id)response{
    [self.refreshControl endRefreshing];
    
    [self.groups removeAllObjects];
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:kDefaultCellAnimationType];
    
    [self fillListWithItems:response];
}

- (void)fillListWithItems:(NSArray *)items{
    NSAssert([items isKindOfClass:[NSArray class]], @"%@ can't accept %@ as models group list.", NSStringFromClass([self class]), NSStringFromClass([items class]));

    NSArray *groups = items;
    NSUInteger groupsCount = groups.count;
    
    NSMutableArray *collector = [[NSMutableArray alloc] initWithCapacity:groupsCount];
    NSMutableArray *insertIndexes = [[NSMutableArray alloc] initWithCapacity:groupsCount];
    for (NSDictionary *dic in groups) {
        
        NSString *name = [dic objectForKey:gHLMGJsonKeyName];
        NSString *command = [dic objectForKey:gHLMGJsonKeyCommand];
        
        HLModelsGroup *group = [[HLModelsGroup alloc] initWithCommand:command key:gHLMGKeyOperation];
        group.name = name;
        
        [insertIndexes addObject:[NSIndexPath indexPathForRow:collector.count inSection:0]];
        [collector addObject:group];
    }
    [_groups addObjectsFromArray:collector];
    
    UITableView *tableView = self.tableView;
    [tableView beginUpdates];
    [tableView insertRowsAtIndexPaths:insertIndexes withRowAnimation:kDefaultCellAnimationType];
    [tableView endUpdates];
}

#pragma mark - Network
- (NSArray *)testData{
    NSString *name0 = @"Voice of America";
    NSString *path0 = [[NSBundle mainBundle] pathForResource:@"51VOA" ofType:@"lah"];
    NSString *string0 = [NSString stringWithContentsOfFile:path0 encoding:NSASCIIStringEncoding error:nil];
    NSDictionary *dic0 = [[NSDictionary alloc] initWithObjectsAndKeys:name0, gHLMGJsonKeyName, string0, gHLMGJsonKeyCommand, nil];
    
    NSString *name1 = @"Listening Comprehension for Examiniations";
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"HuJiang" ofType:@"lah"];
    NSString *string1 = [NSString stringWithContentsOfFile:path1 encoding:NSASCIIStringEncoding error:nil];
    NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:name1, gHLMGJsonKeyName, string1, gHLMGJsonKeyCommand, nil];

    NSArray *groups = [[NSArray alloc] initWithObjects:dic0, dic1, nil];

    return groups;
}

#pragma mark - Swipe
- (void)swipe:(UISwipeGestureRecognizer *)swiper{
    HLOLNavigationController *nav = (HLOLNavigationController *)self.navigationController;
    [nav.panViewController switchToController:CDPanViewControllerTypeRoot withUserInfo:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{;
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger number = 0;
    switch (section) {
        case 0:
            number = _groups.count;
            break;
        case 1:
            number = _documents.count - 1;
            break;
        default:
            break;
    }
    
    return number;
}

static NSString * const gReuseCell = @"RC";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:gReuseCell];
    if (!cell) {
        cell = [[HLCategoryTableCell alloc] initWithReuseIdentifier:gReuseCell];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            
            HLModelsGroup *group = [_groups objectAtIndex:indexPath.row];
            HLCategoryTableCell *categoryCell = (HLCategoryTableCell *)cell;
            categoryCell.title.text = group.name;
            
        }break;
        case 1:{
            
            CDFileItem *item = [_documents itemWithIndex:indexPath.row + 1];
            HLCategoryTableCell *categoryCell = (HLCategoryTableCell *)cell;
            categoryCell.title.text = item.name;

        }break;
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HLOLNavigationController *nav = (HLOLNavigationController *)self.navigationController;
    HLModelsGroup *group = nil;
    switch (indexPath.section) {
        case 0:{
            
            group = [_groups objectAtIndex:indexPath.row];

        }break;
        case 1:{
            
            CDFileItem *item = [_documents itemWithIndex:indexPath.row + 1];
            NSError *error;
            NSString *command = [[NSString alloc] initWithContentsOfFile:item.absolutePath encoding:NSASCIIStringEncoding error:&error];
            AssertError(error);
            group = [[HLModelsGroup alloc] initWithCommand:command key:gHLMGKeyOperation];
        
        }break;
        default:
            break;
    }
    
    NSAssert(group != nil, @"HLModelsGroup is nil.");
    
    [nav pushWithModelsGroup:group link:nil];

}

#pragma mark  - Alert
- (void)networkErrorAlert{
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:NSLocalizedString(@"ServerError", @"ServerError")
                          message:nil
                          delegate:self
                          cancelButtonTitle:NSLocalizedString(@"GetIt", @"GetIt")
                          otherButtonTitles: nil];
    [alert show];

}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            [self handleNetWorkError];
        }break;
            
        default:
            break;
    }
}

- (void)handleNetWorkError{
    [self.refreshControl endRefreshing];
    
    [self.groups removeAllObjects];
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:kDefaultCellAnimationType];
}

@end
