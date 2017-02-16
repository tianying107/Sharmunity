//
//  ChoiceDetailViewController.h
//  Sharmunity
//
//  Created by st chen on 2017/2/15.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoiceDetailViewController : UIViewController<UIScrollViewDelegate>{
    UIScrollView *mainScrollView;
    
}

@property NSString *userID;
@end
