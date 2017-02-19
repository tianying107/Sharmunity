//
//  DiscoverTravelHelpSecondViewController.m
//  Sharmunity
//
//  Created by st chen on 2017/2/15.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "DiscoverTravelHelpSecondViewController.h"
#import "DiscoverLocationViewController.h"
#import "Header.h"
#import "SYHeader.h"
@interface DiscoverTravelHelpSecondViewController ()<SYPriceSliderDelegate>{
    SYPopOut *popOut;
}

@end

@implementation DiscoverTravelHelpSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (_controllerType) {
        case DiscoverTravelPartner:
            self.navigationItem.title = @"找飞伴";
            break;
            
        default:
            break;
    }
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: SYColor1,
                                                                    NSFontAttributeName: SYFont20S};
    self.view.backgroundColor = SYBackgroundColorExtraLight;
    
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mainScrollView.backgroundColor = SYBackgroundColorExtraLight;
    [self.view addSubview:mainScrollView];
    
    MEID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
    _shareDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:MEID,@"email",@"4",@"category",@"2099-01-01",@"expire_date", nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
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
    
    popOut = [SYPopOut new];
    [self dataSetup];
    [self viewsSetup];
    
}
-(void) viewWillAppear:(BOOL)animated{
    mainScrollView.delegate=self;
    [self scrollViewDidScroll:mainScrollView];
}
-(void) viewDidAppear:(BOOL)animated{
    [mainScrollView setScrollEnabled:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dataSetup{
    is_other = NO;
}
-(void)viewsSetup{
    viewsArray = [NSMutableArray new];
    float viewWidth = mainScrollView.frame.size.width;
    float originX = 30;
    
    
    /*has ticket*/
    hasTicketView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    UIButton *shareRentButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 20, 150, 60)];
    [shareRentButton setTitle:@"已买机票" forState:UIControlStateNormal];
    [shareRentButton setTitleColor:SYColor1 forState:UIControlStateNormal];
    shareRentButton.tag = 11;
    [shareRentButton addTarget:self action:@selector(hasTicketResponse:) forControlEvents:UIControlEventTouchUpInside];
    [hasTicketView addSubview:shareRentButton];
    UIButton *soloRentButton = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth-originX-150, 20, 150, 60)];
    [soloRentButton setTitle:@"未买机票" forState:UIControlStateNormal];
    [soloRentButton setTitleColor:SYColor1 forState:UIControlStateNormal];
    soloRentButton.tag = 10;
    [soloRentButton addTarget:self action:@selector(hasTicketResponse:) forControlEvents:UIControlEventTouchUpInside];
    [hasTicketView addSubview:soloRentButton];
    
    /*flight view*/
    flightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    UILabel *flightTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 100, 40)];
    flightTitleLabel.text = @"航班号";
    flightTitleLabel.textColor = SYColor1;
    [flightView addSubview:flightTitleLabel];
    UITextField *flightTextfield = [[UITextField alloc] initWithFrame:CGRectMake(originX, 40, viewWidth-2*originX, 30)];
    flightTextfield.tag = 11;
    [flightTextfield addTarget:self action:@selector(flightEmptyCheck) forControlEvents:UIControlEventEditingChanged];
    flightTextfield.backgroundColor = [UIColor whiteColor];
    [flightView addSubview:flightTextfield];
    
    /*depart airport*/
    departAirportView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    UILabel *departAirportTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 200, 40)];
    departAirportTitleLabel.text = @"出发机场编码";
    departAirportTitleLabel.textColor = SYColor1;
    [departAirportView addSubview:departAirportTitleLabel];
    UITextField *departAirportTextfield = [[UITextField alloc] initWithFrame:CGRectMake(originX, 40, viewWidth-2*originX, 30)];
    departAirportTextfield.tag = 11;
    [departAirportTextfield addTarget:self action:@selector(deparrAirportEmptyCheck) forControlEvents:UIControlEventEditingChanged];
    departAirportTextfield.backgroundColor = [UIColor whiteColor];
    [departAirportView addSubview:departAirportTextfield];
    
    /*arrive airport*/
    arriveAirportView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    UILabel *arriveAirportTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 200, 40)];
    arriveAirportTitleLabel.text = @"到达机场编码";
    arriveAirportTitleLabel.textColor = SYColor1;
    [arriveAirportView addSubview:arriveAirportTitleLabel];
    UITextField *arriveAirportTextfield = [[UITextField alloc] initWithFrame:CGRectMake(originX, 40, viewWidth-2*originX, 30)];
    arriveAirportTextfield.tag = 11;
    [arriveAirportTextfield addTarget:self action:@selector(deparrAirportEmptyCheck) forControlEvents:UIControlEventEditingChanged];
    arriveAirportTextfield.backgroundColor = [UIColor whiteColor];
    [arriveAirportView addSubview:arriveAirportTextfield];
    
    /*depart city*/
    departCityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    departCityView.hidden = YES;
    UILabel *departCityTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 200, 40)];
    departCityTitleLabel.text = @"出发城市";
    departCityTitleLabel.textColor = SYColor1;
    [departCityView addSubview:departCityTitleLabel];
    UITextField *departCityTextfield = [[UITextField alloc] initWithFrame:CGRectMake(originX, 40, viewWidth-2*originX, 30)];
    departCityTextfield.tag = 11;
    [departCityTextfield addTarget:self action:@selector(deparrCityEmptyCheck) forControlEvents:UIControlEventEditingChanged];
    departCityTextfield.backgroundColor = [UIColor whiteColor];
    [departCityView addSubview:departCityTextfield];
    
    /*arrive city*/
    arriveCityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    arriveCityView.hidden = YES;
    UILabel *arriveCityTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 200, 40)];
    arriveCityTitleLabel.text = @"到达城市";
    arriveCityTitleLabel.textColor = SYColor1;
    [arriveCityView addSubview:arriveCityTitleLabel];
    UITextField *arriveCityTextfield = [[UITextField alloc] initWithFrame:CGRectMake(originX, 40, viewWidth-2*originX, 30)];
    arriveCityTextfield.tag = 11;
    [arriveCityTextfield addTarget:self action:@selector(deparrCityEmptyCheck) forControlEvents:UIControlEventEditingChanged];
    arriveCityTextfield.backgroundColor = [UIColor whiteColor];
    [arriveCityView addSubview:arriveCityTextfield];
    
    /*arrive city*/
    cityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    cityView.hidden = YES;
    UILabel *cityTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 200, 40)];
    cityTitleLabel.text = @"在美国的城市";
    cityTitleLabel.textColor = SYColor1;
    [cityView addSubview:cityTitleLabel];
    UITextField *cityTextfield = [[UITextField alloc] initWithFrame:CGRectMake(originX, 40, viewWidth-2*originX, 30)];
    cityTextfield.tag = 11;
    [cityTextfield addTarget:self action:@selector(cityEmptyCheck) forControlEvents:UIControlEventEditingChanged];
    cityTextfield.backgroundColor = [UIColor whiteColor];
    [cityView addSubview:cityTextfield];
    
    /*airport*/
    airportsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    airportsView.hidden = YES;
    UILabel *airportTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 100, 40)];
    airportTitleLabel.text = @"接机机场";
    airportTitleLabel.textColor = SYColor1;
    [airportsView addSubview:airportTitleLabel];
    UITextField *airportTextfield = [[UITextField alloc] initWithFrame:CGRectMake(originX, 40, viewWidth-2*originX, 30)];
    airportTextfield.tag = 11;
    [airportTextfield addTarget:self action:@selector(airportEmptyCheck) forControlEvents:UIControlEventEditingChanged];
    airportTextfield.backgroundColor = [UIColor whiteColor];
    [airportsView addSubview:airportTextfield];
    
    /*location*/
    locationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    locationView.hidden = YES;
    UILabel *locationTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 20, 100, 60)];
    locationTitleLabel.text = @"位置";
    locationTitleLabel.textColor = SYColor1;
    [locationView addSubview:locationTitleLabel];
    UIButton *locationButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 20, viewWidth-2*originX, 60)];
    locationButton.tag = 11;
    [locationButton setTitleColor:SYColor3 forState:UIControlStateNormal];
    [locationButton setTitleColor:SYColor1 forState:UIControlStateSelected];
    [locationButton setTitle:@"请选择位置" forState:UIControlStateNormal];
    [locationButton addTarget:self action:@selector(locationResponse) forControlEvents:UIControlEventTouchUpInside];
    locationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [locationView addSubview:locationButton];
    
    
    
    /*date*/
    dateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    dateView.hidden = YES;
    UILabel *dateTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 20, 100, 60)];
    dateTitleLabel.text = @"日期";
    dateTitleLabel.textColor = SYColor1;
    [dateView addSubview:dateTitleLabel];
    UIButton *dateButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 20, viewWidth-2*originX, 60)];
    [dateButton setTitle:@"请选择日期" forState:UIControlStateNormal];
    [dateButton setTitleColor:SYColor3 forState:UIControlStateNormal];
    [dateButton setTitleColor:SYColor1 forState:UIControlStateSelected];
    dateButton.tag = 11;
    dateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [dateButton addTarget:self action:@selector(dateResponse:) forControlEvents:UIControlEventTouchUpInside];
    [dateView addSubview:dateButton];
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216, self.view.frame.size.width, 216)];
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.datePickerMode = UIDatePickerModeDate;
    NSDate *currentDate = [NSDate date];
    [datePicker setDate:currentDate];
    [datePicker addTarget:self action:@selector(datePickerChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    datePicker.hidden = YES;
    confirmBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216-30, self.view.frame.size.width, 30)];
    confirmBackgroundView.hidden = YES;
    confirmBackgroundView.backgroundColor = [UIColor whiteColor];
    confirmBackgroundView.tag = 9013;
    [self.view addSubview:confirmBackgroundView];
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(confirmBackgroundView.frame.size.width-60, 0, 40, 30)];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:SYColor1 forState:UIControlStateNormal];
    //    [confirmButton.titleLabel setFont:goFont15S];
    [confirmButton addTarget:self action:@selector(pickerConfirmResponse) forControlEvents:UIControlEventTouchUpInside];
    [confirmBackgroundView addSubview:confirmButton];
    CALayer *layer = confirmBackgroundView.layer;
    layer.masksToBounds = NO;
    layer.shadowOffset = CGSizeMake(0, -2);
    layer.shadowColor = [UIColorFromRGB(0xBBBBBB) CGColor];
    layer.shadowRadius = 2;
    layer.shadowOpacity = .25f;
    layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
    
    /*keyword*/
    keywordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    keywordView.hidden = YES;
    UILabel *keywordTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 100, 40)];
    keywordTitleLabel.text = @"关键词";
    keywordTitleLabel.textColor = SYColor1;
    [keywordView addSubview:keywordTitleLabel];
    UITextField *keywordTextfield = [[UITextField alloc] initWithFrame:CGRectMake(originX, 40, viewWidth-2*originX, 30)];
    keywordTextfield.tag = 11;
    [keywordTextfield addTarget:self action:@selector(titleEmptyCheck) forControlEvents:UIControlEventEditingChanged];
    keywordTextfield.backgroundColor = [UIColor whiteColor];
    [keywordView addSubview:keywordTextfield];
    
    /*price*/
    priceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 140)];
    priceView.hidden = YES;
    UILabel *priceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 100, 60)];
    priceTitleLabel.text = @"价格";
    priceTitleLabel.textColor = SYColor1;
    [priceView addSubview:priceTitleLabel];
    SYPriceSlider *priceSlider = [[SYPriceSlider alloc] initWithFrame:CGRectMake(originX, 60, viewWidth-2*originX, 50) type:SYPriceSliderDouble];
    priceSlider.delegate = self;
    [priceView addSubview:priceSlider];
    lowerPriceString = @"100";
    upperPriceString = @"1000";
    
    nextButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 44)];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setBackgroundColor:SYColor4];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton.titleLabel setFont:SYFont20S];
    [nextButton addTarget:self action:@selector(nextResponse) forControlEvents:UIControlEventTouchUpInside];
    nextButton.layer.cornerRadius = nextButton.frame.size.height/2;
    nextButton.clipsToBounds = YES;
    nextButton.hidden = YES;
    
    
    
    
    
    switch (_controllerType) {
        case DiscoverTravelPartner:
            hasTicketView.hidden = NO;
            [mainScrollView addSubview:hasTicketView];
            [viewsArray addObject:hasTicketView];
            [mainScrollView addSubview:dateView];
            [viewsArray addObject:dateView];
            break;
        case DiscoverTravelDrive:
            locationView.hidden = NO;
            [mainScrollView addSubview:locationView];
            [viewsArray addObject:locationView];
            [mainScrollView addSubview:priceView];
            [viewsArray addObject:priceView];
            [mainScrollView addSubview:keywordView];
            [viewsArray addObject:keywordView];
            break;
        case DiscoverTravelCarpool:
            departCityView.hidden = NO; arriveCityView.hidden = NO;
            [mainScrollView addSubview:departCityView];
            [viewsArray addObject:departCityView];
            [mainScrollView addSubview:arriveCityView];
            [viewsArray addObject:arriveCityView];
            [mainScrollView addSubview:dateView];
            [viewsArray addObject:dateView];
            break;
        case DiscoverTravelPickup:
            airportsView.hidden = NO;
            [mainScrollView addSubview:airportsView];
            [viewsArray addObject:airportsView];
            [mainScrollView addSubview:priceView];
            [viewsArray addObject:priceView];
            break;
        case DiscoverTravelBuyCar:
            keywordView.hidden = NO;
            [mainScrollView addSubview:keywordView];
            [viewsArray addObject:keywordView];
            break;
        case DiscoverTravelRepair:
            keywordView.hidden = NO;
            [mainScrollView addSubview:keywordView];
            [viewsArray addObject:keywordView];
            break;
        case DiscoverTravelDeliver:
            cityView.hidden = NO;
            [mainScrollView addSubview:cityView];
            [viewsArray addObject:cityView];
            [mainScrollView addSubview:dateView];
            [viewsArray addObject:dateView];
            [mainScrollView addSubview:priceView];
            [viewsArray addObject:priceView];
            break;
        case DiscoverTravelOther:
            locationView.hidden = NO;
            [mainScrollView addSubview:locationView];
            [viewsArray addObject:locationView];
            [mainScrollView addSubview:keywordView];
            [viewsArray addObject:keywordView];

            break;
        default:
            break;
    }
    
    
    [mainScrollView addSubview:nextButton];
    [viewsArray addObject:nextButton];
    [self viewsLayout];
}

