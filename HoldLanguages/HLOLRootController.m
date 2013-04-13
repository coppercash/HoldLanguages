//
//  HLOLRootController.m
//  HoldLanguages
//
//  Created by William Remaerd on 4/12/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "HLOLRootController.h"

#import "HLOLNavigationController.h"
#import "HLOLCategoryController.h"
#import "HLOLItemsController.h"

#import "CDColorFinder.h"
#import "HLModelsGroup.h"

@interface HLOLRootController ()
@property(nonatomic, copy)NSString *link;
@property(nonatomic, strong)NSArray *groups;
@property(nonatomic, weak)MKNetworkOperation *network;
- (void)refresh;
- (void)didRefreshWith:(id)response;
- (void)didReceiveResponse:(id)response;
@end

@implementation HLOLRootController
@synthesize link = _link, groups = _groups, network = _network;

- (void)loadView{
    self.wantsFullScreenLayout = NO;
    [super loadView];
    
    [self formated];
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self refresh];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    HLOLNavigationController *nav = (HLOLNavigationController *)self.navigationController;
    [nav removeBackButton];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Refresh & Load More
- (void)refresh{    
    [self.refreshControl beginRefreshing];
    [self didRefreshWith:@"testData"];
}

- (void)didRefreshWith:(id)response{
    [self.refreshControl endRefreshing];
        
    [self didReceiveResponse:response];
}

- (void)didReceiveResponse:(id)response{
    NSAssert([response isKindOfClass:[NSString class]], @"%@ must recieve a NSString as data.", NSStringFromClass(self.class));
    
    NSArray *groups = [self testData];
    
    NSMutableArray *collector = [[NSMutableArray alloc] initWithCapacity:groups.count];
    for (NSDictionary *dic in groups) {
        
        NSString *name = [dic objectForKey:gHLMGKeyName];
        NSString *command = [dic objectForKey:gHLMGKeyCommand];
        
        HLModelsGroup *group = [[HLModelsGroup alloc] initWithCommand:command key:gHLMGKeyOperation];
        group.name = name;
        
        [collector addObject:group];
        
    }
    
    self.groups = [[NSArray alloc] initWithArray:collector];
    [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:kDefaultTableViewCellAniamtion];
}

#pragma mark - Network
- (NSArray *)testData{
    NSString *name = @"Voice of America";
    NSString *path = [[NSBundle mainBundle] pathForResource:@"51VOA" ofType:@"lah"];
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:name, gHLMGKeyName, string, gHLMGKeyCommand, nil];
    
    NSArray *groups = [[NSArray alloc] initWithObjects:dic, nil];

    return groups;
}

#pragma mark - Swipe
- (void)swipe:(UISwipeGestureRecognizer *)swiper{
    HLOLNavigationController *nav = (HLOLNavigationController *)self.navigationController;
    [nav.panViewController switchToController:CDPanViewControllerTypeRoot withUserInfo:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _groups.count;
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
    HLModelsGroup *group = [_groups objectAtIndex:indexPath.row];
    cell.textLabel.text = group.name;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HLOLNavigationController *nav = (HLOLNavigationController *)self.navigationController;
    HLModelsGroup *group = [_groups objectAtIndex:indexPath.row];
    [nav pushWithModelsGroup:group link:nil];
    
}

@end
