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
        case DiscoverTravelPickup:
            self.navigationItem.title = @"找接机";
            break;
        case DiscoverTravelDeliver:
            self.navigationItem.title = @"求捎带";
            break;
        case DiscoverTravelCarpool:
            self.navigationItem.title = @"求搭车";
            break;
        case DiscoverTravelDrive:
            self.navigationItem.title = @"学车考证";
            break;
        case DiscoverTravelBuyCar:
            self.navigationItem.title = @"买车卖车";
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
    [backBtn setImage:[UIImage imageNamed:@"SYBackColor5"] forState:UIControlStateNormal];
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
    
    /*type*/
    typeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 80)];
    UIButton *majorTypeButton = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth/2-150, 20, 150, 40)];
    [majorTypeButton setTitle:@"同城" forState:UIControlStateNormal];
    [majorTypeButton setTitleColor:SYColor6 forState:UIControlStateNormal];
    [majorTypeButton.titleLabel setFont:SYFont20];
    majorTypeButton.tag = 11;
    [majorTypeButton addTarget:self action:@selector(typeResponse:) forControlEvents:UIControlEventTouchUpInside];
    [typeView addSubview:majorTypeButton];
    UIButton *appTypeButton = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth/2, 20, 150, 40)];
    [appTypeButton setTitle:@"异地" forState:UIControlStateNormal];
    [appTypeButton setTitleColor:SYColor6 forState:UIControlStateNormal];
    [appTypeButton.titleLabel setFont:SYFont20];
    appTypeButton.tag = 10;
    [appTypeButton addTarget:self action:@selector(typeResponse:) forControlEvents:UIControlEventTouchUpInside];
    [typeView addSubview:appTypeButton];
    /*has ticket*/
    /*type*/
    hasTicketView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 80)];
    UIButton *shareRentButton = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth/2-150, 0, 150, 40)];
    [shareRentButton setTitle:@"已买机票" forState:UIControlStateNormal];
    [shareRentButton setTitleColor:SYColor6 forState:UIControlStateNormal];
    [shareRentButton.titleLabel setFont:SYFont20];
    shareRentButton.tag = 11;
    [shareRentButton addTarget:self action:@selector(hasTicketResponse:) forControlEvents:UIControlEventTouchUpInside];
    [hasTicketView addSubview:shareRentButton];
    UIButton *soloRentButton = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth/2, 0, 150, 40)];
    [soloRentButton setTitle:@"未买机票" forState:UIControlStateNormal];
    [soloRentButton setTitleColor:SYColor6 forState:UIControlStateNormal];
    [soloRentButton.titleLabel setFont:SYFont20];
    soloRentButton.tag = 10;
    [soloRentButton addTarget:self action:@selector(hasTicketResponse:) forControlEvents:UIControlEventTouchUpInside];
    [hasTicketView addSubview:soloRentButton];
    
    /*flight view*/
    flightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 40)];
    SYTextField *flightTextfield = [[SYTextField alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 40) type:SYTextFieldHelp];
    flightTextfield.placeholder = @"航班号";
    flightTextfield.tag = 11;
    [flightView addSubview:flightTextfield];
    
    /*depart airport*/
    departAirportView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 60)];
    SYTextField *departAirportTextfield = [[SYTextField alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 40) type:SYTextFieldHelp];
    departAirportTextfield.placeholder = @"出发机场编码";
    departAirportTextfield.tag = 11;
    [departAirportView addSubview:departAirportTextfield];
    
    /*arrive airport*/
    arriveAirportView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 60)];
    SYTextField *arriveAirportTextfield = [[SYTextField alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 40) type:SYTextFieldHelp];
    arriveAirportTextfield.placeholder = @"到达机场编码";
    arriveAirportTextfield.tag = 11;
    [arriveAirportView addSubview:arriveAirportTextfield];
    
    
    
    /*depart city*/
    departCityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 60)];
    departCityView.hidden = YES;
    UILabel *departTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 100, 40)];
    departTitleLabel.text = @"出发地";
    departTitleLabel.textColor = SYColor1;
    [departCityView addSubview:departTitleLabel];
    UIButton *departButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 40)];
    departButton.tag = 11;
    [departButton setTitleColor:SYColor3 forState:UIControlStateNormal];
    [departButton setTitleColor:SYColor1 forState:UIControlStateSelected];
    [departButton setTitle:@"请选择出发地" forState:UIControlStateNormal];
    [departButton addTarget:self action:@selector(departResponse) forControlEvents:UIControlEventTouchUpInside];
    departButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [departCityView addSubview:departButton];

    
    /*arrive city*/
    arriveCityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 60)];
    arriveCityView.hidden = YES;
    UILabel *arriveTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 100, 40)];
    arriveTitleLabel.text = @"目的地";
    arriveTitleLabel.textColor = SYColor1;
    [arriveCityView addSubview:arriveTitleLabel];
    UIButton *arrivetButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 40)];
    arrivetButton.tag = 11;
    [arrivetButton setTitleColor:SYColor3 forState:UIControlStateNormal];
    [arrivetButton setTitleColor:SYColor1 forState:UIControlStateSelected];
    [arrivetButton setTitle:@"请选择目的地" forState:UIControlStateNormal];
    [arrivetButton addTarget:self action:@selector(arriveResponse) forControlEvents:UIControlEventTouchUpInside];
    arrivetButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [arriveCityView addSubview:arrivetButton];

    
    /*round trip*/
    roundTripView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 40)];
    roundTrip = NO;
    UIView *checkSingleView = [[UIView alloc] initWithFrame:CGRectMake(viewWidth/2-100, 2.5, 15, 15)];
    checkSingleView.tag = 11;
    checkSingleView.layer.borderWidth = 1;
    checkSingleView.layer.borderColor = [SYColor1 CGColor];
    [roundTripView addSubview:checkSingleView];
    UILabel *singleLabel = [[UILabel alloc] initWithFrame:CGRectMake(checkSingleView.frame.origin.x+checkSingleView.frame.size.width+4, 0, 60, 20)];
    singleLabel.text = @"单程";
    singleLabel.textColor = SYColor1;
    [singleLabel setFont:SYFont20];
    [roundTripView addSubview:singleLabel];
    UIButton *singleButton = [[UIButton alloc] initWithFrame:CGRectMake(checkSingleView.frame.origin.x, 0, 60, 20)];
    singleButton.tag = 21;
    [singleButton addTarget:self action:@selector(roundTripResponse:) forControlEvents:UIControlEventTouchUpInside];
    [roundTripView addSubview:singleButton];
    UIView *checkRoundView = [[UIView alloc] initWithFrame:CGRectMake(viewWidth/2+15, 2.5, 15, 15)];
    checkRoundView.tag = 12;
    checkRoundView.layer.borderWidth = 1;
    checkRoundView.layer.borderColor = [SYColor1 CGColor];
    [roundTripView addSubview:checkRoundView];
    UILabel *roundLabel = [[UILabel alloc] initWithFrame:CGRectMake(checkRoundView.frame.origin.x+checkRoundView.frame.size.width+4, 0, 60, 20)];
    roundLabel.text = @"往返";
    roundLabel.textColor = SYColor1;
    [roundLabel setFont:SYFont20];
    [roundTripView addSubview:roundLabel];
    UIButton *roundButton = [[UIButton alloc] initWithFrame:CGRectMake(checkRoundView.frame.origin.x, 0, 60, 20)];
    roundButton.tag = 22;
    [roundButton addTarget:self action:@selector(roundTripResponse:) forControlEvents:UIControlEventTouchUpInside];
    [roundTripView addSubview:roundButton];
    
    /*city*/
    cityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 220)];
    cityView.hidden = YES;
    SYTextView *goodTextView = [[SYTextView alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 50) type:SYTextViewHelp];
    goodTextView.tag = 10;
    [goodTextView setPlaceholder:@"捎带内容"];
    [cityView addSubview:goodTextView];
    UILabel *cityTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 65, viewWidth-2*originX, 20)];
    cityTitleLabel.text = @"捎带方向";
    cityTitleLabel.textAlignment = NSTextAlignmentCenter;
    [cityTitleLabel setFont:SYFont20];
    cityTitleLabel.textColor = SYColor1;
    [cityView addSubview:cityTitleLabel];
    UIImageView *directImageView = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth/2-77, 30+2+65, 154, 36)];
    directImageView.image = [UIImage imageNamed:@"tavelDeliverHelp"];
    [cityView addSubview:directImageView];
    UIView *checkUSView = [[UIView alloc] initWithFrame:CGRectMake(directImageView.frame.origin.x-40-15-20, 30+12.5+65, 15, 15)];
    checkUSView.tag = 11;
    checkUSView.layer.borderWidth = 1;
    checkUSView.layer.borderColor = [SYColor1 CGColor];
    [cityView addSubview:checkUSView];
    UILabel *USLabel = [[UILabel alloc] initWithFrame:CGRectMake(checkUSView.frame.origin.x+checkUSView.frame.size.width+4, 30+65, 40, 40)];
    USLabel.text = @"美国";
    USLabel.textColor = SYColor1;
    [USLabel setFont:SYFont20];
    [cityView addSubview:USLabel];
    UIButton *usDirectButton = [[UIButton alloc] initWithFrame:CGRectMake(checkUSView.frame.origin.x, 30+65, 60, 40)];
    usDirectButton.tag = 21;
    [usDirectButton addTarget:self action:@selector(delieverDirectResponse:) forControlEvents:UIControlEventTouchUpInside];
    [cityView addSubview:usDirectButton];
    UIView *checkCNView = [[UIView alloc] initWithFrame:CGRectMake(directImageView.frame.origin.x+directImageView.frame.size.width+16, 12.5+30+65, 15, 15)];
    checkCNView.tag = 12;
    checkCNView.layer.borderWidth = 1;
    checkCNView.layer.borderColor = [SYColor1 CGColor];
    [cityView addSubview:checkCNView];
    UILabel *cnLabel = [[UILabel alloc] initWithFrame:CGRectMake(checkCNView.frame.origin.x+checkCNView.frame.size.width+4, 30+65, 40, 40)];
    cnLabel.text = @"中国";
    cnLabel.textColor = SYColor1;
    [cnLabel setFont:SYFont20];
    [cityView addSubview:cnLabel];
    UIButton *cnDirectButton = [[UIButton alloc] initWithFrame:CGRectMake(checkCNView.frame.origin.x, 30+65, 60, 40)];
    cnDirectButton.tag = 22;
    [cnDirectButton addTarget:self action:@selector(delieverDirectResponse:) forControlEvents:UIControlEventTouchUpInside];
    [cityView addSubview:cnDirectButton];
    SYTextField *cityTextfield = [[SYTextField alloc] initWithFrame:CGRectMake(viewWidth/2-110-35, 80+65, 110, 40) type:SYTextFieldHelp];
    cityTextfield.tag = 13;
    cityTextfield.placeholder = @"美国城市";
    [cityView addSubview:cityTextfield];
    SYTextField *cnCityTextfield = [[SYTextField alloc] initWithFrame:CGRectMake(viewWidth/2+35, 80+65, 110, 40) type:SYTextFieldHelp];
    cnCityTextfield.tag = 14;
    cnCityTextfield.placeholder = @"中国城市";
    [cityView addSubview:cnCityTextfield];
    
    /*airport*/
    airportsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 60)];
    airportsView.hidden = YES;
    SYTextField *airportTextfield = [[SYTextField alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 40) type:SYTextFieldHelp];
    airportTextfield.tag = 11;
    airportTextfield.placeholder = @"接机机场";
    [airportsView addSubview:airportTextfield];
    
    /*time*/
    timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 60)];
    timeView.hidden = YES;
    SYTextField *timeTextfield = [[SYTextField alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 40) type:SYTextFieldHelp];
    timeTextfield.tag = 11;
    timeTextfield.placeholder = @"到达时间";
    [timeView addSubview:timeTextfield];
    
    /*location*/
    locationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 60)];
    locationView.hidden = YES;
    UILabel *locationTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 100, 40)];
    locationTitleLabel.text = @"位置范围";
    locationTitleLabel.textColor = SYColor1;
    [locationView addSubview:locationTitleLabel];
    UIButton *locationButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 40)];
    locationButton.tag = 11;
    [locationButton setTitleColor:SYColor3 forState:UIControlStateNormal];
    [locationButton setTitleColor:SYColor1 forState:UIControlStateSelected];
    [locationButton setTitle:@"请选择位置" forState:UIControlStateNormal];
    [locationButton addTarget:self action:@selector(locationResponse) forControlEvents:UIControlEventTouchUpInside];
    locationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [locationView addSubview:locationButton];
    
    
    
    /*date*/
    dateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 80)];
    dateView.hidden = YES;
    UILabel *dateTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 100, 40)];
    dateTitleLabel.text = @"出发日期";
    dateTitleLabel.textColor = SYColor1;
    [dateTitleLabel setFont:SYFont20];
    [dateView addSubview:dateTitleLabel];
    UIButton *dateButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 40)];
    [dateButton setTitle:@"请选择出发日期" forState:UIControlStateNormal];
    [dateButton setTitleColor:SYColor9 forState:UIControlStateNormal];
    [dateButton setTitleColor:SYColor1 forState:UIControlStateSelected];
    [dateButton.titleLabel setFont:SYFont20];
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
    keywordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 60)];
    keywordView.hidden = YES;
    SYTextField *keywordTextfield = [[SYTextField alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 40) type:SYTextFieldHelp];
    keywordTextfield.tag = 11;
    [keywordView addSubview:keywordTextfield];
    
    /*title*/
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    titleView.hidden = YES;
    SYTextField *textfield = [[SYTextField alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 40) type:SYTextFieldHelp];
    textfield.tag = 11;
    [textfield addTarget:self action:@selector(titleEmptyCheck) forControlEvents:UIControlEventEditingChanged];
    textfield.backgroundColor = [UIColor whiteColor];
    [titleView addSubview:textfield];
    
    /*introduction*/
    introductionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 110)];
    introductionView.hidden = YES;
    SYTextView *textView = [[SYTextView alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 75) type:SYTextViewHelp];
    textView.tag = 11;
    [introductionView addSubview:textView];
    
    /*buy car*/
    buyCarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 130)];
    buyCarView.hidden = YES;
    UIImageView *buyCarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth/2-21, 0, 42, 33)];
    buyCarImageView.image = [UIImage imageNamed:@"travelBuyCarHelp"];
    [buyCarView addSubview:buyCarImageView];
    UIButton *buyButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 0, 52, 33)];
    [buyButton setTitle:@"买车" forState:UIControlStateNormal];
    [buyButton setTitleColor:SYColor1 forState:UIControlStateNormal];
    [buyButton.titleLabel setFont:SYFont20];
    buyButton.backgroundColor = UIColorFromRGB(0xC4E980);
    buyButton.layer.cornerRadius = 8;
    buyButton.clipsToBounds = YES;
    buyButton.layer.borderColor = [SYColor6 CGColor];
    buyButton.layer.borderWidth = 1;
    [buyCarView addSubview:buyButton];
    UIButton *sellButton = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth-originX-52, 0, 52, 33)];
    [sellButton setTitle:@"卖车" forState:UIControlStateNormal];
    [sellButton setTitleColor:SYColor1 forState:UIControlStateNormal];
    [sellButton.titleLabel setFont:SYFont20];
    sellButton.backgroundColor = UIColorFromRGB(0xC4E980);
    sellButton.layer.cornerRadius = 8;
    sellButton.clipsToBounds = YES;
    sellButton.layer.borderColor = [SYColor6 CGColor];
    sellButton.layer.borderWidth = 1;
    [buyCarView addSubview:sellButton];
    UIView *separatorL = [[UIView alloc] initWithFrame:CGRectMake(buyButton.frame.origin.x+buyButton.frame.size.width+2, 16, buyCarImageView.frame.origin.x-(buyButton.frame.origin.x+buyButton.frame.size.width+6), 1)];
    separatorL.backgroundColor = SYColor6;
    [buyCarView addSubview:separatorL];
    UIView *separatorR = [[UIView alloc] initWithFrame:CGRectMake(buyCarImageView.frame.origin.x+buyCarImageView.frame.size.width+4, 16, sellButton.frame.origin.x-(buyCarImageView.frame.origin.x+buyCarImageView.frame.size.width+6), 1)];
    separatorR.backgroundColor = SYColor6;
    [buyCarView addSubview:separatorR];
    UIView *separatorB = [[UIView alloc] initWithFrame:CGRectMake(0, 70, viewWidth, SYSeparatorHeight)];
    separatorB.backgroundColor = SYSeparatorColor;
    [buyCarView addSubview:separatorB];
    buyCar = NO;
    UILabel *buySellLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth/2-20-130, 90, 130, 20)];
    buySellLabel.text = @"找人帮忙";
    buySellLabel.textColor = SYColor1;
    [buySellLabel setFont:SYFont20];
    buySellLabel.textAlignment = NSTextAlignmentRight;
    [buyCarView addSubview:buySellLabel];
    UIView *checkBuyView = [[UIView alloc] initWithFrame:CGRectMake(viewWidth/2-10, 90+2.5, 15, 15)];
    checkBuyView.tag = 11;
    checkBuyView.layer.borderWidth = 1;
    checkBuyView.layer.borderColor = [SYColor1 CGColor];
    [buyCarView addSubview:checkBuyView];
    UILabel *buyLabel = [[UILabel alloc] initWithFrame:CGRectMake(checkBuyView.frame.origin.x+checkBuyView.frame.size.width+4, 90, 40, 20)];
    buyLabel.text = @"买车";
    buyLabel.textColor = SYColor1;
    [buyLabel setFont:SYFont20];
    [buyCarView addSubview:buyLabel];
    UIButton *checkBuyButton = [[UIButton alloc] initWithFrame:CGRectMake(checkBuyView.frame.origin.x, 90, 60, 20)];
    checkBuyButton.tag = 21;
    [checkBuyButton addTarget:self action:@selector(buyCarResponse:) forControlEvents:UIControlEventTouchUpInside];
    [buyCarView addSubview:checkBuyButton];
    UIView *checkSellView = [[UIView alloc] initWithFrame:CGRectMake(buyLabel.frame.origin.x+buyLabel.frame.size.width+10, 90+2.5, 15, 15)];
    checkSellView.tag = 12;
    checkSellView.layer.borderWidth = 1;
    checkSellView.layer.borderColor = [SYColor1 CGColor];
    [buyCarView addSubview:checkSellView];
    UILabel *sellLabel = [[UILabel alloc] initWithFrame:CGRectMake(checkSellView.frame.origin.x+checkSellView.frame.size.width+4, 90, 40, 20)];
    sellLabel.text = @"卖车";
    sellLabel.textColor = SYColor1;
    [sellLabel setFont:SYFont20];
    [buyCarView addSubview:sellLabel];
    UIButton *checkSellButton = [[UIButton alloc] initWithFrame:CGRectMake(checkSellView.frame.origin.x, 90, 60, 20)];
    checkSellButton.tag = 22;
    [checkSellButton addTarget:self action:@selector(buyCarResponse:) forControlEvents:UIControlEventTouchUpInside];
    [buyCarView addSubview:checkSellButton];
    
    /*price*/
    /*price1*/
    priceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 60)];
    priceView.hidden = YES;
    UITextField *priceTextField = [[UITextField alloc] initWithFrame:CGRectMake(viewWidth/2-30, 7.5, 60, 25)];
    priceTextField.textColor = SYColor1;
    [priceTextField setFont:SYFont20];
    priceTextField.tag = 11;
    priceTextField.keyboardType = UIKeyboardTypeNumberPad;
    priceTextField.backgroundColor = UIColorFromRGB(0xC4E980);
    priceTextField.textAlignment = NSTextAlignmentCenter;
    priceTextField.layer.cornerRadius = 6;
    priceTextField.clipsToBounds = YES;
    [priceView addSubview:priceTextField];
    UILabel *priceTitleLabel = [[UILabel alloc] init];
    priceTitleLabel.text = @"出价";
    [priceTitleLabel setFont:SYFont20];
    priceTitleLabel.textColor = SYColor1;
    [priceTitleLabel sizeToFit];
    priceTitleLabel.frame = CGRectMake(priceTextField.frame.origin.x-priceTitleLabel.frame.size.width-4, 0, priceTitleLabel.frame.size.width, 40);
    [priceView addSubview:priceTitleLabel];
    UILabel *teachUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(priceTextField.frame.size.width+priceTextField.frame.origin.x+4, 0, 130, 40)];
    teachUnitLabel.text = @"美元";
    teachUnitLabel.textColor = SYColor1;
    [teachUnitLabel setFont:SYFont20];
    [priceView addSubview:teachUnitLabel];
    //    priceString = @"150";
    /*price2*/
    price2View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 40)];
    price2View.hidden = YES;
    UITextField *price2TextField = [[UITextField alloc] initWithFrame:CGRectMake(viewWidth/2, 0, 85, 25)];
    price2TextField.textColor = SYColor1;
    [price2TextField setFont:SYFont20];
    price2TextField.tag = 11;
    price2TextField.keyboardType = UIKeyboardTypeNumberPad;
    price2TextField.backgroundColor = UIColorFromRGB(0xC4E980);
    price2TextField.textAlignment = NSTextAlignmentCenter;
    price2TextField.layer.cornerRadius = 6;
    price2TextField.clipsToBounds = YES;
    [price2View addSubview:price2TextField];
    UILabel *price2TitleLabel = [[UILabel alloc] init];
    price2TitleLabel.text = @"可接受的价格";
    [price2TitleLabel setFont:SYFont20];
    price2TitleLabel.textColor = SYColor1;
    [price2TitleLabel sizeToFit];
    price2TitleLabel.frame = CGRectMake(price2TextField.frame.origin.x-price2TitleLabel.frame.size.width-10, 0, price2TitleLabel.frame.size.width, 25);
    [price2View addSubview:price2TitleLabel];
    UILabel *nitLabel = [[UILabel alloc] initWithFrame:CGRectMake(price2TextField.frame.size.width+price2TextField.frame.origin.x+10, 0, 130, 25)];
    nitLabel.text = @"美元";
    nitLabel.textColor = SYColor1;
    [nitLabel setFont:SYFont20];
    [price2View addSubview:nitLabel];
    /*price3*/
    price3View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 40)];
    price3View.hidden = YES;
    UITextField *price3TextField = [[UITextField alloc] initWithFrame:CGRectMake(viewWidth/2-30, 0, 70, 25)];
    price3TextField.textColor = SYColor1;
    [price3TextField setFont:SYFont20];
    price3TextField.tag = 11;
    price3TextField.keyboardType = UIKeyboardTypeNumberPad;
    price3TextField.backgroundColor = UIColorFromRGB(0xC4E980);
    price3TextField.textAlignment = NSTextAlignmentCenter;
    price3TextField.layer.cornerRadius = 6;
    price3TextField.clipsToBounds = YES;
    [price3View addSubview:price3TextField];
    UILabel *price3TitleLabel = [[UILabel alloc] init];
    price3TitleLabel.text = @"可接受的价格";
    [price3TitleLabel setFont:SYFont20];
    price3TitleLabel.textColor = SYColor1;
    [price3TitleLabel sizeToFit];
    price3TitleLabel.frame = CGRectMake(price3TextField.frame.origin.x-price3TitleLabel.frame.size.width-5, 0, price3TitleLabel.frame.size.width, 25);
    [price3View addSubview:price3TitleLabel];
    UILabel *nit3Label = [[UILabel alloc] initWithFrame:CGRectMake(price3TextField.frame.size.width+price3TextField.frame.origin.x+5, 0, 130, 25)];
    nit3Label.text = @"美元/1小时";
    nit3Label.textColor = SYColor1;
    [nit3Label setFont:SYFont20];
    [price3View addSubview:nit3Label];
    /*price4*/
    price4View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    price4View.hidden = YES;
    UILabel *price4TitleLabel = [[UILabel alloc] init];
    price4TitleLabel.text = @"辛苦费";
    [price4TitleLabel setFont:SYFont20];
    price4TitleLabel.textColor = SYColor1;
    [price4TitleLabel sizeToFit];
    price4TitleLabel.frame = CGRectMake(originX, 0, price4TitleLabel.frame.size.width, 40);
    [price4View addSubview:price4TitleLabel];
    UITextField *price4TextField = [[UITextField alloc] initWithFrame:CGRectMake(price4TitleLabel.frame.size.width+price4TitleLabel.frame.origin.x+4, 7.5, 57, 25)];
    price4TextField.textColor = SYColor1;
    [price4TextField setFont:SYFont20];
    price4TextField.textAlignment = NSTextAlignmentCenter;
    price4TextField.tag = 11;
    price4TextField.keyboardType = UIKeyboardTypeNumberPad;
    price4TextField.backgroundColor = UIColorFromRGB(0xC4E980);
    price4TextField.layer.cornerRadius = 6;
    price4TextField.clipsToBounds = YES;
    [price4View addSubview:price4TextField];
    UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(price4TextField.frame.size.width+price4TextField.frame.origin.x+4, 0, 85, 40)];
    unitLabel.text = @"美元";
    unitLabel.textColor = SYColor1;
    [unitLabel setFont:SYFont20];
    [price4View addSubview:unitLabel];
    priceAgg = NO;
    UIView *checkView = [[UIView alloc] initWithFrame:CGRectMake(unitLabel.frame.origin.x+unitLabel.frame.size.width, 12.5, 15, 15)];
    checkView.tag = 12;
    checkView.layer.borderWidth = 1;
    checkView.layer.borderColor = [SYColor1 CGColor];
    [price4View addSubview:checkView];
    UILabel *meetLabel = [[UILabel alloc] initWithFrame:CGRectMake(checkView.frame.origin.x+checkView.frame.size.width+4, 0, 60, 40)];
    meetLabel.text = @"面议";
    meetLabel.textColor = SYColor1;
    [meetLabel setFont:SYFont20];
    [price4View addSubview:meetLabel];
    UIButton *priceAggButton = [[UIButton alloc] initWithFrame:CGRectMake(checkView.frame.origin.x, 0, 60, 40)];
    [priceAggButton addTarget:self action:@selector(priceAggResponse) forControlEvents:UIControlEventTouchUpInside];
    [price4View addSubview:priceAggButton];
    
    /*changable*/
    changableView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 80)];
    changableView.hidden = YES;
    priceAgg = NO;
    UILabel *changeLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth/2-130, 0, 130, 40)];
    changeLabel.text = @"价格是否可议";
    changeLabel.textColor = SYColor1;
    [changeLabel setFont:SYFont20];
    changeLabel.textAlignment = NSTextAlignmentRight;
    [changableView addSubview:changeLabel];
    UIView *checkChangeView = [[UIView alloc] initWithFrame:CGRectMake(viewWidth/2+10, 12.5, 15, 15)];
    checkChangeView.tag = 11;
    checkChangeView.layer.borderWidth = 1;
    checkChangeView.layer.borderColor = [SYColor1 CGColor];
    [changableView addSubview:checkChangeView];
    UILabel *changableLabel = [[UILabel alloc] initWithFrame:CGRectMake(checkChangeView.frame.origin.x+checkChangeView.frame.size.width+4, 0, 40, 40)];
    changableLabel.text = @"是";
    changableLabel.textColor = SYColor1;
    [changableLabel setFont:SYFont20];
    [changableView addSubview:changableLabel];
    UIButton *changeButton = [[UIButton alloc] initWithFrame:CGRectMake(checkChangeView.frame.origin.x, 0, 60, 40)];
    changeButton.tag = 21;
    [changeButton addTarget:self action:@selector(priceChangableResponse:) forControlEvents:UIControlEventTouchUpInside];
    [changableView addSubview:changeButton];
    UIView *checkUnchangeView = [[UIView alloc] initWithFrame:CGRectMake(changableLabel.frame.origin.x+changableLabel.frame.size.width, 12.5, 15, 15)];
    checkUnchangeView.tag = 12;
    checkUnchangeView.layer.borderWidth = 1;
    checkUnchangeView.layer.borderColor = [SYColor1 CGColor];
    [changableView addSubview:checkUnchangeView];
    UILabel *unchangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(checkUnchangeView.frame.origin.x+checkUnchangeView.frame.size.width+4, 0, 40, 40)];
    unchangeLabel.text = @"否";
    unchangeLabel.textColor = SYColor1;
    [unchangeLabel setFont:SYFont20];
    [changableView addSubview:unchangeLabel];
    UIButton *unchangeButton = [[UIButton alloc] initWithFrame:CGRectMake(checkUnchangeView.frame.origin.x, 0, 60, 40)];
    unchangeButton.tag = 22;
    [unchangeButton addTarget:self action:@selector(priceChangableResponse:) forControlEvents:UIControlEventTouchUpInside];
    [changableView addSubview:unchangeButton];
    
    originX = 90;
    nextButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 35)];
    [nextButton setTitle:@"提交" forState:UIControlStateNormal];
    [nextButton setBackgroundColor:SYColor7];
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
            [mainScrollView addSubview:introductionView];
            [viewsArray addObject:introductionView];
            [textView setPlaceholder:@"选填（如第一次出国，或老人需要同行照顾一下）"];
            break;
        case DiscoverTravelDrive:
