//
//  DiscoverLearnShareSubmitViewController.h
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
@interface DiscoverLearnShareSubmitViewController : UIViewController<UIScrollViewDelegate,UITextViewDelegate, CLLocationManagerDelegate>{
    UIScrollView *mainScrollView;
    UIView *majorView;
    UIView *numberView;
    UIView *priceView;
    UIView *locationView;
    UIView *titleView;
    UIView *introductionView;
    UIButton *nextButton;
    
    
    NSString *MEID;
    NSString *priceString;
    
    NSMutableArray *viewsArray;
}


-(void)locationCompleteResponse;
@property NSInteger controllerType;
@property NSMutableDictionary *shareDict;
@property MKMapItem *selectedItem;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end