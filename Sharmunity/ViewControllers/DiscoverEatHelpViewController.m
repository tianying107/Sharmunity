//
//  DiscoverEatHelpViewController.m
//  Sharmunity
//
//  Created by Star Chen on 1/29/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import "DiscoverEatHelpViewController.h"

@interface DiscoverEatHelpViewController ()

@end

@implementation DiscoverEatHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MEID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
    
    
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
    
    [_testButton addTarget:self action:@selector(submitShareResponse) forControlEvents:UIControlEventTouchUpInside];
    [_helpTestButton addTarget:self action:@selector(submitHelpResponse) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)submitShareResponse{
    
    NSString *requestBody = [NSString stringWithFormat:@"email=%@&latitude=%f&longitude=%f&category=4&subcate=02010000&price=100",MEID,self.locationManager.location.coordinate.latitude,self.locationManager.location.coordinate.longitude];
    NSLog(@"%@/n",requestBody);
    /*改上面的 query 和 URLstring 就好了*/
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@newshare",basicURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [requestBody dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:&error];
        NSLog(@"server said: %@",dict);
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }];
    [task resume];
}
- (void)submitHelpResponse{
    
    NSString *requestBody = [NSString stringWithFormat:@"email=%@&latitude=%f&longitude=%f&category=5&subcate=01010000&flight=ua708&date=2017-03-08",MEID,self.locationManager.location.coordinate.latitude,self.locationManager.location.coordinate.longitude];
    NSLog(@"%@/n",requestBody);
    
    /*改上面的 query 和 URLstring 就好了*/
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@newhelp",basicURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [requestBody dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:&error];
        NSLog(@"server said: %@",dict);
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }];
    [task resume];
}

-(void)testget{
    NSString *requestQuery = [NSString stringWithFormat:@"latitude=%f&longitude=%f&distance=30",self.locationManager.location.coordinate.latitude,self.locationManager.location.coordinate.longitude];
    NSString *urlString = [NSString stringWithFormat:@"%@nearby?%@",basicURL,requestQuery];
    NSLog(@"%@",requestQuery);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionTask *task = [session dataTaskWithURL:url
                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                        NSLog(@"server said: %@",string);
//                                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
//                                                                                             options:kNilOptions
//                                                                                               error:&error];
//                                        NSLog(@"server said: %@",dict);
                                        //                                        dispatch_async(dispatch_get_main_queue(), ^{
                                        //                                            [self handleSubmit:dict];
                                        //                                        });
                                        
                                    }];
    [task resume];
}

@end
