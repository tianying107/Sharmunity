//
//  SYSignUpEmail.m
//  Sharmunity
//
//  Created by st chen on 2017/1/19.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "SYSignUpEmail.h"

@implementation SYSignUpEmail
@synthesize emailTextField;
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self basicSetup];
    }
    return self;
}
- (void)basicSetup{
    
    logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.center.x-16, 33, 32, 32)];
    logoImageView.image = [UIImage imageNamed:@"logoSmallColor5"];
    [self addSubview:logoImageView];
    
    float originX = 30, heightCount = 120, weight = self.frame.size.width-2*originX;
    
    emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, heightCount, weight, 20)];
    heightCount += emailLabel.frame.size.height+10;
    [self addSubview:emailLabel];
    emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(originX, heightCount, weight, 40)];
    heightCount += emailTextField.frame.size.height;
    emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    [self addSubview:emailTextField];
    separator1 = [[UIView alloc] initWithFrame:CGRectMake(originX, heightCount, self.frame.size.width-2*originX, SYSeparatorHeight)];
    heightCount += separator1.frame.size.height+10;
    [self addSubview:separator1];
    
}

- (void)contentWithEmail:(NSString*)email code:(NSString*)code english:(BOOL)english{
    UIColor *textColor = [UIColor new];
    UIFont *texttFont = [UIFont new];
    UIFont *tittletFont = SYFont15B;
    if (english) {
        texttFont = SYFont15B;
        textColor = [UIColor whiteColor];
        emailLabel.text = @"What is your E-mail?";
        logoImageView.image = [UIImage imageNamed:@"logo"];
        separator1.backgroundColor = SYSeparatorColor;
        emailTextField.tintColor = [UIColor whiteColor];
        UILabel *explanationLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, separator1.frame.origin.y+15, separator1.frame.size.width, 60)];
        explanationLabel.text = @"We use your email to send you job\nconfirmations and receipts.";
        explanationLabel.textAlignment = NSTextAlignmentCenter;
        explanationLabel.textColor = [UIColor whiteColor];
        [explanationLabel setFont:SYFont13];
        explanationLabel.numberOfLines = 0;
        [self addSubview:explanationLabel];
    }
    else{
        texttFont = SYFont15;
        textColor = SYColor1;
        emailLabel.text = @"What is your E-mail?";
        separator1.backgroundColor = SYSeparatorColor;
    }
    emailLabel.textColor = textColor;
    [emailLabel setFont:tittletFont];
    emailTextField.text = email;
    emailTextField.textColor = textColor;
    [emailTextField setFont:texttFont];
    
}
- (void)complete{
    [emailTextField resignFirstResponder];
}


@end
