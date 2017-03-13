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
@interface DiscoverPlayHelpActiveViewController (){
    SYPopOut *popOut;
}


@end

@implementation DiscoverPlayHelpActiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"找活动";
    self.view.backgroundColor = SYBackgroundColorExtraLight;
    
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mainScrollView.backgroundColor = SYBackgroundColorExtraLight;
    [self.view addSubview:mainScrollView];
    
    MEID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
//                                   initWithTarget:self
//                                   action:@selector(dismissKeyboard)];
//    [self.view addGestureRecognizer:tap];
    
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
//    [self dataSetup];
    [self viewsSetup];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"SYBackColor5"] forState:UIControlStateNormal];
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
//    [self viewsSetup];
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
    NSString* filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"PlayType%ld_cn",subcate1]
                                                         ofType:@"txt"];
    NSString *categoryString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    typeArray = [NSArray new];
    typeArray = [categoryString componentsSeparatedByString:@","];
    [typePickerView reloadAllComponents];
    [typePickerView selectRow:0 inComponent:0 animated:NO];
}
-(void)viewsSetup{
    viewsArray = [NSMutableArray new];
    float viewWidth = mainScrollView.frame.size.width;
    float originX = 30;
    
    /*subcate 1 view*/
    subcate1View = [[UIView alloc] initWithFrame:CGRectMake(10, 0, viewWidth-20, 50)];
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, viewWidth-20, 40)];
    [button1 setTitle:@"体育运动" forState:UIControlStateNormal];
    [button1 setTitleColor:SYColor7 forState:UIControlStateNormal];
    [button1.titleLabel setFont:SYFont20];
    button1.tag = 11;
    [button1 addTarget:self action:@selector(subcateResponse:) forControlEvents:UIControlEventTouchUpInside];
    [subcate1View addSubview:button1];
    
    /*subcate 2 view*/
    subcate2View = [[UIView alloc] initWithFrame:CGRectMake(10, 0, viewWidth-20, 50)];
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, viewWidth-20, 40)];
    [button2 setTitle:@"社交活动" forState:UIControlStateNormal];
    [button2 setTitleColor:SYColor7 forState:UIControlStateNormal];
    [button2.titleLabel setFont:SYFont20];
    button2.tag = 11;
    [button2 addTarget:self action:@selector(subcateResponse:) forControlEvents:UIControlEventTouchUpInside];
    [subcate2View addSubview:button2];
    
    /*subcate 3 view*/
    subcate3View = [[UIView alloc] initWithFrame:CGRectMake(10, 0, viewWidth-20, 50)];
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, viewWidth-20, 40)];
    [button3 setTitle:@"户外冒险" forState:UIControlStateNormal];
    [button3 setTitleColor:SYColor7 forState:UIControlStateNormal];
    [button3.titleLabel setFont:SYFont20];
    button3.tag = 11;
    [button3 addTarget:self action:@selector(subcateResponse:) forControlEvents:UIControlEventTouchUpInside];
    [subcate3View addSubview:button3];
    
    /*subcate 4 view*/
    subcate4View = [[UIView alloc] initWithFrame:CGRectMake(10, 0, viewWidth-20, 50)];
    UIButton *button4 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, viewWidth-20, 40)];
    [button4 setTitle:@"旅游度假" forState:UIControlStateNormal];
    [button4 setTitleColor:SYColor7 forState:UIControlStateNormal];
    [button4.titleLabel setFont:SYFont20];
    button4.tag = 11;
    [button4 addTarget:self action:@selector(subcateResponse:) forControlEvents:UIControlEventTouchUpInside];
    [subcate4View addSubview:button4];
    
    /*subcate 5 view*/
    subcate5View = [[UIView alloc] initWithFrame:CGRectMake(10, 0, viewWidth-20, 50)];
    UIButton *button5 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, viewWidth-20, 40)];
    [button5 setTitle:@"棋牌游戏" forState:UIControlStateNormal];
    [button5 setTitleColor:SYColor7 forState:UIControlStateNormal];
    [button5.titleLabel setFont:SYFont20];
    button5.tag = 11;
    [button5 addTarget:self action:@selector(subcateResponse:) forControlEvents:UIControlEventTouchUpInside];
    [subcate5View addSubview:button5];
    
    /*activity type*/
    typeView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, viewWidth, 50)];
    UILabel *typeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 110, 40)];
    typeTitleLabel.text = @"种类";
    typeTitleLabel.textColor = SYColor5;
    [typeTitleLabel setFont:SYFont20];
