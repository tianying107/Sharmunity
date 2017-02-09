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
#import "Header.h"
@interface DiscoverLiveHelpViewController ()

@end

@implementation DiscoverLiveHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    [_moveButton addTarget:self action:@selector(moveButton) forControlEvents:UIControlEventTouchUpInside];
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
    
}

@end
