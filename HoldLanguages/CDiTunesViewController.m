//
//  CDiTunesViewController.m
//  HoldLanguages
//
//  Created by William Remaerd on 1/13/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDiTunesViewController.h"
#import "CDiTunesViewCell.h"
#import "CDItemDetailTableCell.h"
#import "CDiTunesFinder.h"
#import "CDFileItem.h"
#import "CDItem.h"
#import "CoreDataModels.h"
#import "CDAudioSharer.h"
#import "CDAudioPlayer.h"
#import "CDColorFinder.h"

static NSString * const gItemsCacheName = @"Downloaded Items";
static NSString * const gReuseCell = @"DownloadedItemsCell";
static NSString * const gFileSharingCell = @"FilesSharingCell";
static NSString * const gReuseNoFile = @"NF";
static NSString * const headerXibName = @"CDiTunesHeaders";
static NSString * const footerXibName = @"CDiTunesFooters";

@interface CDiTunesViewController ()
@property(nonatomic, strong)NSFetchedResultsController *items;
@property(nonatomic, strong)CDFileItem *documents;
@property(nonatomic, strong)UIView *downloadsHeader;
@property(nonatomic, strong)UIView *fileSharingHeader;
@property(nonatomic, strong)UIView *downloadsFooter;
@property(nonatomic, strong)UIView *fileSharingFooter;

- (void)selectCellInFileSharingSection:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;
- (void)openFileWithItem:(CDFileItem *)item;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)deleteInFileSharingSection:(NSIndexPath *)indexPath;
- (void)deleteInFileDowloadsSection:(NSIndexPath *)indexPath;

@end

@implementation CDiTunesViewController
@synthesize panViewController = _panViewController;
@synthesize items = _items, documents = _documents;

#pragma mark - Resource Management
- (void)loadView{
    self.wantsFullScreenLayout = NO;
    [super loadView];
    
    UITableView *tableView = self.tableView;
    tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage pngImageWithName:@"iTunesColorPattern"]];
    tableView.separatorColor = [UIColor darkGrayColor];
    
    //Footers
    self.downloadsHeader = [UIView viewFromXibNamed:headerXibName owner:self atIndex:0];
    [_downloadsHeader shadowed];
    _downloadsHeader.backgroundColor = [CDColorFinder colorOfDownloads];
    self.fileSharingHeader = [UIView viewFromXibNamed:headerXibName owner:self atIndex:1];
    [_fileSharingHeader shadowed];
    _fileSharingHeader.backgroundColor = [CDColorFinder colorOfFileSharing];
    self.downloadsFooter = [UIView viewFromXibNamed:footerXibName owner:self atIndex:0];
    self.fileSharingFooter = [UIView viewFromXibNamed:footerXibName owner:self atIndex:1];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Item class])];
    request.predicate = [NSPredicate predicateWithFormat:@"status = %d", ItemStatusDownloaded];
    request.sortDescriptors = @[
                                [[NSSortDescriptor alloc] initWithKey:@"downloadTry" ascending:NO]
                                ];
    
    [NSFetchedResultsController deleteCacheWithName:gItemsCacheName];
    self.items = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:kMOContext sectionNameKeyPath:nil cacheName:gItemsCacheName];
    _items.delegate = self;
    
    self.documents = [[CDFileItem alloc] initWithName:directoryDocuments(nil)];
    _documents.visibleExtension = @[@"lrc", @"mp3"];
    _documents.isOpened = YES;
    
    NSError *error = nil;
    [_items performFetch:&error];
    AssertError(error);
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning{
    // Test self.view can be release (on the screen or not).
    if (self.view.window == nil){
        // Preserve data stored in the views that might be needed later.
        NSError *error = nil;
        [kMOContext save:&error];
        AssertError(error);
        
        // Clean up other strong references to the view in the view hierarchy.
        self.downloadsFooter = nil;
        self.fileSharingFooter = nil;
        
        //Release self.view
        self.view = nil;
    }
    
    // iOS6 & later did nothing.
    // iOS5 & earlier test self.view == nil, if not viewWillUnload -> release self.view -> viewDidUnload.
    // In this implementation self.view is always nil, so iOS5 & earlier should do nothing.
    [super didReceiveMemoryWarning];
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
    NSString *path = item.absolutePath;
    if ([path.pathExtension isEqualToString:@"lrc"]) {
        [App openLyricsAt:path];
    }else if ([path.pathExtension isEqualToString:@"mp3"]){
        [App openAudioAt:path];
    }
}

- (void)deleteInFileDowloadsSection:(NSIndexPath *)indexPath{
    Item *item = [_items objectAtIndexPath:indexPath];
    [item removeResource];
    [kMOContext deleteObject:item];
}

