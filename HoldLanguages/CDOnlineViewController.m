//
//  CDOnlineViewController.m
//  HoldLanguages
//
//  Created by William Remaerd on 3/15/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDOnlineViewController.h"
#import "CD51VOA.h"
#import "Item.h"
#import "CoreDataModels.h"
#import "CDItem.h"
#import "CDItemNetwork.h"
#import "CDItemTableCell.h"
#import "CDLoadMoreControl.h"

static NSString *gReuseCell = @"RC";

@interface CDOnlineViewController ()
@property(nonatomic, strong)CDLoadMoreControl *loader;

@property(nonatomic, strong)NSMutableArray *itemList;
@property(nonatomic, strong)CD51VOA *VOA51;
@property(nonatomic, strong)NSMutableDictionary *trash;

@property(nonatomic, assign)NSInteger indexOfPage;
@property(nonatomic, strong)NSString *currentPage;
@property(nonatomic, assign)NSInteger indexInPage;
@property(nonatomic, assign)NSUInteger pageCapacity;

- (void)swipe:(UISwipeGestureRecognizer *)swiper;
- (void)tableView:(UITableView *)tableView swipeRowAtIndexPath:(NSIndexPath *)indexPath toDirection:(UISwipeGestureRecognizerDirection)direction;
- (void)refresh;
- (void)didRefreshWith:(NSArray *)newItems;
- (void)loadMore;
- (void)didLoadMoreWith:(NSArray *)newItems;
- (void)addItems:(NSArray *)newItems;
- (void)downloadWithRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)cancelDownloadWithRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@implementation CDOnlineViewController
@synthesize loader = _loader;
@synthesize VOA51 = _VOA51, itemList = _itemList, trash = _trash;
@synthesize
indexOfPage = _indexOfPage,
currentPage = _currentPage,
indexInPage = _indexInPage,
pageCapacity = _pageCapacity;

#pragma mark - Class Basic

#pragma mark - Resource Management
- (void)loadView{
    self.wantsFullScreenLayout = NO;
    [super loadView];
    
    UITableView *tableView = self.tableView;
    tableView.separatorColor = [UIColor darkGrayColor];
    tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage pngImageWithName:@"iTunesColorPattern"]];
    
    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    right.direction = UISwipeGestureRecognizerDirectionRight;
    [tableView addGestureRecognizer:left];
    [tableView addGestureRecognizer:right];
    
    UIRefreshControl *refresher = [[UIRefreshControl alloc] init];
    self.refreshControl = refresher;
    [refresher addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    CDLoadMoreControl *loader = [[CDLoadMoreControl alloc] init];
    self.loader = loader;
    tableView.tableFooterView = loader;
    [loader addTarget:self action:@selector(loadMore) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.VOA51 = [[CD51VOA alloc] init];
    self.itemList = [[NSMutableArray alloc] initWithCapacity:kRefreshCapacity];
    self.trash = [[NSMutableDictionary alloc] initWithCapacity:kRefreshCapacity];
    
    self.pageCapacity = 10;
    self.indexOfPage = 0;
    self.currentPage = g51PathStandard;
    self.indexInPage = 0;
    
    [self refresh];
    [self.refreshControl beginRefreshing];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning{
    // Test self.view can be release (on the screen or not).
    if (self.view.window == nil){
        // Preserve data stored in the views that might be needed later.
        
        // Clean up other strong references to the view in the view hierarchy.
        self.loader = nil;
        
        //Release self.view
        self.view = nil;
    }
    
    // iOS6 & later did nothing.
    // iOS5 & earlier test self.view == nil, if not viewWillUnload -> release self.view -> viewDidUnload.
    // In this implementation self.view is always nil, so iOS5 & earlier should do nothing.
    [super didReceiveMemoryWarning];
}

#pragma mark - Events
- (void)refresh{
    if (_loader.loadingMore) {
        [self.refreshControl endRefreshing];
        return;
    }
    
    self.currentPage = g51PathStandard;
    self.indexInPage = 0;
    
    __weak CDOnlineViewController *bSelf = self;
    LAHOperation *ope = [_VOA51 listAt:_currentPage inRange:NSMakeRange(_indexInPage, kRefreshCapacity)];
    [ope addCompletion:^(LAHOperation *operation) {
        [bSelf didRefreshWith:operation.container];
    }];
    [ope start];
}

- (void)didRefreshWith:(NSArray *)newItems{
    [_itemList removeAllObjects];
    [self.tableView reloadData];
    
    [self addItems:newItems];
    
    [self.refreshControl endRefreshing];
    [_loader endLoadingMore];
}

- (void)loadMore{
    if (self.refreshControl.refreshing) {
        [_loader endLoadingMore];
        return;
    }
    
    __weak CDOnlineViewController *bSelf = self;
    LAHOperation *ope = [_VOA51 listAt:_currentPage inRange:NSMakeRange(_indexInPage, _pageCapacity)];
    [ope addCompletion:^(LAHOperation *operation) {
        [bSelf didLoadMoreWith:operation.container];
    }];
    [ope start];
}

- (void)didLoadMoreWith:(NSArray *)newItems{
    [self addItems:newItems];
    
    [self.refreshControl endRefreshing];
    [_loader endLoadingMore];
}

- (void)addItems:(NSArray *)newItems{
    NSUInteger count = newItems.count;
    
    NSInteger newIndex = self.indexInPage + count;
    NSMutableArray *collector = [[NSMutableArray alloc] initWithCapacity:count];
    for (NSUInteger index = _indexInPage; index < newIndex; index++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [collector addObject:indexPath];
    }
    self.indexInPage = newIndex;
    
    NSMutableArray *adding = [[NSMutableArray alloc] initWithArray:newItems];
    NSUInteger index = 0;
    for (NSDictionary *dic in newItems) {
        NSString *urlString = [dic objectForKey:@"url"];
        NSArray *results = [Item itemsOfAbsolutePath:urlString];
        if (results.count >= 1) {
            [_trash setObject:dic forKey:[NSIndexPath indexPathForRow:_itemList.count + index inSection:0]];    //relaim
            Item *item = [results objectAtIndex:0];
            [adding replaceObjectAtIndex:index withObject:item];
        }
        index ++;
    }
    
    UITableView *tableView = self.tableView;
    [tableView beginUpdates];
    [_itemList addObjectsFromArray:adding];
    [tableView insertRowsAtIndexPaths:collector withRowAnimation:UITableViewRowAnimationMiddle];
    [tableView endUpdates];
}

- (void)downloadWithRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger index = indexPath.row;
    NSDictionary *data = [_itemList objectAtIndex:index];
    if (![data isKindOfClass:[NSDictionary class]]) return;
    NSString *path = [data objectForKey:@"link"];
    
    LAHOperation *ope = [_VOA51 itemAtPath:path];
    __weak CDNetwork *network = kSingletonNetwork;
    __weak NSMutableArray *itemList = _itemList;
    __weak UITableView *tableView = self.tableView;
    [ope addCompletion:^(LAHOperation *operation) {
        Item *item = [Item newItemWithDictionary:operation.container];
        NSAssert(item != nil, @"Can't new Item.");
        if (item == nil) return;
        
        //reclaim
        NSDictionary *dic = [itemList objectAtIndex:index];
       [_trash setObject:dic forKey:indexPath];
        
        [itemList replaceObjectAtIndex:index withObject:item];
 
        [network downloadItem:item];    //item network;
        
        CDItemTableCell *cell = (CDItemTableCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell setIsProgressive:YES animated:YES];
        [cell setupUpdaterWithItem:item];
    }];
    [ope start];
}

- (void)cancelDownloadWithRowAtIndexPath:(NSIndexPath *)indexPath{
    //Get item to be cancel
    Item *item = [_itemList objectAtIndex:indexPath.row];
    
    //Cancel downloading
    CDNetwork *network = kSingletonNetwork;
    [network cancelDownloadWithItem:item];
    
    //Remove resources
    [item removeResource];
    [kMOContext deleteObject:item];
    
    //Replace models
    NSDictionary *dic = [_trash objectForKey:indexPath];
    [_itemList replaceObjectAtIndex:indexPath.row withObject:dic];
    [_trash removeObjectForKey:indexPath];

    //Update View
    CDItemTableCell *cell = (CDItemTableCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell setIsProgressive:NO animated:YES];
    [cell invalidateUpdater];
}

#pragma mark - Swipe
- (void)swipe:(UISwipeGestureRecognizer *)swiper{
    UITableView *tableView = self.tableView;
    CGPoint location = [swiper locationInView:tableView];
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:location];
    [self tableView:tableView swipeRowAtIndexPath:indexPath toDirection:swiper.direction];
}

