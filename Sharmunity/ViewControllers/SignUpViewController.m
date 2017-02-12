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
    
    infoSummary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"", @"email", nil];
    viewArray = [NSMutableArray new];
    cardArray = [NSMutableArray new];
    SYSuscard *baseView = [[SYSuscard alloc] initWithFullSize];
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:baseView];
    baseView.backButton.hidden = NO;
    baseView.cardBackgroundView.backgroundColor = SYBackgroundColorExtraLight;
    currentSuscard = baseView;
    [cardArray addObject:baseView];
    
    [baseView.backButton setImage:[UIImage imageNamed:@"goBackShort"] forState:UIControlStateNormal];
    [baseView.backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [baseView.backButton addTarget:self action:@selector(goBackResponse) forControlEvents:UIControlEventTouchUpInside];
    baseView.cancelButton.hidden = YES;
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.bounds = CGRectMake(0, 0, 100, 36);
    [confirmButton setTitle:@"Next" forState:UIControlStateNormal];
    [confirmButton setTitleColor:SYColor1 forState:UIControlStateNormal];
    [confirmButton.titleLabel setFont:SYFont15];
    [confirmButton addTarget:self action:@selector(phoneConfirm) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.frame = baseView.rightButtonFrame;
    [baseView addSubview:confirmButton];
    
    SYSignUpEmail *firstPage = [[SYSignUpEmail alloc] initWithFrame:self.view.frame];
    [firstPage contentWithEmail:[infoSummary valueForKey:@"email"] code:[infoSummary valueForKey:@"code"] english:NO];
    [viewArray addObject:firstPage];
    [baseView addGoSubview:firstPage];
    
}
- (void)goBack{
    [viewArray removeLastObject];
}
- (void)goBackResponse{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)phoneConfirm{
    [(SYSignUpEmail*)[viewArray lastObject] complete];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:((SYSignUpEmail*)[viewArray lastObject]).emailTextField.text, @"email", nil];
    [infoSummary addEntriesFromDictionary:dict];
    /****BASE VIEW****/
    SYSuscard *baseView = [[SYSuscard alloc] initWithFullSize];
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:baseView];
    baseView.backButton.hidden = NO;
    baseView.cardBackgroundView.backgroundColor = SYBackgroundColorExtraLight;
    currentSuscard = baseView;
    [cardArray addObject:baseView];
    
    [baseView.backButton setImage:[UIImage imageNamed:@"goBackShort"] forState:UIControlStateNormal];
    [baseView.backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    baseView.cancelButton.hidden = YES;
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.bounds = CGRectMake(0, 0, 100, 36);
    [confirmButton setTitle:@"Next" forState:UIControlStateNormal];
    [confirmButton setTitleColor:SYColor1 forState:UIControlStateNormal];
    [confirmButton.titleLabel setFont:SYFont15];
    [confirmButton addTarget:self action:@selector(passwordConfirm) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.frame = baseView.rightButtonFrame;
    [baseView addSubview:confirmButton];
    
    baseView.alpha = 0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.258];
    baseView.alpha = 1;
    [UIView commitAnimations];
    /****NEXT VIEW****/
    SYSignUpPassword *passwordView = [[SYSignUpPassword alloc] initWithFrame:CGRectMake(0, 0, baseView.cardSize.width, baseView.cardSize.height)];
    [passwordView contentWithPassword:[infoSummary valueForKey:@"password"]];
    [viewArray addObject:passwordView];
    [baseView addGoSubview:[viewArray lastObject]];
}
- (void)passwordConfirm{
    if ([((SYSignUpPassword*)[viewArray lastObject]).textField1.text isEqualToString:((SYSignUpPassword*)[viewArray lastObject]).textField2.text]) {
        
        [(SYSignUpPassword*)[viewArray lastObject] complete];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:((SYSignUpPassword*)[viewArray lastObject]).textField1.text, @"password", nil];
        [infoSummary addEntriesFromDictionary:dict];
        [self submit];
    }
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
