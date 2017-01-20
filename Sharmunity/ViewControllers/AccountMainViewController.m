//
//  AccountMainViewController.m
//  Sharmunity
//
//  Created by st chen on 2017/1/20.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "AccountMainViewController.h"

@interface AccountMainViewController ()

@end

@implementation AccountMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_logoutButton addTarget:self action:@selector(logOutResponse) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)logOutResponse{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"admin"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"appliedOrder"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *docPath = [NSString new];
    docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSError *error;
    if ([fileManager fileExistsAtPath:docPath])
    {
        [fileManager removeItemAtPath:docPath error:&error];
    }
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"myHeadAvatar.jpg"];
    if ([fileManager fileExistsAtPath:path])
    {
        [fileManager removeItemAtPath:path error:&error];
    }
    path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"myBackground.jpg"];
    if ([fileManager fileExistsAtPath:path])
    {
        [fileManager removeItemAtPath:path error:&error];
    }
    
    
    UIViewController *viewController = (UIViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"WelcomeNavigator"];
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