//    typeTitleLabel.textAlignment = NSTextAlignmentRight;
    [typeView addSubview:typeTitleLabel];
    UIButton *typeButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-20-2*originX, 40)];
    [typeButton setTitleColor:SYColor6 forState:UIControlStateNormal];
    [typeButton setTitleColor:SYColor5 forState:UIControlStateSelected];
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
    locationView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, viewWidth, 50)];
    UILabel *locationTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 110, 40)];
    locationTitleLabel.text = @"位置范围";
    locationTitleLabel.textColor = SYColor5;
    locationTitleLabel.textAlignment = NSTextAlignmentLeft;
    [locationTitleLabel setFont:SYFont20];
    [locationView addSubview:locationTitleLabel];
    UIButton *locationButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-20-2*originX, 40)];
    locationButton.tag = 11;
    [locationButton setTitleColor:SYColor6 forState:UIControlStateNormal];
    [locationButton setTitleColor:SYColor5 forState:UIControlStateSelected];
    [locationButton setTitle:@"请选择活动位置" forState:UIControlStateNormal];
    [locationButton.titleLabel setFont:SYFont20];
    [locationButton addTarget:self action:@selector(locationResponse) forControlEvents:UIControlEventTouchUpInside];
    locationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [locationView addSubview:locationButton];
    
//    /*title*/
//    keywordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
//    keywordView.hidden = YES;
//    UILabel *titleTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 100, 40)];
//    titleTitleLabel.text = @"关键词";
//    titleTitleLabel.textColor = SYColor1;
//    [keywordView addSubview:titleTitleLabel];
//    UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(originX, 40, viewWidth-2*originX, 30)];
//    textfield.tag = 11;
//    [textfield addTarget:self action:@selector(titleEmptyCheck) forControlEvents:UIControlEventEditingChanged];
//    textfield.backgroundColor = [UIColor whiteColor];
//    [keywordView addSubview:textfield];
    
    
    originX = 60;
    nextButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 150, viewWidth-2*originX, 35)];
    [nextButton setTitle:@"提交" forState:UIControlStateNormal];
    [nextButton setBackgroundColor:SYColor7];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton.titleLabel setFont:SYFont20M];
    [nextButton addTarget:self action:@selector(nextResponse) forControlEvents:UIControlEventTouchUpInside];
    nextButton.layer.cornerRadius = 8;
    nextButton.clipsToBounds = YES;
//    nextButton.hidden = YES;
    
    
    
    
    
    
//            [mainScrollView addSubview:typeView];
//            [viewsArray addObject:typeView];
//            [mainScrollView addSubview:locationView];
//            [viewsArray addObject:locationView];
//            [mainScrollView addSubview:keywordView];
//            [viewsArray addObject:keywordView];
    [mainScrollView addSubview:subcate1View];
    [viewsArray addObject:subcate1View];
    [mainScrollView addSubview:subcate2View];
    [viewsArray addObject:subcate2View];
    [mainScrollView addSubview:subcate3View];
    [viewsArray addObject:subcate3View];
    [mainScrollView addSubview:subcate4View];
    [viewsArray addObject:subcate4View];
    [mainScrollView addSubview:subcate5View];
    [viewsArray addObject:subcate5View];
    
    
//    [viewsArray addObject:_otherGroup];
//    [viewsArray addObject:_subcate2Button];
//    [viewsArray addObject:_subcate3Button];
//    [viewsArray addObject:_subcate4Button];
//    [viewsArray addObject:_subcate5Button];
    
//    [mainScrollView addSubview:nextButton];
//    [viewsArray addObject:nextButton];
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