- (void)deleteInFileSharingSection:(NSIndexPath *)indexPath{
    NSInteger itemIndex = indexPath.row + 1;
    [_documents removeFileOfItemAtIndex:itemIndex];
    
    UITableView *tableView = self.tableView;
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:kDefaultCellAnimationType];
    [tableView endUpdates];
    
    //Relaod for footer
    if (_documents.count <= 1) {
        NSIndexSet *indexes = [[NSIndexSet alloc] initWithIndex:1];
        [tableView reloadSections:indexes withRowAnimation:kDefaultCellAnimationType];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    if (section < _items.sections.count) {
        
        CDItemDetailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:gReuseCell];
        if (cell == nil) cell = [[CDItemDetailTableCell alloc] initWithReuseIdentifier:gReuseCell];
        
        return cell;
    }else if (section == _items.sections.count){
        
        CDiTunesViewCell *cell = [tableView dequeueReusableCellWithIdentifier:gFileSharingCell];
        if (cell == nil) cell = [[CDiTunesViewCell alloc] initWithReuseIdentifier:gFileSharingCell];
        
        return cell;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:gReuseNoFile];
    cell.textLabel.text = @"No file.";
    cell.textLabel.textColor = [UIColor darkGrayColor];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    if (section < _items.sections.count) {
        Item *item = [_items objectAtIndexPath:indexPath];
        [(CDItemTableCell *)cell configureWithItem:item];
    }else if (section == _items.sections.count){
        CDFileItem *item = [_documents itemWithIndex:indexPath.row + 1];
        [(CDiTunesViewCell *)cell configureWithItem:item];
    }
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    CDAudioSharer *audio = App.audioSharer;
    NSString *path = audio.audioPlayer.currentAudioPath;

    NSInteger section = indexPath.section;
    if (section < _items.sections.count) {
        
        Item *item = [_items objectAtIndexPath:indexPath];
        if ([path isEqualToString:item.audio.absolutePath]) return NO;
        return YES;
    
    }else if (section == _items.sections.count){
        
        CDFileItem *item = [_documents itemWithIndex:indexPath.row + 1];
        if ([path isEqualToString:item.absolutePath]) return NO;
        
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger section = indexPath.section;
        if (section < _items.sections.count) {
            [self deleteInFileDowloadsSection:indexPath];
        }else if (section == _items.sections.count){
            [self deleteInFileSharingSection:indexPath];
        }
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    if (section < _items.sections.count) {
        AppDelegate *app = App;
        app.status->audioSourceType = AudioSourceTypeDownloads;
        Item *item = [_items objectAtIndexPath:indexPath];
        [app openItem:item];
        [_panViewController switchToController:CDPanViewControllerTypeRoot withUserInfo:item.title];
    
    }else if (section == _items.sections.count){
        App.status->audioSourceType = AudioSourceTypeFileSharing;
        [self selectCellInFileSharingSection:indexPath tableView:tableView];
        [_panViewController switchToController:CDPanViewControllerTypeRoot withUserInfo:nil];
    
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self configureCell:cell atIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    if (section < _items.sections.count) {
        Item *item = [_items objectAtIndexPath:indexPath];
        return [CDItemDetailTableCell heightWithItem:item];
    }
    return 44.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section < _items.sections.count) {
        
        return _downloadsHeader;
        
    }else if (section == _items.sections.count){
        
        return _fileSharingHeader;
        
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section < _items.sections.count) {
        
        return _downloadsFooter;
        
    }else if (section == _items.sections.count){
        
        return _fileSharingFooter;
        
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section < _items.sections.count &&
        [[[_items sections] objectAtIndex:section] numberOfObjects] == 0) {
        
        return CGRectGetHeight(_downloadsFooter.frame);
        
    }else if (section == _items.sections.count
              && _documents.count <= 1){
        
        return CGRectGetHeight(_fileSharingFooter.frame);
        
    }
    return 0.0f;
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
                          withRowAnimation:kDefaultCellAnimationType];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:kDefaultCellAnimationType];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:{
            
            
            // For coming Item when the _items is empty, and the footer won't disappear immediately.
            NSInteger section = newIndexPath.section;
            NSUInteger numberOfObjects = [[[_items sections] objectAtIndex:section] numberOfObjects];
            if (section < _items.sections.count && numberOfObjects == 1) {
                
                [tableView reloadSections:[[NSIndexSet alloc] initWithIndex:section] withRowAnimation:kDefaultCellAnimationType];
            
            }else{
                
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                 withRowAnimation:kDefaultCellAnimationType];

            }
        
        }break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:kDefaultCellAnimationType];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:kDefaultCellAnimationType];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:kDefaultCellAnimationType];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
    
    //Relaod for footer
    if ([[[controller sections] objectAtIndex:0] numberOfObjects] == 0) {
        NSIndexSet *indexes = [[NSIndexSet alloc] initWithIndex:0];
        [self.tableView reloadSections:indexes withRowAnimation:kDefaultCellAnimationType];
    }
}

@end
