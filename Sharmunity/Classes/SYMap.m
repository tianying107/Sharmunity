//
//  SYMap.m
//  Sharmunity
//
//  Created by st chen on 2017/2/9.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "SYMap.h"
#import "SYAnnotationView.h"
#import "MapPin.h"
@implementation SYMap
@synthesize searchBar;
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
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
        [self mapInit];
    }
    return self;
}
- (void)mapInit{
    MKCoordinateRegion region = {{0.0, 0.0},{0.0,0.0}};
    region.center.latitude = self.locationManager.location.coordinate.latitude;
    region.center.longitude= self.locationManager.location.coordinate.longitude;
    double scalingFactor = ABS( (cos(2 * M_PI * region.center.latitude / 360.0) ));
    region.span.latitudeDelta = 5/69.0;
    region.span.longitudeDelta = 5/(scalingFactor * 69.0);
    self.delegate = self;
    [self setRegion:region];
    self.scrollEnabled = YES;
    self.zoomEnabled = YES;
    self.showsUserLocation = YES;
    self.showsBuildings = YES;
    self.pitchEnabled = YES;
    self.tintColor = SYColor4;
    pinIndex = 0;
    placemarkArray = [NSMutableArray new];
    normalPin =[UIImage imageNamed:@"mapPoint"];
    selectedPin = [UIImage imageNamed:@"mapPin"];
    
    /**
     *job map
     */
    jobIDArray = [NSMutableArray new];
}
- (SYAnnotationView *)mapView:(MKMapView *)tmapView viewForAnnotation:(id <MKAnnotation>)annotation{
    SYAnnotationView *pinView = nil;
    if ([annotation isKindOfClass:[MapPin class]]){
        MapPin *mapPin = annotation;
        pinView = (SYAnnotationView*)[MapPin createViewAnnotationForMapView:self annotation:annotation height:20];
        pinView.image = normalPin;
        pinView.canShowCallout = NO;
        pinView.tag = mapPin.index;
        
        //        pinIndex++;
    }
    return pinView;
}
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    if ([view.annotation isKindOfClass:[MKUserLocation class]]) {
        CLGeocoder *ceo = [[CLGeocoder alloc]init];
        CLLocation *loc = [[CLLocation alloc]initWithLatitude:self.locationManager.location.coordinate.latitude longitude:self.locationManager.location.coordinate.longitude];
        [ceo reverseGeocodeLocation:loc
                  completionHandler:^(NSArray *placemarks, NSError *error) {
                      CLPlacemark *placemark = [placemarks firstObject];
                      MKPlacemark *mkplaceMark = [[MKPlacemark alloc]initWithPlacemark:placemark];
                      MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:mkplaceMark];
                      [self.SYDelegate SYMap:self didSelectedSharePin:view mapItem:mapItem];
                  }
         ];
    }
    else{
        [self.SYDelegate SYMap:self didSelectedSharePin:view mapItem:[placemarkArray objectAtIndex:view.tag]];
        //    [self.SYDelegate postMap:self didSelectedJobPin:view mapItem:[placemarkArray objectAtIndex:view.tag]];
        view.image = selectedPin;
        if (previousSelectedPin) {
            previousSelectedPin.image = normalPin;
        }
        previousSelectedPin = view;
    }
    
}
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    if ([view.annotation isKindOfClass:[MKUserLocation class]]) {

    }
    else{
        [self.SYDelegate SYMap:self didDeselectedSharePin:view mapItem:[placemarkArray objectAtIndex:view.tag]];
        if (previousSelectedPin) {
            previousSelectedPin.image = normalPin;
            previousSelectedPin = nil;
        }
    }
    
}
- (void)addMapPinAnnotation:(float)latitude longitude:(float)longitude{
    MapPin *localPin=[[MapPin alloc] init];
    localPin.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    [self addAnnotation:localPin];
}
- (void)addMapItemAnnotation:(MKMapItem*)mapItem{
    float latitude = [[mapItem placemark] location].coordinate.latitude;
    float longitude = [[mapItem placemark] location].coordinate.longitude;
    
    MapPin *localPin=[[MapPin alloc] init];
    localPin.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    localPin.index = pinIndex;
    //    jobPin.orderDict = placemark;
    [placemarkArray insertObject:mapItem atIndex:pinIndex];
    [self addAnnotation:localPin];
    [self selectAnnotation:localPin animated:NO];
    pinIndex++;
}
- (void)removeAnnotations{
    NSArray* existAnnotationPoints = self.annotations;
    if (existAnnotationPoints.count) {
        [self removeAnnotations:existAnnotationPoints];
    }
    pinIndex = 0;
    placemarkArray = [NSMutableArray new];
}
- (void)addCircleWithDistanse:(float)tdistance latitude:(float)latitude longitude:(float)longitude{
    distance = tdistance;
    CLLocationDistance fenceDistance = distance*1000;
    MKCoordinateRegion region = {{0.0, 0.0},{0.0,0.0}};
    region.center.latitude = latitude;
    region.center.longitude= longitude;
    double scalingFactor = ABS( (cos(2 * M_PI * region.center.latitude / 360.0) ));
    region.span.latitudeDelta = 5/69.0;
    region.span.longitudeDelta = 5/(scalingFactor * 69.0);
    CLLocationCoordinate2D circleMiddlePoint = CLLocationCoordinate2DMake(region.center.latitude, region.center.longitude);
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:circleMiddlePoint radius:fenceDistance];
    
    [self addOverlay:circle];
}
- (void)removeCircles{
    NSArray *existOverlays = self.overlays;
    [self removeOverlays:existOverlays];
}
- (void)setLocationWithLatitude:(float)latitude longitude:(float)longitude{
    MKCoordinateRegion region = { {0.0, 0.0},{0.0,0.0}};
    region.center.latitude = latitude;
    region.center.longitude= longitude;
    double scalingFactor = ABS( (cos(2 * M_PI * region.center.latitude / 360.0) ));
    region.span.latitudeDelta = 3/69.0;
    region.span.longitudeDelta = 3/(scalingFactor * 69.0);
    [self setRegion:region animated:YES];
    
}
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKCircleRenderer *circleR = [[MKCircleRenderer alloc] initWithCircle:(MKCircle *)overlay];
    circleR.fillColor = SYColor5;
    circleR.alpha=0.3;
    return circleR;
}
- (IBAction)location:(id)sender{
    MKCoordinateRegion region = { {0.0, 0.0},{0.0,0.0}};
    region.center.latitude = self.locationManager.location.coordinate.latitude;
    region.center.longitude= self.locationManager.location.coordinate.longitude;
    double scalingFactor = ABS( (cos(2 * M_PI * region.center.latitude / 360.0) ));
    region.span.latitudeDelta = 5/69.0;
    region.span.longitudeDelta = 5/(scalingFactor * 69.0);
    [self setRegion:region animated:YES];
}