//            locationView.hidden = NO;
            introductionView.hidden = NO; price3View.hidden = NO;
            changableView.hidden = NO;
//            [mainScrollView addSubview:locationView];
//            [viewsArray addObject:locationView];
            [mainScrollView addSubview:introductionView];
            [viewsArray addObject:introductionView];
            [mainScrollView addSubview:price3View];
            [viewsArray addObject:price3View];
            [mainScrollView addSubview:changableView];
            [viewsArray addObject:changableView];
            textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, 90);
            [textView setPlaceholder:@"简单说明（如本人零基础，需要找人教我开车，带我去考驾照）"];
            nextButton.hidden = NO;
            break;
        case DiscoverTravelCarpool:
            departCityView.hidden = NO; arriveCityView.hidden = NO;
            price3View.hidden = NO;  titleView.hidden = NO;
            introductionView.hidden = NO; locationView.hidden = NO;
            dateView.hidden = NO; price2View.hidden = NO;
            [mainScrollView addSubview:typeView];
            [viewsArray addObject:typeView];
            dateView.frame = CGRectMake(dateView.frame.origin.x, dateView.frame.origin.y, dateView.frame.size.width, 60);
            textfield.placeholder = @"车辆信息（选填）";
            [textView setPlaceholder:@"说明（如 常去华人超市，去学校，或地铁站公交站等）"];
            /*
            departCityView.hidden = NO; arriveCityView.hidden = NO;
            roundTripView.hidden = NO; price2View.hidden = NO;
            changableView.hidden = NO; introductionView.hidden = NO;
            
            [mainScrollView addSubview:departCityView];
            [viewsArray addObject:departCityView];
            [mainScrollView addSubview:arriveCityView];
            [viewsArray addObject:arriveCityView];
            [mainScrollView addSubview:roundTripView];
            [viewsArray addObject:roundTripView];
            [mainScrollView addSubview:introductionView];
            [viewsArray addObject:introductionView];
            [mainScrollView addSubview:price2View];
            [viewsArray addObject:price2View];
            [mainScrollView addSubview:changableView];
            [viewsArray addObject:changableView];
             
//            [mainScrollView addSubview:dateView];
//            [viewsArray addObject:dateView];
            textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, 85);
            [textView setPlaceholder:@"简单说明（如 去华人超市，去学校，或地铁站公交站等）"];
             */
