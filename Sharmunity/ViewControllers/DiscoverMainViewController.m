//
//  DiscoverMainViewController.m
//  Sharmunity
//
//  Created by st chen on 2017/1/20.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "DiscoverMainViewController.h"

@interface DiscoverMainViewController ()

@end

@implementation DiscoverMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: SYColor1,
                                                                    NSFontAttributeName: SYFont20};
    
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

    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:self.locationManager.location.coordinate.latitude longitude:self.locationManager.location.coordinate.longitude];
    [ceo reverseGeocodeLocation:loc
              completionHandler:^(NSArray *placemarks, NSError *error) {
                  CLPlacemark *placemark = [placemarks objectAtIndex:0];
                  _cityItem.title =placemark.locality;
              }
     ];
    
    
    isHelp = YES;
    [self welcomeTitleRequest];
    [self viewsSetup];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [self recentRefresh];
}

- (void)viewsSetup{
    float width = self.view.frame.size.width;
    _currentHelpButton.frame = CGRectMake(0, 15, 0.67*width, 30);
    _currentShareButton.frame = CGRectMake(0.67*width, 15, 0.33*width, 30);

    [_currentShareButton addTarget:self action:@selector(shareHelpSwitch:) forControlEvents:UIControlEventTouchUpInside];
    [_currentHelpButton addTarget:self action:@selector(shareHelpSwitch:) forControlEvents:UIControlEventTouchUpInside];
    
    [_eatButton addTarget:self action:@selector(eatButtonResponse) forControlEvents:UIControlEventTouchUpInside];
    [_liveButton addTarget:self action:@selector(liveButtonResponse) forControlEvents:UIControlEventTouchUpInside];
    [_learnButton addTarget:self action:@selector(learnButtonResponse) forControlEvents:UIControlEventTouchUpInside];
    [_playButton addTarget:self action:@selector(playButtonResponse) forControlEvents:UIControlEventTouchUpInside];
    [_travelButton addTarget:self action:@selector(travelButtonResponse) forControlEvents:UIControlEventTouchUpInside];
    
    _slogenImageView.center = CGPointMake(self.view.center.x, _slogenImageView.center.y);
    _eatButton.center = CGPointMake(self.view.center.x, _eatButton.center.y) ;
    _learnButton.center = CGPointMake(self.view.center.x, _learnButton.center.y) ;
    _liveButton.center = CGPointMake(self.view.center.x/2, _liveButton.center.y) ;
    _playButton.center = CGPointMake(self.view.center.x/2, _playButton.center.y) ;
    _travelButton.center = CGPointMake(3*self.view.center.x/2, _travelButton.center.y) ;
    _tradeButton.center = CGPointMake(3*self.view.center.x/2, _tradeButton.center.y) ;
    
    _eatLabel.center = CGPointMake(self.view.center.x, _eatLabel.center.y) ;
    _learnLabel.center = CGPointMake(self.view.center.x, _learnLabel.center.y) ;
    _liveLabel.center = CGPointMake(self.view.center.x/2, _liveLabel.center.y) ;
    _playLabel.center = CGPointMake(self.view.center.x/2, _playLabel.center.y) ;
    _travelLabel.center = CGPointMake(3*self.view.center.x/2, _travelLabel.center.y) ;
    _tradeLabel.center = CGPointMake(3*self.view.center.x/2, _tradeLabel.center.y) ;
    
    [self requestRecentHelpFromServer];
    [self requestRecentShareFromServer];
}

-(IBAction)shareHelpSwitch:(id)sender{
    isHelp = ([sender isEqual:_currentHelpButton])?YES:NO;
    float width = self.view.frame.size.width;
    if ([sender isEqual:_currentHelpButton]) {
        _currentHelpButton.frame = CGRectMake(0, 15, 0.67*width, 30);
        _currentShareButton.frame = CGRectMake(0.67*width, 15, 0.33*width, 30);
        _eatButton.selected = NO;
        _liveButton.selected = NO;
        _learnButton.selected = NO;
        _playButton.selected = NO;
        _travelButton.selected = NO;
        _tradeButton.selected = NO;
        _buttonBackgroundImageView.image = [UIImage imageNamed:@"helpShareButtonBackground"];
        _slogenImageView.image = [UIImage imageNamed:@"helpSolgen"];
    }
    else{
        _currentHelpButton.frame = CGRectMake(0, 15, 0.33*width, 30);
        _currentShareButton.frame = CGRectMake(0.33*width, 15, 0.67*width, 30);
        _eatButton.selected = YES;
        _liveButton.selected = YES;
        _learnButton.selected = YES;
        _playButton.selected = YES;
        _travelButton.selected = YES;
        _tradeButton.selected = YES;
        _buttonBackgroundImageView.image = [UIImage imageNamed:@"shareHelpButtonBackground"];
        _slogenImageView.image = [UIImage imageNamed:@"shareSolgen"];
    }
}

