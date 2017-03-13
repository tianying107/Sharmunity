//
//  DiscoverTravelShareSecondViewController.h
//  Sharmunity
//
//  Created by Star Chen on 2/15/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
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
@interface DiscoverTravelShareSecondViewController : UIViewController<UIScrollViewDelegate,UITextViewDelegate, CLLocationManagerDelegate>{
    UIScrollView *mainScrollView;
    UIView *hasTicketView;
    UIView *flightView;
    UIView *departAirportView;
    UIView *arriveAirportView;
    UIView *departCityView;
    UIView *arriveCityView;
    UIView *airportsView;
    UIView *cityView;
    UIView *typeView;
    UIView *personView;
    UIView *roundTripView;
    UIView *timeView;
    UIView *priceView;
    UIView *price2View;
    UIView *price3View;
    UIView *price4View;
    UIView *locationView;
    UIView *dateView;
    UIView *titleView;
    UIView *introductionView;
    UIDatePicker *datePicker;
    UIView *confirmBackgroundView;
    UIButton *nextButton;
    
    NSString *MEID;
    NSString *priceString;
    NSString *dateString;
    NSString *ticketString;
    NSString *typeString;
    BOOL is_other;
    BOOL priceAgg;
    BOOL priceFree;
    BOOL toCN;
    BOOL roundTrip;
    NSArray *airportArray;
    
    NSMutableArray *viewsArray;
}
-(void)locationCompleteResponse;
-(void)arriveCompleteResponse;
-(void)departCompleteResponse;
@property NSInteger controllerType;
@property NSMutableDictionary *shareDict;
@property MKMapItem *selectedItem;
@property MKMapItem *departItem;
@property MKMapItem *arriveItem;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end
