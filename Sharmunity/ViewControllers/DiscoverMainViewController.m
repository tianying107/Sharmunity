//
//  DiscoverMainViewController.m
//  Sharmunity
//
//  Created by st chen on 2017/1/20.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "DiscoverMainViewController.h"
#import "DiscoverLiveShareLeaseViewController.h"
#import "DiscoverLiveShareSubmitViewController.h"
@interface DiscoverMainViewController (){
    SYPopOut *popOut;
}

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

    
    cityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cityButton setTitleColor:SYColor1 forState:UIControlStateNormal];
    [cityButton.titleLabel setFont:SYFont15];
//    [cityButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    cityButton.bounds = CGRectMake(0, 0, 120, 40);
    cityButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem *cityItem = [[UIBarButtonItem alloc] initWithCustomView:cityButton] ;
    self.navigationItem.leftBarButtonItem = cityItem;
    
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:self.locationManager.location.coordinate.latitude longitude:self.locationManager.location.coordinate.longitude];
    [ceo reverseGeocodeLocation:loc
              completionHandler:^(NSArray *placemarks, NSError *error) {
                  CLPlacemark *placemark = [placemarks objectAtIndex:0];
                  [cityButton setTitle:placemark.locality forState:UIControlStateNormal];
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
    _currentHelpButton.frame = CGRectMake(0, -2.5, 0.67*width, 30);
    _currentShareButton.frame = CGRectMake(0.67*width, -2.5, 0.33*width, 30);

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
        _currentHelpButton.frame = CGRectMake(0, -2.5, 0.67*width, 30);
        [_currentHelpButton.titleLabel setFont:SYFont20];
        _currentShareButton.frame = CGRectMake(0.67*width, -2.5, 0.33*width, 30);
        [_currentShareButton.titleLabel setFont:SYFont15];
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
        _currentHelpButton.frame = CGRectMake(0, -2.5, 0.33*width, 30);
        [_currentHelpButton.titleLabel setFont:SYFont15];
        _currentShareButton.frame = CGRectMake(0.33*width, -2.5, 0.67*width, 30);
        [_currentShareButton.titleLabel setFont:SYFont20];
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
//    NSLog(@"%@",requestQuery);
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
//    NSLog(@"%@",requestQuery);
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
    recentHelpViewArray = [NSMutableArray new];
    for (int i=0; i<MIN(3, recentHelpArray.count); i++) {
        SYHelp *helpView = [[SYHelp alloc] initAbstractWithFrame:CGRectMake(0, i*20,_recentHelpView.frame.size.width, 20) helpID:[recentHelpArray objectAtIndex:i]];
        [helpView.helpButton addTarget:self action:@selector(solveHelp:) forControlEvents:UIControlEventTouchUpInside];
        helpView.helpButton.tag = i;
        [_recentHelpView addSubview:helpView];
        [recentHelpViewArray addObject:helpView];
    }
}
-(IBAction)solveHelp:(id)sender{
    UIButton *interestButton = sender;
    SYHelp *helpView = [recentHelpViewArray objectAtIndex:interestButton.tag];
    
    UIViewController *viewController;
    switch ([[helpView.helpDict valueForKey:@"category"] integerValue]) {
        case 2:
            if ([[[helpView.helpDict valueForKey:@"subcate"] substringToIndex:2] isEqualToString:@"03"]) {
                viewController = [DiscoverLiveShareSubmitViewController new];
            }
            else{
            viewController = [DiscoverLiveShareLeaseViewController new];
            if ([[[helpView.helpDict valueForKey:@"subcate"] substringToIndex:2] isEqualToString:@"02"]) {
                ((DiscoverLiveShareLeaseViewController*)viewController).shortRent = YES;
            }
                ((DiscoverLiveShareLeaseViewController*)viewController).helpDict = helpView.helpDict;
                ((DiscoverLiveShareLeaseViewController*)viewController).setupWithHelp = YES;
            }
            break;
            
        default:
            break;
    }
    
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    [(SYSuscard*)helpView.abstractSuscard cancelResponse];
}
-(void)requestRecentShareFromServer{
    recentShareArray = [NSArray new];
    MEID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
    NSString *requestQuery = [NSString stringWithFormat:@"latitude=%f&longitude=%f",self.locationManager.location.coordinate.latitude,self.locationManager.location.coordinate.longitude];
    NSString *urlString = [NSString stringWithFormat:@"%@recentshare?%@",basicURL,requestQuery];
//    NSLog(@"%@",requestQuery);
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
        shareView.interestButton.tag = i;
        [shareView.interestButton addTarget:self action:@selector(createInterestHelp:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}
-(IBAction)createInterestHelp:(id)sender{
    UIButton *interestButton = sender;
    NSString *shareID = [recentShareArray objectAtIndex:interestButton.tag];
    NSString *requestBody = [NSString stringWithFormat:@"email=%@&latitude=%f&longitude=%f&share_id=%@&keyword= ",MEID,self.locationManager.location.coordinate.latitude,self.locationManager.location.coordinate.longitude,shareID];
    interestButton.selected = YES;
    NSMutableArray *interestedShare = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"interestedShare"]];
    [interestedShare addObject:shareID];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:interestedShare forKey:@"interestedShare"];
    [userDefault synchronize];
    
    NSLog(@"%@/n",requestBody);
    /*改上面的 query 和 URLstring 就好了*/
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@otohelp",basicURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [requestBody dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:&error];
//        NSLog(@"server said: %@",dict);
        dispatch_async(dispatch_get_main_queue(), ^{
         [self submitHandle:dict];
        });
    }];
    [task resume];
    
}
-(void)submitHandle:(NSDictionary*)dict{
    if ([[dict valueForKey:@"success"] boolValue]){
        [self helpResponse:[dict valueForKey:@"help_id"]];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else [popOut showUpPop:SYPopDiscoverShareFail];
    
}
-(void)helpResponse:(NSString*)helpID{
    SYSuscard *baseView = [[SYSuscard alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen]bounds].size.height) withCardSize:CGSizeMake(320, 300) keyboard:NO];
    baseView.cardBackgroundView.backgroundColor = SYBackgroundColorExtraLight;
    baseView.scrollView.scrollEnabled = NO;
    baseView.backButton.hidden = YES;
    
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:baseView];
    baseView.alpha = 0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.258];
    baseView.alpha = 1;
    [UIView commitAnimations];
    
    /**************content***************/
    SYHelp *helpView = [[SYHelp alloc] initWithFrame:CGRectMake(0, 0, baseView.cardSize.width, baseView.cardSize.height) helpID:helpID withHeadView:YES];
    [baseView addGoSubview:helpView];
}
@end
