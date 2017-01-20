//
//  WelcomeViewController.m
//  Sharmunity
//
//  Created by st chen on 2017/1/19.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "WelcomeViewController.h"
#import "Header.h"
@interface WelcomeViewController ()

@end

@implementation WelcomeViewController
@synthesize emailTextField, passwordTextField;
- (void)viewDidLoad {
    [super viewDidLoad];
    loginButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-30-48, self.view.frame.size.height-48-30-216, 48, 48)];
    loginButton.hidden = YES;
    [loginButton setImage:[UIImage imageNamed:@"confirmCircle"] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(logInResponse) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowUp:) name:UIKeyboardWillShowNotification object:nil];
    passwordTextField.secureTextEntry = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [emailTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    loginButton.hidden = YES;
}
- (void)keyboardShowUp:(NSNotification *)notification{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    float height = keyboardFrameBeginRect.size.height;
    
    loginButton.frame = CGRectMake(loginButton.frame.origin.x, self.view.frame.size.height-30-loginButton.frame.size.height-height, loginButton.frame.size.width, loginButton.frame.size.height);
    loginButton.hidden = NO;
}
- (void)logInResponse{
    NSString *requestBody = [NSString stringWithFormat:@"email=%@&password=%@",emailTextField.text, passwordTextField.text];
    NSLog(@"%@/n",requestBody);
    
    /*改上面的 query 和 URLstring 就好了*/
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@login",basicURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [requestBody dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                            NSLog(@"server said: %@",string);
                                            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                                                options:kNilOptions
                                                                                                  error:&error];
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [self handleSubmit:dic];
                                            });
                                        }];
    [task resume];
}

- (void)handleSubmit:(NSDictionary*)dictionary{
    BOOL success = [[dictionary valueForKey:@"success"] boolValue];
    if (success) {
        UITabBarController *viewController = (UITabBarController *)[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MainTabBar"];
        [self presentViewController:viewController animated:YES completion:nil];
        NSString *statusString = @"0";
        if ([dictionary valueForKey:@"status"]) {
            statusString = [dictionary valueForKey:@"status"];
        }
        NSDictionary *adminDict = [[NSDictionary alloc] initWithObjectsAndKeys:[emailTextField.text lowercaseString],@"id",[passwordTextField.text valueForKey:@"password"],@"password",statusString,@"status", nil];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:adminDict forKey:@"admin"];
        [userDefault synchronize];
        
    }
    else if ([[dictionary valueForKey:@"message"] isEqualToString:@"You've already registered, please verify your email!"]){
        UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"verificationWarningPage"];
        [self presentViewController:viewController animated:YES completion:nil];
    }
    else
        NSLog(@"wrong!");
}


@end
