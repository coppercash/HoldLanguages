//
//  CDOnlineViewController.m
//  HoldLanguages
//
//  Created by William Remaerd on 3/15/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "HLOLItemsController.h"
#import "HLOLNavigationController.h"
#import "CoreDataModels.h"
#import "CDItem.h"
#import "CDItemNetwork.h"
#import "CDItemTableCell.h"
#import "CDItemDetailTableCell.h"
#import "CDLoadMoreControl.h"
#import "HLModelsGroup.h"
#import "LAHPage.h"

static NSString * const gReuseCell = @"RC";
static NSString * const gReuseDetailCell = @"RDC";

@interface HLOLItemsController ()
#pragma mark - Swipe
- (void)tableView:(UITableView *)tableView swipeRowAtIndexPath:(NSIndexPath *)indexPath toDirection:(UISwipeGestureRecognizerDirection)direction;
#pragma mark - Download
- (void)downloadWithRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)cancelDownloadWithRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)convertDictionary:(NSDictionary *)dictionary atIndexPath:(NSIndexPath *)indexPath completion:(void(^)(Item *item, NSIndexPath *indePath))completion;
#pragma mark - Detail
- (void)downloadTempImage:(Image *)image forIndexPath:(NSIndexPath *)indexPath;
- (void)enterDetailModeWithIndexPath:(NSIndexPath *)indexPath;
- (void)cancelDetailMode;
#pragma mark - Alert
- (void)alertCellNetworkError;
- (void)handleCellNetworkError;
@end

@implementation HLOLItemsController

#pragma mark - Class Basic

#pragma mark - Resource Management
- (void)loadView{
    [super loadView];
    
    UITableView *tableView = self.tableView;
    
    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    [tableView addGestureRecognizer:left];
}

- (void)viewDidLoad{
    [super viewDidLoad];
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

#pragma mark - Joiner
- (void)fillListWithItems:(NSArray *)items{
    NSAssert([items isKindOfClass:[NSArray class]] || items == nil, @"%@ must recieve a NSArray as data.", NSStringFromClass(self.class));
    
    //Replace dictionary with item already exits.
    NSMutableArray *replacedItems = [[NSMutableArray alloc] initWithArray:items];
    NSUInteger index = 0;
    for (NSDictionary *dic in items) {
        NSString *urlString = [dic objectForKey:gHLMGKeyURL];
        NSArray *results = [Item itemsOfAbsolutePath:urlString];
        if (results.count >= 1) {
            Item *item = [results objectAtIndex:0];
            [replacedItems replaceObjectAtIndex:index withObject:item];
        }
        index ++;
    }
    
    [super fillListWithItems:replacedItems];
    
    
    /*
    //NSArray *newItems = response;
    NSUInteger count = items.count;
    
    //Determine new index and indexes will be inserted
    NSInteger newIndex = self.indexInPage + count;
    NSMutableArray *insertIndexes = [[NSMutableArray alloc] initWithCapacity:count];
    for (NSUInteger index = _indexInPage; index < newIndex; index++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [insertIndexes addObject:indexPath];
    }

    //Replace dictionary with item already exits.
    NSMutableArray *adding = [[NSMutableArray alloc] initWithArray:items];
    NSUInteger index = 0;
    for (NSDictionary *dic in items) {
        NSString *urlString = [dic objectForKey:gHLMGKeyURL];
        NSArray *results = [Item itemsOfAbsolutePath:urlString];
        if (results.count >= 1) {
            Item *item = [results objectAtIndex:0];
            [adding replaceObjectAtIndex:index withObject:item];
        }
        index ++;
    }
    [_itemList addObjectsFromArray:adding];

    //Update tableView
    UITableView *tableView = self.tableView;
    [tableView beginUpdates];
    [tableView insertRowsAtIndexPaths:insertIndexes withRowAnimation:UITableViewRowAnimationMiddle];
    [tableView endUpdates];
    
    //Must after statements up, because last functions use the vars before update;
    [_joiner removeAllObjects];
    self.indexInPage += count;
    if (items.count < _breakCapacity) {
        self.entireCapacity = _itemList.count;
    }*/
}

#pragma mark - Download
- (void)convertDictionary:(NSDictionary *)dictionary atIndexPath:(NSIndexPath *)indexPath
               completion:(void(^)(Item *item, NSIndexPath *indePath))completion{
    
    NSString *link = [dictionary objectForKey:@"link"];
    LAHOperation *ope = _models.itemOperation;
    ope.page.link = link;
    
    __weak NSMutableArray *itemList = _itemList;
    [ope addCompletion:^(LAHOperation *operation) {
        Item *item = [Item newItemWithDictionary:operation.data];
        NSAssert(item != nil, @"Can't new Item.");
        if (item == nil) return;
        
        //Replace models
        [itemList replaceObjectAtIndex:indexPath.row withObject:item];
        
        //Do completion
        if (completion) completion(item, indexPath);
    }];
    [ope addCorrector:^(LAHOperation *operation, NSError *error) {
        [self alertCellNetworkError];
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
    
    NSInteger index = indexPath.row;
    if (index < _itemList.count) {
        
        Item *data = [_itemList objectAtIndex:index];
        
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

    } else {
        
        switch (direction) {
            case UISwipeGestureRecognizerDirectionRight:
                
                [self.navigationController popViewControllerAnimated:YES];
                
                break;
            default:
                break;
        }

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

#pragma mark - Alert
- (void)alertCellNetworkError{
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:NSLocalizedString(@"CellNetworkError", @"CellNetworkError")
                          message:nil
                          delegate:self
                          cancelButtonTitle:NSLocalizedString(@"GetIt", @"GetIt")
                          otherButtonTitles: nil];
    [alert show];
    
}

- (void)alertVIewDismissWithTitle:(NSString *)title{
    [super alertVIewDismissWithTitle:title];
    if ([title isEqualToString:NSLocalizedString(@"CellNetworkError", @"CellNetworkError")]) {
        [self handleCellNetworkError];
    }
}

- (void)handleCellNetworkError{
    [self cancelDetailMode];
}

@end
