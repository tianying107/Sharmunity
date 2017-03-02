//
//  DiscoverLearnHelpExpViewController.m
//  Sharmunity
//
//  Created by st chen on 2017/3/1.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "DiscoverLearnHelpExpViewController.h"
#import "DiscoverLearnHelpSubmitViewController.h"
#import "Header.h"
@interface DiscoverLearnHelpExpViewController ()

@end

@implementation DiscoverLearnHelpExpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"找学长";
    
    [self viewsSetup];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"SYBackColor5"] forState:UIControlStateNormal];
    [backBtn setTitle:@"学" forState:UIControlStateNormal];
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
    [_majorTypeButton addTarget:self action:@selector(experienceResponse:) forControlEvents:UIControlEventTouchUpInside];
    [_appTypeButton addTarget:self action:@selector(experienceResponse:) forControlEvents:UIControlEventTouchUpInside];
}
-(IBAction)experienceResponse:(id)sender{
    DiscoverLearnHelpSubmitViewController *viewController = [DiscoverLearnHelpSubmitViewController new];
    viewController.controllerType = discoverLearnExper;
    viewController.typeString = ([sender isEqual:_majorTypeButton])?@"01":@"02";
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
