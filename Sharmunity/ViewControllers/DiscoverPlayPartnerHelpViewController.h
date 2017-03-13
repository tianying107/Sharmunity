//
//  DiscoverPlayPartnerHelpViewController.h
//  Sharmunity
//
//  Created by Star Chen on 3/10/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface DiscoverPlayPartnerHelpViewController : UIViewController<UIScrollViewDelegate, CLLocationManagerDelegate>{
    UIScrollView *mainScrollView;
    UIView *typeView;
//    UIView *priceView;
//    UIView *locationView;
    UIView *keywordView;
    UIView *introductionView;
//    UIPickerView *typePickerView;
//    UIView *confirmBackgroundView;
    UIView *subcateView;
    UIButton *nextButton;
    
    NSString *MEID;
//    NSString *upperPriceString;
//    NSString *lowerPriceString;
    NSString *typeString;
    BOOL is_other;
    NSArray *typeArray;
    NSInteger subcate1;
    
    NSMutableArray *viewsArray;
    
    NSInteger keywordCount;
}
//-(void)locationCompleteResponse;
@property MKMapItem *selectedItem;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property NSString *distanceString;


@end
