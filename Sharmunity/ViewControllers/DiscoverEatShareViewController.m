//
//  DiscoverEatShareViewController.m
//  Sharmunity
//
//  Created by Star Chen on 2/11/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import "DiscoverEatShareViewController.h"
#import "DiscoverEatShareSecondViewController.h"
@interface DiscoverEatShareViewController ()

@end

@implementation DiscoverEatShareViewController

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
    [_regionButton addTarget:self action:@selector(regionResponse) forControlEvents:UIControlEventTouchUpInside];
    [_foodButton addTarget:self action:@selector(foodResponse) forControlEvents:UIControlEventTouchUpInside];
}

     
-(void)regionResponse{
    DiscoverEatShareSecondViewController *viewController = [DiscoverEatShareSecondViewController new];
    viewController.controllerType = discoverEatRegion;
    [self.navigationController pushViewController:viewController animated:YES];
}
-(void)foodResponse{
    DiscoverEatShareSecondViewController *viewController = [DiscoverEatShareSecondViewController new];
    viewController.controllerType = discoverEatFood;
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