//            nextButton.hidden = NO;
            break;
        case DiscoverTravelPickup:
            airportsView.hidden = NO;
            timeView.hidden = NO;
            keywordView.hidden = NO;
            introductionView.hidden = NO;
            [mainScrollView addSubview:airportsView];
            [viewsArray addObject:airportsView];
            [mainScrollView addSubview:timeView];
            [viewsArray addObject:timeView];
            [mainScrollView addSubview:keywordView];
            [viewsArray addObject:keywordView];
            [mainScrollView addSubview:introductionView];
            [viewsArray addObject:introductionView];
            keywordTextfield.placeholder = @"目的地地址";
            [textView setPlaceholder:@"选填（如几人，几个行李箱）"];
            nextButton.hidden = NO;
            break;
        case DiscoverTravelBuyCar:
            buyCarView.hidden = NO; price4View.hidden = NO;
            [mainScrollView addSubview:buyCarView];
            [viewsArray addObject:buyCarView];
            [mainScrollView addSubview:price4View];
            [viewsArray addObject:price4View];
            nextButton.hidden = NO;
            break;
        case DiscoverTravelRepair:
            keywordView.hidden = NO;
            [mainScrollView addSubview:keywordView];
            [viewsArray addObject:keywordView];
            break;
        case DiscoverTravelDeliver:
            cityView.hidden = NO; priceView.hidden = NO;
            changableView.hidden = NO;
            [mainScrollView addSubview:cityView];
            [viewsArray addObject:cityView];
