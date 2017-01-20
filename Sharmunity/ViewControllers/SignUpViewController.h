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

@end
