//
//  DiscoverLiveShareLeaseViewController.h
//  Sharmunity
//
//  Created by st chen on 2017/2/9.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface DiscoverLiveShareLeaseViewController : UIViewController<UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>{
    UIScrollView *mainScrollView;
    UIView *shareRentView;
    UIView *genderView;
    UIView *houseView;
    UIView *typeView;
    UIPickerView *typePickerView;
    UIView *confirmBackgroundView;
    UIView *locationView;
    UIView *dateView;
    UIView *shortView;
    UIView *priceView;
    UIView *distanceView;
    UIDatePicker *datePicker;
    UIPickerView *shortPickerView;
    UIView *titleView;
    UIView *introductionView;
    UIButton *nextButton;
    
    NSString *MEID;
    NSString *shareRentString;
    NSString *houseString;
    NSString *typeString;
    NSString *dateString;
    NSString *shortString;
    NSString *priceString;
    NSString *distanceString;
    NSInteger shortNumber;
    NSInteger short1;
    NSInteger short2;
    
    NSArray *roomTypeArray;
    NSArray *shortArray;
    NSMutableArray *viewsArray;
}
-(void)locationCompleteResponse;

@property NSMutableDictionary *shareDict;
@property BOOL shortRent;
@property BOOL distanceAvailable;
@property MKMapItem *selectedItem;


@property BOOL setupWithHelp;
@property NSDictionary *helpDict;
@end
