//
//  DiscoverPlayShareActiveViewController.m
//  Sharmunity
//
//  Created by st chen on 2017/2/14.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "DiscoverPlayShareActiveViewController.h"
#import "DiscoverLocationViewController.h"
#import "Header.h"
#import "SYHeader.h"
@interface DiscoverPlayShareActiveViewController (){
    SYPopOut *popOut;
}


@end

@implementation DiscoverPlayShareActiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *titleArray = [[NSArray alloc] initWithObjects:@"体育运动",@"社交活动",@"户外冒险",@"旅游度假",@"棋牌游戏",@"其他活动", nil];
    
    switch (_controllerType) {
//        case DiscoverPlayPartner:
//            self.navigationItem.title = @"找玩伴";
//            break;
        case DiscoverPlayActivity:
            self.navigationItem.title = (_subcate1==99)?[titleArray lastObject]:[titleArray objectAtIndex:_subcate1-1];
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
    [backBtn setTitle:@"玩" forState:UIControlStateNormal];
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
    is_other = (_subcate1==99)?YES:NO;
    /*type data*/
    NSString* filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"PlayType%ld_cn",_subcate1]
                                                         ofType:@"txt"];
    NSString *categoryString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    typeArray = [NSArray new];
    typeArray = [categoryString componentsSeparatedByString:@","];
}
-(void)viewsSetup{
    viewsArray = [NSMutableArray new];
    float viewWidth = mainScrollView.frame.size.width;
    float originX = 30;
    
    /*activity type*/
    typeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 50)];
    UILabel *typeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 100, 40)];
    typeTitleLabel.text = @"种类";
    typeTitleLabel.textColor = SYColor1;
    [typeTitleLabel setFont:SYFont25];
    [typeView addSubview:typeTitleLabel];
    UIButton *typeButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 40)];
    [typeButton setTitle:[NSString stringWithFormat:@"请选择%@名称",self.navigationItem.title] forState:UIControlStateNormal];
    [typeButton setTitleColor:SYColor8 forState:UIControlStateNormal];
    [typeButton setTitleColor:SYColor1 forState:UIControlStateSelected];
    [typeButton.titleLabel setFont:SYFont20];
    typeButton.tag = 11;
    typeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [typeButton addTarget:self action:@selector(typeResponse:) forControlEvents:UIControlEventTouchUpInside];
    [typeView addSubview:typeButton];
    typePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216, self.view.frame.size.width, 216)];
    typePickerView.delegate = self;
    typePickerView.dataSource = self;
    typePickerView.backgroundColor = [UIColor whiteColor];
    typePickerView.hidden = YES;
    [self.view addSubview:typePickerView];
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
    
    
    /*location*/
    locationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 50)];
    locationView.hidden = YES;
    UILabel *locationTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 100, 40)];
    locationTitleLabel.text = @"发起地点";
    locationTitleLabel.textColor = SYColor1;
    [locationTitleLabel setFont:SYFont20];
    [locationView addSubview:locationTitleLabel];
    UIButton *locationButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 40)];
    locationButton.tag = 11;
    [locationButton setTitleColor:SYColor8 forState:UIControlStateNormal];
    [locationButton setTitleColor:SYColor1 forState:UIControlStateSelected];
    [locationButton.titleLabel setFont:SYFont20];
    [locationButton setTitle:@"请选择发起地点" forState:UIControlStateNormal];
    [locationButton addTarget:self action:@selector(locationResponse) forControlEvents:UIControlEventTouchUpInside];
    locationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [locationView addSubview:locationButton];
    
    /*date*/
    dateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 140)];
    dateView.hidden = YES;
    UILabel *startTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 100, 40)];
    startTitleLabel.text = @"开始时间";
    startTitleLabel.textColor = SYColor1;
    [startTitleLabel setFont:SYFont20];
    [dateView addSubview:startTitleLabel];
    UIButton *dateButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 40)];
    [dateButton setTitle:@"请选择开始时间" forState:UIControlStateNormal];
    [dateButton setTitleColor:SYColor10 forState:UIControlStateNormal];
    [dateButton setTitleColor:SYColor4 forState:UIControlStateSelected];
    [dateButton.titleLabel setFont:SYFont20];
    dateButton.tag = 11;
    dateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [dateButton addTarget:self action:@selector(dateResponse:) forControlEvents:UIControlEventTouchUpInside];
    [dateView addSubview:dateButton];
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216, self.view.frame.size.width, 216)];
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    NSDate *currentDate = [NSDate date];
    [datePicker setDate:currentDate];
    [datePicker addTarget:self action:@selector(datePickerChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    datePicker.hidden = YES;
    
//    UILabel *startMinLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth-originX-20, 0, 20, 40)];
//    startMinLabel.text = @"分";
//    [startMinLabel setFont:SYFont15];
//    startMinLabel.textColor = SYColor4;
//    [dateView addSubview:startMinLabel];
//    SYTextField *startMinTextField = [[SYTextField alloc] initWithFrame:CGRectMake(startMinLabel.frame.origin.x-20, 0, 20, 40) type:SYTextFieldSeparator];
//    startMinTextField.textColor = SYColor1;
//    startMinTextField.textAlignment = NSTextAlignmentRight;
//    startMinTextField.keyboardType = UIKeyboardTypeNumberPad;
//    startMinTextField.tag = 15;
//    [dateView addSubview:startMinTextField];
//    UILabel *startHourLabel = [[UILabel alloc] initWithFrame:CGRectMake(startMinTextField.frame.origin.x-20, 0, 20, 40)];
//    startHourLabel.text = @"时";
//    [startHourLabel setFont:SYFont15];
//    startHourLabel.textColor = SYColor4;
//    [dateView addSubview:startHourLabel];
//    SYTextField *startHourTextField = [[SYTextField alloc] initWithFrame:CGRectMake(startHourLabel.frame.origin.x-20, 0, 20, 40) type:SYTextFieldSeparator];
//    startHourTextField.textColor = SYColor1;
//    startHourTextField.textAlignment = NSTextAlignmentRight;
//    startHourTextField.keyboardType = UIKeyboardTypeNumberPad;
//    startHourTextField.tag = 14;
//    [dateView addSubview:startHourTextField];
//    UILabel *startDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(startHourTextField.frame.origin.x-20, 0, 20, 40)];
//    startDayLabel.text = @"日";
//    [startDayLabel setFont:SYFont15];
//    startDayLabel.textColor = SYColor4;
//    [dateView addSubview:startDayLabel];
//    SYTextField *startDayTextField = [[SYTextField alloc] initWithFrame:CGRectMake(startDayLabel.frame.origin.x-20, 0, 20, 40) type:SYTextFieldSeparator];
//    startDayTextField.textColor = SYColor1;
//    startDayTextField.textAlignment = NSTextAlignmentRight;
//    startDayTextField.keyboardType = UIKeyboardTypeNumberPad;
//    startDayTextField.tag = 13;
//    [dateView addSubview:startDayTextField];
//    UILabel *startMonthLabel = [[UILabel alloc] initWithFrame:CGRectMake(startDayTextField.frame.origin.x-20, 0, 20, 40)];
//    startMonthLabel.text = @"月";
//    [startMonthLabel setFont:SYFont15];
//    startMonthLabel.textColor = SYColor4;
//    [dateView addSubview:startMonthLabel];
//    SYTextField *startMonthTextField = [[SYTextField alloc] initWithFrame:CGRectMake(startMonthLabel.frame.origin.x-20, 0, 20, 40) type:SYTextFieldSeparator];
//    startMonthTextField.textColor = SYColor1;
//    startMonthTextField.textAlignment = NSTextAlignmentRight;
//    startMonthTextField.keyboardType = UIKeyboardTypeNumberPad;
//    startMonthTextField.tag = 12;
//    [dateView addSubview:startMonthTextField];
//    UILabel *startYearLabel = [[UILabel alloc] initWithFrame:CGRectMake(startMonthTextField.frame.origin.x-20, 0, 20, 40)];
//    startYearLabel.text = @"年";
//    [startYearLabel setFont:SYFont15];
//    startYearLabel.textColor = SYColor4;
//    [dateView addSubview:startYearLabel];
//    SYTextField *startYearTextField = [[SYTextField alloc] initWithFrame:CGRectMake(startYearLabel.frame.origin.x-40, 0, 40, 40) type:SYTextFieldSeparator];
//    startYearTextField.textColor = SYColor1;
//    startYearTextField.textAlignment = NSTextAlignmentRight;
//    startYearTextField.keyboardType = UIKeyboardTypeNumberPad;
//    startYearTextField.tag = 11;
//    [dateView addSubview:startYearTextField];
    UILabel *endTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 40, 100, 40)];
    endTitleLabel.text = @"结束时间";
    endTitleLabel.textColor = SYColor1;
    [endTitleLabel setFont:SYFont20];
    [dateView addSubview:endTitleLabel];
    UIButton *endButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 40, viewWidth-2*originX, 40)];
    [endButton setTitle:@"请选择结束时间" forState:UIControlStateNormal];
    [endButton setTitleColor:SYColor10 forState:UIControlStateNormal];
    [endButton setTitleColor:SYColor4 forState:UIControlStateSelected];
    [endButton.titleLabel setFont:SYFont20];
    endButton.tag = 12;
    endButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [endButton addTarget:self action:@selector(dateResponse:) forControlEvents:UIControlEventTouchUpInside];
    [dateView addSubview:endButton];/*
    UILabel *endMinLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth-originX-20, 40, 20, 40)];
    endMinLabel.text = @"分";
    [endMinLabel setFont:SYFont15];
    endMinLabel.textColor = SYColor4;
    [dateView addSubview:endMinLabel];
    SYTextField *endMinTextField = [[SYTextField alloc] initWithFrame:CGRectMake(endMinLabel.frame.origin.x-20, 40, 20, 40) type:SYTextFieldSeparator];
    endMinTextField.textColor = SYColor1;
    endMinTextField.textAlignment = NSTextAlignmentRight;
    endMinTextField.keyboardType = UIKeyboardTypeNumberPad;
    endMinTextField.tag = 25;
    [dateView addSubview:endMinTextField];
    UILabel *endHourLabel = [[UILabel alloc] initWithFrame:CGRectMake(endMinTextField.frame.origin.x-20, 40, 20, 40)];
    endHourLabel.text = @"时";
    [endHourLabel setFont:SYFont15];
    endHourLabel.textColor = SYColor4;
    [dateView addSubview:endHourLabel];
    SYTextField *endHourTextField = [[SYTextField alloc] initWithFrame:CGRectMake(endHourLabel.frame.origin.x-20, 40, 20, 40) type:SYTextFieldSeparator];
    endHourTextField.textColor = SYColor1;
    endHourTextField.textAlignment = NSTextAlignmentRight;
    endHourTextField.keyboardType = UIKeyboardTypeNumberPad;
    endHourTextField.tag = 24;
    [dateView addSubview:endHourTextField];
    UILabel *endDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(endHourTextField.frame.origin.x-20, 40, 20, 40)];
    endDayLabel.text = @"日";
    [endDayLabel setFont:SYFont15];
    endDayLabel.textColor = SYColor4;
    [dateView addSubview:endDayLabel];
    SYTextField *endDayTextField = [[SYTextField alloc] initWithFrame:CGRectMake(endDayLabel.frame.origin.x-20, 40, 20, 40) type:SYTextFieldSeparator];
    endDayTextField.textColor = SYColor1;
    endDayTextField.textAlignment = NSTextAlignmentRight;
    endDayTextField.keyboardType = UIKeyboardTypeNumberPad;
    endDayTextField.tag = 23;
    [dateView addSubview:endDayTextField];
    UILabel *endMonthLabel = [[UILabel alloc] initWithFrame:CGRectMake(endDayTextField.frame.origin.x-20, 40, 20, 40)];
    endMonthLabel.text = @"月";
    [endMonthLabel setFont:SYFont15];
    endMonthLabel.textColor = SYColor4;
    [dateView addSubview:endMonthLabel];
    SYTextField *endMonthTextField = [[SYTextField alloc] initWithFrame:CGRectMake(endMonthLabel.frame.origin.x-20, 40, 20, 40) type:SYTextFieldSeparator];
    endMonthTextField.textColor = SYColor1;
    endMonthTextField.textAlignment = NSTextAlignmentRight;
    endMonthTextField.keyboardType = UIKeyboardTypeNumberPad;
    endMonthTextField.tag = 22;
    [dateView addSubview:endMonthTextField];
    UILabel *endYearLabel = [[UILabel alloc] initWithFrame:CGRectMake(endMonthTextField.frame.origin.x-20, 40, 20, 40)];
    endYearLabel.text = @"年";
    [endYearLabel setFont:SYFont15];
    endYearLabel.textColor = SYColor4;
    [dateView addSubview:endYearLabel];
    SYTextField *endYearTextField = [[SYTextField alloc] initWithFrame:CGRectMake(endYearLabel.frame.origin.x-40, 40, 40, 40) type:SYTextFieldSeparator];
    endYearTextField.textColor = SYColor1;
    endYearTextField.textAlignment = NSTextAlignmentRight;
    endYearTextField.keyboardType = UIKeyboardTypeNumberPad;
    endYearTextField.tag = 21;
    [dateView addSubview:endYearTextField];
    */
    UIView *checkView = [[UIView alloc] initWithFrame:CGRectMake(viewWidth-originX-150-10-15, 80+12.5, 15, 15)];
    checkView.tag = 31;
    checkView.layer.borderWidth = 1;
    checkView.layer.borderColor = [SYColor1 CGColor];
    [dateView addSubview:checkView];
    UILabel *meetLabel = [[UILabel alloc] initWithFrame:CGRectMake(checkView.frame.origin.x+checkView.frame.size.width+10, 80, 150, 40)];
    meetLabel.text = @"不设定活动时间";
    meetLabel.textColor = SYColor4;
    [meetLabel setFont:SYFont20];
    meetLabel.textAlignment = NSTextAlignmentRight;
    [dateView addSubview:meetLabel];
    timeAgg = NO;
    UIButton *timeAggButton = [[UIButton alloc] initWithFrame:CGRectMake(checkView.frame.origin.x, 80, 60, 40)];
    [timeAggButton addTarget:self action:@selector(timeAggResponse) forControlEvents:UIControlEventTouchUpInside];
    [dateView addSubview:timeAggButton];
