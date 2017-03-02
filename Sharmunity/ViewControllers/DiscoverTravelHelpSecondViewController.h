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
    UIView *roundTripView;
    UIView *airportsView;
    UIView *cityView;
    UIView *priceView;
    UIView *price2View;
    UIView *price3View;
    UIView *price4View;
    UIView *changableView;
    UIView *locationView;
    UIView *buyCarView;
    UIView *dateView;
    UIView *timeView;
    UIView *keywordView;
    UIView *introductionView;
    UIDatePicker *datePicker;
    UIView *confirmBackgroundView;
    UIButton *nextButton;
    
    NSString *MEID;
    NSString *upperPriceString;
    NSString *lowerPriceString;
    NSString *dateString;
    NSString *ticketString;
    BOOL is_other;
    BOOL priceAgg;
    BOOL priceFree;
    BOOL roundTrip;
    BOOL buyCar;
    BOOL toCN;
    NSArray *airportArray;
    
    NSMutableArray *viewsArray;
}
-(void)locationCompleteResponse;
@property NSInteger controllerType;
@property NSMutableDictionary *shareDict;
@property MKMapItem *selectedItem;
@property (strong, nonatomic) CLLocationManager *locationManager;



@end
