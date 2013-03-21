//
//  CDiTunesViewController.m
//  HoldLanguages
//
//  Created by William Remaerd on 1/13/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDiTunesViewController.h"
#import "CDiTunesViewCell.h"
#import "CDItemCell.h"
#import "CDiTunesFinder.h"
#import "CDFileItem.h"
#import "CDItem.h"

static NSString *gItemsCacheName = @"Downloaded Items";
static NSString *gDownloadedItemsCell = @"DownloadedItemsCell";
static NSString *gFileSharingCell = @"FilesSharingCell";

@interface CDiTunesViewController ()
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSFetchedResultsController *items;
@property(nonatomic, strong)CDFileItem *documents;
- (void)selectCellInFileSharingSection:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;
- (void)openFileWithItem:(CDFileItem *)item;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation CDiTunesViewController
#pragma mark - Resource Management
- (void)loadView{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    
    CGRect tableViewFrame = view.bounds;
    tableViewFrame.origin.y = 20.0;
    tableViewFrame.size.height -= 20.0f;
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage pngImageWithName:@"iTunesColorPattern"]];
    _tableView.separatorColor = [UIColor darkGrayColor];

    [view addSubview:_tableView];
    self.view = view;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Item class])];
    request.predicate = [NSPredicate predicateWithFormat:@"status = %d", ItemStatusDownloaded];
    request.sortDescriptors = @[
                                [[NSSortDescriptor alloc] initWithKey:@"downloadTry" ascending:NO]
                                ];
    
    self.items = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:kMOContext sectionNameKeyPath:nil cacheName:gItemsCacheName];
    
    self.documents = [[CDFileItem alloc] initWithName:directoryDocuments(nil)];
    _documents.visibleExtension = @[@"lrc", @"mp3"];
    _documents.isOpened = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSError *error = nil;
    [_items performFetch:&error];
    AssertError(error);
    
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Events
- (void)selectCellInFileSharingSection:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
    CDFileItem *item = [_documents itemWithIndex:indexPath.row + 1];
    if (item.isDirectory) {
        BOOL isOpened = item.isOpened;
        
        NSUInteger oldCount = item.count;
        item.isOpened = !isOpened;
        NSUInteger increment = abs(item.count - oldCount);
        
        NSInteger baseRow = indexPath.row + 1, section = indexPath.section;
        NSMutableArray *paths = [[NSMutableArray alloc] initWithCapacity:increment];
        for (int i = 0; i < increment; i++) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:baseRow + i inSection:section];
            [paths addObject:path];
        }
        
        [tableView beginUpdates];
        if (isOpened) {
            [tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationBottom];
        }else{
            [tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationBottom];
        }
        [tableView endUpdates];
        
        [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:section]] withRowAnimation:UITableViewRowAnimationFade];
    }else{
        [self openFileWithItem:item];
    }

}

- (void)openFileWithItem:(CDFileItem *)item{
    [_panViewController switchToController:CDPanViewControllerTypeRoot withUserInfo:item.absolutePath];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{;
    DLog(@"section\t%@", _items.sections)
    NSUInteger number = _items.sections.count + 1;  //1 for files in iTunes File Sharing.
    return number;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSUInteger number = 0;
    if (section < _items.sections.count) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[_items sections] objectAtIndex:section];
        number = sectionInfo.numberOfObjects;
    }else if (section == _items.sections.count){
        number = _documents.count - 1;
    }

    return number;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    if (section < _items.sections.count) {
        Item *item = [_items objectAtIndexPath:indexPath];
        [(CDItemCell *)cell configureWithItem:item];
    }else if (section == _items.sections.count){
        CDFileItem *item = [_documents itemWithIndex:indexPath.row + 1];
        [(CDiTunesViewCell *)cell configureWithItem:item];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    DLog(@"\nindexPath\t%d\t%d\n_item%@", indexPath.section, indexPath.row, _items.sections);
    if (section < _items.sections.count) {
        CDItemCell *cell = [tableView dequeueReusableCellWithIdentifier:gDownloadedItemsCell];
        if (cell == nil) cell = [[CDItemCell alloc] initWithReuseIdentifier:gDownloadedItemsCell];
        id <NSFetchedResultsSectionInfo> sectionInfo = [[_items sections] objectAtIndex:section];
        DLog(@"info:%d", sectionInfo.numberOfObjects);
        Item *item = [_items objectAtIndexPath:indexPath];
        [cell configureWithItem:item];
        
        return cell;
    }else if (section == _items.sections.count){
        CDiTunesViewCell *cell = [tableView dequeueReusableCellWithIdentifier:gFileSharingCell];
        if (cell == nil) cell = [[CDiTunesViewCell alloc] initWithReuseIdentifier:gFileSharingCell];
        
        CDFileItem *item = [_documents itemWithIndex:indexPath.row + 1];
        [cell configureWithItem:item];
        
        return cell;
    }
    
    return [[UITableViewCell alloc] init];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return NSLocalizedString(@"iTunesViewHeaderDownloads", @"Downloads");
            break;
        case 1:
            return NSLocalizedString(@"iTunesViewHeaderFileSharing", @"iTunes File Sharing");
            break;
        default:
            break;
    }
    return [NSString stringWithFormat:@"Section %d has no title for header.", section];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            
            break;
        case 1:
            [self selectCellInFileSharingSection:indexPath tableView:tableView];
            break;
        default:
            break;
    }
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

@end
