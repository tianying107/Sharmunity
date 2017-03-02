//
//  DiscoverTravelShareSecondViewController.m
//  Sharmunity
//
//  Created by Star Chen on 2/15/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import "DiscoverTravelShareSecondViewController.h"
#import "DiscoverLocationViewController.h"
#import "Header.h"
#import "SYHeader.h"
@interface DiscoverTravelShareSecondViewController ()<SYPriceSliderDelegate>{
    SYPopOut *popOut;
}

@end

@implementation DiscoverTravelShareSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (_controllerType) {
        case DiscoverTravelPartner:
            self.navigationItem.title = @"找飞伴";
            break;
        case DiscoverTravelDrive:
            self.navigationItem.title = @"教车考证";
            break;
        case DiscoverTravelCarpool:
            self.navigationItem.title = @"搭车帮助";
            break;
        case DiscoverTravelBuyCar:
            self.navigationItem.title = @"买卖车帮助";
            break;
        case DiscoverTravelPickup:
            self.navigationItem.title = @"接机帮助";
            break;
        case DiscoverTravelDeliver:
            self.navigationItem.title = @"捎带帮助";
            break;
            
        default:
            break;
    }
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
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"SYBackColor4"] forState:UIControlStateNormal];
    [backBtn setTitle:@"行" forState:UIControlStateNormal];
    [backBtn setTitleColor:SYColor1 forState:UIControlStateNormal];
    [backBtn.titleLabel setFont:SYFont15];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backBtn.bounds = CGRectMake(0, 0, 80, 40);
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
}
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
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
    float originX = 40;
    
    
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
    departCityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 60)];
    departCityView.hidden = YES;
    SYTextField *departCityTextfield = [[SYTextField alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 40) type:SYTextFieldShare];
    departCityTextfield.tag = 11;
    departCityTextfield.placeholder = @"出发地点";
    [departCityTextfield addTarget:self action:@selector(deparrCityEmptyCheck) forControlEvents:UIControlEventEditingChanged];
    departCityTextfield.backgroundColor = [UIColor whiteColor];
    [departCityView addSubview:departCityTextfield];
    
    /*arrive city*/
    arriveCityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 60)];
    arriveCityView.hidden = YES;
    SYTextField *arriveCityTextfield = [[SYTextField alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 40) type:SYTextFieldShare];
    arriveCityTextfield.placeholder = @"到达地点";
    arriveCityTextfield.tag = 11;
    [arriveCityTextfield addTarget:self action:@selector(deparrCityEmptyCheck) forControlEvents:UIControlEventEditingChanged];
    arriveCityTextfield.backgroundColor = [UIColor whiteColor];
    [arriveCityView addSubview:arriveCityTextfield];
    
    /*city*/
    cityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 160)];
    cityView.hidden = YES;
    UILabel *cityTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 20)];
    cityTitleLabel.text = @"去往方向";
    cityTitleLabel.textAlignment = NSTextAlignmentCenter;
    [cityTitleLabel setFont:SYFont20];
    cityTitleLabel.textColor = SYColor1;
    [cityView addSubview:cityTitleLabel];
    UIImageView *directImageView = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth/2-77, 30+2, 154, 36)];
    directImageView.image = [UIImage imageNamed:@"tavelDeliverShare"];
    [cityView addSubview:directImageView];
    UIView *checkUSView = [[UIView alloc] initWithFrame:CGRectMake(directImageView.frame.origin.x-40-15-20, 30+12.5, 15, 15)];
    checkUSView.tag = 11;
    checkUSView.layer.borderWidth = 1;
    checkUSView.layer.borderColor = [SYColor1 CGColor];
    [cityView addSubview:checkUSView];
    UILabel *USLabel = [[UILabel alloc] initWithFrame:CGRectMake(checkUSView.frame.origin.x+checkUSView.frame.size.width+4, 30, 40, 40)];
    USLabel.text = @"美国";
    USLabel.textColor = SYColor1;
    [USLabel setFont:SYFont20];
    [cityView addSubview:USLabel];
    UIButton *usDirectButton = [[UIButton alloc] initWithFrame:CGRectMake(checkUSView.frame.origin.x, 30, 60, 40)];
    usDirectButton.tag = 21;
    [usDirectButton addTarget:self action:@selector(delieverDirectResponse:) forControlEvents:UIControlEventTouchUpInside];
    [cityView addSubview:usDirectButton];
    UIView *checkCNView = [[UIView alloc] initWithFrame:CGRectMake(directImageView.frame.origin.x+directImageView.frame.size.width+16, 12.5+30, 15, 15)];
    checkCNView.tag = 12;
    checkCNView.layer.borderWidth = 1;
    checkCNView.layer.borderColor = [SYColor1 CGColor];
    [cityView addSubview:checkCNView];
    UILabel *cnLabel = [[UILabel alloc] initWithFrame:CGRectMake(checkCNView.frame.origin.x+checkCNView.frame.size.width+4, 30, 40, 40)];
    cnLabel.text = @"中国";
    cnLabel.textColor = SYColor1;
    [cnLabel setFont:SYFont20];
    [cityView addSubview:cnLabel];
    UIButton *cnDirectButton = [[UIButton alloc] initWithFrame:CGRectMake(checkCNView.frame.origin.x, 30, 60, 40)];
    cnDirectButton.tag = 22;
    [cnDirectButton addTarget:self action:@selector(delieverDirectResponse:) forControlEvents:UIControlEventTouchUpInside];
    [cityView addSubview:cnDirectButton];
    SYTextField *cityTextfield = [[SYTextField alloc] initWithFrame:CGRectMake(viewWidth/2-110-35, 80, 110, 40) type:SYTextFieldShare];
    cityTextfield.tag = 13;
    cityTextfield.placeholder = @"美国城市";
    [cityView addSubview:cityTextfield];
    SYTextField *cnCityTextfield = [[SYTextField alloc] initWithFrame:CGRectMake(viewWidth/2+35, 80, 110, 40) type:SYTextFieldShare];
    cnCityTextfield.tag = 14;
    cnCityTextfield.placeholder = @"中国城市";
    [cityView addSubview:cnCityTextfield];
    
    
    /*date*/
    dateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    dateView.hidden = YES;
    UILabel *dateTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 100, 40)];
    dateTitleLabel.text = @"出发日期";
    dateTitleLabel.textColor = SYColor1;
    [dateTitleLabel setFont:SYFont20];
    [dateView addSubview:dateTitleLabel];
    UIButton *dateButton = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth/2+10, 0, viewWidth-2*originX, 40)];
    [dateButton setTitle:@"请选择日期" forState:UIControlStateNormal];
    [dateButton setTitleColor:SYColor9 forState:UIControlStateNormal];
    [dateButton setTitleColor:SYColor1 forState:UIControlStateSelected];
    [dateButton.titleLabel setFont:SYFont20];
    dateButton.tag = 11;
    dateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [dateButton addTarget:self action:@selector(dateResponse:) forControlEvents:UIControlEventTouchUpInside];
    [dateView addSubview:dateButton];
    
    /*airport*/
    airportsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 180)];
    airportsView.hidden = YES;
    SYTextField *airport1Textfield = [[SYTextField alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 40) type:SYTextFieldShare];
    airport1Textfield.tag = 11;
    airport1Textfield.placeholder = @"接机机场编号1";
    [airportsView addSubview:airport1Textfield];
    SYTextField *airport2Textfield = [[SYTextField alloc] initWithFrame:CGRectMake(originX, 60, viewWidth-2*originX, 40) type:SYTextFieldShare];
    airport2Textfield.tag = 12;
    airport2Textfield.placeholder = @"接机机场编号2";
    [airportsView addSubview:airport2Textfield];
    SYTextField *airport3Textfield = [[SYTextField alloc] initWithFrame:CGRectMake(originX, 120, viewWidth-2*originX, 40) type:SYTextFieldShare];
    airport3Textfield.tag = 13;
    airport3Textfield.placeholder = @"接机机场编号3";
    [airportsView addSubview:airport3Textfield];
    
    /*person view*/
    personView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 135)];
    personView.hidden = YES;
    UILabel *avatarLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX+10, 0, 80, 100)];
    avatarLabel.text = @"请上传本人照片";
    avatarLabel.textAlignment = NSTextAlignmentCenter;
    avatarLabel.textColor = SYColor4;
    [avatarLabel setFont:SYFont15];
    avatarLabel.numberOfLines = 0;
    [personView addSubview:avatarLabel];
    UIButton *avatarButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 0, 100, 100)];
    avatarButton.layer.cornerRadius = 6;
    avatarButton.clipsToBounds = YES;
    avatarButton.layer.borderColor = [SYSeparatorColor CGColor];
    avatarButton.layer.borderWidth = 1;
    [personView addSubview:avatarButton];
    SYTextField *nameTextfield = [[SYTextField alloc] initWithFrame:CGRectMake(originX+avatarButton.frame.size.width+30, 15, viewWidth-2*originX-avatarButton.frame.size.width-30, 40) type:SYTextFieldShare];
    nameTextfield.placeholder = @"真实姓名";
    nameTextfield.tag = 11;
    [personView addSubview:nameTextfield];
    SYTextField *genderTextfield = [[SYTextField alloc] initWithFrame:CGRectMake(nameTextfield.frame.origin.x, 75, (nameTextfield.frame.size.width-15)/2, 25) type:SYTextFieldShare];
    genderTextfield.placeholder = @"性别";
    genderTextfield.tag = 12;
    [personView addSubview:genderTextfield];
    SYTextField *ageTextfield = [[SYTextField alloc] initWithFrame:CGRectMake(viewWidth-originX-(nameTextfield.frame.size.width-15)/2, 75, (nameTextfield.frame.size.width-15)/2, 25) type:SYTextFieldShare];
    ageTextfield.placeholder = @"年龄";
    ageTextfield.tag = 13;
    [personView addSubview:ageTextfield];

    /*time view*/
    timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 50)];
    timeView.hidden = YES;
    UILabel *driveTimeLabel = [UILabel new];
    driveTimeLabel.text = @"美国驾龄";
    driveTimeLabel.textColor = SYColor1;
    [driveTimeLabel setFont:SYFont20];
    [driveTimeLabel sizeToFit];
    driveTimeLabel.frame = CGRectMake(originX, 0, driveTimeLabel.frame.size.width, 40);
    [timeView addSubview:driveTimeLabel];
    SYTextField *driveTextfield = [[SYTextField alloc] initWithFrame:CGRectMake(driveTimeLabel.frame.size.width+driveTimeLabel.frame.origin.x+4, 7.5, 40, 25) type:SYTextFieldShare];
    driveTextfield.tag = 11;
    [timeView addSubview:driveTextfield];
    UILabel *yearLabel = [UILabel new];
    yearLabel.text = @"年";
    yearLabel.textColor = SYColor1;
    [yearLabel setFont:SYFont20];
    [yearLabel sizeToFit];
    yearLabel.frame = CGRectMake(driveTextfield.frame.origin.x+driveTextfield.frame.size.width+4, 0, yearLabel.frame.size.width, 40);
    [timeView addSubview:yearLabel];
    if (_controllerType==DiscoverTravelDrive) {
        UILabel *teachTimeLabel = [UILabel new];
        teachTimeLabel.text = @"教龄";
        teachTimeLabel.textColor = SYColor1;
        [teachTimeLabel setFont:SYFont20];
        [teachTimeLabel sizeToFit];
        teachTimeLabel.frame = CGRectMake(yearLabel.frame.origin.x+yearLabel.frame.size.width+30, 0, teachTimeLabel.frame.size.width, 40);
        [timeView addSubview:teachTimeLabel];
        SYTextField *teachTextfield = [[SYTextField alloc] initWithFrame:CGRectMake(teachTimeLabel.frame.size.width+teachTimeLabel.frame.origin.x+4, 7.5, 40, 25) type:SYTextFieldShare];
        teachTextfield.tag = 12;
        [timeView addSubview:teachTextfield];
        UILabel *monthLabel = [UILabel new];
        monthLabel.text = @"月";
        monthLabel.textColor = SYColor1;
        [monthLabel setFont:SYFont20];
        [monthLabel sizeToFit];
        monthLabel.frame = CGRectMake(teachTextfield.frame.origin.x+teachTextfield.frame.size.width+4, 0, monthLabel.frame.size.width, 40);
        [timeView addSubview:monthLabel];
    }
    
    
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
    
    /*title*/
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    titleView.hidden = YES;
    SYTextField *textfield = [[SYTextField alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 40) type:SYTextFieldShare];
    textfield.tag = 11;
    [textfield addTarget:self action:@selector(titleEmptyCheck) forControlEvents:UIControlEventEditingChanged];
    textfield.backgroundColor = [UIColor whiteColor];
    [titleView addSubview:textfield];
    
    /*introduction*/
    introductionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 110)];
    introductionView.hidden = YES;
    SYTextView *textView = [[SYTextView alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 75) type:SYTextViewShare];
    textView.tag = 11;
    [introductionView addSubview:textView];
    
    /*price*/
    priceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 80)];
    priceView.hidden = YES;
    UILabel *priceTitleLabel = [[UILabel alloc] init];
    priceTitleLabel.text = @"教车价格";
    [priceTitleLabel setFont:SYFont20];
    priceTitleLabel.textColor = SYColor1;
    [priceTitleLabel sizeToFit];
    priceTitleLabel.frame = CGRectMake(originX, 0, priceTitleLabel.frame.size.width, 40);
    [priceView addSubview:priceTitleLabel];
    UITextField *priceTextField = [[UITextField alloc] initWithFrame:CGRectMake(priceTitleLabel.frame.size.width+priceTitleLabel.frame.origin.x+4, 7.5, 70, 25)];
    priceTextField.textColor = SYColor1;
    [priceTextField setFont:SYFont20];
    priceTextField.tag = 11;
    priceTextField.keyboardType = UIKeyboardTypeNumberPad;
    priceTextField.backgroundColor = UIColorFromRGB(0xF6EDBE);
    priceTextField.layer.cornerRadius = 6;
    priceTextField.clipsToBounds = YES;
    [priceView addSubview:priceTextField];
    UILabel *teachUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(priceTextField.frame.size.width+priceTextField.frame.origin.x+4, 0, 130, 40)];
    teachUnitLabel.text = @"美元/1小时";
    teachUnitLabel.textColor = SYColor1;
    [teachUnitLabel setFont:SYFont20];
    [priceView addSubview:teachUnitLabel];
