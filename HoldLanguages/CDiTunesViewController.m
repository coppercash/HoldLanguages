//
//  CDiTunesViewController.m
//  HoldLanguages
//
//  Created by William Remaerd on 1/13/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDiTunesViewController.h"
#import "CDiTunesFinder.h"
#import "CDFileItem.h"
#import "CDiTunesViewCell.h"

@interface CDiTunesViewController ()
- (void)openFileWithItem:(CDFileItem *)item;
@end

@implementation CDiTunesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _documents = [[CDFileItem alloc] initWithName:documentsPath()];
    _documents.visibleExtension = @[@"lrc"];
    _documents.isOpened = YES;
    
    CGRect tableViewFrame = self.view.bounds;
    tableViewFrame.origin.y = 20.0;
    tableViewFrame.size.height -= 20.0f;
    _tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage pngImageWithName:@"iTunesColorPattern"]];
    _tableView.separatorColor = [UIColor darkGrayColor];
    //DLogRect(_tableView.bounds);
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Open
- (void)openFileWithItem:(CDFileItem *)item{
    [_panViewController switchToController:CDPanViewControllerTypeRoot withUserInfo:item.absolutePath];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = _documents.count - 1;
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = kCDiTunesViewCell;
    CDiTunesViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) cell = [[CDiTunesViewCell alloc] initWithReuseIdentifier:kCDiTunesViewCell];
    
    CDFileItem *item = [_documents itemWithIndex:indexPath.row + 1];
    [cell setupWithItem:item];
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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

@end
