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
    _centerLatitude = self.locationManager.location.coordinate.latitude;
    _centerLongitude = self.locationManager.location.coordinate.longitude;
    mapView = [[SYMap alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-45) withLatitude:_centerLatitude longitude:_centerLongitude];
    mapView.SYDelegate = self;
    [self.view addSubview:mapView];

    
    cardView = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-cardUnselectOriginalY, self.view.frame.size.width, 100)];
    [cardView addTarget:self action:@selector(cardSelectResponse) forControlEvents:UIControlEventTouchUpInside];
    cardView.backgroundColor = SYBackgroundColorExtraLight;
    [self.view addSubview:cardView];
    
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-barOriginalY, self.view.frame.size.width, 50)];
    barView.backgroundColor = SYBackgroundColorExtraLight;
    [self.view addSubview:barView];
    
    UIView *separator2 = [[UIView alloc] initWithFrame:CGRectMake(0, -SYSeparatorHeight, barView.frame.size.width, SYSeparatorHeight)];
    separator2.backgroundColor = SYSeparatorColor;
    [barView addSubview:separator2];
    
    sortButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sortButton.bounds = CGRectMake(0, 0, 28, 30);
    [sortButton setImage:[UIImage imageNamed:@"jobMapFilter"] forState:UIControlStateNormal];
    [sortButton addTarget:self action:@selector(sortResponse) forControlEvents:UIControlEventTouchUpInside];
    sortButton.frame = CGRectMake(30, 10, sortButton.bounds.size.width, sortButton.bounds.size.height);
    [barView addSubview:sortButton];
    
    locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    locationButton.bounds = CGRectMake(0, 0, 28, 30);
    locationButton.frame = CGRectMake(barView.frame.size.width-58, 10, 28, 30);
    [locationButton setImage:[UIImage imageNamed:@"jobMapLocation"] forState:UIControlStateNormal];
    [locationButton addTarget:mapView action:@selector(location:) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:locationButton];
    
    hasJobSelected = NO;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
//                                   initWithTarget:self
//                                   action:@selector(dismissKeyboard)];
//    [self.view addGestureRecognizer:tap];
    
    [self requestNearbyShare];
    [self jobLocationSetup];
    [mapView setLocationWithLatitude:_centerLatitude longitude:_centerLongitude];
    [mapView removeCircles];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)jobLocationSetup{
    if (shareIDArray.count) {
        for (NSString *jobID in shareIDArray) {
//            NSString *jobID = [jobIDDict valueForKey:@"share_id"];
            [self requestAbstract:jobID];
        }
    }
    else{
        [mapView removeAnnotations];
    }
    
}
- (void)requestNearbyShare{
    shareIDArray = [NSArray new];
        NSString *requestQuery = [NSString stringWithFormat:@"latitude=%f&longitude=%f&distance=50",self.locationManager.location.coordinate.latitude,self.locationManager.location.coordinate.longitude];
        NSString *urlString = [NSString stringWithFormat:@"%@nearby?%@",basicURL,requestQuery];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLSessionTask *task = [session dataTaskWithURL:url
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                                                      options:kNilOptions
                                                                                                        error:&error];
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                shareIDArray = [dict valueForKey:@"share"];
                                                [self jobLocationSetup];
                                            });
                                        }];
        [task resume];
    
}
- (void)requestAbstract:(NSString*)orderNumber{
    if (orderNumber) {
        NSString *requestQuery = [NSString stringWithFormat:@"share_id=%@",orderNumber];
        NSString *urlString = [NSString stringWithFormat:@"%@reqshare?%@",basicURL,requestQuery];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLSessionTask *task = [session dataTaskWithURL:url
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            NSDictionary *orderDict = [NSJSONSerialization JSONObjectWithData:data
                                                                                                      options:kNilOptions
                                                                                                        error:&error];
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [mapView addShareAnnotation:orderDict];
                                            });
                                        }];
        [task resume];
    }
}
@end