//    priceString = @"150";
    
    /*price2*/
    price2View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 60)];
    price2View.hidden = YES;
    UILabel *price2TitleLabel = [[UILabel alloc] init];
    price2TitleLabel.text = @"费用";
    [price2TitleLabel setFont:SYFont20];
    price2TitleLabel.textColor = SYColor1;
    [price2TitleLabel sizeToFit];
    price2TitleLabel.frame = CGRectMake(originX, 0, price2TitleLabel.frame.size.width, 40);
    [price2View addSubview:price2TitleLabel];
    UITextField *price2TextField = [[UITextField alloc] initWithFrame:CGRectMake(price2TitleLabel.frame.size.width+price2TitleLabel.frame.origin.x+4, 7.5, 57, 25)];
    price2TextField.textColor = SYColor1;
    [price2TextField setFont:SYFont20];
    price2TextField.textAlignment = NSTextAlignmentCenter;
    price2TextField.tag = 11;
    price2TextField.keyboardType = UIKeyboardTypeNumberPad;
    price2TextField.backgroundColor = UIColorFromRGB(0xF6EDBE);
    price2TextField.layer.cornerRadius = 6;
    price2TextField.clipsToBounds = YES;
    //    [price2TextField addTarget:self action:@selector(priceEmptyCheck) forControlEvents:UIControlEventEditingChanged];
    [price2View addSubview:price2TextField];
    priceString = @"0";
    UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(price2TextField.frame.size.width+price2TextField.frame.origin.x+4, 0, 85, 40)];
    unitLabel.text = @"美元";
    unitLabel.textColor = SYColor1;
    [unitLabel setFont:SYFont20];
    [price2View addSubview:unitLabel];
    priceAgg = NO;
    UIView *checkView = [[UIView alloc] initWithFrame:CGRectMake(unitLabel.frame.origin.x+unitLabel.frame.size.width, 12.5, 15, 15)];
    checkView.tag = 12;
    checkView.layer.borderWidth = 1;
    checkView.layer.borderColor = [SYColor1 CGColor];
    [price2View addSubview:checkView];
    UILabel *meetLabel = [[UILabel alloc] initWithFrame:CGRectMake(checkView.frame.origin.x+checkView.frame.size.width+4, 0, 60, 40)];
    meetLabel.text = @"面议";
    meetLabel.textColor = SYColor1;
    [meetLabel setFont:SYFont20];
    [price2View addSubview:meetLabel];
    UIButton *priceAggButton = [[UIButton alloc] initWithFrame:CGRectMake(checkView.frame.origin.x, 0, 60, 40)];
    [priceAggButton addTarget:self action:@selector(priceAggResponse) forControlEvents:UIControlEventTouchUpInside];
    [price2View addSubview:priceAggButton];
    
    /*price3*/
    price3View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 60)];
    priceFree = NO;
    UIView *check1View = [[UIView alloc] initWithFrame:CGRectMake(viewWidth/2-100, 12.5, 15, 15)];
    check1View.tag = 11;
    check1View.layer.borderWidth = 1;
    check1View.layer.borderColor = [SYColor1 CGColor];
    [price3View addSubview:check1View];
    UILabel *chargeLabel = [[UILabel alloc] initWithFrame:CGRectMake(check1View.frame.origin.x+check1View.frame.size.width+4, 0, 60, 40)];
    chargeLabel.text = @"收费";
    chargeLabel.textColor = SYColor1;
    [chargeLabel setFont:SYFont20];
    [price3View addSubview:chargeLabel];
    UIButton *priceChargeButton = [[UIButton alloc] initWithFrame:CGRectMake(check1View.frame.origin.x, 0, 60, 40)];
    priceChargeButton.tag = 21;
    [priceChargeButton addTarget:self action:@selector(priceFreeResponse:) forControlEvents:UIControlEventTouchUpInside];
    [price3View addSubview:priceChargeButton];
    UIView *check2View = [[UIView alloc] initWithFrame:CGRectMake(viewWidth/2+15, 12.5, 15, 15)];
    check2View.tag = 12;
    check2View.layer.borderWidth = 1;
    check2View.layer.borderColor = [SYColor1 CGColor];
    [price3View addSubview:check2View];
    UILabel *freeLabel = [[UILabel alloc] initWithFrame:CGRectMake(check2View.frame.origin.x+check2View.frame.size.width+4, 0, 60, 40)];
    freeLabel.text = @"免费";
    freeLabel.textColor = SYColor1;
    [freeLabel setFont:SYFont20];
    [price3View addSubview:freeLabel];
    UIButton *priceFreeButton = [[UIButton alloc] initWithFrame:CGRectMake(check2View.frame.origin.x, 0, 60, 40)];
    priceFreeButton.tag = 22;
    [priceFreeButton addTarget:self action:@selector(priceFreeResponse:) forControlEvents:UIControlEventTouchUpInside];
    [price3View addSubview:priceFreeButton];
    
    originX = 90;
    nextButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 35)];
    [nextButton setTitle:@"提交" forState:UIControlStateNormal];
    [nextButton setBackgroundColor:SYColor4];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton.titleLabel setFont:SYFont20M];
    [nextButton addTarget:self action:@selector(nextResponse) forControlEvents:UIControlEventTouchUpInside];
    nextButton.layer.cornerRadius = 8;
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
            personView.hidden = NO; timeView.hidden = NO;
            priceView.hidden = NO; titleView.hidden = NO;
            [mainScrollView addSubview:personView];
            [viewsArray addObject:personView];
            [mainScrollView addSubview:timeView];
            [viewsArray addObject:timeView];
            [mainScrollView addSubview:priceView];
            [viewsArray addObject:priceView];
            [mainScrollView addSubview:titleView];
            [viewsArray addObject:titleView];
            textfield.placeholder = @"车辆信息（选填）";
            nextButton.hidden = NO;
