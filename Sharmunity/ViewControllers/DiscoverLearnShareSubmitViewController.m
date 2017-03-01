//
//  DiscoverLearnShareSubmitViewController.m
//  Sharmunity
//
//  Created by st chen on 2017/2/13.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "DiscoverLearnShareSubmitViewController.h"
#import "DiscoverLocationViewController.h"
#import "Header.h"
#import "SYHeader.h"
@interface DiscoverLearnShareSubmitViewController ()<SYPriceSliderDelegate>{
    SYPopOut *popOut;
    SYTextView *contentTextView;
}

@end

@implementation DiscoverLearnShareSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (_controllerType) {
        case discoverLearnExper:
            self.navigationItem.title = @"学长咨询";
            break;
        case discoverLearnTutor:
            self.navigationItem.title = @"课程辅导";
            break;
        case discoverLearnInterest:
            self.navigationItem.title = @"开兴趣班";
            break;
            
        default:
            break;
    }
    self.view.backgroundColor = SYBackgroundColorExtraLight;
    
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mainScrollView.backgroundColor = SYBackgroundColorExtraLight;
    [self.view addSubview:mainScrollView];
    
    MEID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
    _shareDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:MEID,@"email",@"3",@"category",@"2099-01-01",@"expire_date", nil];
    
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
    [self viewsSetup];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"SYBackColor4"] forState:UIControlStateNormal];
    [backBtn setTitle:@"住" forState:UIControlStateNormal];
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

-(void)viewsSetup{
    viewsArray = [NSMutableArray new];
    float viewWidth = mainScrollView.frame.size.width;
    float originX = 40;
    
    /*type*/
    typeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 80)];
    UIButton *majorTypeButton = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth/2-150, 20, 150, 40)];
    [majorTypeButton setTitle:@"专业咨询" forState:UIControlStateNormal];
    [majorTypeButton setTitleColor:SYColor8 forState:UIControlStateNormal];
    [majorTypeButton.titleLabel setFont:SYFont20];
    majorTypeButton.tag = 11;
    [majorTypeButton addTarget:self action:@selector(typeResponse:) forControlEvents:UIControlEventTouchUpInside];
    [typeView addSubview:majorTypeButton];
    UIButton *appTypeButton = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth/2, 20, 150, 40)];
    [appTypeButton setTitle:@"申请辅导" forState:UIControlStateNormal];
    [appTypeButton setTitleColor:SYColor8 forState:UIControlStateNormal];
    [appTypeButton.titleLabel setFont:SYFont20];
    appTypeButton.tag = 10;
    [appTypeButton addTarget:self action:@selector(typeResponse:) forControlEvents:UIControlEventTouchUpInside];
    [typeView addSubview:appTypeButton];
    
    /*major type*/
    schoolContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 290)];
    schoolContentView.hidden = YES;
    SYTextField *schoolTextfield = [[SYTextField alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 40) type:SYTextFieldShare];
    schoolTextfield.tag = 11;
    [schoolContentView addSubview:schoolTextfield];
    SYTextField *collegeTextfield = [[SYTextField alloc] initWithFrame:CGRectMake(originX, 50, viewWidth-2*originX, 40) type:SYTextFieldShare];
    collegeTextfield.tag = 12;
    collegeTextfield.backgroundColor = [UIColor whiteColor];
    [schoolContentView addSubview:collegeTextfield];
    SYTextField *departmentTextfield = [[SYTextField alloc] initWithFrame:CGRectMake(originX, 100, viewWidth-2*originX, 40) type:SYTextFieldShare];
    departmentTextfield.tag = 13;
    departmentTextfield.backgroundColor = [UIColor whiteColor];
    [schoolContentView addSubview:departmentTextfield];
    SYTextField *majorTextfield = [[SYTextField alloc] initWithFrame:CGRectMake(originX, 150, viewWidth-2*originX, 40) type:SYTextFieldShare];
    majorTextfield.tag = 14;
//    [majorTextfield addTarget:self action:@selector(majorEmptyCheck) forControlEvents:UIControlEventEditingChanged];
    majorTextfield.backgroundColor = [UIColor whiteColor];
    [schoolContentView addSubview:majorTextfield];
    contentTextView = [[SYTextView alloc] initWithFrame:CGRectMake(originX, 205, viewWidth-2*originX, 70) type:SYTextViewShare];
    [schoolContentView addSubview:contentTextView];
    


    
    /*price*/
    priceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 45)];
    priceView.hidden = YES;
    UILabel *priceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 100, 45)];
    priceTitleLabel.text = @"价格";
    priceTitleLabel.textColor = SYColor4;
    [priceTitleLabel setFont:SYFont25];
    [priceView addSubview:priceTitleLabel];
    UITextField *priceTextField = [[UITextField alloc] initWithFrame:CGRectMake(175, 0, 90, 45)];
    priceTextField.textColor = SYColor4;
    [priceTextField setFont:SYFont20];
    priceTextField.textAlignment = NSTextAlignmentRight;
    priceTextField.tag = 11;
    priceTextField.keyboardType = UIKeyboardTypeNumberPad;