/*********************search section************************/
- (void)setupSearchBar{
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    searchBarView = [[UIView alloc] initWithFrame:CGRectMake(80, 20, [[UIScreen mainScreen] bounds].size.width-30-80, 44)];
    searchBarView.backgroundColor = SYBackgroundColorExtraLight;
    searchBarView.layer.cornerRadius = searchBarView.frame.size.height/2;
    searchBarView.clipsToBounds = YES;
    
    searchBar = [[UITextField alloc] initWithFrame:CGRectMake(38, 0, searchBarView.frame.size.width-32, searchBarView.frame.size.height)];
    searchBar.textColor = SYColor1;
    [searchBar setFont:SYFont15];
    searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
    [searchBar addTarget:self action:@selector(searchBarContentChange) forControlEvents:UIControlEventEditingChanged];
    searchBar.delegate = self;
    [searchBarView addSubview:searchBar];
    
    UIImageView *searchIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 16, 16)];
    searchIconImageView.image = [UIImage imageNamed:@"searchIconColor5"];
    [searchBarView addSubview:searchIconImageView];
    
    
    searchView = [[SYSuscard alloc] initWithFullSize];
    [currentWindow addSubview:searchView];
    searchView.hidden = YES;
    searchView.backButton.hidden = NO;
    searchView.cancelButton.hidden = YES;
    [searchView.backButton removeTarget:nil
                                 action:NULL
                       forControlEvents:UIControlEventAllEvents];
    [searchView.backButton addTarget:self action:@selector(searchViewDismiss) forControlEvents:UIControlEventTouchUpInside];
    [searchView.backButton setImage:[UIImage imageNamed:@"SYBackCommon"] forState:UIControlStateNormal];
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(38+80, 20+searchBarView.frame.size.height, searchBarView.frame.size.width-32, SYSeparatorHeight)];
    separator.backgroundColor = SYSeparatorColor;
    [searchView addSubview:separator];
    
    searchResultArray = [NSArray new];
    
    resultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 90, self.frame.size.width, searchView.cardSize.height-90)];
    resultTableView.delegate = self;
    resultTableView.dataSource = self;
    resultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    resultTableView.backgroundColor = SYBackgroundColorExtraLight;
    [searchView addSubview:resultTableView];
    
    
    [currentWindow addSubview:searchBarView];
}
- (void)removeSearchBarViews{
    [searchBarView removeFromSuperview];
    [searchView removeFromSuperview];
}
- (void)searchViewShowUp{
    searchBarView.alpha = 0;
    searchBarView.hidden = NO;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.258];
    searchBarView.alpha = 1;
    [UIView commitAnimations];
}
- (void)searchViewDismiss{
    searchView.hidden = YES;
    [searchBar resignFirstResponder];
}
- (void)searchBarContentChange{
    clearSearchButton.selected = YES;
    MKLocalSearchRequest *searchRequest = [MKLocalSearchRequest new];
    [searchRequest setRegion:self.region];
    [searchRequest setNaturalLanguageQuery:searchBar.text];
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:searchRequest];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (!error) {
            searchResultArray = [response mapItems];
            [resultTableView reloadData];
        }
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    MKLocalSearchRequest *searchRequest = [MKLocalSearchRequest new];
    [searchRequest setNaturalLanguageQuery:textField.text];
    //    [searchRequest setRegion:mapView.region];
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:searchRequest];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (!error) {
            //            for (MKMapItem *mapItem in [response mapItems]) {
            //                [mapView addMapItemAnnotation:mapItem];
            //            }
        }
    }];
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    searchView.alpha = 0;
    searchView.hidden = NO;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.258];
    searchView.alpha = 1;
    [UIView commitAnimations];
    
    return YES;
}
//** the number of section and rows
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [searchResultArray count];
}
//** cell detail
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"resultList";
    SYCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SYCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    MKMapItem *mapItem = [searchResultArray objectAtIndex:indexPath.row];
    UIView *basicView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 65)];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 22, basicView.frame.size.width-30, 20)];
    nameLabel.text =[mapItem name];
    nameLabel.textColor = SYColor1;
    [nameLabel setFont:SYFont15];
    [basicView addSubview:nameLabel];
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 42, basicView.frame.size.width-30, 20)];
    addressLabel.text = [[[mapItem placemark] addressDictionary] valueForKey:@"Street"];
    addressLabel.textColor = SYColor1;
    [addressLabel setFont:SYFont15];
    [basicView addSubview:addressLabel];
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(30, 65-SYSeparatorHeight, basicView.frame.size.width-60, SYSeparatorHeight)];
    separator.backgroundColor = SYSeparatorColor;
    [basicView addSubview:separator];
    [cell setBasicView:basicView];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = SYBackgroundColorExtraLight;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    isSearching = YES;
    [self removeAnnotations];
    MKMapItem *mapItem = [searchResultArray objectAtIndex:indexPath.row];
    [self addMapItemAnnotation:mapItem];
    [self setLocationWithLatitude:mapItem.placemark.location.coordinate.latitude longitude:mapItem.placemark.location.coordinate.longitude];
    //    [self updateAddressWithMapItem:mapItem];
    [self.SYDelegate SYMap:self didSelectedSearchResult:mapItem];//postMap:self didSelectedSearchResult:mapItem];
    [self searchViewDismiss];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [searchBar resignFirstResponder];
}

