//
//  AccountMainViewController.h
//  Sharmunity
//
//  Created by st chen on 2017/1/20.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountMainViewController : UIViewController<UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    NSString *MEID;
    
    UIImagePickerController *avaterPicker;
}
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@end