//    [priceTextField addTarget:self action:@selector(priceEmptyCheck) forControlEvents:UIControlEventEditingChanged];
    [priceView addSubview:priceTextField];
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(175, 32, 90, SYSeparatorHeight)];
    separator.backgroundColor = SYColor4;
    [priceView addSubview:separator];
    UILabel *dollarLabel = [[UILabel alloc] initWithFrame:CGRectMake(155, 0, 20, 45)];
    dollarLabel.text = @"$";
    dollarLabel.textColor = SYColor4;
    [dollarLabel setFont:SYFont20];
    [priceView addSubview:dollarLabel];
    UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(275, 0, 40, 45)];
    monthLabel.text = @"/月";
    monthLabel.textColor = SYColor4;
    [monthLabel setFont:SYFont20];
    monthLabel.tag = 12;
    [priceView addSubview:monthLabel];
    
    /*price2*/
    price2View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 80)];
    price2View.hidden = YES;
    UILabel *price2TitleLabel = [[UILabel alloc] init];
    price2TitleLabel.text = @"费用";
    [price2TitleLabel setFont:SYFont20];
    price2TitleLabel.textColor = SYColor1;
    [price2TitleLabel sizeToFit];
    price2TitleLabel.frame = CGRectMake(55, 0, price2TitleLabel.frame.size.width, 40);
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
    
    nextButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 32)];
    [nextButton setTitle:@"提交" forState:UIControlStateNormal];
    [nextButton setBackgroundColor:SYColor4];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton.titleLabel setFont:SYFont20M];
    [nextButton addTarget:self action:@selector(nextResponse) forControlEvents:UIControlEventTouchUpInside];
    nextButton.layer.cornerRadius = 8;
    nextButton.clipsToBounds = YES;
    nextButton.hidden = YES;
    
    
    
    
    
    switch (_controllerType) {
        case discoverLearnExper:
            [mainScrollView addSubview:typeView];
            [viewsArray addObject:typeView];
            [mainScrollView addSubview:schoolContentView];
            [viewsArray addObject:schoolContentView];
            [mainScrollView addSubview:price2View];
            [viewsArray addObject:price2View];
            schoolTextfield.placeholder = @"目标学校（请输入英文全称）";
            collegeTextfield.placeholder = @"目标学院（请输入英文全称）";
            departmentTextfield.placeholder = @"目标专业（请输入英文全称）";
            majorTextfield.placeholder = @"专业编号";
            break;
        case discoverLearnTutor:
            [mainScrollView addSubview:majorView];
            [viewsArray addObject:majorView];
            [mainScrollView addSubview:numberView];
            [viewsArray addObject:numberView];
            [mainScrollView addSubview:titleView];
            [viewsArray addObject:titleView];
            [mainScrollView addSubview:introductionView];
            [viewsArray addObject:introductionView];
            [mainScrollView addSubview:priceView];
            [viewsArray addObject:priceView];
            schoolTextfield.placeholder = @"学校（请输入英文全称）";
            collegeTextfield.placeholder = @"学院（请输入英文全称）";
            departmentTextfield.placeholder = @"专业（请输入英文全称）";
            majorTextfield.placeholder = @"课程编号";
            break;
        case discoverLearnInterest:
            titleView.hidden = NO;
            [mainScrollView addSubview:titleView];
            [viewsArray addObject:titleView];
            [mainScrollView addSubview:locationView];
            [viewsArray addObject:locationView];
            [mainScrollView addSubview:introductionView];
            [viewsArray addObject:introductionView];
            [mainScrollView addSubview:priceView];
            [viewsArray addObject:priceView];
            break;
        default:
            break;
    }
    
    
    [mainScrollView addSubview:nextButton];
    [viewsArray addObject:nextButton];
    [self viewsLayout];
}

-(void)viewsLayout{
    float height = 10;
    for (UIView *view in viewsArray){
        CGRect frame = view.frame;
        frame.origin.y = height;
        [view setFrame:frame];
        height += frame.size.height;
    }
    mainScrollView.contentSize = CGSizeMake(0, height+20+44+10);
}

