//
//  DiscoverEatHelpSecondViewController.m
//  Sharmunity
//
//  Created by Star Chen on 2/12/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import "DiscoverEatHelpSecondViewController.h"
#import "Header.h"
#import "SYHeader.h"
@interface DiscoverEatHelpSecondViewController (){
    SYPopOut *popOut;
}

@end

@implementation DiscoverEatHelpSecondViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"按地域分类";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: SYColor1,
                                                                    NSFontAttributeName: SYFont20S};
    self.view.backgroundColor = SYBackgroundColorExtraLight;
    
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mainScrollView.backgroundColor = SYBackgroundColorExtraLight;
    [self.view addSubview:mainScrollView];
    
    MEID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
    _helpDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:MEID,@"email",@"1",@"category",@"2099-01-01",@"expire_date", nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    popOut = [SYPopOut new];
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
    /*region data*/
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"EatRegion_cn"
                                                         ofType:@"txt"];
    NSString *categoryString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    regionArray = [NSArray new];
    regionArray = [categoryString componentsSeparatedByString:@","];
    /*subregion data*/
    filePath = [[NSBundle mainBundle] pathForResource:@"EatSubRegion_cn"
                                               ofType:@"txt"];
    categoryString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    subRegionArray = [NSArray new];
    subRegionArray = [categoryString componentsSeparatedByString:@","];
    /*food data*/
    filePath = [[NSBundle mainBundle] pathForResource:@"EatFood_cn"
                                               ofType:@"txt"];
    categoryString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    foodArray = [NSArray new];
    foodArray = [categoryString componentsSeparatedByString:@","];
}
-(void)viewsSetup{
    viewsArray = [NSMutableArray new];
    float viewWidth = mainScrollView.frame.size.width;
    float originX = 30;
    
    /*region type*/
    regionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    
    UILabel *regionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 20, 100, 60)];
    regionTitleLabel.text = @"地域";
    regionTitleLabel.textColor = SYColor1;
    [regionView addSubview:regionTitleLabel];
    UIButton *regionButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 20, viewWidth-2*originX, 60)];
    [regionButton setTitle:@"请选择地域" forState:UIControlStateNormal];
    [regionButton setTitleColor:SYColor3 forState:UIControlStateNormal];
    [regionButton setTitleColor:SYColor1 forState:UIControlStateSelected];
    regionButton.tag = 11;
    regionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [regionButton addTarget:self action:@selector(regionResponse:) forControlEvents:UIControlEventTouchUpInside];
    [regionView addSubview:regionButton];
    regionPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216, self.view.frame.size.width, 216)];
    regionPickerView.delegate = self;
    regionPickerView.dataSource = self;
    regionPickerView.backgroundColor = [UIColor whiteColor];
    regionPickerView.hidden = YES;
    [self.view addSubview:regionPickerView];
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
    
    /*subregion type*/
    subRegionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    subRegionView.hidden = YES;
    
    UILabel *subregionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 20, 100, 60)];
    subregionTitleLabel.text = @"菜系";
    subregionTitleLabel.textColor = SYColor1;
    [subRegionView addSubview:subregionTitleLabel];
    UIButton *subregionButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 20, viewWidth-2*originX, 60)];
    [subregionButton setTitle:@"请选择菜系" forState:UIControlStateNormal];
    [subregionButton setTitleColor:SYColor3 forState:UIControlStateNormal];
    [subregionButton setTitleColor:SYColor1 forState:UIControlStateSelected];
    subregionButton.tag = 11;
    subregionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [subregionButton addTarget:self action:@selector(subRegionResponse:) forControlEvents:UIControlEventTouchUpInside];
    [subRegionView addSubview:subregionButton];
    subRegionPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216, self.view.frame.size.width, 216)];
    subRegionPickerView.delegate = self;
    subRegionPickerView.dataSource = self;
    subRegionPickerView.backgroundColor = [UIColor whiteColor];
    subRegionPickerView.hidden = YES;
    [self.view addSubview:subRegionPickerView];
    
    /*food type*/
    foodView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    
    UILabel *foodTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 20, 100, 60)];
    foodTitleLabel.text = @"食材";
    foodTitleLabel.textColor = SYColor1;
    [foodView addSubview:foodTitleLabel];
    UIButton *foodButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 20, viewWidth-2*originX, 60)];
    [foodButton setTitle:@"请选择食材" forState:UIControlStateNormal];
    [foodButton setTitleColor:SYColor3 forState:UIControlStateNormal];
    [foodButton setTitleColor:SYColor1 forState:UIControlStateSelected];
    foodButton.tag = 11;
    foodButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [foodButton addTarget:self action:@selector(foodResponse:) forControlEvents:UIControlEventTouchUpInside];
    [foodView addSubview:foodButton];
    foodPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216, self.view.frame.size.width, 216)];
    foodPickerView.delegate = self;
    foodPickerView.dataSource = self;
    foodPickerView.backgroundColor = [UIColor whiteColor];
    foodPickerView.hidden = YES;
    [self.view addSubview:foodPickerView];
    
    
    /*keyword*/
    keywordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    keywordView.hidden = YES;
    UILabel *keywordTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 100, 40)];
    keywordTitleLabel.text = @"关键词";
    keywordTitleLabel.textColor = SYColor1;
    [keywordView addSubview:keywordTitleLabel];
    UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(originX, 40, viewWidth-2*originX, 30)];
    textfield.tag = 11;
    [textfield addTarget:self action:@selector(titleEmptyCheck) forControlEvents:UIControlEventEditingChanged];
    textfield.backgroundColor = [UIColor whiteColor];
    [keywordView addSubview:textfield];
    
    
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
        case discoverEatRegion:
            [mainScrollView addSubview:regionView];
            [viewsArray addObject:regionView];
            [mainScrollView addSubview:subRegionView];
            [viewsArray addObject:subRegionView];
            break;
        case discoverEatFood:
            [mainScrollView addSubview:foodView];
            [viewsArray addObject:foodView];
            break;
        default:
            break;
    }
    [mainScrollView addSubview:keywordView];
    [viewsArray addObject:keywordView];
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

