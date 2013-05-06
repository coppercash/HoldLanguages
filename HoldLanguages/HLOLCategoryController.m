//
//  CDCategoryViewController.m
//  HoldLanguages
//
//  Created by William Remaerd on 4/1/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "HLOLCategoryController.h"
#import "HLOLNavigationController.h"
#import "HLOLItemsController.h"
#import "HLModelsGroup.h"
#import "CDLoadMoreControl.h"
#import "CDColorFinder.h"
#import "HLCategoryTableCell.h"

@interface HLOLCategoryController ()
@end

@implementation HLOLCategoryController
@synthesize itemList = _itemList;
@synthesize models = _models, network = _network;
@synthesize
joiner = _joiner,
indexOfPage = _indexOfPage,
entireCapacity = _entireCapacity,
firstPage = _firstPage,
currentPage = _currentPage,
indexInPage = _indexInPage,
breakCapacity = _breakCapacity;

- (void)loadView{
    self.wantsFullScreenLayout = NO;
    [super loadView];
    
    [self formated];
    
    CDLoadMoreControl *loader = [[CDLoadMoreControl alloc] init];
    self.loader = loader;
    self.tableView.tableFooterView = loader;
    [loader addTarget:self action:@selector(loadMore) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self itemList];
    
    [self refresh];
    [self.refreshControl beginRefreshing];
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

- (void)dealloc{
    [_network cancel];
}

#pragma mark - Getter & Setter
- (NSMutableArray *)itemList{
    if (!_itemList) {
        _itemList = [[NSMutableArray alloc] initWithCapacity:kRefreshCapacity];
    }
    return _itemList;
}

- (NSMutableArray *)joiner{
    if (!_joiner) {
        _joiner = [[NSMutableArray alloc] initWithCapacity:_breakCapacity];
    }
    return _joiner;
}

- (void)setModels:(HLModelsGroup *)models{
    _models = models;
    self.firstPage = models.operation.link;
    self.currentPage = _firstPage;
    self.breakCapacity = 9;
    self.entireCapacity = _models.initRange.length;
}

#pragma mark - Refresh & Load More
- (void)refresh{
    if (_loader.loadingMore) {
        [self.refreshControl endRefreshing];
        return;
    }
    
    self.currentPage = _firstPage;
    self.indexInPage = 0;
    self.indexOfPage = 0;
    
    NSUInteger nOIIPP = 0;                                      //number Of Items In Previous Page
    NSRange tPPOER = NSMakeRange(0, _entireCapacity - nOIIPP);      //target Page Part Of Entire Range
    NSRange uRITP = NSMakeRange(_indexInPage, kRefreshCapacity);  //unlimited Range In Target Page
    NSRange limitedRange = NSIntersectionRange(tPPOER, uRITP);
    
    __weak HLOLCategoryController *bSelf = self;
    LAHOperation *ope = _models.operation;
    ope.link = _currentPage;
    _models.ranger.range = limitedRange;
    [ope addCompletion:^(LAHOperation *operation) {
        [bSelf didRefreshWith:operation.container];
    }];
    [ope addCorrector:^(LAHOperation *operation, NSError *error) {
        [self alertNetworkError];
        //AssertError(error);
    }];
    [ope start];
}

- (void)didRefreshWith:(id)response{
    [self.itemList removeAllObjects];
    [self.tableView reloadData];

    if ([self joinItemsWithResponse:response]){
        //Must after statements above, in order to avoid load more while refreshing.
        [self.refreshControl endRefreshing];
        [_loader endLoadingMore];
    }
}

- (void)loadMore:(NSUInteger)count{
    if (self.refreshControl.refreshing) {
        [_loader endLoadingMore];
        return;
    }
    
    NSUInteger nOIIPP = _itemList.count + _joiner.count;        //number Of Items In Previous Page
    NSRange tPPOER = NSMakeRange(0, _entireCapacity - nOIIPP);      //target Page Part Of Entire Range
    NSRange uRITP = NSMakeRange(_indexInPage, _breakCapacity);  //unlimited Range In Target Page
    NSRange limitedRange = NSIntersectionRange(tPPOER, uRITP);
    if (limitedRange.length == 0) {
        [_loader endLoadingMore];
        return;
    }
    
    __weak HLOLCategoryController *bSelf = self;
    LAHOperation *ope = _models.operation;
    ope.link = _currentPage;
    _models.ranger.range = limitedRange;
    [ope addCompletion:^(LAHOperation *operation) {
        [bSelf didLoadMoreWith:operation.container];
    }];
    [ope addCorrector:^(LAHOperation *operation, NSError *error) {
        [self alertNetworkError];
        //AssertError(error);
    }];
    [ope start];
}

- (void)loadMore{
    [self loadMore:_breakCapacity];
}

- (void)didLoadMoreWith:(id)response{
    if ([self joinItemsWithResponse:response]){
        //Must after statements above, in order to avoid load more while refreshing.
        [self.refreshControl endRefreshing];
        [_loader endLoadingMore];
    }
}

#pragma mark - Joiner
- (BOOL)joinItemsWithResponse:(id)response{
    NSDictionary *dic = response;
    NSArray *items = [dic objectForKey:gHLMGKeyItems];
    NSString *nextPage = [dic objectForKey:gHLMGKeyNextPage];
    BOOL finish = YES;
    
    if (items.count < _breakCapacity) {
        
        [self.joiner addObjectsFromArray:items];
        if (_joiner.count < _breakCapacity && nextPage) {
            
            finish = NO;
            
            self.currentPage = nextPage;
            self.indexInPage = 0;
            self.indexOfPage += 1;
            [self loadMore:_breakCapacity - _joiner.count];
            
        } else {
            [self fillListWithItems:_joiner];
        }
        
    } else {
        
        [self fillListWithItems:items];
    
    }
    return finish;
}

- (void)fillListWithItems:(NSArray *)items{
    NSAssert([items isKindOfClass:[NSArray class]] || items == nil, @"%@ must recieve a NSArray as data.", NSStringFromClass(self.class));
    
    //NSArray *newItems = response;
    NSUInteger count = items.count;
    
    //Determine new index and indexes will be inserted
    NSInteger currentIndex = _itemList.count;
    NSInteger newIndex = currentIndex + count;
    NSMutableArray *insertIndexes = [[NSMutableArray alloc] initWithCapacity:count];
    for (NSUInteger index = currentIndex; index < newIndex; index++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [insertIndexes addObject:indexPath];
    }
    [_itemList addObjectsFromArray:items];

    //Update tableView
    UITableView *tableView = self.tableView;
    [tableView beginUpdates];
    [tableView insertRowsAtIndexPaths:insertIndexes withRowAnimation:kDefaultCellAnimationType];
    [tableView endUpdates];

    //Must after statements up, because last functions use the vars before update;
    [_joiner removeAllObjects];
    self.indexInPage += count;
    if (items.count < _breakCapacity) {
        self.entireCapacity = _itemList.count;
    }
    
    DLog(@"Items List contains %d items.", _itemList.count);
}

#pragma mark - Swipe
- (void)swipe:(UISwipeGestureRecognizer *)swiper{
    HLOLNavigationController *nav = (HLOLNavigationController *)self.navigationController;
    [nav popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _itemList.count;
}

static NSString * const gReuseCell = @"RC";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:gReuseCell];
    if (!cell) {
        cell = [[HLCategoryTableCell alloc] initWithReuseIdentifier:gReuseCell];
        //cell.textLabel.textColor = [UIColor whiteColor];
        //cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = [_itemList objectAtIndex:indexPath.row];
    NSString *title = [dic objectForKey:gHLMGKeyTitle];
    HLCategoryTableCell *categoryCell = (HLCategoryTableCell *)cell;
    categoryCell.title.text = title;

}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HLOLNavigationController *nav = (HLOLNavigationController *)self.navigationController;
    NSDictionary *dic = [_itemList objectAtIndex:indexPath.row];
    NSString *link = [dic objectForKey:gHLMGKeyLink];
    [nav pushWithModelsGroup:_models link:link];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_loader testLoadingMore:scrollView];
}

#pragma mark  - Alert
- (void)alertNetworkError{
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:NSLocalizedString(@"NetworkError", @"NetworkError")
                          message:nil
                          delegate:self
                          cancelButtonTitle:NSLocalizedString(@"GetIt", @"GetIt")
                          otherButtonTitles: nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            [self alertVIewDismissWithTitle:alertView.title];
        }break;
            
        default:
            break;
    }
}

- (void)alertVIewDismissWithTitle:(NSString *)title{
    if ([title isEqualToString:NSLocalizedString(@"NetworkError", @"NetworkError")]) {
        [self handleNetWorkError];
    }
}

- (void)handleNetWorkError{
    HLOLNavigationController *nav = (HLOLNavigationController *)self.navigationController;
    [nav popViewControllerAnimated:YES];
}

@end
