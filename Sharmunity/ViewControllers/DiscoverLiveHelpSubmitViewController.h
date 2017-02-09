//
//  DiscoverLiveHelpSubmitViewController.h
//  Sharmunity
//
//  Created by st chen on 2017/2/9.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface DiscoverLiveHelpSubmitViewController : UIViewController<UIScrollViewDelegate>{
    UIScrollView *mainScrollView;
    UIView *locationView;
    UIView *dateView;
    UIView *priceView;
    UIView *distanceView;
    UIDatePicker *datePicker;
    UIView *confirmBackgroundView;
    UIView *introductionView;
    UIButton *nextButton;
    
    NSString *MEID;
    NSString *dateString;
    NSString *upperPriceString;
    NSString *lowerPriceString;
    NSString *distanceString;
    
    NSMutableArray *viewsArray;
}
@property BOOL dateAvailable;
@property BOOL distanceAvailable;
@property NSMutableDictionary *helpDict;
@property MKMapItem *selectedItem;

@end