//            [mainScrollView addSubview:introductionView];
//            [viewsArray addObject:introductionView];
            break;
        case DiscoverTravelCarpool:
            departCityView.hidden = NO; arriveCityView.hidden = NO;
            price3View.hidden = NO;  titleView.hidden = NO;
            [mainScrollView addSubview:departCityView];
            [viewsArray addObject:departCityView];
            [mainScrollView addSubview:arriveCityView];
            [viewsArray addObject:arriveCityView];
            [mainScrollView addSubview:price3View];
            [viewsArray addObject:price3View];
            [mainScrollView addSubview:titleView];
            [viewsArray addObject:titleView];
            textfield.placeholder = @"车辆信息（选填）";
            nextButton.hidden = NO;
//            [mainScrollView addSubview:dateView];
//            [viewsArray addObject:dateView];
            break;
        case DiscoverTravelPickup:
            airportsView.hidden = NO;
            price3View.hidden = NO;  titleView.hidden = NO;
            
            [mainScrollView addSubview:airportsView];
            [viewsArray addObject:airportsView];
            [mainScrollView addSubview:price3View];
            [viewsArray addObject:price3View];
            [mainScrollView addSubview:titleView];
            [viewsArray addObject:titleView];
            textfield.placeholder = @"车辆信息（选填）";
            nextButton.hidden = NO;
            
