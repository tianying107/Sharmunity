//
//  SYSignUpPassword.m
//  Sharmunity
//
//  Created by st chen on 2017/1/20.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "SYSignUpPassword.h"

@implementation SYSignUpPassword

@synthesize textField1,textField2;
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
    
    label1 = [[UILabel alloc] initWithFrame:CGRectMake(originX, heightCount, weight, 20)];
    heightCount += label1.frame.size.height+10;
    [self addSubview:label1];
    textField1 = [[UITextField alloc] initWithFrame:CGRectMake(originX, heightCount, weight, 40)];
    heightCount += textField1.frame.size.height;
    
    textField1.secureTextEntry = YES;
    [self addSubview:textField1];
    separator1 = [[UIView alloc] initWithFrame:CGRectMake(originX, heightCount, self.frame.size.width-2*originX, SYSeparatorHeight)];
    heightCount += separator1.frame.size.height+10;
    [self addSubview:separator1];
    label2 = [[UILabel alloc] initWithFrame:CGRectMake(originX, heightCount, weight, 20)];
    heightCount += label2.frame.size.height+10;
    [self addSubview:label2];
    textField2 = [[UITextField alloc] initWithFrame:CGRectMake(originX, heightCount, weight, 40)];
    heightCount += textField2.frame.size.height;
    
    textField2.secureTextEntry = YES;
    [self addSubview:textField2];
    separator2 = [[UIView alloc] initWithFrame:CGRectMake(originX, heightCount, self.frame.size.width-2*originX, SYSeparatorHeight)];
    [self addSubview:separator2];
}
- (void)contentWithPassword:(NSString*)password{
    UIColor *textColor = [UIColor new];
    UIFont *texttFont = [UIFont new];
    UIFont *tittletFont = SYFont15B;

    texttFont = SYFont15;
    textColor = SYColor1;
    label1.text = @"设置密码";
    label2.text = @"确认密码";
    separator1.backgroundColor = SYSeparatorColor;
    separator2.backgroundColor = SYSeparatorColor;
    
    label1.textColor = textColor;
    [label1 setFont:tittletFont];
    textField1.text = password;
    textField1.textColor = textColor;
    [textField1 setFont:texttFont];
    
    label2.textColor = textColor;
    [label2 setFont:tittletFont];
    textField2.text = password;
    textField2.textColor = textColor;
    [textField2 setFont:texttFont];
    
    
    UILabel *reminderLabel = [[UILabel alloc] initWithFrame:CGRectMake(separator2.frame.origin.x, separator2.frame.origin.y+10, separator2.frame.size.width, 80)];
    reminderLabel.numberOfLines = 0;
    [self addSubview:reminderLabel];
    
    reminderLabel.textColor = SYColor5;
    reminderLabel.text = @"6-15位数字、字母（区分大小写）、符号的组合（空格除外）， 避免使用有规律的纯数字或字母，以提升密码的安全等级，如 83$a56Dfc2%9";
    [reminderLabel setFont:SYFont13];

    //    NSDictionary *attributes = @{NSFontAttributeName: texttFont};
    //    CGSize stringsize = [verifyButton.titleLabel.text sizeWithAttributes:attributes];
    //    verifyButton.frame = CGRectMake(self.frame.size.width-30-stringsize.width-20, codeTextField.frame.origin.y+5, stringsize.width+20, 30);
    //    [verifyButton setTitleColor:textColor forState:UIControlStateNormal];
    //    [verifyButton.titleLabel setFont:texttFont];
    //    verifyButton.layer.cornerRadius = verifyButton.frame.size.height/2;
    //    verifyButton.clipsToBounds = YES;
    //    verifyButton.layer.borderColor = [textColor CGColor];
    //    verifyButton.layer.borderWidth = 1;
    //    [self addSubview:verifyButton];
}
- (void)complete{
    [textField1 resignFirstResponder];
    [textField2 resignFirstResponder];
}


@end
