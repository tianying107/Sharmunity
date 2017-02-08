//
//  SYPopOut.h
//  Sharmunity
//
//  Created by Star Chen on 2/4/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Header.h"
#import "SYHeader.h"
/*log in and sign up */
#define SYPopLogInFail 101
#define SYPopLogInNetwork 102
#define SYPopSignUpDuplicate 111
#define SYPopSignUpVerify 112

@interface SYPopOut : NSObject{
    UILabel *contentLabel;
}
-(void)showUpPop:(NSInteger)type;
@property SYSuscard *baseView;

@property UIButton *firstButton;
@property UIButton *secondButton;
@property UIButton *learnMoreButton;
@end