-(IBAction)regionResponse:(id)sender{
    [self pickerConfirmResponse];
    UIButton *button = sender;
    button.selected = YES;
    if (!regionString) {
        regionString = @"0";
        [button setTitle:[regionArray objectAtIndex:0] forState:UIControlStateSelected];
    }
    regionPickerView.hidden = NO;
    confirmBackgroundView.hidden = NO;
    subRegionView.hidden = NO;
    
}
-(IBAction)subRegionResponse:(id)sender{
    [self pickerConfirmResponse];
    UIButton *button = sender;
    button.selected = YES;
    if (!subRegionString) {
        subRegionString = @"0";
        [button setTitle:[subRegionArray objectAtIndex:0] forState:UIControlStateSelected];
        keywordView.hidden = NO;
    }
    
    confirmBackgroundView.hidden = NO;
    subRegionPickerView.hidden = NO;
    
}
-(IBAction)foodResponse:(id)sender{
    [self pickerConfirmResponse];
    UIButton *button = sender;
    button.selected = YES;
    if (!foodString) {
        foodString = @"0";
        [button setTitle:[foodArray objectAtIndex:0] forState:UIControlStateSelected];
    }
    foodPickerView.hidden = NO;
    confirmBackgroundView.hidden = NO;
    keywordView.hidden = NO;
}

- (void)pickerConfirmResponse{
    confirmBackgroundView.hidden = YES;
    
    regionPickerView.hidden = YES;
    subRegionPickerView.hidden = YES;
    foodPickerView.hidden = YES;
}



-(void)nextResponse{
    NSString *subCate;
    if (_controllerType==discoverEatRegion) {
        subCate= [NSString stringWithFormat:@"01%02ld%02ld00",[regionString integerValue],[subRegionString integerValue]];
    }
    else if (_controllerType == discoverEatFood){
        subCate= [NSString stringWithFormat:@"02%02ld0000",[foodString integerValue]];
    }
    UITextField *keyword = [keywordView viewWithTag:11];
    
    NSString *requestBody = [NSString stringWithFormat:@"email=%@&latitude=%f&longitude=%f&category=1&subcate=%@&keyword=%@",MEID,self.locationManager.location.coordinate.latitude,self.locationManager.location.coordinate.longitude,subCate,keyword.text];
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
    SYHelp *helpView = [[SYHelp alloc] initWithFrame:CGRectMake(0, 0, baseView.cardSize.width, baseView.cardSize.height) helpID:helpID];
    [baseView addGoSubview:helpView];
}

-(void)titleEmptyCheck{
    UITextField *textField = [keywordView viewWithTag:11];
    if ([textField.text length]) {
        nextButton.hidden = NO;
    }
}
-(void)dismissKeyboard {
    UITextField *textField = [keywordView viewWithTag:11];
    [textField resignFirstResponder];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component{
    float result;
    if ([pickerView isEqual:regionPickerView])
        result = regionArray.count;
    else if ([pickerView isEqual:subRegionPickerView])
        result = subRegionArray.count;
    else if ([pickerView isEqual:foodPickerView])
        result = foodArray.count;
    return result;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component{
    NSString *resultString = [NSString new];
    if ([pickerView isEqual:regionPickerView])
        resultString = [regionArray objectAtIndex:row];
    else if ([pickerView isEqual:subRegionPickerView])
        resultString = [subRegionArray objectAtIndex:row];
    else if ([pickerView isEqual:foodPickerView])
        resultString = [foodArray objectAtIndex:row];
    
    return resultString;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if ([pickerView isEqual:regionPickerView]) {
        UIButton *typeButton = [regionView viewWithTag:11];
        [typeButton setTitle:[regionArray objectAtIndex:row] forState:UIControlStateSelected];
        regionString = [NSString stringWithFormat:@"%ld",row];
        if (row) {
            subRegionView.hidden = YES;
            [viewsArray removeObject:subRegionView];
            subRegionString = @"0";
            keywordView.hidden = NO;
            [self viewsLayout];
        }
        else{
            subRegionString = @"0";
            [subRegionPickerView selectRow:0 inComponent:0 animated:NO];
            UIButton *subregionButton = [subRegionView viewWithTag:11];
            [subregionButton setTitle:[subRegionArray objectAtIndex:0] forState:UIControlStateSelected];
            regionString = [NSString stringWithFormat:@"%ld",row];
            subRegionView.hidden = NO;
            if (![viewsArray containsObject:subRegionView])
                [viewsArray insertObject:subRegionView atIndex:[viewsArray indexOfObject:regionView]+1];
            [self viewsLayout];
        }
    }
    else if ([pickerView isEqual:subRegionPickerView]){
        UIButton *subregionButton = [subRegionView viewWithTag:11];
        [subregionButton setTitle:[subRegionArray objectAtIndex:row] forState:UIControlStateSelected];
        subRegionString = [NSString stringWithFormat:@"%ld",row];
    }
    else if ([pickerView isEqual:foodPickerView]){
        UIButton *foodButton = [foodView viewWithTag:11];
        [foodButton setTitle:[foodArray objectAtIndex:row] forState:UIControlStateSelected];
        foodString = [NSString stringWithFormat:@"%ld",row];
    }
    
}


@end
