//
//  DiscoverLearnHelpViewController.m
//  Sharmunity
//
//  Created by st chen on 2017/2/13.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "DiscoverLearnHelpViewController.h"
#import "DiscoverLearnHelpSubmitViewController.h"
@interface DiscoverLearnHelpViewController ()

@end

@implementation DiscoverLearnHelpViewController

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
    DiscoverLearnHelpSubmitViewController *viewController = [DiscoverLearnHelpSubmitViewController new];
    viewController.controllerType = discoverLearnExper;
    [self.navigationController pushViewController:viewController animated:YES];
}
-(void)tutorResponse{
    DiscoverLearnHelpSubmitViewController *viewController = [DiscoverLearnHelpSubmitViewController new];
    viewController.controllerType = discoverLearnTutor;
    [self.navigationController pushViewController:viewController animated:YES];
}
-(void)interestResponse{
    DiscoverLearnHelpSubmitViewController *viewController = [DiscoverLearnHelpSubmitViewController new];
    viewController.controllerType = discoverLearnInterest;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
