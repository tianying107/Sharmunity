//
//  SYSignUpPassword.h
//  Sharmunity
//
//  Created by st chen on 2017/1/20.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
@interface SYSignUpPassword : UIView<UITextFieldDelegate>{
    UILabel *label1;
    UILabel *label2;
    UIImageView *logoImageView;
    UIView *separator1;
    UIView *separator2;
    UIButton *showButton;
}

- (void)contentWithPassword:(NSString*)password;
- (void)complete;
@property UITextField *textField1;
@property UITextField *textField2;

@end
