//
//  DiscoverLiveHelpViewController.m
//  Sharmunity
//
//  Created by Star Chen on 2/5/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import "DiscoverLiveHelpViewController.h"
#import "DiscoverLiveHelpRentViewController.h"
#import "DiscoverLiveShareLeaseViewController.h"
#import "DiscoverLocationViewController.h"
#import "Header.h"
@interface DiscoverLiveHelpViewController ()

@end

@implementation DiscoverLiveHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MEID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
    [self viewsSetup];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewsSetup{
    [_rentButton addTarget:self action:@selector(rentHomeResponse) forControlEvents:UIControlEventTouchUpInside];
    [_leaseButton addTarget:self action:@selector(leaseResponse) forControlEvents:UIControlEventTouchUpInside];
    [_moveButton addTarget:self action:@selector(moveResponse) forControlEvents:UIControlEventTouchUpInside];
}

-(void)rentHomeResponse{
    DiscoverLiveHelpRentViewController *viewController = [DiscoverLiveHelpRentViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)leaseResponse{
    DiscoverLiveShareLeaseViewController *viewController = [DiscoverLiveShareLeaseViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)moveResponse{
    NSString *subCate = @"02000000";
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:subCate, @"subcate", nil];
    NSMutableDictionary *shareDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:MEID,@"email",@"2",@"category",@"2099-01-01",@"expire_date", nil];;
    [shareDict addEntriesFromDictionary:dict];
    DiscoverLocationViewController *viewController = [DiscoverLocationViewController new];
    viewController.subCate = subCate;
    viewController.summaryDict = shareDict;
    viewController.needDistance = NO;
    viewController.nextControllerType = SYDiscoverNextHelpMove;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