//    UIButton *dateButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 20, viewWidth-2*originX, 60)];
//    [dateButton setTitle:@"请选择活动日期" forState:UIControlStateNormal];
//    [dateButton setTitleColor:SYColor3 forState:UIControlStateNormal];
//    [dateButton setTitleColor:SYColor1 forState:UIControlStateSelected];
//    dateButton.tag = 11;
//    dateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    [dateButton addTarget:self action:@selector(dateResponse:) forControlEvents:UIControlEventTouchUpInside];
//    [dateView addSubview:dateButton];
    
//    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216, self.view.frame.size.width, 216)];
//    datePicker.backgroundColor = [UIColor whiteColor];
//    datePicker.datePickerMode = UIDatePickerModeDate;
//    NSDate *currentDate = [NSDate date];
//    [datePicker setDate:currentDate];
//    [datePicker addTarget:self action:@selector(datePickerChanged) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:datePicker];
//    datePicker.hidden = YES;
//    
    /*title*/
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 50)];
    titleView.hidden = YES;
    SYTextField *textfield = [[SYTextField alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 40) type:SYTextFieldShare];
    textfield.tag = 11;
    textfield.placeholder = @"标题";
    [titleView addSubview:textfield];
    
    /*introduction*/
    introductionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 110)];
    introductionView.hidden = YES;
    SYTextView *textView = [[SYTextView alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 90) type:SYTextViewShare];
    textView.tag = 11;
    [textView setPlaceholder:@"描述"];
    [introductionView addSubview:textView];
    
    /*price*/
    priceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 140)];
    priceView.hidden = YES;
    UILabel *numberTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 110, 40)];
    numberTitleLabel.text = @"活动人数";
    [numberTitleLabel setFont:SYFont20];
    numberTitleLabel.textColor = SYColor1;
    [priceView addSubview:numberTitleLabel];
    SYTextField *numberTextField = [[SYTextField alloc] initWithFrame:CGRectMake(numberTitleLabel.frame.size.width+numberTitleLabel.frame.origin.x+20, 7.5, 57, 25) type:SYTextFieldSeparator];
    numberTextField.textAlignment = NSTextAlignmentCenter;
    numberTextField.tag = 12;
    numberTextField.keyboardType = UIKeyboardTypeNumberPad;
    [priceView addSubview:numberTextField];
    numberString = @"0";
    UILabel *numberUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(numberTextField.frame.size.width+numberTextField.frame.origin.x+4, 0, 85, 40)];
    numberUnitLabel.text = @"人";
    numberUnitLabel.textColor = SYColor1;
    [numberUnitLabel setFont:SYFont20];
    [priceView addSubview:numberUnitLabel];
    UIView *numberCheckView = [[UIView alloc] initWithFrame:CGRectMake(viewWidth-originX-40-10-15, 12.5, 15, 15)];
    numberCheckView.tag = 13;
    numberCheckView.layer.borderWidth = 1;
    numberCheckView.layer.borderColor = [SYColor1 CGColor];
    [priceView addSubview:numberCheckView];
    UILabel *numberAggLabel = [[UILabel alloc] initWithFrame:CGRectMake(numberCheckView.frame.origin.x+numberCheckView.frame.size.width+10, 0, 40, 40)];
    numberAggLabel.text = @"不限";
    numberAggLabel.textColor = SYColor4;
    [numberAggLabel setFont:SYFont20];
    numberAggLabel.textAlignment = NSTextAlignmentRight;
    [priceView addSubview:numberAggLabel];
    numberAgg = NO;
    UIButton *numberAggButton = [[UIButton alloc] initWithFrame:CGRectMake(numberCheckView.frame.origin.x, 0, 60, 40)];
    [numberAggButton addTarget:self action:@selector(numberAggResponse) forControlEvents:UIControlEventTouchUpInside];
    [priceView addSubview:numberAggButton];
    UILabel *price2TitleLabel = [[UILabel alloc] init];
    price2TitleLabel.text = @"费用";
    [price2TitleLabel setFont:SYFont20];
    price2TitleLabel.textColor = SYColor1;
    [price2TitleLabel sizeToFit];
    price2TitleLabel.frame = CGRectMake(originX, 50, price2TitleLabel.frame.size.width, 40);
    [priceView addSubview:price2TitleLabel];
    UITextField *price2TextField = [[UITextField alloc] initWithFrame:CGRectMake(price2TitleLabel.frame.size.width+price2TitleLabel.frame.origin.x+4, 50+7.5, 57, 25)];
    price2TextField.textColor = SYColor1;
    [price2TextField setFont:SYFont20];
    price2TextField.textAlignment = NSTextAlignmentCenter;
    price2TextField.tag = 11;
    price2TextField.keyboardType = UIKeyboardTypeNumberPad;
    price2TextField.backgroundColor = UIColorFromRGB(0xF6EDBE);
    price2TextField.layer.cornerRadius = 6;
    price2TextField.clipsToBounds = YES;
    //    [price2TextField addTarget:self action:@selector(priceEmptyCheck) forControlEvents:UIControlEventEditingChanged];
    [priceView addSubview:price2TextField];
    priceString = @"0";
    UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(price2TextField.frame.size.width+price2TextField.frame.origin.x+4, 50, 85, 40)];
    unitLabel.text = @"美元/人";
    unitLabel.textColor = SYColor1;
    [unitLabel setFont:SYFont20];
    [priceView addSubview:unitLabel];
    
    
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
//        case DiscoverPlayPartner:
//            [mainScrollView addSubview:typeView];
//            [viewsArray addObject:typeView];
//            [mainScrollView addSubview:locationView];
//            [viewsArray addObject:locationView];
//            [mainScrollView addSubview:titleView];
//            [viewsArray addObject:titleView];
//            [mainScrollView addSubview:introductionView];
//            [viewsArray addObject:introductionView];
//            break;
        case DiscoverPlayActivity:
            dateView.hidden = NO;locationView.hidden = NO;
            titleView.hidden = NO; introductionView.hidden = NO;
            priceView.hidden = NO; nextButton.hidden = NO;
            if (_subcate1!=99) {
                [mainScrollView addSubview:typeView];
                [viewsArray addObject:typeView];
            }
            [mainScrollView addSubview:titleView];
            [viewsArray addObject:titleView];
            [mainScrollView addSubview:introductionView];
            [viewsArray addObject:introductionView];
            [mainScrollView addSubview:dateView];
            [viewsArray addObject:dateView];
            [mainScrollView addSubview:locationView];
            [viewsArray addObject:locationView];
            
            [mainScrollView addSubview:priceView];
            [viewsArray addObject:priceView];
            
            break;
