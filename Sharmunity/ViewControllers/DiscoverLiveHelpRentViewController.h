//
//  DiscoverLiveHelpRentViewController.h
//  Sharmunity
//
//  Created by st chen on 2017/2/9.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface DiscoverLiveHelpRentViewController : UIViewController<UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>{
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
    UIButton *nextButton;
    
    NSString *MEID;
    NSString *shareRentString;
    NSString *houseString;
    NSString *typeString;
    NSString *shortString;
    NSString *dateString;
    NSString *upperPriceString;
    NSString *lowerPriceString;
    
    NSInteger shortNumber;
    
    NSArray *roomTypeArray;
    NSArray *shortArray;
    NSInteger short1;
    NSInteger short2;
    NSMutableArray *viewsArray;
}
-(void)locationCompleteResponse;
@property NSMutableDictionary *helpDict;
@property BOOL shortRent;
@property BOOL distanceAvailable;
@property MKMapItem *selectedItem;
@property NSString *distanceString;
@end
