//
//  DiscoverLearnShareViewController.m
//  Sharmunity
//
//  Created by st chen on 2017/2/13.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "DiscoverLearnShareViewController.h"
#import "DiscoverLearnShareSubmitViewController.h"
@interface DiscoverLearnShareViewController ()

@end

@implementation DiscoverLearnShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self viewsSetup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewsSetup{
    [_experienceButton addTarget:self action:@selector(experienceResponse) forControlEvents:UIControlEventTouchUpInside];
    [_tutorButton addTarget:self action:@selector(tutorResponse) forControlEvents:UIControlEventTouchUpInside];
    [_interestButton addTarget:self action:@selector(interestResponse) forControlEvents:UIControlEventTouchUpInside];
}
-(void)experienceResponse{
    DiscoverLearnShareSubmitViewController *viewController = [DiscoverLearnShareSubmitViewController new];
    viewController.controllerType = discoverLearnExper;
    [self.navigationController pushViewController:viewController animated:YES];
}
-(void)tutorResponse{
    DiscoverLearnShareSubmitViewController *viewController = [DiscoverLearnShareSubmitViewController new];
    viewController.controllerType = discoverLearnTutor;
    [self.navigationController pushViewController:viewController animated:YES];
}
-(void)interestResponse{
    DiscoverLearnShareSubmitViewController *viewController = [DiscoverLearnShareSubmitViewController new];
    viewController.controllerType = discoverLearnInterest;
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
