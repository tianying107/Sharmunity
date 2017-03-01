//
//  DiscoverLearnHelpSubmitViewController.h
//  Sharmunity
//
//  Created by st chen on 2017/2/13.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#define discoverLearnExper 301
#define discoverLearnTutor 302
#define discoverLearnInterest 303
@interface DiscoverLearnHelpSubmitViewController : UIViewController<UIScrollViewDelegate,UITextViewDelegate, CLLocationManagerDelegate>{
    UIScrollView *mainScrollView;
    UIView *schoolContentView;
    UIView *interestView;
    UIView *majorView;
    UIView *numberView;
    UIView *priceView;
    UIView *locationView;
    UIView *keywordView;
    UIButton *nextButton;
    
    
    NSString *MEID;
    NSString *upperPriceString;
    NSString *lowerPriceString;
    
    NSMutableArray *viewsArray;
}
-(void)locationCompleteResponse;
@property NSInteger controllerType;
@property NSMutableDictionary *shareDict;
@property MKMapItem *selectedItem;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property NSString *typeString;

@end