-(IBAction)subcateResponse:(id)sender{
    typeString = nil;
    [self pickerConfirmResponse];
    [typeView removeFromSuperview];
    [locationView removeFromSuperview];
    UIButton *selectButton = sender;
    UIView *view = [sender superview];
    
    UIButton *typeButton = [typeView viewWithTag:11];
    typeButton.selected = NO;
    [typeButton setTitle:[NSString stringWithFormat:@"请选择%@名称",selectButton.titleLabel.text] forState:UIControlStateNormal];
    
    
    UIButton *locationButton = [locationView viewWithTag:11];
    locationButton.selected = NO;

    for (int i=0; i<5; i++) {
        UIView *view = [viewsArray objectAtIndex:i];
        UIButton *button = [view viewWithTag:11];
        CGRect frame = view.frame;
        frame.size.height = 50;
        [view setFrame:frame];
        [button setTitleColor:SYColor7 forState:UIControlStateNormal];
        [button.titleLabel setFont:SYFont20];
        view.layer.borderWidth = 0;
    }
    
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 210);
    [view addSubview:typeView];
    [view addSubview:locationView];
    [view addSubview:nextButton];
    view.layer.borderWidth = 1;
    view.layer.borderColor = [SYSeparatorColor CGColor];
    [selectButton setTitleColor:SYColor5 forState:UIControlStateNormal];
    [selectButton.titleLabel setFont:SYFont25M];
    subcate1 = [viewsArray indexOfObject:view]+1;
    [self dataSetup];
    [self viewsLayout];
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
//    [self dismissKeyboard];
    [self pickerConfirmResponse];
    
    DiscoverLocationViewController *viewController = [DiscoverLocationViewController new];
    viewController.previousController = self;
    viewController.needDistance = YES;
    viewController.nextControllerType = SYDiscoverNextHelp;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)locationCompleteResponse{
    UIButton *locationButton = [locationView viewWithTag:11];
    locationButton.selected = YES;
    [locationButton.titleLabel setNumberOfLines:2];
    [locationButton setTitle:[NSString stringWithFormat:@"%@\n附近%@英里",[[[_selectedItem placemark] addressDictionary] valueForKey:@"Street"],_distanceString] forState:UIControlStateSelected];
}
- (void)pickerConfirmResponse{
    confirmBackgroundView.hidden = YES;
    typePickerView.hidden = YES;
}
-(void)nextResponse{
    NSString *subCate;
    NSString *startLatitude;
    NSString *startLongitude;
    
//    switch (_controllerType) {
//        case DiscoverPlayPartner:
//            subCate= [NSString stringWithFormat:@"01%02ld0000",[typeString integerValue]];
//            startLatitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
//            startLongitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.longitude];
//            lowerPriceString = @"0";
//            upperPriceString = @"2";
//            break;
//        case DiscoverPlayActivity:
            subCate= [NSString stringWithFormat:@"01%02ld%02ld00",subcate1,[typeString integerValue]];
            startLatitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
            startLongitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.longitude];
//            break;
//        case DiscoverPlayOther:
//            subCate= [NSString stringWithFormat:@"99%02ld0000",[typeString integerValue]];
//            startLatitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
//            startLongitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.longitude];
//            break;
//            
//        default:
//            break;
//    }
    
//    UITextField *keyword = [keywordView viewWithTag:11];
    
    NSString *requestBody = [NSString stringWithFormat:@"email=%@&latitude=%f&longitude=%f&category=4&subcate=%@&distance=%@&placemark=%@",MEID,[[_selectedItem placemark] coordinate].latitude,[[_selectedItem placemark] coordinate].longitude,subCate,_distanceString,_selectedItem.placemark.name];
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

//-(void)titleEmptyCheck{
//    UITextField *textField = [keywordView viewWithTag:11];
//    if ([textField.text length]) {
//        if (_controllerType==DiscoverPlayActivity)
//            priceView.hidden = NO;
//        
//        nextButton.hidden = NO;
//        
//    }
//}
//-(void)dismissKeyboard {
//    UITextField *textField = [keywordView viewWithTag:11];
//    [textField resignFirstResponder];
//}



//- (void)priceSlider:(UISlider *)slider priceChangeToValue:(NSInteger)price{
//    
//}
//-(void)lowerPriceChangeToValue:(NSInteger)lowerPrice upperToValue:(NSInteger)upperPrice{
//    lowerPriceString = [NSString stringWithFormat:@"%ld",lowerPrice];
//    upperPriceString = [NSString stringWithFormat:@"%ld",upperPrice];
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:lowerPriceString, @"lower_price",upperPriceString,@"upper_price", nil];
//    [_shareDict addEntriesFromDictionary:dict];
//}

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
