//
//  CDCategoryViewController.m
//  HoldLanguages
//
//  Created by William Remaerd on 4/1/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDCategoryViewController.h"
#import "CD51VOA.h"
#import "CDOnlineNavController.h"
#import "CDOnlineViewController.h"

@interface CDCategoryViewController ()
@property(nonatomic, strong)CD51VOA *VOA51;
@property(nonatomic, strong)NSMutableArray *itemList;
- (void)swipe:(UISwipeGestureRecognizer *)swiper;
@end

@implementation CDCategoryViewController
@synthesize VOA51 = _VOA51, itemList = _itemList;

- (void)loadView{
    self.wantsFullScreenLayout = NO;
    [super loadView];
    
    UITableView *tableView = self.tableView;
    tableView.separatorColor = [UIColor darkGrayColor];
    tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage pngImageWithName:@"iTunesColorPattern"]];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [tableView addGestureRecognizer:swipe];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    CDOnlineNavController *nav = (CDOnlineNavController *)self.navigationController;

    self.itemList = [[NSMutableArray alloc] initWithCapacity:kNumberOfCategories];
    self.VOA51 = nav.VOA51;
    
    LAHOperation *ope = [_VOA51 categoty];
    CDCategoryViewController *bSelf = self;
    [ope addCompletion:^(LAHOperation *operation) {
        bSelf.itemList = operation.container;
        [bSelf.tableView reloadData];
    }];
    [ope start];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    CDOnlineNavController *nav = (CDOnlineNavController *)self.navigationController;
    [nav destroyBackButton];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Swipe
- (void)swipe:(UISwipeGestureRecognizer *)swiper{
    CDOnlineNavController *nav = (CDOnlineNavController *)self.navigationController;

    [nav.panViewController switchToController:CDPanViewControllerTypeRoot withUserInfo:nil];
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
    NSString *name = [dic objectForKey:@"name"];
    cell.textLabel.text = name;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CDOnlineNavController *nav = (CDOnlineNavController *)self.navigationController;
    
    CDOnlineViewController *con = [[CDOnlineViewController alloc] init];
    NSDictionary *dic = [_itemList objectAtIndex:indexPath.row];
    NSString *link = [dic objectForKey:@"link"];
    con.rootPage = link;
    NSString *name = [dic objectForKey:@"name"];
    con.title = name;
    
    [nav pushViewController:con animated:YES];
}

@end