/*Current location*/
- (void)setCurrentLocationWithAddress:(BOOL)addressBool{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
//    [self setLatitude:_locationManager.location.coordinate.latitude longitude:_locationManager.location.coordinate.longitude address:addressBool];
}


/*JOB MAP*/
- (id)initWithFrame:(CGRect)frame withLatitude:(float)latitude longitude:(float)longitude{
    NSNumber *latitudeNumber = [[NSNumber alloc] initWithFloat:latitude];
    NSNumber *longitudeNumber = [[NSNumber alloc] initWithFloat:longitude];
    NSArray *array = [[NSArray alloc] initWithObjects:latitudeNumber, longitudeNumber, nil];
    regionCenterArray = [[NSMutableArray alloc] initWithObjects:array, nil];
    self = [super initWithFrame:frame];
    if (self) {
        [self mapInit];
    }
    
    return self;
}

- (void)addShareAnnotation:(NSDictionary*)shareDict{
    float latitude = [[[shareDict valueForKey:@"location"] valueForKey:@"latitude"] floatValue];
    float longitude = [[[shareDict valueForKey:@"location"] valueForKey:@"longitude"] floatValue];
    
    MapPin *jobPin=[[MapPin alloc] init];
    jobPin.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    jobPin.orderDict = shareDict;
    jobPin.index = pinIndex;
    [jobIDArray insertObject:[shareDict valueForKey:@"share_id"] atIndex:pinIndex];
    [self addAnnotation:jobPin];
    pinIndex++;
    //    [self selectAnnotation:jobPin animated:NO];
}
@end
