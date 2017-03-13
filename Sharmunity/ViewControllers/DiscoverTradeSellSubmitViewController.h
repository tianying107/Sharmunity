//
//  DiscoverTradeSellSubmitViewController.h
//  Sharmunity
//
//  Created by Star Chen on 3/12/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface DiscoverTradeSellSubmitViewController : UIViewController<UIScrollViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,CLLocationManagerDelegate>{
    UIScrollView *mainScrollView;
    UIView *imageSelectView;
    UIView *typeView;
    UIPickerView *typePickerView;
    UIView *priceView;
    UIView *locationView;
    UIView *introductionView;
    UIView *titleView;
    UIView *confirmBackgroundView;
    UIButton *nextButton;
    
    NSString *typeString;
    NSArray *typeArray;
    BOOL is_other;
    BOOL is_first;
    BOOL priceAgg;
    NSString *priceString;
    NSString *MEID;
    
    NSInteger completeImages;
    
    NSMutableArray *viewsArray;
    NSMutableArray *imageArray;
}
-(void)locationCompleteResponse;
@property MKMapItem *selectedItem;
@property (strong, nonatomic) CLLocationManager *locationManager;


-(void)addImageAtIndex:(NSInteger)index;
-(void)addImageCompleteAtIndex:(NSInteger)index image:(UIImage*)image data:(NSData*)data;
-(void)setPrice:(NSString*)price priceAgg:(BOOL)agg;
@end
