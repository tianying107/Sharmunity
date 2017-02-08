//
//  DiscoverEatHelpViewController.h
//  Sharmunity
//
//  Created by Star Chen on 1/29/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Header.h"

@interface DiscoverEatHelpViewController : UIViewController<CLLocationManagerDelegate>{
    NSString *MEID;
}
@property (weak, nonatomic) IBOutlet UIButton *testButton;
@property (weak, nonatomic) IBOutlet UIButton *helpTestButton;
@property (strong, nonatomic) CLLocationManager *locationManager;
@end
