//
//  DiscoverLocationViewController.m
//  Sharmunity
//
//  Created by st chen on 2017/2/9.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "DiscoverLocationViewController.h"
#import "DiscoverLiveShareSubmitViewController.h"
#import "DiscoverLiveHelpSubmitViewController.h"
#import "SYHeader.h"
#define cardUnselectOriginalY 0
#define cardSelectOriginalY 80
#define locButtonUnselectOriginalY 70
#define locButtonSelectOriginalY 150
@interface DiscoverLocationViewController ()<SYMapDelegate>{
    SYMap* mapView;
    UIView *searchView;
    UIButton *cardView;
    UITextField *searchTextField;
    UIButton *locationButton;
    UIBarButtonItem *backButton;
    BOOL hasLocationSelected;
}

@end

@implementation DiscoverLocationViewController

@synthesize selectedItem;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    mapView = [[SYMap alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mapView.SYDelegate = self;
    if (_activeRange) {
        [mapView setLocationWithLatitude:_preferLatitude longitude:_preferLongitude];
        [mapView addCircleWithDistanse:_preferDistance latitude:_preferLatitude longitude:_preferLongitude];
    }
    [self.view addSubview:mapView];
    
    if (selectedItem) {
        [mapView addMapItemAnnotation:selectedItem];
    }
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"SYBackBackground"];
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.bounds = CGRectMake(0, 0, 48, 48);
    backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
    
    
    
    cardView = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-cardUnselectOriginalY, self.view.frame.size.width, 80)];
    [cardView addTarget:self action:@selector(cardSelectResponse) forControlEvents:UIControlEventTouchUpInside];
    cardView.backgroundColor = SYBackgroundColorExtraLight;
    [self.view addSubview:cardView];
    
    
    locationButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-80, self.view.frame.size.height-locButtonUnselectOriginalY, 56, 56)];
    [locationButton setImage:[UIImage imageNamed:@"currentLocation"] forState:UIControlStateNormal];
    [locationButton addTarget:mapView action:@selector(location:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locationButton];
    
    
    hasLocationSelected = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    
//    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
//        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [mapView setupSearchBar];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar"]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.backgroundColor = SYBackgroundColorExtraLight;
    self.navigationController.view.backgroundColor = SYBackgroundColorExtraLight;
}
//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}
- (void)goback{
    [mapView removeSearchBarViews];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)SYMap:(SYMap *)SYMap didSelectedSharePin:(MKAnnotationView *)placemarkPin mapItem:(MKMapItem *)mapItem{
    for (UIView *view in cardView.subviews){
        [view removeFromSuperview];
    }
    hasLocationSelected = YES;
    [cardView addSubview:[self locationView:mapItem]];
    CGRect frame = cardView.frame;
    frame.origin.y = self.view.frame.size.height-cardSelectOriginalY;
    CGRect frame3 = locationButton.frame;
    frame3.origin.y = self.view.frame.size.height-locButtonSelectOriginalY;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.258];
    [cardView setFrame:frame];
    [locationButton setFrame:frame3];
    [UIView commitAnimations];
    selectedItem = mapItem;
}
-(void)SYMap:(SYMap *)SYMap didDeselectedSharePin:(MKAnnotationView *)placemarkPin mapItem:(MKMapItem *)mapItem{
    hasLocationSelected = NO;
    CGRect frame = cardView.frame;
    frame.origin.y = self.view.frame.size.height-cardUnselectOriginalY;
    CGRect frame3 = locationButton.frame;
    frame3.origin.y = self.view.frame.size.height-locButtonUnselectOriginalY;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.258];
    [cardView setFrame:frame];
    [locationButton setFrame:frame3];
    [UIView commitAnimations];
}

- (void)keyboardShowUp:(NSNotification*)notification{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.258];
    searchView.frame = CGRectMake(searchView.frame.origin.x, self.view.frame.size.height-keyboardFrameBeginRect.size.height-searchView.frame.size.height, searchView.frame.size.width, searchView.frame.size.height);
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    MKLocalSearchRequest *searchRequest = [MKLocalSearchRequest new];
    [searchRequest setNaturalLanguageQuery:textField.text];
    [searchRequest setRegion:mapView.region];
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:searchRequest];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (!error) {
            for (MKMapItem *mapItem in [response mapItems]) {
                [mapView addMapItemAnnotation:mapItem];
            }
        }
    }];
    [textField resignFirstResponder];
    return YES;
}
-(void)SYMap:(SYMap *)SYMap didSelectedSearchResult:(MKMapItem *)mapItem{
    for (UIView *view in cardView.subviews){
        [view removeFromSuperview];
    }
    hasLocationSelected = YES;
    [cardView addSubview:[self locationView:mapItem]];
    CGRect frame = cardView.frame;
    frame.origin.y = self.view.frame.size.height-cardSelectOriginalY;
    CGRect frame3 = locationButton.frame;
    frame3.origin.y = self.view.frame.size.height-locButtonSelectOriginalY;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.258];
    [cardView setFrame:frame];
    [locationButton setFrame:frame3];
    [UIView commitAnimations];
    selectedItem = mapItem;
}

- (void)cardSelectResponse{
    [mapView removeSearchBarViews];
    
    UIViewController *viewController;
    switch (_nextControllerType) {
        case SYDiscoverNextShareLease:
            viewController = [DiscoverLiveShareSubmitViewController new];
            ((DiscoverLiveShareSubmitViewController*)viewController).shareDict = _summaryDict;
            ((DiscoverLiveShareSubmitViewController*)viewController).distanceAvailable = NO;
            ((DiscoverLiveShareSubmitViewController*)viewController).dateAvailable = YES;
            ((DiscoverLiveShareSubmitViewController*)viewController).selectedItem = selectedItem;
            break;
        case SYDiscoverNextHelpRent:
            viewController = [DiscoverLiveHelpSubmitViewController new];
            ((DiscoverLiveHelpSubmitViewController*)viewController).helpDict = _summaryDict;
            ((DiscoverLiveHelpSubmitViewController*)viewController).distanceAvailable = YES;
            ((DiscoverLiveHelpSubmitViewController*)viewController).dateAvailable = YES;
            ((DiscoverLiveHelpSubmitViewController*)viewController).selectedItem = selectedItem;
            break;
            
            
        default:
            break;
    }


    [self.navigationController pushViewController:viewController animated:YES];
    
}

- (UIView*)locationView:(MKMapItem*)mapItem{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cardView.frame.size.width, cardView.frame.size.height)];
    UIImageView *mapPinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 28, 12, 24)];
    mapPinImageView.image = [UIImage imageNamed:@"selectedPin"];
    [view addSubview:mapPinImageView];
    view.userInteractionEnabled = NO;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 20, cardView.frame.size.width-158, 20)];
    nameLabel.text = [mapItem name];
    nameLabel.textColor = SYColor1;
    [nameLabel setFont:SYFont15S];
    [view addSubview:nameLabel];
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 40, cardView.frame.size.width-158, 20)];
    addressLabel.text = [[[mapItem placemark] addressDictionary] valueForKey:@"Street"];//title is too long
    addressLabel.textColor = SYColor1;
    [addressLabel setFont:SYFont15S];
    [view addSubview:addressLabel];
    
    UIImageView *indicatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(cardView.frame.size.width-68, 22, 36, 36)];
    indicatorImageView.image = [UIImage imageNamed:@"confirmCircleColor5"];
    [view addSubview:indicatorImageView];
    
    return view;
}

-(void)dismissKeyboard {
    [searchTextField resignFirstResponder];
}

@end
