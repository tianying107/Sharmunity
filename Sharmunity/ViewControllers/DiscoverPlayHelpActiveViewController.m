//
//  DiscoverPlayHelpActiveViewController.m
//  Sharmunity
//
//  Created by st chen on 2017/2/15.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "DiscoverPlayHelpActiveViewController.h"
#import "DiscoverLocationViewController.h"
#import "Header.h"
#import "SYHeader.h"
@interface DiscoverPlayHelpActiveViewController ()<SYPriceSliderDelegate>{
    SYPopOut *popOut;
}


@end

@implementation DiscoverPlayHelpActiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (_controllerType) {
        case DiscoverPlayPartner:
            self.navigationItem.title = @"找玩伴";
            break;
        case DiscoverPlayActivity:
            self.navigationItem.title = @"组织活动";
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
    /*type data*/
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"PlayType_cn"
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
    typeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    UILabel *typeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 20, 100, 60)];
    typeTitleLabel.text = @"活动";
    typeTitleLabel.textColor = SYColor1;
    [typeView addSubview:typeTitleLabel];
    UIButton *typeButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 20, viewWidth-2*originX, 60)];
    [typeButton setTitle:@"请选择活动类型" forState:UIControlStateNormal];
    [typeButton setTitleColor:SYColor3 forState:UIControlStateNormal];
    [typeButton setTitleColor:SYColor1 forState:UIControlStateSelected];
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
    [locationButton setTitle:@"请选择活动位置" forState:UIControlStateNormal];
    [locationButton addTarget:self action:@selector(locationResponse) forControlEvents:UIControlEventTouchUpInside];
    locationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [locationView addSubview:locationButton];
    
    /*title*/
    keywordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    keywordView.hidden = YES;
    UILabel *titleTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 100, 40)];
    titleTitleLabel.text = @"关键词";
    titleTitleLabel.textColor = SYColor1;
    [keywordView addSubview:titleTitleLabel];
    UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(originX, 40, viewWidth-2*originX, 30)];
    textfield.tag = 11;
    [textfield addTarget:self action:@selector(titleEmptyCheck) forControlEvents:UIControlEventEditingChanged];
    textfield.backgroundColor = [UIColor whiteColor];
    [keywordView addSubview:textfield];
    
    /*price*/
    priceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 140)];
    priceView.hidden = YES;
    UILabel *priceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 200, 60)];
    priceTitleLabel.text = @"接受的价格区间";
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
        case DiscoverPlayPartner:
            [mainScrollView addSubview:typeView];
            [viewsArray addObject:typeView];
            [mainScrollView addSubview:locationView];
            [viewsArray addObject:locationView];
            [mainScrollView addSubview:keywordView];
            [viewsArray addObject:keywordView];
            break;
        case DiscoverPlayActivity:
            [mainScrollView addSubview:typeView];
            [viewsArray addObject:typeView];
            [mainScrollView addSubview:locationView];
            [viewsArray addObject:locationView];
            [mainScrollView addSubview:keywordView];
            [viewsArray addObject:keywordView];
            [mainScrollView addSubview:priceView];
            [viewsArray addObject:priceView];
            break;
        case DiscoverPlayOther:
            locationView.hidden = NO;
            [mainScrollView addSubview:locationView];
            [viewsArray addObject:locationView];
            [mainScrollView addSubview:keywordView];
            [viewsArray addObject:keywordView];
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

-(IBAction)typeResponse:(id)sender{
    UIButton *button = sender;
    button.selected = YES;
    if (!typeString) {
        typeString = @"0";
        [button setTitle:[typeArray objectAtIndex:0] forState:UIControlStateSelected];
    }
    typePickerView.hidden = NO;
    confirmBackgroundView.hidden = NO;
    locationView.hidden = NO;
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
    keywordView.hidden = NO;
}
- (void)pickerConfirmResponse{
    confirmBackgroundView.hidden = YES;
    
    typePickerView.hidden = YES;
}
-(void)nextResponse{
    NSString *subCate;
    NSString *startLatitude;
    NSString *startLongitude;
    
    switch (_controllerType) {
        case DiscoverPlayPartner:
            subCate= [NSString stringWithFormat:@"01%02ld0000",[typeString integerValue]];
            startLatitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
            startLongitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.longitude];
            lowerPriceString = @"0";
            upperPriceString = @"2";
            break;
        case DiscoverPlayActivity:
            subCate= [NSString stringWithFormat:@"02%02ld0000",[typeString integerValue]];
            startLatitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
            startLongitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.longitude];
            break;
        case DiscoverPlayOther:
            subCate= [NSString stringWithFormat:@"99%02ld0000",[typeString integerValue]];
            startLatitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
            startLongitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.longitude];
            break;
            
        default:
            break;
    }
    
    UITextField *keyword = [keywordView viewWithTag:11];
    
    NSString *requestBody = [NSString stringWithFormat:@"email=%@&latitude=%f&longitude=%f&category=3&subcate=%@&keyword=%@&upper_price=%@&lower_price=%@",MEID,[[_selectedItem placemark] coordinate].latitude,[[_selectedItem placemark] coordinate].longitude,subCate,keyword.text,upperPriceString,lowerPriceString];
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
        if (_controllerType==DiscoverPlayActivity)
            priceView.hidden = NO;
        
        nextButton.hidden = NO;
        
    }
}
-(void)dismissKeyboard {
    UITextField *textField = [keywordView viewWithTag:11];
    [textField resignFirstResponder];
}



- (void)priceSlider:(UISlider *)slider priceChangeToValue:(NSInteger)price{
    
}
-(void)lowerPriceChangeToValue:(NSInteger)lowerPrice upperToValue:(NSInteger)upperPrice{
    lowerPriceString = [NSString stringWithFormat:@"%ld",lowerPrice];
    upperPriceString = [NSString stringWithFormat:@"%ld",upperPrice];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:lowerPriceString, @"lower_price",upperPriceString,@"upper_price", nil];
    [_shareDict addEntriesFromDictionary:dict];
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
