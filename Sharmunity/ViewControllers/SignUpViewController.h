//
//  SignUpViewController.h
//  Sharmunity
//
//  Created by st chen on 2017/1/19.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYSignUpHeader.h"
#import "Header.h"
#import "SYHeader.h"
@interface SignUpViewController : UIViewController{
    SYSuscard *currentSuscard;
    id firstView;
    NSMutableArray *viewArray;
    NSMutableArray *cardArray;
    NSMutableDictionary *infoSummary;
}
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordConfirmTextField;

@property (strong, nonatomic) IBOutlet UIButton *signUpButton;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;


@end