-(void)viewsLayout{
    float height = 20;
    for (UIView *view in viewsArray){
        CGRect frame = view.frame;
        frame.origin.y = height;
        [view setFrame:frame];
        height += frame.size.height;
    }
    mainScrollView.contentSize = CGSizeMake(0, height+20+44+10);
}

-(IBAction)hasTicketResponse:(id)sender{
    /*0 has ticket; 1 no ticket*/
    UIButton *button = sender;
    if (button.tag-10) {
        ticketString = @"01";
        [button setTitleColor:SYColor1 forState:UIControlStateNormal];
        UIButton *button2 = [hasTicketView viewWithTag:10];
        [button2 setTitleColor:SYColor3 forState:UIControlStateNormal];
        [departAirportView removeFromSuperview];
        [arriveAirportView removeFromSuperview];
        [viewsArray removeObject:departAirportView];
        [viewsArray removeObject:arriveAirportView];
        [viewsArray removeObject:flightView];
        [mainScrollView addSubview:flightView];
        [viewsArray insertObject:flightView atIndex:1];
        
    }
    else{
        ticketString = @"02";
        [button setTitleColor:SYColor1 forState:UIControlStateNormal];
        UIButton *button2 = [hasTicketView viewWithTag:11];
        [button2 setTitleColor:SYColor3 forState:UIControlStateNormal];
        [viewsArray removeObject:flightView];
        [flightView removeFromSuperview];
        [mainScrollView addSubview:departAirportView];
        [viewsArray insertObject:departAirportView atIndex:1];
        [mainScrollView addSubview:arriveAirportView];
        [viewsArray insertObject:arriveAirportView atIndex:2];
        
    }
    [self viewsLayout];
    
}
-(IBAction)dateResponse:(id)sender{
    if (!dateString) {
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dtrDate = [dateFormatter stringFromDate:currentDate];
        UIButton *button = [dateView viewWithTag:11];
        button.selected = YES;
        [button setTitle:dtrDate forState:UIControlStateSelected];
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:dtrDate, @"available_date", nil];
        [_shareDict addEntriesFromDictionary:dict];
        dateString = dtrDate;
    }
    datePicker.hidden = NO;
    confirmBackgroundView.hidden = NO;
    locationView.hidden = NO;
    switch (_controllerType) {
        case DiscoverTravelPartner:
            nextButton.hidden = NO;
            break;
        case DiscoverTravelCarpool:
            nextButton.hidden = NO;
            break;
        case DiscoverTravelDeliver:
            priceView.hidden = NO;
            nextButton.hidden = NO;
            break;
            
        default:
            break;
    }
}
-(void)datePickerChanged{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dtrDate = [dateFormatter stringFromDate:datePicker.date];
    UIButton *button = [dateView viewWithTag:11];
    [button setTitle:dtrDate forState:UIControlStateSelected];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:dtrDate, @"available_date", nil];
    [_shareDict addEntriesFromDictionary:dict];
    dateString = dtrDate;
}

