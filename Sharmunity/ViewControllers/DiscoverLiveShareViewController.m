//
//  DiscoverLiveShareViewController.m
//  Sharmunity
//
//  Created by st chen on 2017/2/9.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "DiscoverLiveShareViewController.h"
#import "DiscoverLiveShareLeaseViewController.h"
#import "DiscoverLocationViewController.h"
@interface DiscoverLiveShareViewController ()

@end

@implementation DiscoverLiveShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MEID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
    [self viewsSetup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    viewController.nextControllerType = SYDiscoverNextShareMove;
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
