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
@synthesize emailTextField,nameTextField,passwordTextField,passwordConfirmTextField;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewsSetup];
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
    [_signUpButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    _signUpButton.layer.cornerRadius = 5;
    _signUpButton.clipsToBounds = YES;
    emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"您的邮箱", nil) attributes:@{NSForegroundColorAttributeName: SYColor5}];
    nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"昵称", nil) attributes:@{NSForegroundColorAttributeName: SYColor5}];
    passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"密码（请输入6-16数字或字母）", nil) attributes:@{NSForegroundColorAttributeName: SYColor5}];
    passwordConfirmTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"确认密码", nil) attributes:@{NSForegroundColorAttributeName: SYColor5}];
    
}

- (void)submit{
    /*insert password check and empty check here*/
    NSString *passwordString = passwordTextField.text;
    NSString *emailString = emailTextField.text;
    NSString *nameString = nameTextField.text;
    NSString *requestBody = [NSString stringWithFormat:@"email=%@&password=%@&name=%@",emailString,passwordString,nameString];
    
    if([nameString isEqualToString:@""]){
        SYPopOut *namePopout = [SYPopOut new];
        [namePopout showUpPop:SYPopSignUpDuplicate];
    }
    /*改上面的 query 和 URLstring 就好了*/
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@signup",basicURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [requestBody dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                            NSLog(@"server said: %@",string);
                                            
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
    if ([[dict valueForKey:@"success"] boolValue]) {
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
        SYPopOut *namePopout = [SYPopOut new];
        [namePopout showUpPop:SYPopSignUpDuplicate];
    }
}
- (void) jump{
    /*jump to verificationWarningPage*/
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"verificationWarningPage"];
    [self presentViewController:viewController animated:YES completion:nil];
}


@end