//        case DiscoverPlayOther:
//            locationView.hidden = NO;
//            [mainScrollView addSubview:locationView];
//            [viewsArray addObject:locationView];
//            [mainScrollView addSubview:titleView];
//            [viewsArray addObject:titleView];
//            [mainScrollView addSubview:introductionView];
//            [viewsArray addObject:introductionView];
//            break;
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
-(IBAction)dateResponse:(id)sender{
    [self dismissKeyboard];
    currentDateButton = sender;
    UIButton *button = sender;
    if (button.tag == 11) {
        if (!dateString) {
            NSDate *currentDate = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
            NSString *dtrDate = [dateFormatter stringFromDate:currentDate];
            button.selected = YES;
            [button setTitle:dtrDate forState:UIControlStateSelected];
            dateString = dtrDate;
        }
    }
    else if (button.tag == 12){
        if (!endString) {
            NSDate *currentDate = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
            NSString *dtrDate = [dateFormatter stringFromDate:currentDate];
            button.selected = YES;
            [button setTitle:dtrDate forState:UIControlStateSelected];
            endString = dtrDate;
        }
    }
    datePicker.hidden = NO;
    confirmBackgroundView.hidden = NO;
}
-(void)datePickerChanged{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSString *dtrDate = [dateFormatter stringFromDate:datePicker.date];
    UIButton *button = currentDateButton;
    [button setTitle:dtrDate forState:UIControlStateSelected];
    if (button.tag == 11){
        dateString = dtrDate;
    }
    else if (button.tag == 12){
        endString = dtrDate;
    }
}
-(IBAction)typeResponse:(id)sender{
    UIButton *button = sender;
    button.selected = YES;
    if (!typeString) {
        typeString = @"00";
        [button setTitle:[typeArray objectAtIndex:0] forState:UIControlStateSelected];
    }
    typePickerView.hidden = NO;
    confirmBackgroundView.hidden = NO;
//    if (_controllerType==DiscoverPlayActivity) {
//        dateView.hidden = NO;
//    }
//    else
//        locationView.hidden = NO;
}
-(void)timeAggResponse{
    UIView *checkView = [dateView viewWithTag:31];
    timeAgg = !timeAgg;
    checkView.backgroundColor = (timeAgg)?SYColor4:[UIColor clearColor];
}
-(void)numberAggResponse{
    UIView *checkView = [priceView viewWithTag:13];
    numberAgg = !numberAgg;
    checkView.backgroundColor = (numberAgg)?SYColor4:[UIColor clearColor];
}
-(void)locationResponse{
    [self dismissKeyboard];
    [self pickerConfirmResponse];
    
    DiscoverLocationViewController *viewController = [DiscoverLocationViewController new];
    viewController.previousController = self;
    viewController.nextControllerType = SYDiscoverNextShareLearn;
    [self presentViewController:viewController animated:YES completion:nil];
//    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)locationCompleteResponse{
    UIButton *locationButton = [locationView viewWithTag:11];
    locationButton.selected = YES;
    [locationButton setTitle:[[[_selectedItem placemark] addressDictionary] valueForKey:@"Street"] forState:UIControlStateSelected];
    
    titleView.hidden = NO;
    
}
- (void)pickerConfirmResponse{
    confirmBackgroundView.hidden = YES;
    datePicker.hidden = YES;
    typePickerView.hidden = YES;
}
-(void)nextResponse{
    NSString *subCate;
    NSString *startLatitude;
    NSString *startLongitude;
    UITextField *numberField = [priceView viewWithTag:12];
    numberString = (numberAgg)?@"999":numberField.text;
    priceString = [(UITextField*)[priceView viewWithTag:11] text];
    
//    NSString *endTimeString =(timeAgg)?@"2099-01-01 09:00":[NSString stringWithFormat:@"%@-%@-%@ %@:%@",[(UITextField*)[dateView viewWithTag:21] text],[(UITextField*)[dateView viewWithTag:22] text],[(UITextField*)[dateView viewWithTag:23] text],[(UITextField*)[dateView viewWithTag:24] text],[(UITextField*)[dateView viewWithTag:25] text]];
    switch (_controllerType) {
//        case DiscoverPlayPartner:
//            subCate= [NSString stringWithFormat:@"%02ld%02ld0000",_subcate1,[typeString integerValue]];
//            startLatitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
//            startLongitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.longitude];
//            priceString = @"1";
//            break;
        case DiscoverPlayActivity:
            subCate= [NSString stringWithFormat:@"01%02ld%02ld00",_subcate1,[typeString integerValue]];
            startLatitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
            startLongitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.longitude];
            break;
//        case DiscoverPlayOther:
//            subCate= [NSString stringWithFormat:@"99%02ld0000",[typeString integerValue]];
//            startLatitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
//            startLongitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.longitude];
//            break;
            
        default:
            break;
    }
    
    UITextField *title = [titleView viewWithTag:11];
    UITextView *introduction = [introductionView viewWithTag:11];
    
    NSString *requestBody = [NSString stringWithFormat:@"expire_date=%@&email=%@&latitude=%f&longitude=%f&category=4&subcate=%@&title=%@&introduction=%@&start_lati=%@&start_long=%@&price=%@&number=%@&start_time=%@&end_time=%@&is_other=%d",dateString,MEID,[[_selectedItem placemark] coordinate].latitude,[[_selectedItem placemark] coordinate].longitude,subCate,title.text, introduction.text,startLatitude,startLongitude,priceString,numberString,dateString,endString,is_other];
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
        if (_controllerType==DiscoverPlayActivity)
            priceView.hidden = NO;
        
        introductionView.hidden = NO;
        
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
    UITextView *textView = [introductionView viewWithTag:11];
    [textView resignFirstResponder];
    textField = [priceView viewWithTag:11];
    [textField resignFirstResponder];
    textField = [priceView viewWithTag:12];
    [textField resignFirstResponder];
    textField = [dateView viewWithTag:11];
    [textField resignFirstResponder];
    textField = [dateView viewWithTag:12];
    [textField resignFirstResponder];
    textField = [dateView viewWithTag:13];
    [textField resignFirstResponder];
    textField = [dateView viewWithTag:14];
    [textField resignFirstResponder];
    textField = [dateView viewWithTag:15];
    [textField resignFirstResponder];
    textField = [dateView viewWithTag:21];
    [textField resignFirstResponder];
    textField = [dateView viewWithTag:22];
    [textField resignFirstResponder];
    textField = [dateView viewWithTag:23];
    [textField resignFirstResponder];
    textField = [dateView viewWithTag:24];
    [textField resignFirstResponder];
    textField = [dateView viewWithTag:25];
    [textField resignFirstResponder];
}



- (void)priceSlider:(UISlider *)slider priceChangeToValue:(NSInteger)price{
    priceString = [NSString stringWithFormat:@"%ld",price];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:priceString, @"price", nil];
    [_shareDict addEntriesFromDictionary:dict];
}
-(void)lowerPriceChangeToValue:(NSInteger)lowerPrice upperToValue:(NSInteger)upperPrice{
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    float result;
    if ([pickerView isEqual:typePickerView]) {
        result = typeArray.count;
    }
    return result;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component{
    NSString *resultString = [NSString new];
    if ([pickerView isEqual:typePickerView]) {
        resultString = [typeArray objectAtIndex:row];
    }
    return resultString;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if ([pickerView isEqual:typePickerView]) {
        is_other = (row==typeArray.count-1)?YES:NO;
        UIButton *typeButton = [typeView viewWithTag:11];
        [typeButton setTitle:[typeArray objectAtIndex:row] forState:UIControlStateSelected];
        typeString = (row==typeArray.count-1)?@"99":[NSString stringWithFormat:@"%ld",row];
        
    }
}
@end