//            [mainScrollView addSubview:priceView];
//            [viewsArray addObject:priceView];
            break;
        case DiscoverTravelBuyCar:
            personView.hidden = NO; timeView.hidden = NO;
            price2View.hidden = NO; introductionView.hidden = NO;
            [mainScrollView addSubview:personView];
            [viewsArray addObject:personView];
            [mainScrollView addSubview:timeView];
            [viewsArray addObject:timeView];
            [mainScrollView addSubview:price2View];
            [viewsArray addObject:price2View];
            [mainScrollView addSubview:introductionView];
            [viewsArray addObject:introductionView];
            [textView setPlaceholder:@"经验描述（选填）"];
            nextButton.hidden = NO;
//            titleView.hidden = NO;
//            [mainScrollView addSubview:titleView];
//            [viewsArray addObject:titleView];
//            [mainScrollView addSubview:introductionView];
//            [viewsArray addObject:introductionView];
            break;
        case DiscoverTravelRepair:
            titleView.hidden = NO;
            [mainScrollView addSubview:titleView];
            [viewsArray addObject:titleView];
            [mainScrollView addSubview:introductionView];
            [viewsArray addObject:introductionView];
            break;
        case DiscoverTravelDeliver:
            cityView.hidden = NO;dateView.hidden = NO;
            [mainScrollView addSubview:cityView];
            [viewsArray addObject:cityView];
            [mainScrollView addSubview:dateView];
            [viewsArray addObject:dateView];