- (void)eatButtonResponse{
    if (isHelp) {
        DiscoverEatHelpViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"eatHelpFirst"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else{
        DiscoverEatShareViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"eatShareFirst"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}
- (void)liveButtonResponse{
    if (isHelp) {
        DiscoverLiveHelpViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"liveHelpFirst"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else{
        DiscoverLiveShareViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"liveShareFirst"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}
- (void)learnButtonResponse{
    if (isHelp) {
        DiscoverLiveHelpViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"learnHelpFirst"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else{
        DiscoverLiveShareViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"learnShareFirst"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}
- (void)playButtonResponse{
    if (isHelp) {
        DiscoverPlayHelpViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"playHelpFirst"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else{
        DiscoverPlayShareViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"playShareFirst"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}
- (void)travelButtonResponse{
    if (isHelp) {
        DiscoverTravelHelpViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"travelHelpFirst"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else{
        DiscoverTravelShareViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"travelShareFirst"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)welcomeTitleRequest{
    MEID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
    NSString *requestQuery = [NSString stringWithFormat:@"email=%@",MEID];
    NSString *urlString = [NSString stringWithFormat:@"%@reqprofile?%@",basicURL,requestQuery];
    NSLog(@"%@",requestQuery);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionTask *task = [session dataTaskWithURL:url
                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                        
                                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                                             options:kNilOptions
                                                                                               error:&error];
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            self.navigationItem.title = [NSString stringWithFormat:@"您好！%@",[dict valueForKey:@"name"]];
                                        });
                                        
                                    }];
    [task resume];
}


-(void)recentRefresh{
    [self requestRecentHelpFromServer];
    [self requestRecentShareFromServer];
}
-(void)requestRecentHelpFromServer{
    recentHelpArray = [NSArray new];
    MEID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
    NSString *requestQuery = [NSString stringWithFormat:@"latitude=%f&longitude=%f",self.locationManager.location.coordinate.latitude,self.locationManager.location.coordinate.longitude];
    NSString *urlString = [NSString stringWithFormat:@"%@recenthelp?%@",basicURL,requestQuery];
    NSLog(@"%@",requestQuery);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionTask *task = [session dataTaskWithURL:url
                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

                                        NSArray *array = [NSJSONSerialization JSONObjectWithData:data
                                                                                         options:kNilOptions
                                                                                           error:&error];
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            recentHelpArray = array;
                                            [self recentHelpSetup];
                                        });
                                        
                                    }];
    [task resume];
}
-(void)recentHelpSetup{
    for (UIView *view in [_recentHelpView subviews]){
        [view removeFromSuperview];
    }
    for (int i=0; i<MIN(3, recentHelpArray.count); i++) {
        SYHelp *helpView = [[SYHelp alloc] initAbstractWithFrame:CGRectMake(0, i*20,_recentHelpView.frame.size.width, 20) helpID:[recentHelpArray objectAtIndex:i]];
        [_recentHelpView addSubview:helpView];
    }
}
-(void)requestRecentShareFromServer{
    recentShareArray = [NSArray new];
    MEID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
    NSString *requestQuery = [NSString stringWithFormat:@"latitude=%f&longitude=%f",self.locationManager.location.coordinate.latitude,self.locationManager.location.coordinate.longitude];
    NSString *urlString = [NSString stringWithFormat:@"%@recentshare?%@",basicURL,requestQuery];
    NSLog(@"%@",requestQuery);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionTask *task = [session dataTaskWithURL:url
                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                        NSArray *array = [NSJSONSerialization JSONObjectWithData:data
                                                                                         options:kNilOptions
                                                                                           error:&error];
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            recentShareArray = array;
                                            [self recentShareSetup];

                                        });
                                        
                                    }];
    [task resume];
}
-(void)recentShareSetup{
    for (UIView *view in [_recentShareView subviews]){
        [view removeFromSuperview];
    }
    for (int i=0; i<MIN(3, recentShareArray.count); i++) {
        SYShare *shareView = [[SYShare alloc] initAbstractWithFrame:CGRectMake(0, i*20,_recentHelpView.frame.size.width, 20) shareID:[recentShareArray objectAtIndex:i]];
        [_recentShareView addSubview:shareView];
    }
}


@end
