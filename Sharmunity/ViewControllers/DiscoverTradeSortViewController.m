//
//  DiscoverTradeSortViewController.m
//  Sharmunity
//
//  Created by Star Chen on 3/12/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import "DiscoverTradeSortViewController.h"
#import "DiscoverLocationViewController.h"
#import "Header.h"
#import "SYHeader.h"
#import "DiscoverTradeListViewController.h"
@interface DiscoverTradeSortViewController (){
    SYPopOut *popOut;
}

@end

@implementation DiscoverTradeSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SYBackgroundColorExtraLight;
    self.navigationItem.title = @"过滤条件";
    
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mainScrollView.delegate = self;
    mainScrollView.backgroundColor = SYBackgroundColorExtraLight;
    [self.view addSubview:mainScrollView];
    
    MEID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
    
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
    [backBtn setTitle:@"交易" forState:UIControlStateNormal];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dataSetup{
    is_other = NO;
    /*type data*/
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"TradeType_cn"
                                                         ofType:@"txt"];
    NSString *categoryString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    typeArray = [NSArray new];
    typeArray = [categoryString componentsSeparatedByString:@","];
    expireArray = [[NSArray alloc] initWithObjects:@"不限",@"1天",@"1周",@"1个月", nil];
}
-(void)viewsSetup{
    viewsArray = [NSMutableArray new];
    float viewWidth = mainScrollView.frame.size.width;
    float originX = 30;
    
    /*location*/
    locationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 60)];
    UILabel *locationTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 140, 40)];
    locationTitleLabel.text = @"换个地方看看";
    locationTitleLabel.textColor = SYColor1;
    [locationTitleLabel setFont:SYFont20];
    [locationView addSubview:locationTitleLabel];
    UIButton *locationButton = [[UIButton alloc] initWithFrame:CGRectMake(145, 0, viewWidth-145-45, 40)];
    locationButton.tag = 11;
    [locationButton setTitleColor:SYColor1 forState:UIControlStateNormal];
    [locationButton.titleLabel setFont:SYFont20];
    [locationButton addTarget:self action:@selector(locationResponse) forControlEvents:UIControlEventTouchUpInside];
    locationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [locationView addSubview:locationButton];
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:self.locationManager.location.coordinate.latitude longitude:self.locationManager.location.coordinate.longitude];
    [ceo reverseGeocodeLocation:loc
              completionHandler:^(NSArray *placemarks, NSError *error) {
                  CLPlacemark *placemark = [placemarks objectAtIndex:0];
                  [locationButton setTitle:placemark.locality forState:UIControlStateNormal];
              }
     ];
    
    /*activity type*/
    typeView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, viewWidth, 50)];
    UILabel *typeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 110, 40)];
    typeTitleLabel.text = @"类别";
    typeTitleLabel.textColor = SYColor1;
    [typeTitleLabel setFont:SYFont20];
    //    typeTitleLabel.textAlignment = NSTextAlignmentRight;
    [typeView addSubview:typeTitleLabel];
    UIButton *typeButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-20-2*originX, 40)];
    [typeButton setTitleColor:SYColor3 forState:UIControlStateNormal];
    [typeButton setTitleColor:SYColor1 forState:UIControlStateSelected];
    [typeButton.titleLabel setFont:SYFont20];
    [typeButton setTitle:@"全部物品" forState:UIControlStateNormal];
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
    

    
    /*expire*/
    expireView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, viewWidth, 50)];
    UILabel *expireTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 110, 40)];
    expireTitleLabel.text = @"发布时间";
    expireTitleLabel.textColor = SYColor1;
    [expireTitleLabel setFont:SYFont20];
    //    typeTitleLabel.textAlignment = NSTextAlignmentRight;
    [expireView addSubview:expireTitleLabel];
    UIButton *expireButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-20-2*originX, 40)];
    [expireButton setTitleColor:SYColor3 forState:UIControlStateNormal];
    [expireButton setTitleColor:SYColor1 forState:UIControlStateSelected];
    [expireButton.titleLabel setFont:SYFont20];
    [expireButton setTitle:@"不限" forState:UIControlStateNormal];
    expireButton.tag = 11;
    expireButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [expireButton addTarget:self action:@selector(expireResponse:) forControlEvents:UIControlEventTouchUpInside];
    [expireView addSubview:expireButton];
    expirePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216, self.view.frame.size.width, 216)];
    expirePickerView.delegate = self;
    expirePickerView.dataSource = self;
    expirePickerView.backgroundColor = [UIColor whiteColor];
    expirePickerView.hidden = YES;
    [self.view addSubview:expirePickerView];
    
    /*price*/
    priceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 140)];
    UILabel *priceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 100, 40)];
        priceTitleLabel.text = @"价格区间";
        priceTitleLabel.textColor = SYColor1;
    [priceTitleLabel setFont:SYFont20];
        [priceView addSubview:priceTitleLabel];
    SYTextField *upperTextField = [[SYTextField alloc] initWithFrame:CGRectMake(viewWidth-originX-50, 2.5, 50, 35) type:SYTextFieldSeparator];
    upperTextField.tag = 12;
    upperTextField.textAlignment = NSTextAlignmentRight;
    upperTextField.keyboardType = UIKeyboardTypeNumberPad;
    [priceView addSubview:upperTextField];
    UILabel *middleLabel = [[UILabel alloc] initWithFrame:CGRectMake(upperTextField.frame.origin.x-60, 0, 60, 40)];
    middleLabel.textAlignment = NSTextAlignmentCenter;
    middleLabel.text = @"至 $";
    middleLabel.textColor = SYColor1;
    [middleLabel setFont:SYFont20];
    [priceView addSubview:middleLabel];
    SYTextField *lowerTextField = [[SYTextField alloc] initWithFrame:CGRectMake(middleLabel.frame.origin.x-50, 2.5, 50, 35) type:SYTextFieldSeparator];
    lowerTextField.tag = 11;
    lowerTextField.textAlignment = NSTextAlignmentRight;
    lowerTextField.keyboardType = UIKeyboardTypeNumberPad;
    [priceView addSubview:lowerTextField];
    UILabel *pxLabel = [[UILabel alloc] initWithFrame:CGRectMake(lowerTextField.frame.origin.x-40, 0, 40, 40)];
    pxLabel.textAlignment = NSTextAlignmentRight;
    pxLabel.text = @"$";
    pxLabel.textColor = SYColor1;
    [pxLabel setFont:SYFont20];
    [priceView addSubview:pxLabel];
    
    
    nextButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 35)];
    [nextButton setTitle:@"提交" forState:UIControlStateNormal];
    [nextButton setBackgroundColor:SYColor10];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton.titleLabel setFont:SYFont20M];
    [nextButton addTarget:self action:@selector(nextResponse) forControlEvents:UIControlEventTouchUpInside];
    nextButton.layer.cornerRadius = nextButton.frame.size.height/2;
    nextButton.clipsToBounds = YES;
    
    
    
    
    
    [mainScrollView addSubview:locationView];
    [viewsArray addObject:locationView];
    [mainScrollView addSubview:typeView];
    [viewsArray addObject:typeView];
    [mainScrollView addSubview:expireView];
    [viewsArray addObject:expireView];
    [mainScrollView addSubview:priceView];
    [viewsArray addObject:priceView];
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
    expirePickerView.hidden = YES;
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
}
-(IBAction)expireResponse:(id)sender{
    UIButton *button = sender;
    button.selected = YES;
    if (!expireString) {
        expireString = @"0";
        [button setTitle:[expireArray objectAtIndex:0] forState:UIControlStateSelected];
    }
    expirePickerView.hidden = NO;
    confirmBackgroundView.hidden = NO;
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
    else if ([pickerView isEqual:expirePickerView]) {
        result = expireArray.count;
    }
    return result;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component{
    NSString *resultString = [NSString new];
    if ([pickerView isEqual:typePickerView]) {
        resultString = [typeArray objectAtIndex:row];
    }
    else if ([pickerView isEqual:expirePickerView]){
        resultString = [expireArray objectAtIndex:row];
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
    else if ([pickerView isEqual:expirePickerView]){
        UIButton *expireButton = [typeView viewWithTag:11];
        [expireButton setTitle:[expireArray objectAtIndex:row] forState:UIControlStateSelected];
        expireString = [NSString stringWithFormat:@"%ld",row];
    }
}
-(void)nextResponse{
    NSString *subCate;
    NSString *latitude;
    NSString *longitude;
    NSString *requestQuery;
    
    UITextField *lowerPriceField = [priceView viewWithTag:11];
    UITextField *upperPriceField = [priceView viewWithTag:12];
    NSString *upperString;
    NSString *lowerString;
    NSString *distance;
    
    if (_selectedItem) {
        latitude = [NSString stringWithFormat:@"%f",[[_selectedItem placemark] coordinate].latitude];
        longitude = [NSString stringWithFormat:@"%f",[[_selectedItem placemark] coordinate].longitude];
        distance = _distanceString;
    }
    else{
        latitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
        longitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.longitude];
        distance = @"50";
    }
    lowerString =[lowerPriceField.text isEqualToString:@""]?@"0":lowerPriceField.text;
    upperString =[upperPriceField.text isEqualToString:@""]?@"99999":upperPriceField.text;
    
    subCate=(typeString)?[NSString stringWithFormat:@"%@000000",typeString]:@"99999999";
    NSString *expire = (expireString)?expireString:@"0";
    requestQuery = [NSString stringWithFormat:@"latitude=%@&longitude=%@&category=6&subcate=%@&upper_price=%@&lower_price=%@&post=%@&distance=%@",latitude,longitude,subCate,upperString,lowerString,expire,distance];
    NSString *urlString = [NSString stringWithFormat:@"%@search?%@",basicURL,requestQuery];
    NSLog(@"%@/n",urlString);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionTask *task = [session dataTaskWithURL:url
                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
        NSArray *shareIDArray = [dict valueForKey:@"result"];
        DiscoverTradeListViewController *viewController = (DiscoverTradeListViewController*)_previousController;
        [viewController reloadButtonsWithArray:shareIDArray];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else [popOut showUpPop:SYPopDiscoverShareFail];
    
}

@end