-(void)locationResponse{
    [self dismissKeyboard];
    [self pickerConfirmResponse];
    
    DiscoverLocationViewController *viewController = [DiscoverLocationViewController new];
    viewController.previousController = self;
    viewController.nextControllerType = SYDiscoverNextShareLearn;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)locationCompleteResponse{
    UIButton *locationButton = [locationView viewWithTag:11];
    locationButton.selected = YES;
    [locationButton setTitle:[[[_selectedItem placemark] addressDictionary] valueForKey:@"Street"] forState:UIControlStateSelected];
    switch (_controllerType) {
        case DiscoverTravelDrive:
            priceView.hidden = NO;
            keywordView.hidden = NO;
            break;
        case DiscoverTravelOther:
            keywordView.hidden = NO;
            break;
            
        default:
            break;
    }
    
    
}
- (void)pickerConfirmResponse{
    confirmBackgroundView.hidden = YES;
    datePicker.hidden = YES;
}
-(void)nextResponse{
    NSString *subCate;
    NSString *latitude;
    NSString *longitude;
    NSString *expireDate;
    UITextField *flight = [flightView viewWithTag:11];
    UITextField *departAirport = [departAirportView viewWithTag:11];
    UITextField *arriveAirport = [arriveAirportView viewWithTag:11];
    UITextField *departCity = [departCityView viewWithTag:11];
    UITextField *arriveCity = [arriveCityView viewWithTag:11];
    UITextField *airport = [airportsView viewWithTag:11];
    UITextField *city = [cityView viewWithTag:11];
    UITextField *keyword = [keywordView viewWithTag:11];
    
    NSString *requestBody;
    
    switch (_controllerType) {
        case DiscoverTravelPartner:
            subCate= [NSString stringWithFormat:@"01%@0000",ticketString];
            latitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
            longitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.longitude];
            expireDate = ([ticketString isEqualToString:@"01"])?dateString:@"2099-01-01";
            if ([ticketString isEqualToString:@"01"]) {
                requestBody = [NSString stringWithFormat:@"expire_date=%@&email=%@&latitude=%@&longitude=%@&category=5&subcate=%@&date=%@&flight=%@",expireDate,MEID,latitude,longitude,subCate,dateString,flight.text];
            }
            else
                requestBody = [NSString stringWithFormat:@"expire_date=%@&email=%@&latitude=%@&longitude=%@&category=5&subcate=%@&date=%@&depart=%@&arrive=%@",expireDate,MEID,latitude,longitude,subCate,expireDate,departAirport.text,arriveAirport.text];
            
            break;
        case DiscoverTravelDrive:
            subCate=@"02000000";
            requestBody = [NSString stringWithFormat:@"expire_date=2099-01-01&email=%@&latitude=%f&longitude=%f&category=5&subcate=%@&keyword=%@&lower_price=%@&upper_price=%@",MEID,[[_selectedItem placemark] coordinate].latitude,[[_selectedItem placemark] coordinate].longitude,subCate,keyword.text,lowerPriceString,upperPriceString];
            break;
        case DiscoverTravelCarpool:
            subCate=@"03000000";
            latitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
            longitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.longitude];
            requestBody = [NSString stringWithFormat:@"expire_date=%@&email=%@&latitude=%@&longitude=%@&category=5&subcate=%@&date=%@&depart=%@&arrive=%@",dateString,MEID,latitude,longitude,subCate,dateString, departCity.text,arriveCity.text];
            break;
        case DiscoverTravelPickup:
            subCate=@"04000000";
            latitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
            longitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.longitude];
            requestBody = [NSString stringWithFormat:@"expire_date=2099-01-01&email=%@&latitude=%@&longitude=%@&category=5&subcate=%@&airport=%@&lower_price=%@&upper_price=%@",MEID,latitude,longitude,subCate,airport.text,lowerPriceString,upperPriceString];
            break;
        case DiscoverTravelBuyCar:
            subCate=@"05030000";
            latitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
            longitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.longitude];
            requestBody = [NSString stringWithFormat:@"expire_date=2099-01-01&email=%@&latitude=%@&longitude=%@&category=5&subcate=%@&keyword=%@",MEID,latitude,longitude,subCate,keyword.text];
            break;
        case DiscoverTravelRepair:
            subCate=@"06000000";
            requestBody = [NSString stringWithFormat:@"expire_date=2099-01-01&email=%@&latitude=%f&longitude=%f&category=5&subcate=%@&keyword=%@",MEID,[[_selectedItem placemark] coordinate].latitude,[[_selectedItem placemark] coordinate].longitude,subCate,keyword.text];
            break;
        case DiscoverTravelDeliver:
            subCate=@"07000000";
            latitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
            longitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.longitude];
            requestBody = [NSString stringWithFormat:@"expire_date=2099-01-01&email=%@&latitude=%@&longitude=%@&category=5&subcate=%@&airport=%@&lower_price=%@&upper_price=%@&date=%@",MEID,latitude,longitude,subCate,city.text,lowerPriceString,upperPriceString,dateString];
            break;
        case DiscoverTravelOther:
            subCate=@"99000000";
            requestBody = [NSString stringWithFormat:@"expire_date=2099-01-01&email=%@&latitude=%f&longitude=%f&category=5&subcate=%@&keyword=%@&is_other=1",MEID,[[_selectedItem placemark] coordinate].latitude,[[_selectedItem placemark] coordinate].longitude,subCate,keyword.text];
            break;
            
            
        default:
            break;
    }
    
    
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