- (void)tableView:(UITableView *)tableView swipeRowAtIndexPath:(NSIndexPath *)indexPath toDirection:(UISwipeGestureRecognizerDirection)direction{
    /*
     direction == UISwipeGestureRecognizerDirectionLeft  && [data isKindOfClass:[NSDictionary class]];    //download
     direction == UISwipeGestureRecognizerDirectionLeft  && [data isKindOfClass:[Item class]] && ((Item *)data).status.integerValue == ItemStatusDownloaded;   //remove
     direction == UISwipeGestureRecognizerDirectionRight && [data isKindOfClass:[NSDictionary class]];   //return
     direction == UISwipeGestureRecognizerDirectionRight && [data isKindOfClass:[Item class]] && ((Item *)data).status.integerValue == ItemStatusDownloading;    //cancel
     */
    id data = [_itemList objectAtIndex:indexPath.row];
    switch (direction) {
        case UISwipeGestureRecognizerDirectionLeft:{
            if ([data isKindOfClass:[NSDictionary class]]) {
                [self downloadWithRowAtIndexPath:indexPath];
            } else if ([data isKindOfClass:[Item class]] && ((Item *)data).status.integerValue == ItemStatusDownloaded) {
            }
        }break;
        case UISwipeGestureRecognizerDirectionRight:
            if ([data isKindOfClass:[NSDictionary class]]) {
                
            } else if ([data isKindOfClass:[Item class]] && ((Item *)data).status.integerValue == ItemStatusDownloading) {
                [self cancelDownloadWithRowAtIndexPath:indexPath];
            }
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSUInteger number = _itemList.count;
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CDItemTableCell *cell = [tableView dequeueReusableCellWithIdentifier:gReuseCell];
    if (cell == nil) cell = [[CDItemTableCell alloc] initWithReuseIdentifier:gReuseCell];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CDItemTableCell *theCell = (CDItemTableCell *)cell;
    
    NSUInteger index = indexPath.row;
    id data = [_itemList objectAtIndex:index];
    if ([data isKindOfClass:[NSDictionary class]]) {
        [theCell configureWithDictionary:(NSDictionary *)data];
        
    }else if ([data isKindOfClass:[Item class]]){
        [theCell configureWithItem:(Item *)data];
    }
}

#pragma mark - UITableViewDelegate

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_loader testLoadingMore:scrollView];
}

@end
