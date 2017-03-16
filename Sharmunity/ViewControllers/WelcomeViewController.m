//
//  WelcomeViewController.m
//  Sharmunity
//
//  Created by st chen on 2017/1/19.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "WelcomeViewController.h"
#import "Header.h"
#import "SYHeader.h"

@interface WelcomeViewController (){
    SYPopOut *popOut;
}

@end

@implementation WelcomeViewController
@synthesize emailTextField, passwordTextField, loginButton;
- (void)viewDidLoad {
    [super viewDidLoad];

    [loginButton addTarget:self action:@selector(logInResponse) forControlEvents:UIControlEventTouchUpInside];
    
    [_forgetPasswordButton addTarget:self action:@selector(forgetPasswordResponse) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowUp:) name:UIKeyboardWillShowNotification object:nil];
    passwordTextField.secureTextEntry = YES;
    _signUpButton.layer.cornerRadius = 5;
    _signUpButton.clipsToBounds = YES;
    _signUpButton.layer.borderColor = [SYColor5 CGColor];
    _signUpButton.layer.borderWidth = 1;
    emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"您的邮箱", nil) attributes:@{NSForegroundColorAttributeName: SYColor5}];
    passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"众享国密码", nil) attributes:@{NSForegroundColorAttributeName: SYColor5}];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    popOut = [SYPopOut new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [emailTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
//    loginButton.hidden = YES;
}
//- (void)keyboardShowUp:(NSNotification *)notification{
//    NSDictionary* keyboardInfo = [notification userInfo];
//    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
////    float height = keyboardFrameBeginRect.size.height;
//    
////    loginButton.frame = CGRectMake(loginButton.frame.origin.x, self.view.frame.size.height-30-loginButton.frame.size.height-height, loginButton.frame.size.width, loginButton.frame.size.height);
////    loginButton.hidden = NO;
//}
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
    if ([dictionary valueForKey:@"success"]) {
        BOOL success = [[dictionary valueForKey:@"success"] boolValue];
        if (success) {
            
            UIViewController *viewController;
            NSString *statusString = @"0";
            if ([dictionary valueForKey:@"status"]){
                statusString = [dictionary valueForKey:@"status"];
                if ([statusString boolValue])
                    viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MainTabBar"];
                else
                    viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"verificationWarningPage"];
            }
            else
                viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"verificationWarningPage"];
            
            [self presentViewController:viewController animated:YES completion:nil];
            
            
            NSDictionary *adminDict = [[NSDictionary alloc] initWithObjectsAndKeys:[emailTextField.text lowercaseString],@"id",[passwordTextField.text lowercaseString],@"password",statusString,@"status", nil];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:adminDict forKey:@"admin"];
            
            NSMutableArray *interestedShareArray = [NSMutableArray new];
            [userDefault setObject:interestedShareArray forKey:@"interestedShare"];
            
            [userDefault synchronize];
            
            
        }
        else if ([[dictionary valueForKey:@"message"] isEqualToString:@"You've already registered, please verify your email!"]){
            UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"verificationWarningPage"];
            [self presentViewController:viewController animated:YES completion:nil];
        }
        else
            [popOut showUpPop:SYPopLogInFail];
    }
    else{
        [popOut showUpPop:SYPopLogInNetwork];
    }
    
}

-(void)forgetPasswordResponse{
    NSString *requestBody = [NSString stringWithFormat:@"email=%@",emailTextField.text];
    NSLog(@"%@/n",requestBody);
    
    /*改上面的 query 和 URLstring 就好了*/
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@resetpwd",basicURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [requestBody dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request];
    [task resume];
//    [self testget];
}
-(void)testget{
    NSString *requestQuery = [NSString stringWithFormat:@"email=%@",emailTextField.text];
    NSString *urlString = [NSString stringWithFormat:@"%@reqprofile?%@",basicURL,requestQuery];
    NSLog(@"%@",requestQuery);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionTask *task = [session dataTaskWithURL:url
                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                                             options:kNilOptions
                                                                                               error:&error];
                                        NSLog(@"server said: %@",dict);
//                                        dispatch_async(dispatch_get_main_queue(), ^{
//                                            [self handleSubmit:dict];
//                                        });
                                        
                                    }];
    [task resume];
}
@end