-(void)titleEmptyCheck{
    UITextField *textField = [keywordView viewWithTag:11];
    if ([textField.text length]) {
        nextButton.hidden = NO;
        
    }
}
-(void)flightEmptyCheck{
    UITextField *textField = [flightView viewWithTag:11];
    if ([textField.text length]) {
        dateView.hidden = NO;
    }
}
-(void)cityEmptyCheck{
    UITextField *textField = [cityView viewWithTag:11];
    if ([textField.text length]) {
        dateView.hidden = NO;
    }
}
-(void)airportEmptyCheck{
    UITextField *textField = [airportsView viewWithTag:11];
    if ([textField.text length]) {
        priceView.hidden = NO;
        nextButton.hidden = NO;
    }
}
-(void)deparrAirportEmptyCheck{
    UITextField *textField1 = [departAirportView viewWithTag:11];
    UITextField *textField2 = [arriveAirportView viewWithTag:11];
    if ([textField1.text length]&&[textField2.text length]) {
        nextButton.hidden = NO;
    }
}
-(void)deparrCityEmptyCheck{
    UITextField *textField1 = [departCityView viewWithTag:11];
    UITextField *textField2 = [arriveCityView viewWithTag:11];
    if ([textField1.text length]&&[textField2.text length]) {
        dateView.hidden = NO;
    }
}
-(void)textViewDidChange:(UITextView *)textView{
    if ([textView.text length]) {
        nextButton.hidden = NO;
    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text length]) {
        nextButton.hidden = NO;
    }
}
-(void)dismissKeyboard {
    UITextField *textField = [keywordView viewWithTag:11];
    [textField resignFirstResponder];
    textField = [flightView viewWithTag:11];
    [textField resignFirstResponder];
}



- (void)priceSlider:(UISlider *)slider priceChangeToValue:(NSInteger)price{
    
}
-(void)lowerPriceChangeToValue:(NSInteger)lowerPrice upperToValue:(NSInteger)upperPrice{
    lowerPriceString = [NSString stringWithFormat:@"%ld",lowerPrice];
    upperPriceString = [NSString stringWithFormat:@"%ld",upperPrice];
}


@end
