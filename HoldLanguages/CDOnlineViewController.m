//
//  CDOnlineViewController.m
//  HoldLanguages
//
//  Created by William Remaerd on 3/15/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDOnlineViewController.h"
#import "CDOnlineNavController.h"
#import "CD51VOA.h"
#import "Item.h"
#import "CoreDataModels.h"
#import "CDItem.h"
#import "CDItemNetwork.h"
#import "CDItemTableCell.h"
#import "CDItemDetailTableCell.h"
#import "CDLoadMoreControl.h"
#import "Reachability.h"

static NSString * const gReuseCell = @"RC";
static NSString * const gReuseDetailCell = @"RDC";

@interface CDOnlineViewController ()
@property(nonatomic, strong)CDLoadMoreControl *loader;

@property(nonatomic, strong)NSMutableArray *itemList;
@property(nonatomic, strong)CD51VOA *VOA51;

@property(nonatomic, assign)NSInteger indexOfPage;
@property(nonatomic, assign)NSInteger indexInPage;
@property(nonatomic, assign)NSUInteger pageCapacity;
@property(nonatomic, strong)NSString *currentPage;

#pragma mark - Swipe
- (void)swipe:(UISwipeGestureRecognizer *)swiper;
- (void)tableView:(UITableView *)tableView swipeRowAtIndexPath:(NSIndexPath *)indexPath toDirection:(UISwipeGestureRecognizerDirection)direction;
#pragma mark - Refresh & Load More
- (void)refresh;
- (void)didRefreshWith:(NSArray *)newItems;
- (void)loadMore;
- (void)didLoadMoreWith:(NSArray *)newItems;
- (void)addItems:(NSArray *)newItems;
#pragma mark - Download
- (void)downloadWithRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)cancelDownloadWithRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)convertDictionary:(NSDictionary *)dictionary atIndexPath:(NSIndexPath *)indexPath completion:(void(^)(Item *item, NSIndexPath *indePath))completion;
#pragma mark - Detail
- (void)downloadTempImage:(Image *)image forIndexPath:(NSIndexPath *)indexPath;
- (void)enterDetailModeWithIndexPath:(NSIndexPath *)indexPath;
- (void)cancelDetailMode;
@end

@implementation CDOnlineViewController
@synthesize panViewController = _panViewController;
@synthesize loader = _loader;
@synthesize VOA51 = _VOA51, itemList = _itemList;
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
    CDOnlineNavController *nav = (CDOnlineNavController *)self.navigationController;
    
    self.itemList = [[NSMutableArray alloc] initWithCapacity:kRefreshCapacity];
    self.VOA51 = nav.VOA51;
    
    self.pageCapacity = 10;
    
    [self refresh];
    [self.refreshControl beginRefreshing];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    CDOnlineNavController *nav = (CDOnlineNavController *)self.navigationController;
    [nav backButton];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [Item removeInitItems];
}

- (void)didReceiveMemoryWarning{
    // Test self.view can be release (on the screen or not).
    if (self.view.window == nil){
        // Preserve data stored in the views that might be needed later.
        NSError *error = nil;
        [kMOContext save:&error];
        AssertError(error);
        
        // Clean up other strong references to the view in the view hierarchy.
        self.loader = nil;
        if (_imageNetwork) {
            [_imageNetwork cancel];
            _imageNetwork = nil;
        }
        
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
    
    self.currentPage = _rootPage;
    self.indexInPage = 0;
    self.indexOfPage = 0;
    
    __weak CDOnlineViewController *bSelf = self;
    LAHOperation *ope = [_VOA51 listAt:_currentPage inRange:NSMakeRange(_indexInPage, kRefreshCapacity)];
    [ope addCompletion:^(LAHOperation *operation) {
        [bSelf didRefreshWith:operation.container];
    }];
    [ope start];
}

- (void)didRefreshWith:(NSArray *)newItems{
    [self.refreshControl endRefreshing];
    [_loader endLoadingMore];
    
    [_itemList removeAllObjects];
    [self.tableView reloadData];
    
    [self addItems:newItems];
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
    [self.refreshControl endRefreshing];
    [_loader endLoadingMore];

    [self addItems:newItems];
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

#pragma mark - Download
- (void)convertDictionary:(NSDictionary *)dictionary atIndexPath:(NSIndexPath *)indexPath
               completion:(void(^)(Item *item, NSIndexPath *indePath))completion{
    NSString *path = [dictionary objectForKey:@"link"];
    LAHOperation *ope = [_VOA51 itemAtPath:path];
    
    __weak NSMutableArray *itemList = _itemList;
    [ope addCompletion:^(LAHOperation *operation) {
        Item *item = [Item newItemWithDictionary:operation.container];
        NSAssert(item != nil, @"Can't new Item.");
        if (item == nil) return;
        
        //Replace models
        [itemList replaceObjectAtIndex:indexPath.row withObject:item];
        
        //Do completion
        if (completion) completion(item, indexPath);
    }];
    [ope start];
}

- (void)downloadWithRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger index = indexPath.row;
    NSDictionary *data = [_itemList objectAtIndex:index];
    
    __weak CDNetwork *network = kSingletonNetwork;
    __weak UITableView *tableView = self.tableView;
    if ([data isKindOfClass:[NSDictionary class]]) {
        
        [self convertDictionary:data atIndexPath:indexPath completion:^(Item *item, NSIndexPath *indePath) {
            //item network;
            [network downloadItem:item];
            
            //Update table view
            CDItemTableCell *cell = (CDItemTableCell *)[tableView cellForRowAtIndexPath:indexPath];
            [cell setIsProgressive:YES animated:YES];
            [cell setupUpdaterWithItem:item];
        }];
        
    } else if ([data isKindOfClass:[Item class]]) {
        Item *item = (Item *)data;
        
        //item network;
        [kSingletonNetwork downloadItem:item];
        
        //Update table view
        CDItemTableCell *cell = (CDItemTableCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell setIsProgressive:YES animated:YES];
        [cell setupUpdaterWithItem:item];
    }
}

- (void)cancelDownloadWithRowAtIndexPath:(NSIndexPath *)indexPath{
    //Get item to be cancel
    Item *item = [_itemList objectAtIndex:indexPath.row];
    
    //Cancel downloading
    CDNetwork *network = kSingletonNetwork;
    [network cancelDownloadWithItem:item];
    
    /*
    //Remove resources
    [item removeResource];
    [kMOContext deleteObject:item];
    
    //Replace models
    NSDictionary *dic = [_trash objectForKey:indexPath];
    [_itemList replaceObjectAtIndex:indexPath.row withObject:dic];
    [_trash removeObjectForKey:indexPath];
     */
    
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
    //download  Left && (isDictionary || init item)
    //cancel    Right && downloading item
    //return    Right && (isDictionary || !downloading item)
    
    Item *data = [_itemList objectAtIndex:indexPath.row];
    
    switch (direction) {
        case UISwipeGestureRecognizerDirectionLeft:{
            if ([data isKindOfClass:[NSDictionary class]] ||
                ([data isKindOfClass:[Item class]] && data.status.integerValue == ItemStatusInit)) {
                
                [self downloadWithRowAtIndexPath:indexPath];
            
            }
        }break;
        case UISwipeGestureRecognizerDirectionRight:
            
            if ([data isKindOfClass:[Item class]] && data.status.integerValue == ItemStatusDownloading) {
                
                [self cancelDownloadWithRowAtIndexPath:indexPath];
            
            }else{
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            break;
        default:
            break;
    }
}

#pragma mark - Detail
- (void)downloadTempImage:(Image *)image forIndexPath:(NSIndexPath *)indexPath{
    NSURL *imageURL = [[NSURL alloc] initWithString:image.absoluteLink];
    __weak UITableView *tableView = self.tableView;
    CDNKOperation *ope =
    [kSingletonNetwork
     imageAtURL:imageURL
     completionHandler:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
         
         CDItemDetailTableCell *cell = (CDItemDetailTableCell *)[tableView cellForRowAtIndexPath:indexPath];
         [cell loadImage:fetchedImage];
         
     } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
         
         AssertError(error);
         
     }];
    
    _imageNetwork = ope;
}

