//
//  DiscoverPlayShareViewController.m
//  Sharmunity
//
//  Created by st chen on 2017/2/14.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "DiscoverPlayShareViewController.h"
#import "DiscoverPlayShareActiveViewController.h"
@interface DiscoverPlayShareViewController ()

@end

@implementation DiscoverPlayShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewsSetup];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewsSetup{
    [_partnerButton addTarget:self action:@selector(partnerResponse) forControlEvents:UIControlEventTouchUpInside];
    [_activityButton addTarget:self action:@selector(activityResponse) forControlEvents:UIControlEventTouchUpInside];
    [_articalButton addTarget:self action:@selector(articalResponse) forControlEvents:UIControlEventTouchUpInside];
    [_otherButton addTarget:self action:@selector(otherResponse) forControlEvents:UIControlEventTouchUpInside];
}

-(void)partnerResponse{
    DiscoverPlayShareActiveViewController *viewController = [DiscoverPlayShareActiveViewController new];
    viewController.controllerType = DiscoverPlayPartner;
    [self.navigationController pushViewController:viewController animated:YES];
}
-(void)activityResponse{
    DiscoverPlayShareActiveViewController *viewController = [DiscoverPlayShareActiveViewController new];
    viewController.controllerType = DiscoverPlayActivity;
    [self.navigationController pushViewController:viewController animated:YES];

}
-(void)articalResponse{
    
}
-(void)otherResponse{
    DiscoverPlayShareActiveViewController *viewController = [DiscoverPlayShareActiveViewController new];
    viewController.controllerType = DiscoverPlayOther;
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
