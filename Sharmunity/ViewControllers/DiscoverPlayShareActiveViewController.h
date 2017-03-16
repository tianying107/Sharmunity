//
//  DiscoverPlayShareActiveViewController.h
//  Sharmunity
//
//  Created by st chen on 2017/2/14.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#define DiscoverPlayPartner 101
#define DiscoverPlayActivity 102
#define DiscoverPlayOther 199
@interface DiscoverPlayShareActiveViewController : UIViewController<UIScrollViewDelegate,UITextViewDelegate, CLLocationManagerDelegate,UIPickerViewDelegate, UIPickerViewDataSource>{
    UIScrollView *mainScrollView;
    UIView *typeView;
    UIView *priceView;
    UIView *locationView;
    UIView *dateView;
    UIView *titleView;
    UIView *introductionView;
    UIPickerView *typePickerView;
    UIDatePicker *datePicker;
    UIView *confirmBackgroundView;
    UIButton *nextButton;
    
    NSString *MEID;
    NSString *priceString;
    NSString *typeString;
    NSString *dateString;
    NSString *endString;
    NSString *numberString;
    BOOL is_other;
    BOOL timeAgg;
    BOOL numberAgg;
    id currentDateButton;
    NSArray *typeArray;
    
    NSMutableArray *viewsArray;
}
-(void)locationCompleteResponse;
@property NSInteger controllerType;
@property NSMutableDictionary *shareDict;
@property NSInteger subcate1;
@property MKMapItem *selectedItem;
@property (strong, nonatomic) CLLocationManager *locationManager;
@end