- (void)enterDetailModeWithIndexPath:(NSIndexPath *)indexPath{
    DLogCurrentMethod;
    self.tableView.scrollEnabled = NO;
    _detailIndex = indexPath;
    
    __weak UITableView *tableView = self.tableView;
    NSDictionary *data = [_itemList objectAtIndex:indexPath.row];
    if ([data isKindOfClass:[NSDictionary class]]) {
        
        [self convertDictionary:data atIndexPath:indexPath completion:^(Item *item, NSIndexPath *indePath) {
            
            // Unfold cell
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:kDefaultCellAnimationType];
            [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];

            Image *image = item.anyImage;
            if (image) [self downloadTempImage:image forIndexPath:indexPath];
            
        }];
    
    }else if ([data isKindOfClass:[Item class]]) {
        
        // Unfold cell
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:kDefaultCellAnimationType];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        
        Item *item = (Item *)data;
        ItemStatus status = item.status.integerValue;
        if (status == ItemStatusInit || status == ItemStatusDownloading) {
            //Download tmp image if image file related to Image doesn't exists.
            Image *image = item.anyImage;
            if (image && !image.fileExists) [self downloadTempImage:image forIndexPath:indexPath];
        }
    }
}

- (void)cancelDetailMode{
    DLogCurrentMethod;
    
    //Deal with index
    NSIndexPath *detailIndex = _detailIndex;
    _detailIndex = nil; //Assign nil for tableView:cellForRowAtIndexPath: will test it to determine load what kink of cell
    
    // Cancel network and its block
    if (_imageNetwork) {
        [_imageNetwork cancel];
        _imageNetwork = nil;
    }
    
    //Update table view
    [self.tableView reloadRowsAtIndexPaths:@[detailIndex] withRowAnimation:kDefaultCellAnimationType];
    
    self.tableView.scrollEnabled = YES;
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
    CDItemTableCell *cell = nil;

    if ([_detailIndex isEqual:indexPath]) {
        // Detail Cell in Detail Mode
        cell = [[CDItemDetailTableCell alloc] initWithReuseIdentifier:nil];

    }else{
        //Non-Detail Mode and normal cell in Detail Mode
        cell = [tableView dequeueReusableCellWithIdentifier:gReuseCell];
        if (cell == nil) cell = [[CDItemTableCell alloc] initWithReuseIdentifier:gReuseCell];
    }
    
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 44.0f;
    
    if ([_detailIndex isEqual:indexPath]) {
        // Detail Cell in Detail Mode
        Item *item = [_itemList objectAtIndex:indexPath.row];
        NSParameterAssert([item isKindOfClass:[Item class]]);
        height = [CDItemDetailTableCell heightWithItem:item];
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_detailIndex == nil) {
        [self enterDetailModeWithIndexPath:indexPath];
    }else if (![indexPath isEqual:_detailIndex]) {
        [self cancelDetailMode];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_loader testLoadingMore:scrollView];
}

@end
