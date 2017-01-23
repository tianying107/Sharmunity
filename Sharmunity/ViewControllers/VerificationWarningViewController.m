//
//  VerificationWarningViewController.m
//  Sharmunity
//
//  Created by st chen on 2017/1/20.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "VerificationWarningViewController.h"

@interface VerificationWarningViewController ()

@end

@implementation VerificationWarningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_verifyDoneButton addTarget:self action:@selector(checkVerifyStatus) forControlEvents:UIControlEventTouchUpInside];
    [_resendButton addTarget:self action:@selector(resentEmail) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)jump{
    UITabBarController *viewController = (UITabBarController *)[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MainTabBar"];
    [self presentViewController:viewController animated:YES completion:nil];
}
-(void)checkVerifyStatus{
    NSString *emailAddress = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
    if (emailAddress) {
        NSString *requestQuery = [NSString stringWithFormat:@"email=%@",emailAddress];
        NSString *urlString = [NSString stringWithFormat:@"%@checkstatus?%@",basicURL,requestQuery];
        NSLog(@"%@",requestQuery);
        NSURLSession *session = [NSURLSession sharedSession];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLSessionTask *task = [session dataTaskWithURL:url
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                                                 options:kNilOptions
                                                                                                   error:&error];
                                            NSLog(@"server said: %@",dict);
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [self handleSubmit:dict];
                                            });

                                        }];
        [task resume];
    }
}
-(void)resentEmail{
    NSString *emailAddress = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
    if (emailAddress) {
        NSString *requestBody = [NSString stringWithFormat:@"email=%@",emailAddress];
        /*改上面的 query 和 URLstring 就好了*/
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@resend",basicURL]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        request.HTTPMethod = @"POST";
        request.HTTPBody = [requestBody dataUsingEncoding:NSUTF8StringEncoding];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionTask *task = [session dataTaskWithRequest:request];
        [task resume];
    }
}
- (void)handleSubmit:(NSDictionary*)dict{
    if ([[dict valueForKey:@"status"] boolValue]) {
        [self jump];
    }
    else{
        NSLog(@"Please verify your email.");
    }
}

@end
