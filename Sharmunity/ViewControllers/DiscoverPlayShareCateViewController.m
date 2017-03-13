//
//  DiscoverPlayShareCateViewController.m
//  Sharmunity
//
//  Created by Star Chen on 3/9/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import "DiscoverPlayShareCateViewController.h"
#import "DiscoverPlayShareActiveViewController.h"
#import "Header.h"
@interface DiscoverPlayShareCateViewController ()

@end

@implementation DiscoverPlayShareCateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发起活动";
    
    [self viewsSetup];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"SYBackColor4"] forState:UIControlStateNormal];
    [backBtn setTitle:@"玩" forState:UIControlStateNormal];
    [backBtn setTitleColor:SYColor1 forState:UIControlStateNormal];
    [backBtn.titleLabel setFont:SYFont15];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backBtn.bounds = CGRectMake(0, 0, 80, 40);
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
}
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewsSetup{
    [_cate1Button addTarget:self action:@selector(activityResponse:) forControlEvents:UIControlEventTouchUpInside];
    [_cate2Button addTarget:self action:@selector(activityResponse:) forControlEvents:UIControlEventTouchUpInside];
    [_cate3Button addTarget:self action:@selector(activityResponse:) forControlEvents:UIControlEventTouchUpInside];
    [_cate4Button addTarget:self action:@selector(activityResponse:) forControlEvents:UIControlEventTouchUpInside];
    [_cate5Button addTarget:self action:@selector(activityResponse:) forControlEvents:UIControlEventTouchUpInside];
    [_otherButton addTarget:self action:@selector(activityResponse:) forControlEvents:UIControlEventTouchUpInside];
}
-(IBAction)activityResponse:(id)sender{
    UIButton *button = sender;
    DiscoverPlayShareActiveViewController *viewController = [DiscoverPlayShareActiveViewController new];
    viewController.controllerType = DiscoverPlayActivity;
    viewController.subcate1 = button.tag;
    [self.navigationController pushViewController:viewController animated:YES];
}


@end
