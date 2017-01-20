//
//  WelcomeViewController.h
//  Sharmunity
//
//  Created by st chen on 2017/1/19.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface WelcomeViewController : UIViewController<UITextFieldDelegate,CLLocationManagerDelegate>{
    UIButton *loginButton;
}
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) CLLocationManager *locationManager;
@end
