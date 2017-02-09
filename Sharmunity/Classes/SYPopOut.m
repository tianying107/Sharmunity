//
//  SYPopOut.m
//  Sharmunity
//
//  Created by Star Chen on 2/4/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import "SYPopOut.h"

@implementation SYPopOut
@synthesize baseView, firstButton, secondButton;
-(id)init{
    self = [super init];
    if (self) {
        [self baseSetup];
    }
    return self;
}
-(void)baseSetup{
    baseView = [[SYSuscard alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen]bounds].size.height) withCardSize:CGSizeMake(320, 200) keyboard:NO];
    baseView.cardBackgroundView.backgroundColor = SYBackgroundColorExtraLight;
    baseView.scrollView.scrollEnabled = NO;
    baseView.cancelButton.hidden = YES;
    baseView.backButton.hidden = YES;
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, baseView.cardSize.height-60, baseView.cardSize.width, SYSeparatorHeight)];
    separator.backgroundColor = SYSeparatorColor;
    [baseView addGoSubview:separator];
    
    firstButton = [UIButton new];
    [firstButton setTitleColor:SYColor1 forState:UIControlStateNormal];
    [firstButton.titleLabel setFont:SYFont15S];
    [firstButton addTarget:baseView action:@selector(cancelResponse) forControlEvents:UIControlEventTouchUpInside];
    [baseView addGoSubview:firstButton];
    firstButton.hidden = YES;
    firstButton.frame = CGRectMake(0, baseView.cardSize.height-60, baseView.cardSize.width, 60);
    
    secondButton = [UIButton new];
    [secondButton addTarget:baseView action:@selector(cancelResponse) forControlEvents:UIControlEventTouchUpInside];
    [baseView addGoSubview:secondButton];
    secondButton.hidden = YES;
    
    contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, baseView.cardSize.width-40, baseView.cardSize.height-60)];
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = SYColor1;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    [contentLabel setFont:SYFont15];
    [baseView addGoSubview:contentLabel];
}
-(void)showUpPop:(NSInteger)type{
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:baseView];
    baseView.alpha = 0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.258];
    baseView.alpha = 1;
    [UIView commitAnimations];

    switch (type) {
        case SYPopLogInFail:
            contentLabel.text = @"非常抱歉，您输入的密码或手机号有误，请检查后再试一次。";
            [firstButton setTitle:@"确定" forState:UIControlStateNormal];
            firstButton.hidden = NO;
            break;
        case SYPopLogInNetwork:
            contentLabel.text = @"请检查网络连接然后重试。";
            [firstButton setTitle:@"确定" forState:UIControlStateNormal];
            firstButton.hidden = NO;
            break;
        case SYPopDiscoverShareSuccess:
            contentLabel.text = @"帮助信息发布成功。";
            [firstButton setTitle:@"确定" forState:UIControlStateNormal];
            firstButton.hidden = NO;
            break;
        case SYPopDiscoverShareFail:
            contentLabel.text = @"帮助信息发布错误，请检查后重新发布。";
            [firstButton setTitle:@"确定" forState:UIControlStateNormal];
            firstButton.hidden = NO;
            break;
            
        default:
            break;
    }
}
@end