//            [mainScrollView addSubview:priceView];
//            [viewsArray addObject:priceView];
            nextButton.hidden = NO;
            break;
        case DiscoverTravelOther:
            locationView.hidden = NO;
            [mainScrollView addSubview:locationView];
            [viewsArray addObject:locationView];
            [mainScrollView addSubview:titleView];
            [viewsArray addObject:titleView];
            [mainScrollView addSubview:introductionView];
            [viewsArray addObject:introductionView];
            break;
        default:
            break;
    }
    
    
    [mainScrollView addSubview:nextButton];
    [viewsArray addObject:nextButton];
    [self viewsLayout];
}

-(void)viewsLayout{
    float height = 30;
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
    [self dismissKeyboard];
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
            titleView.hidden = NO;
            break;
        case DiscoverTravelOther:
            titleView.hidden = NO;
            break;
            
        default:
            break;
    }
    
    
}
- (void)pickerConfirmResponse{
    confirmBackgroundView.hidden = YES;
    datePicker.hidden = YES;
}
-(void)priceAggResponse{
    UIView *checkView = [price2View viewWithTag:12];
    priceAgg = !priceAgg;
    checkView.backgroundColor = (priceAgg)?SYColor4:[UIColor clearColor];
}
-(IBAction)priceFreeResponse:(id)sender{
    UIButton *button = (UIButton*)sender;
    UIView *check1View = [price3View viewWithTag:11];
    UIView *check2View = [price3View viewWithTag:12];
    priceFree = (button.tag==21)?NO:YES;
    check1View.backgroundColor = (!priceFree)?SYColor4:[UIColor clearColor];
    check2View.backgroundColor = (priceFree)?SYColor4:[UIColor clearColor];
}
-(IBAction)delieverDirectResponse:(id)sender{
    UIButton *button = (UIButton*)sender;
    UIView *check1View = [cityView viewWithTag:11];
    UIView *check2View = [cityView viewWithTag:12];
    toCN = (button.tag==21)?NO:YES;
    check1View.backgroundColor = (!toCN)?SYColor4:[UIColor clearColor];
    check2View.backgroundColor = (toCN)?SYColor4:[UIColor clearColor];
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
    UITextField *airport1 = [airportsView viewWithTag:11];
    UITextField *airport2 = [airportsView viewWithTag:12];
    UITextField *airport3 = [airportsView viewWithTag:13];
    UITextField *city = [cityView viewWithTag:13];
    UITextField *cnCity = [cityView viewWithTag:14];
    UITextField *title = [titleView viewWithTag:11];
    UITextView *introduction = [introductionView viewWithTag:11];
    
    UITextView *price1 = [priceView viewWithTag:11];
    UITextView *price2 = [price2View viewWithTag:11];
    UITextView *name = [personView viewWithTag:11];
    UITextView *gender = [personView viewWithTag:12];
    UITextView *age = [personView viewWithTag:13];
    UITextView *driveTime = [timeView viewWithTag:11];
    UITextView *teachTime = [timeView viewWithTag:12];
    
    NSString *airportString;
    if ([airport1.text isEqualToString:@""])
        return;
    else{
        airportString = airport1.text;
        if ([airport2.text isEqualToString:@""])
            return;
        else{
            airportString = [NSString stringWithFormat:@"%@,%@",airportString,airport2.text];
            if ([airport3.text isEqualToString:@""])
                return;
            else
                airportString = [NSString stringWithFormat:@"%@,%@",airportString,airport3.text];
        }
    }
    NSString *requestBody;
//    = [NSString stringWithFormat:@"expire_date=%@&email=%@&latitude=%f&longitude=%f&category=3&subcate=%@&title=%@&introduction=%@&start_lati=%@&start_long=%@&price=%@",dateString,MEID,[[_selectedItem placemark] coordinate].latitude,[[_selectedItem placemark] coordinate].longitude,subCate,title.text, introduction.text,startLatitude,startLongitude,priceString];
    
    switch (_controllerType) {
        case DiscoverTravelPartner:
            subCate= [NSString stringWithFormat:@"01%@0000",ticketString];
            latitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
            longitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.longitude];
            expireDate = ([ticketString isEqualToString:@"01"])?dateString:@"2099-01-01";
            if ([ticketString isEqualToString:@"01"]) {
                requestBody = [NSString stringWithFormat:@"expire_date=%@&email=%@&latitude=%@&longitude=%@&category=5&subcate=%@&date=%@&flight=%@",expireDate,MEID,latitude,longitude,subCate,expireDate,flight.text];
            }
            else
                requestBody = [NSString stringWithFormat:@"expire_date=%@&email=%@&latitude=%@&longitude=%@&category=5&subcate=%@&date=%@&depart=%@&arrive=%@",expireDate,MEID,latitude,longitude,subCate,expireDate,departAirport.text,arriveAirport.text];

            break;
        case DiscoverTravelDrive:
            subCate=@"02000000";
            latitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
            longitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.longitude];
            requestBody = [NSString stringWithFormat:@"expire_date=2099-01-01&email=%@&latitude=%@&longitude=%@&category=5&subcate=%@&price=%@&car=%@&name=%@&gender=%@&age=%@&drive_time=%@&teach_time=%@",MEID,latitude,longitude,subCate,price1.text,title.text,name.text,gender.text,age.text,driveTime.text,teachTime.text];
            break;
        case DiscoverTravelCarpool:
            subCate=@"03000000";
            latitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
            longitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.longitude];
            requestBody = [NSString stringWithFormat:@"expire_date=2099-01-01&email=%@&latitude=%@&longitude=%@&category=5&subcate=%@&depart=%@&arrive=%@&is_free=%d&car=%@",MEID,latitude,longitude,subCate, departCity.text,arriveCity.text,priceFree,title.text];
            break;
        case DiscoverTravelPickup:
            subCate=@"04000000";
            latitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
            longitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.longitude];
            requestBody = [NSString stringWithFormat:@"expire_date=2099-01-01&email=%@&latitude=%@&longitude=%@&category=5&subcate=%@&airport=%@&is_free=%d&car=%@",MEID,latitude,longitude,subCate,airportString,priceFree,title.text];
            break;
        case DiscoverTravelBuyCar:
            subCate=@"05030000";
            latitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
            longitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.longitude];
            requestBody = [NSString stringWithFormat:@"expire_date=2099-01-01&email=%@&latitude=%@&longitude=%@&category=5&subcate=%@&price=%@&introduction=%@&changable=%d&name=%@&gender=%@&age=%@&drive_time=%@",MEID,latitude,longitude,subCate,price2.text,introduction.text,priceAgg,name.text,gender.text,age.text,driveTime.text];
            break;
        case DiscoverTravelRepair:
            subCate=@"06000000";
            requestBody = [NSString stringWithFormat:@"expire_date=2099-01-01&email=%@&latitude=%f&longitude=%f&category=5&subcate=%@&title=%@&introduction=%@",MEID,[[_selectedItem placemark] coordinate].latitude,[[_selectedItem placemark] coordinate].longitude,subCate,title.text, introduction.text];
            break;
        case DiscoverTravelDeliver:
            subCate=@"07000000";
            latitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
            longitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.longitude];
            requestBody = [NSString stringWithFormat:@"expire_date=2099-01-01&email=%@&latitude=%@&longitude=%@&category=5&subcate=%@&city=%@&price=%@&date=%@&cn_city=%@&to_cn=%d",MEID,latitude,longitude,subCate,city.text,priceString,dateString,cnCity.text,toCN];
            break;
        case DiscoverTravelOther:
            subCate=@"99000000";
            requestBody = [NSString stringWithFormat:@"expire_date=2099-01-01&email=%@&latitude=%f&longitude=%f&category=5&subcate=%@&title=%@&introduction=%@&is_other=1",MEID,[[_selectedItem placemark] coordinate].latitude,[[_selectedItem placemark] coordinate].longitude,subCate,title.text, introduction.text];
            break;

         
        default:
            break;
    }
    
    
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
            [self submitHandle:dict];
        });
    }];
    [task resume];
    
}

-(void)submitHandle:(NSDictionary*)dict{
    if ([[dict valueForKey:@"success"] boolValue]){
        [popOut showUpPop:SYPopDiscoverShareSuccess];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else [popOut showUpPop:SYPopDiscoverShareFail];
    
}

-(void)titleEmptyCheck{
    UITextField *textField = [titleView viewWithTag:11];
    if ([textField.text length]) {        
        introductionView.hidden = NO;
        
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
    UITextField *textField = [titleView viewWithTag:11];
    [textField resignFirstResponder];
    textField = [flightView viewWithTag:11];
    [textField resignFirstResponder];
    UITextView *textView = [introductionView viewWithTag:11];
    [textView resignFirstResponder];
}



- (void)priceSlider:(UISlider *)slider priceChangeToValue:(NSInteger)price{
    priceString = [NSString stringWithFormat:@"%ld",price];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:priceString, @"price", nil];
    [_shareDict addEntriesFromDictionary:dict];
}
-(void)lowerPriceChangeToValue:(NSInteger)lowerPrice upperToValue:(NSInteger)upperPrice{
    
}

@end