//            [mainScrollView addSubview:dateView];
//            [viewsArray addObject:dateView];
            [mainScrollView addSubview:priceView];
            [viewsArray addObject:priceView];
            [mainScrollView addSubview:changableView];
            [viewsArray addObject:changableView];
            nextButton.hidden = NO;
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
    float height = 35;
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
        [button setTitleColor:SYColor5 forState:UIControlStateNormal];
        UIButton *button2 = [hasTicketView viewWithTag:10];
        [button2 setTitleColor:SYColor6 forState:UIControlStateNormal];
        [departAirportView removeFromSuperview];
        [arriveAirportView removeFromSuperview];
        [viewsArray removeObject:departAirportView];
        [viewsArray removeObject:arriveAirportView];
        [viewsArray removeObject:flightView];
        [mainScrollView addSubview:flightView];
        [viewsArray insertObject:flightView atIndex:1];
        [mainScrollView addSubview:dateView];
        [viewsArray insertObject:dateView atIndex:2];
    }
    else{
        ticketString = @"02";
        [button setTitleColor:SYColor5 forState:UIControlStateNormal];
        UIButton *button2 = [hasTicketView viewWithTag:11];
        [button2 setTitleColor:SYColor6 forState:UIControlStateNormal];
        [viewsArray removeObject:flightView];
        [flightView removeFromSuperview];
        [viewsArray removeObject:dateView];
        [dateView removeFromSuperview];
        [mainScrollView addSubview:departAirportView];
        [viewsArray insertObject:departAirportView atIndex:1];
        [mainScrollView addSubview:arriveAirportView];
        [viewsArray insertObject:arriveAirportView atIndex:2];
        
    }
    dateView.hidden = NO;
    introductionView.hidden = NO;
    nextButton.hidden = NO;
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
-(IBAction)typeResponse:(id)sender{
    UIButton *button = sender;
    if (button.tag-10) {
        typeString = @"01";
        [button setTitleColor:SYColor5 forState:UIControlStateNormal];
        UIButton *button2 = [typeView viewWithTag:10];
        [button2 setTitleColor:SYColor6 forState:UIControlStateNormal];
        [button.titleLabel setFont:SYFont25M];
        [button2.titleLabel setFont:SYFont20];
        
        [locationView removeFromSuperview];
        [introductionView removeFromSuperview];
        [viewsArray removeObject:locationView];
        [viewsArray removeObject:introductionView];
        [departCityView removeFromSuperview];
        [arriveCityView removeFromSuperview];
        [roundTripView removeFromSuperview];
        [dateView removeFromSuperview];
        [introductionView removeFromSuperview];
        [viewsArray removeObject:departCityView];
        [viewsArray removeObject:arriveCityView];
        [viewsArray removeObject:roundTripView];
        [viewsArray removeObject:dateView];
        [viewsArray removeObject:introductionView];
        
        [mainScrollView addSubview:locationView];
        [viewsArray insertObject:locationView atIndex:1];
        [mainScrollView addSubview:introductionView];
        [viewsArray insertObject:introductionView atIndex:2];
        
    }
    else{
        typeString = @"02";
        [button setTitleColor:SYColor5 forState:UIControlStateNormal];
        UIButton *button2 = [typeView viewWithTag:11];
        [button2 setTitleColor:SYColor6 forState:UIControlStateNormal];
        [button.titleLabel setFont:SYFont25M];
        [button2.titleLabel setFont:SYFont20];
        [locationView removeFromSuperview];
        [price3View removeFromSuperview];
        [titleView removeFromSuperview];
        [introductionView removeFromSuperview];
        [viewsArray removeObject:locationView];
        [viewsArray removeObject:price3View];
        [viewsArray removeObject:titleView];
        [viewsArray removeObject:introductionView];
        [departCityView removeFromSuperview];
        [arriveCityView removeFromSuperview];
        [roundTripView removeFromSuperview];
        [dateView removeFromSuperview];
        [price2View removeFromSuperview];
        [introductionView removeFromSuperview];
        [viewsArray removeObject:departCityView];
        [viewsArray removeObject:arriveCityView];
        [viewsArray removeObject:roundTripView];
        [viewsArray removeObject:dateView];
        [viewsArray removeObject:price2View];
        [viewsArray removeObject:introductionView];
        
        [mainScrollView addSubview:departCityView];
        [viewsArray insertObject:departCityView atIndex:1];
        [mainScrollView addSubview:arriveCityView];
        [viewsArray insertObject:arriveCityView atIndex:2];
        [mainScrollView addSubview:roundTripView];
        [viewsArray insertObject:roundTripView atIndex:3];
        [mainScrollView addSubview:dateView];
        [viewsArray insertObject:dateView atIndex:4];
        [mainScrollView addSubview:introductionView];
        [viewsArray insertObject:introductionView atIndex:5];
        
    }
    //    schoolContentView.hidden = NO;
    //    price2View.hidden = NO;
    nextButton.hidden = NO;
    [self viewsLayout];
}
-(void)locationResponse{
    [self dismissKeyboard];
    [self pickerConfirmResponse];
    
    DiscoverLocationViewController *viewController = [DiscoverLocationViewController new];
    viewController.previousController = self;
    viewController.needDistance = YES;
    viewController.nextControllerType = SYDiscoverNextHelp;
    [self presentViewController:viewController animated:YES completion:nil];
}
-(void)departResponse{
    [self dismissKeyboard];
    [self pickerConfirmResponse];
    
    DiscoverLocationViewController *viewController = [DiscoverLocationViewController new];
    viewController.previousController = self;
    viewController.nextControllerType = SYDiscoverNextCarpoolDepart;
    [self presentViewController:viewController animated:YES completion:nil];
}
-(void)arriveResponse{
    [self dismissKeyboard];
    [self pickerConfirmResponse];
    
    DiscoverLocationViewController *viewController = [DiscoverLocationViewController new];
    viewController.previousController = self;
    viewController.nextControllerType = SYDiscoverNextCarpoolArrive;
    [self presentViewController:viewController animated:YES completion:nil];
}
-(void)locationCompleteResponse{
    UIButton *locationButton = [locationView viewWithTag:11];
    locationButton.selected = YES;
    [locationButton.titleLabel setNumberOfLines:2];
    [locationButton setTitle:[NSString stringWithFormat:@"%@\n附近%@英里",[[[_selectedItem placemark] addressDictionary] valueForKey:@"Street"],_distanceString] forState:UIControlStateSelected];
//    UIButton *locationButton = [locationView viewWithTag:11];
//    locationButton.selected = YES;
//    [locationButton setTitle:[[[_selectedItem placemark] addressDictionary] valueForKey:@"Street"] forState:UIControlStateSelected];
//    switch (_controllerType) {
//        case DiscoverTravelDrive:
//            priceView.hidden = NO;
//            keywordView.hidden = NO;
//            break;
//        case DiscoverTravelOther:
//            keywordView.hidden = NO;
//            break;
//            
//        default:
//            break;
//    }
}
-(void)departCompleteResponse{
    UIButton *locationButton = [departCityView viewWithTag:11];
    locationButton.selected = YES;
    [locationButton setTitle:[[[_departItem placemark] addressDictionary] valueForKey:@"Street"] forState:UIControlStateSelected];
}
-(void)arriveCompleteResponse{
    UIButton *locationButton = [arriveCityView viewWithTag:11];
    locationButton.selected = YES;
    [locationButton setTitle:[[[_arriveItem placemark] addressDictionary] valueForKey:@"Street"] forState:UIControlStateSelected];
}
- (void)pickerConfirmResponse{
    confirmBackgroundView.hidden = YES;
    datePicker.hidden = YES;
}
-(IBAction)delieverDirectResponse:(id)sender{
    UIButton *button = (UIButton*)sender;
    UIView *check1View = [cityView viewWithTag:11];
    UIView *check2View = [cityView viewWithTag:12];
    toCN = (button.tag==21)?NO:YES;
    check1View.backgroundColor = (!toCN)?SYColor4:[UIColor clearColor];
    check2View.backgroundColor = (toCN)?SYColor4:[UIColor clearColor];
}
-(IBAction)priceChangableResponse:(id)sender{
    UIButton *button = (UIButton*)sender;
    UIView *check1View = [changableView viewWithTag:11];
    UIView *check2View = [changableView viewWithTag:12];
    priceAgg = (button.tag==21)?YES:NO;
    check1View.backgroundColor = (priceAgg)?SYColor6:[UIColor clearColor];
    check2View.backgroundColor = (!priceAgg)?SYColor6:[UIColor clearColor];
}
-(IBAction)roundTripResponse:(id)sender{
    UIButton *button = (UIButton*)sender;
    UIView *check1View = [roundTripView viewWithTag:11];
    UIView *check2View = [roundTripView viewWithTag:12];
    roundTrip = (button.tag==21)?NO:YES;
    check1View.backgroundColor = (!roundTrip)?SYColor6:[UIColor clearColor];
    check2View.backgroundColor = (roundTrip)?SYColor6:[UIColor clearColor];
}
-(IBAction)buyCarResponse:(id)sender{
    UIButton *button = (UIButton*)sender;
    UIView *check1View = [buyCarView viewWithTag:11];
    UIView *check2View = [buyCarView viewWithTag:12];
    buyCar = (button.tag==22)?NO:YES;
    check1View.backgroundColor = (buyCar)?SYColor6:[UIColor clearColor];
    check2View.backgroundColor = (!buyCar)?SYColor6:[UIColor clearColor];
}
-(void)priceAggResponse{
    UIView *checkView = [price4View viewWithTag:12];
    priceAgg = !priceAgg;
    checkView.backgroundColor = (priceAgg)?SYColor6:[UIColor clearColor];
}
-(void)nextResponse{
    NSString *subCate;
    NSString *latitude;
    NSString *longitude;
    NSString *departLatitude;
    NSString *departLongitude;
    NSString *arriveLatitude;
    NSString *arriveLongitude;
    NSString *expireDate;
    UITextField *flight = [flightView viewWithTag:11];
    UITextField *departAirport = [departAirportView viewWithTag:11];
    UITextField *arriveAirport = [arriveAirportView viewWithTag:11];
//    UITextField *departCity = [departCityView viewWithTag:11];
//    UITextField *arriveCity = [arriveCityView viewWithTag:11];
    UITextField *airport = [airportsView viewWithTag:11];
    UITextField *city = [cityView viewWithTag:13];
    UITextField *cnCity = [cityView viewWithTag:14];
    UITextField *keyword = [keywordView viewWithTag:11];
    UITextField *time = [timeView viewWithTag:11];
//    UITextField *title = [titleView viewWithTag:11];
    UITextView *introduction = [introductionView viewWithTag:11];
    UITextView *goods = [cityView viewWithTag:10];
    UITextField *price1 = [priceView viewWithTag:11];
//    UITextField *price2 = [price2View viewWithTag:11];
    UITextField *price3 = [price3View viewWithTag:11];
    UITextField *price4 = [price4View viewWithTag:11];
    
    NSString *requestBody;
    
    switch (_controllerType) {
        case DiscoverTravelPartner:
            subCate= [NSString stringWithFormat:@"01%@0000",ticketString];
            latitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
            longitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.longitude];
            expireDate = ([ticketString isEqualToString:@"01"])?dateString:@"2099-01-01";
            if ([ticketString isEqualToString:@"01"]) {
                requestBody = [NSString stringWithFormat:@"expire_date=%@&email=%@&latitude=%@&longitude=%@&category=5&subcate=%@&date=%@&flight=%@&introduction=%@",expireDate,MEID,latitude,longitude,subCate,dateString,flight.text,introduction.text];
            }
            else
                requestBody = [NSString stringWithFormat:@"expire_date=%@&email=%@&latitude=%@&longitude=%@&category=5&subcate=%@&depart=%@&arrive=%@&introduction=%@",expireDate,MEID,latitude,longitude,subCate,departAirport.text,arriveAirport.text,introduction.text];
            
            break;
        case DiscoverTravelDrive:
            subCate=@"02000000";
            latitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
            longitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.longitude];
            requestBody = [NSString stringWithFormat:@"expire_date=2099-01-01&email=%@&latitude=%@&longitude=%@&category=5&subcate=%@&introduction=%@&price=%@&changeable=%d",MEID,latitude,longitude,subCate,introduction.text,price3.text,priceAgg];
            break;
