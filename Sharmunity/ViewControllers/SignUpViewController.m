//
//  SignUpViewController.m
//  Sharmunity
//
//  Created by st chen on 2017/1/19.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
- (void)goBackResponse{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewsSetup{
    /*define targets here*/
    
}
- (void)submit{
    /*insert password check and empty check here*/
    NSString *passwordString;
    NSString *emailString;
    NSString *nameString;
    NSString *requestBody = [NSString stringWithFormat:@"email=%@&password=%@&name=%@",emailString,passwordString,nameString];
    
    
    /*改上面的 query 和 URLstring 就好了*/
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@signup",basicURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [requestBody dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request
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
- (void)handleSubmit:(NSDictionary*)dict{
    if ([[dict valueForKey:@"msg"] isEqualToString:@"An email has been sent to you. Please check it to verify your account."]) {
        for (SYSuscard *baseView in cardArray){
            [baseView removeFromSuperview];
        }
        NSDictionary *adminDict = [[NSDictionary alloc] initWithObjectsAndKeys:[[infoSummary valueForKey:@"email"] lowercaseString],@"id",[infoSummary valueForKey:@"password"],@"password",@"0",@"status", nil];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:adminDict forKey:@"admin"];
        [userDefault synchronize];
        [NSTimer scheduledTimerWithTimeInterval:.06 target:self selector:@selector(jump) userInfo:NULL repeats:NO];
    }
    else if([[dict valueForKey:@"msg"] isEqualToString:@"You have already signed up. Please check your email to verify your account."]){
        NSLog(@"duplicate, not verified yet.");
    }
}
- (void) jump{
    /*jump to verificationWarningPage*/
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"verificationWarningPage"];
    [self presentViewController:viewController animated:YES completion:nil];
}


@end
