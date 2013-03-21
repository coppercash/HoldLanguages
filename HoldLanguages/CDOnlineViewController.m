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

@interface CDOnlineViewController ()
@property(nonatomic, strong)CD51VOA *VOA51;
@end

@implementation CDOnlineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    button.autoresizingMask = CDViewAutoresizingCenter;
    [button addTarget:self action:@selector(buttonFired:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:button];
    self.view = view;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.VOA51 = [[CD51VOA alloc] init];

    /*
     LAHOperation *ope = [_VOA51 homePage];
    [ope addCompletion:^(LAHOperation *operation) {
        NSLog(@"51voa\n%@", operation.container);
    }];
    [ope start];
     */
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event
- (void)buttonFired:(UIButton *)button{
    LAHOperation *ope = [_VOA51 itemAtPath:@"/VOA_Special_English/a-navigation-app-that-helps-predict-traffic-conditions-48973.html"];
    [ope addCompletion:^(LAHOperation *operation) {
        DLog(@"51voa\n%@", operation.container);
        Item *item = [Item newItemWithDictionary:operation.container path:operation.absolutePath];
        DLog(@"%@", item);
        __weak CDItemNetwork * network = [kSingletonContext downloadItem:item];
        [network addCompletion:^(CDNetworkGroup *group) {
            CDItemNetwork *iN = (CDItemNetwork *)group;
            DLog(@"Success status:%d", iN.item.status.integerValue);
        } forKey:self];
        [network addCorrector:^(CDNetworkGroup *group, NSError *error) {
            DLog(@"\n%@\n%@", NSStringFromSelector(_cmd), error.userInfo);
        } forKey:self];
        [network addProgress:^(CDNetworkGroup *group, double progress) {
            DLog(@"progress:%lf", progress);
        } forKey:self];
    }];
    [ope start];
}
@end
