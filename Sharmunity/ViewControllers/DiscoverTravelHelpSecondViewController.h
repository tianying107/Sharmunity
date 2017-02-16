//
//  DiscoverTravelHelpSecondViewController.h
//  Sharmunity
//
//  Created by st chen on 2017/2/15.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#define DiscoverTravelPartner 101
#define DiscoverTravelDrive 102
#define DiscoverTravelCarpool 103
#define DiscoverTravelPickup 104
#define DiscoverTravelBuyCar 105
#define DiscoverTravelRepair 106
#define DiscoverTravelDeliver 107
#define DiscoverTravelOther 199
@interface DiscoverTravelHelpSecondViewController : UIViewController<UIScrollViewDelegate,UITextViewDelegate, CLLocationManagerDelegate>{
    UIScrollView *mainScrollView;
    UIView *hasTicketView;
    UIView *flightView;
    UIView *departAirportView;
    UIView *arriveAirportView;
    UIView *departCityView;
    UIView *arriveCityView;
    UIView *airportsView;
    UIView *cityView;
    UIView *priceView;
    UIView *locationView;
    UIView *dateView;
    UIView *keywordView;
    UIDatePicker *datePicker;
    UIView *confirmBackgroundView;
    UIButton *nextButton;
    
    NSString *MEID;
    NSString *upperPriceString;
    NSString *lowerPriceString;
    NSString *dateString;
    NSString *ticketString;
    BOOL is_other;
    NSArray *airportArray;
    
    NSMutableArray *viewsArray;
}
-(void)locationCompleteResponse;
@property NSInteger controllerType;
@property NSMutableDictionary *shareDict;
@property MKMapItem *selectedItem;
@property (strong, nonatomic) CLLocationManager *locationManager;



@end
