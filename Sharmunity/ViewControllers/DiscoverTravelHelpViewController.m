//
//  DiscoverTravelHelpViewController.m
//  Sharmunity
//
//  Created by Star Chen on 2/15/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import "DiscoverTravelHelpViewController.h"
#import "DiscoverTravelHelpSecondViewController.h"
@interface DiscoverTravelHelpViewController ()

@end

@implementation DiscoverTravelHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewsSetup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewsSetup{
    _partnerButton.tag = DiscoverTravelPartner;
    _driveButton.tag = DiscoverTravelDrive;
    _carpoolButton.tag = DiscoverTravelCarpool;
    _pickupButton.tag = DiscoverTravelPickup;
    _buyCarButton.tag = DiscoverTravelBuyCar;
    _repairButton.tag = DiscoverTravelRepair;
    _deliverButton.tag = DiscoverTravelDeliver;
    _otherButton.tag = DiscoverTravelOther;
    [_partnerButton addTarget:self action:@selector(selectResponse:) forControlEvents:UIControlEventTouchUpInside];
    [_driveButton addTarget:self action:@selector(selectResponse:) forControlEvents:UIControlEventTouchUpInside];
    [_carpoolButton addTarget:self action:@selector(selectResponse:) forControlEvents:UIControlEventTouchUpInside];
    [_pickupButton addTarget:self action:@selector(selectResponse:) forControlEvents:UIControlEventTouchUpInside];
    [_buyCarButton addTarget:self action:@selector(selectResponse:) forControlEvents:UIControlEventTouchUpInside];
    [_repairButton addTarget:self action:@selector(selectResponse:) forControlEvents:UIControlEventTouchUpInside];
    [_deliverButton addTarget:self action:@selector(selectResponse:) forControlEvents:UIControlEventTouchUpInside];
    [_otherButton addTarget:self action:@selector(selectResponse:) forControlEvents:UIControlEventTouchUpInside];
}

-(IBAction)selectResponse:(id)sender{
    UIButton *button = sender;
    DiscoverTravelHelpSecondViewController *viewController = [DiscoverTravelHelpSecondViewController new];
    viewController.controllerType = button.tag;
    [self.navigationController pushViewController:viewController animated:YES];
}


@end
