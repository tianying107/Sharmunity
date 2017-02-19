//
//  NearbyMapViewController.m
//  Sharmunity
//
//  Created by st chen on 2017/2/9.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "NearbyMapViewController.h"
#import "Header.h"
#import "SYHeader.h"
#define searchUnselectOriginalY 90
#define searchSelectOriginalY 190
#define cardUnselectOriginalY 50
#define cardSelectOriginalY 150
#define barOriginalY 50

@interface NearbyMapViewController ()

@end

@implementation NearbyMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SYBackgroundColorExtraLight;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
        
    }
    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
    if (authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
        authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
    }
    
//    mapView = [[SYMap alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-45) withLatitude:_centerLatitude longitude:_centerLongitude];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
