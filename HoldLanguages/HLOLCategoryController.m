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

@interface HLOLCategoryController ()
@end

@implementation HLOLCategoryController
@synthesize itemList = _itemList;
@synthesize models = _models, network = _network;
@synthesize
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

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
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

- (void)setModels:(HLModelsGroup *)models{
    _models = models;
    self.firstPage = models.operation.link;
    self.currentPage = _firstPage;
    self.breakCapacity = 10;
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
    
    NSRange entireRange = NSMakeRange(0, _entireCapacity);
    NSRange targetRange = NSMakeRange(_indexInPage, kRefreshCapacity);
    NSRange intersection = NSIntersectionRange(entireRange, targetRange);
    
    __weak HLOLCategoryController *bSelf = self;
    LAHOperation *ope = _models.operation;
    _models.ranger.range = intersection;
    [ope addCompletion:^(LAHOperation *operation) {
        [bSelf didRefreshWith:operation.container];
    }];
    [ope start];
}

- (void)didRefreshWith:(NSArray *)newItems{
    [self.refreshControl endRefreshing];
    [_loader endLoadingMore];
    
    [self.itemList removeAllObjects];
    [self.tableView reloadData];

    [self didReceiveResponse:newItems];
}

- (void)loadMore{
    if (self.refreshControl.refreshing) {
        [_loader endLoadingMore];
        return;
    }
    
    NSRange entireRange = NSMakeRange(0, _entireCapacity);
    NSRange targetRange = NSMakeRange(_indexInPage, _breakCapacity);
    NSRange intersection = NSIntersectionRange(entireRange, targetRange);
    if (intersection.length == 0) {
        [_loader endLoadingMore];
        return;
    }
    
    __weak HLOLCategoryController *bSelf = self;
    LAHOperation *ope = _models.operation;
    _models.ranger.range = intersection;
    [ope addCompletion:^(LAHOperation *operation) {
        [bSelf didLoadMoreWith:operation.container];
    }];
    [ope start];
}

- (void)didLoadMoreWith:(NSArray *)newItems{
    [self.refreshControl endRefreshing];
    [_loader endLoadingMore];
    
    [self didReceiveResponse:newItems];
}

- (void)didReceiveResponse:(id)response{
    NSAssert([response isKindOfClass:[NSArray class]] || response == nil, @"%@ must recieve a NSArray as data.", NSStringFromClass(self.class));
    
    NSArray *newItems = response;
    NSUInteger count = newItems.count;
    
    //Determine new index and indexes will be inserted
    NSInteger newIndex = self.indexInPage + count;
    NSMutableArray *insertIndexes = [[NSMutableArray alloc] initWithCapacity:count];
    for (NSUInteger index = _indexInPage; index < newIndex; index++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [insertIndexes addObject:indexPath];
    }
    [_itemList addObjectsFromArray:newItems];

    //Update tableView
    UITableView *tableView = self.tableView;
    [tableView beginUpdates];
    [tableView insertRowsAtIndexPaths:insertIndexes withRowAnimation:UITableViewRowAnimationMiddle];
    [tableView endUpdates];

    //Must after statements up, because last functions use the vars before update;
    self.indexInPage += count;
    if (newItems.count < _breakCapacity) {
        self.entireCapacity = _itemList.count;
    }
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:gReuseCell];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = [_itemList objectAtIndex:indexPath.row];
    NSString *title = [dic objectForKey:gHLMGKeyTitle];
    cell.textLabel.text = title;
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

@end
