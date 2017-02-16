//
//  DiscoverPlayHelpActiveViewController.h
//  Sharmunity
//
//  Created by st chen on 2017/2/15.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#define DiscoverPlayPartner 101
#define DiscoverPlayActivity 102
#define DiscoverPlayOther 199
@interface DiscoverPlayHelpActiveViewController : UIViewController<UIScrollViewDelegate,UITextViewDelegate, CLLocationManagerDelegate,UIPickerViewDelegate, UIPickerViewDataSource>{
    UIScrollView *mainScrollView;
    UIView *typeView;
    UIView *priceView;
    UIView *locationView;
    UIView *keywordView;
    UIPickerView *typePickerView;
    UIView *confirmBackgroundView;
    UIButton *nextButton;
    
    NSString *MEID;
    NSString *upperPriceString;
    NSString *lowerPriceString;
    NSString *typeString;
    BOOL is_other;
    NSArray *typeArray;
    
    NSMutableArray *viewsArray;
}
-(void)locationCompleteResponse;
@property NSInteger controllerType;
@property NSMutableDictionary *shareDict;
@property MKMapItem *selectedItem;
@property (strong, nonatomic) CLLocationManager *locationManager;


@end