-(IBAction)typeResponse:(id)sender{
    UIButton *button = sender;
    if (button.tag-10) {
        typeString = @"01";
        [button setTitleColor:SYColor4 forState:UIControlStateNormal];
        UIButton *button2 = [typeView viewWithTag:10];
        [button2 setTitleColor:SYColor8 forState:UIControlStateNormal];
        [button.titleLabel setFont:SYFont25M];
        [button2.titleLabel setFont:SYFont20];
        [contentTextView setPlaceholder:@"咨询内容（选填）如：专业内容，难易；如何选专业等。"];
    }
    else{
        typeString = @"02";
        [button setTitleColor:SYColor4 forState:UIControlStateNormal];
        UIButton *button2 = [typeView viewWithTag:11];
        [button2 setTitleColor:SYColor8 forState:UIControlStateNormal];
        [button.titleLabel setFont:SYFont25M];
        [button2.titleLabel setFont:SYFont20];
        [contentTextView setPlaceholder:@"辅导内容（选填）如：PS修改，简历修改等。"];
    }
    schoolContentView.hidden = NO;
    price2View.hidden = NO;
    nextButton.hidden = NO;
    [self viewsLayout];
}

-(void)locationResponse{
    [self dismissKeyboard];
    
    DiscoverLocationViewController *viewController = [DiscoverLocationViewController new];
    viewController.previousController = self;
    viewController.nextControllerType = SYDiscoverNextShareLearn;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)locationCompleteResponse{
    UIButton *locationButton = [locationView viewWithTag:11];
    locationButton.selected = YES;
    [locationButton setTitle:[[[_selectedItem placemark] addressDictionary] valueForKey:@"Street"] forState:UIControlStateSelected];
    introductionView.hidden = NO;
}
-(void)priceAggResponse{
    UIView *checkView = [price2View viewWithTag:12];
    priceAgg = !priceAgg;
    checkView.backgroundColor = (priceAgg)?SYColor4:[UIColor clearColor];
}
-(void)nextResponse{
    NSString *subCate;
    NSString *majorString;
    NSString *numberString;
    NSString *latitude;
    NSString *longitude;
    NSString *requestBody;
    UITextField *school = [schoolContentView viewWithTag:11];
    UITextField *college = [schoolContentView viewWithTag:12];
    UITextField *department = [schoolContentView viewWithTag:13];
    UITextField *major = [schoolContentView viewWithTag:14];
    UITextView *introduction = [introductionView viewWithTag:11];
    switch (_controllerType) {
        case discoverLearnExper:
            subCate= @"01000000";
            priceString = ((UITextField*)[price2View viewWithTag:11]).text;
            latitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
            longitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.longitude];
            requestBody = [NSString stringWithFormat:@"email=%@&latitude=%@&longitude=%@&category=3&subcate=%@&school=%@&introduction=%@&major=%@&college=%@&price=%@&department=%@&changable=%d",MEID,latitude,longitude,subCate,school.text, contentTextView.text,major.text,college.text,priceString,department.text,priceAgg];
            break;
        case discoverLearnTutor:
            subCate= @"02000000";
            latitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
            longitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.longitude];
            requestBody = [NSString stringWithFormat:@"email=%@&latitude=%@&longitude=%@&category=3&subcate=%@&school=%@&introduction=%@&major=%@&college=%@&price=%@&department=%@&changable=%d",MEID,latitude,longitude,subCate,school.text, contentTextView.text,major.text,college.text,priceString,department.text,priceAgg];
            break;
        case discoverLearnInterest:
            subCate= @"03000000";
            majorString = @"";
            numberString = @"";
            latitude = [NSString stringWithFormat:@"%f",[[_selectedItem placemark] coordinate].latitude];
            longitude = [NSString stringWithFormat:@"%f",[[_selectedItem placemark] coordinate].longitude];
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
        if (_controllerType == discoverLearnInterest) {
            locationView.hidden = NO;
        }
        else
            introductionView.hidden = NO;
    }
}
-(void)majorEmptyCheck{
    UITextView *textView = [majorView viewWithTag:11];
    if ([textView.text length]) {
        titleView.hidden = NO;
    }
}
-(void)textViewDidChange:(UITextView *)textView{
    if ([textView.text length]) {
        if (_controllerType!=discoverLearnExper) {
            priceView.hidden = NO;
        }
        nextButton.hidden = NO;
    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text length]) {
        nextButton.hidden = NO;
    }
}
-(void)dismissKeyboard {
    UITextField *textField = [majorView viewWithTag:11];
    [textField resignFirstResponder];
    textField = [numberView viewWithTag:11];
    [textField resignFirstResponder];
    textField = [titleView viewWithTag:11];
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
