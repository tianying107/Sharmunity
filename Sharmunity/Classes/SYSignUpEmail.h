//
//  SYSignUpEmail.h
//  Sharmunity
//
//  Created by st chen on 2017/1/19.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
@class SYSignUpEmail;
@interface SYSignUpEmail : UIView<UITextFieldDelegate>{
    UILabel *emailLabel;
    UIImageView *logoImageView;
    UIView *separator1;
}
- (void)contentWithEmail:(NSString*)email code:(NSString*)code english:(BOOL)english;
- (void)complete;
@property UITextField *emailTextField;

@end
