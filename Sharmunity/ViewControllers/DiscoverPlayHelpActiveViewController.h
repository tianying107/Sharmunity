//
//  DiscoverPlayHelpActiveViewController.h
//  Sharmunity
//
//  Created by st chen on 2017/2/15.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
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
    NSInteger subcate1;
    
    NSMutableArray *viewsArray;
    
    UIView *subcate1View;
    UIView *subcate2View;
    UIView *subcate3View;
    UIView *subcate4View;
    UIView *subcate5View;
}
-(void)locationCompleteResponse;
@property MKMapItem *selectedItem;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property NSString *distanceString;



@property (weak, nonatomic) IBOutlet UIButton *otherButton;
@property (weak, nonatomic) IBOutlet UIStackView *otherGroup;

@end
