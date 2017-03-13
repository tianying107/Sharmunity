//
//  DiscoverTradeSortViewController.h
//  Sharmunity
//
//  Created by Star Chen on 3/12/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface DiscoverTradeSortViewController : UIViewController<UIScrollViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,CLLocationManagerDelegate>{
    UIScrollView *mainScrollView;
    UIView *typeView;
    UIPickerView *typePickerView;
    UIPickerView *expirePickerView;
    UIView *priceView;
    UIView *locationView;
    UIView *expireView;
    UIView *confirmBackgroundView;
    UIButton *nextButton;
    
    NSString *typeString;
    NSString *expireString;
    NSArray *typeArray;
    NSArray *expireArray;
    BOOL is_other;
    NSString *MEID;
    
    NSMutableArray *viewsArray;
}
-(void)locationCompleteResponse;
@property MKMapItem *selectedItem;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property NSString *distanceString;
@property id previousController;
@end
