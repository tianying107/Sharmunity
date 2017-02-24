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
    UIView *locationInView;
    UIView *locationOutView;
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

-(void)locationInCompleteResponse;
-(void)locationOutCompleteResponse;

@property BOOL dateAvailable;
@property BOOL distanceAvailable;
@property NSMutableDictionary *helpDict;
@property NSString *subcate;
@property MKMapItem *selectedInItem;
@property MKMapItem *selectedOutItem;

@end
