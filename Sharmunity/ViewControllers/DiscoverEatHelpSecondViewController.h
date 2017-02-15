//
//  DiscoverEatHelpSecondViewController.h
//  Sharmunity
//
//  Created by Star Chen on 2/12/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#define discoverEatRegion 101
#define discoverEatFood 102
@interface DiscoverEatHelpSecondViewController : UIViewController<UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource,UITextViewDelegate,CLLocationManagerDelegate>{
    UIScrollView *mainScrollView;
    UIView *regionView;
    UIView *subRegionView;
    UIView *foodView;
    UIView *keywordView;
    UIPickerView *regionPickerView;
    UIPickerView *subRegionPickerView;
    UIPickerView *foodPickerView;
    UIView *confirmBackgroundView;
    UIButton *nextButton;
    
    NSString *MEID;
    NSString *regionString;
    NSString *subRegionString;
    NSString *foodString;
    
    NSArray *regionArray;
    NSArray *subRegionArray;
    NSArray *foodArray;
    NSMutableArray *viewsArray;
    
    BOOL is_other;
}

@property (strong, nonatomic) CLLocationManager *locationManager;
@property NSInteger controllerType;
@property NSMutableDictionary *helpDict;


@end
