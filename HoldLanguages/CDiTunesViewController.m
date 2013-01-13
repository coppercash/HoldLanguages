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
    [self.view addSubview:_tableView];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    CDFileItem *item = [_documents itemWithIndex:indexPath.row + 1];
    if (cell == nil) cell = [[CDiTunesViewCell alloc] initWithReuseIdentifier:kCDiTunesViewCell item:item];
    
    // Configure the cell...
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
    [_panViewController switchToController:CDPanViewControllerTypeRoot withUserInfo:item.absolutePath];
}

@end