//        case DiscoverTravelCarpool:
//            subCate=@"03020000";
//            latitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
//            longitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.longitude];
//            requestBody = [NSString stringWithFormat:@"expire_date=2099-01-01&email=%@&latitude=%@&longitude=%@&category=5&subcate=%@&depart=%@&arrive=%@&round_trip=%d&introduction=%@&price=%@&changeable=%d&date=",MEID,latitude,longitude,subCate, departCity.text,arriveCity.text,roundTrip,introduction.text,price2.text,priceAgg];
            /*subCate=@"03010000";
             requestBody = [NSString stringWithFormat:@"expire_date=2099-01-01&email=%@&latitude=%@&longitude=%@&category=5&subcate=%@&introduction=%@&price=%@&car=%@",MEID,latitude,longitude,subCate, departCity.text,arriveCity.text,roundTrip,introduction.text,price2.text,priceAgg];
             */
        case DiscoverTravelCarpool:
            subCate=[NSString stringWithFormat:@"03%@0000",typeString];
            latitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
            longitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.longitude];
            if ([typeString isEqualToString:@"01"]) {
                latitude = [NSString stringWithFormat:@"%lf",[[_selectedItem placemark] coordinate].latitude];
                longitude = [NSString stringWithFormat:@"%lf",[[_selectedItem placemark] coordinate].longitude];
                requestBody = [NSString stringWithFormat:@"expire_date=2099-01-01&email=%@&latitude=%@&longitude=%@&category=5&subcate=%@&introduction=%@&distance=%@",MEID,latitude,longitude,subCate,introduction.text,_distanceString];
            }
            else{
                departLatitude = [NSString stringWithFormat:@"%lf",[[_departItem placemark] coordinate].latitude];
                departLongitude = [NSString stringWithFormat:@"%lf",[[_departItem placemark] coordinate].longitude];
                arriveLatitude = [NSString stringWithFormat:@"%lf",[[_arriveItem placemark] coordinate].latitude];
                arriveLongitude = [NSString stringWithFormat:@"%lf",[[_arriveItem placemark] coordinate].longitude];
                requestBody = [NSString stringWithFormat:@"expire_date=%@&email=%@&latitude=%@&longitude=%@&category=5&subcate=%@&date=%@&depart_lat=%@&depart_long=%@&arrive_lat=%@&arrive_long=%@&round_trip=%d&introduction=%@&distance=20",dateString,MEID,latitude,longitude,subCate,dateString,departLatitude,departLongitude,arriveLatitude,arriveLongitude,roundTrip,introduction.text];
            }
            break;
        case DiscoverTravelPickup:
            subCate=@"04000000";
            latitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
            longitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.longitude];
            requestBody = [NSString stringWithFormat:@"expire_date=2099-01-01&email=%@&latitude=%@&longitude=%@&category=5&subcate=%@&airport=%@&time=%@&address=%@&introduction=%@",MEID,latitude,longitude,subCate,airport.text,time.text,keyword.text,introduction.text];
            break;
        case DiscoverTravelBuyCar:
            subCate=@"05030000";
            latitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
            longitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.longitude];
            requestBody = [NSString stringWithFormat:@"expire_date=2099-01-01&email=%@&latitude=%@&longitude=%@&category=5&subcate=%@&buy_car=%d&price=%@&changeable=%d",MEID,latitude,longitude,subCate,buyCar,price4.text,priceAgg];
            break;
        case DiscoverTravelRepair:
            subCate=@"06000000";
            requestBody = [NSString stringWithFormat:@"expire_date=2099-01-01&email=%@&latitude=%f&longitude=%f&category=5&subcate=%@&keyword=%@",MEID,[[_selectedItem placemark] coordinate].latitude,[[_selectedItem placemark] coordinate].longitude,subCate,keyword.text];
            break;
        case DiscoverTravelDeliver:
            subCate=@"07000000";
            latitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
            longitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.longitude];
            requestBody = [NSString stringWithFormat:@"expire_date=2099-01-01&email=%@&latitude=%@&longitude=%@&category=5&subcate=%@&city=%@&price=%@&changeable=%d&cn_city=%@&to_cn=%d&introduction=%@&date=",MEID,latitude,longitude,subCate,city.text,price1.text,priceAgg,cnCity.text,toCN,goods.text];
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
    SYSuscard *baseView = [[SYSuscard alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen]bounds].size.height) withCardSize:CGSizeMake(320, 400) keyboard:NO];
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
    textField = [departAirportView viewWithTag:11];
    [textField resignFirstResponder];
    textField = [arriveAirportView viewWithTag:11];
    [textField resignFirstResponder];
    textField = [cityView viewWithTag:10];
    [textField resignFirstResponder];
    textField = [cityView viewWithTag:13];
    [textField resignFirstResponder];
    textField = [cityView viewWithTag:14];
    [textField resignFirstResponder];
    textField = [priceView viewWithTag:11];
    [textField resignFirstResponder];
    
    UITextView *textView = [introductionView viewWithTag:11];
    [textView resignFirstResponder];
}



- (void)priceSlider:(UISlider *)slider priceChangeToValue:(NSInteger)price{
    
}
-(void)lowerPriceChangeToValue:(NSInteger)lowerPrice upperToValue:(NSInteger)upperPrice{
    lowerPriceString = [NSString stringWithFormat:@"%ld",lowerPrice];
    upperPriceString = [NSString stringWithFormat:@"%ld",upperPrice];
}


@end
