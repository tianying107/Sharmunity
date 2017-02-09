//
//  NearbyMapViewController.h
//  Sharmunity
//
//  Created by st chen on 2017/2/9.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface NearbyMapViewController : UIViewController<CLLocationManagerDelegate>{
    
    BOOL hasJobSelected;
}
@property (strong, nonatomic) CLLocationManager *locationManager;

/**
 * Properties get from parent view controller, used to set up this view controller.
 */
@property (nonatomic, weak) NSArray *idList;
@property float centerLatitude;
@property float centerLongitude;
@property NSString *MEID;
@end
