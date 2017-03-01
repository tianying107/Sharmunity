//
//  DiscoverEatArticalShareViewController.h
//  Sharmunity
//
//  Created by st chen on 2017/2/28.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface DiscoverEatArticalShareViewController : UIViewController<UIScrollViewDelegate,UITextViewDelegate,CLLocationManagerDelegate>{
    UIScrollView *mainScrollView;
    UIView *titleView;
    UIView *introductionView;
    UIButton *nextButton;
    
    NSString *MEID;
    
    NSMutableArray *viewsArray;
}
@property (strong, nonatomic) CLLocationManager *locationManager;
@end
