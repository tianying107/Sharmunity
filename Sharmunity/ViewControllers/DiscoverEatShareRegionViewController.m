//
//  DiscoverEatShareRegionViewController.m
//  Sharmunity
//
//  Created by Star Chen on 2/11/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import "DiscoverEatShareSecondViewController.h"
#import "DiscoverLocationViewController.h"
#import "Header.h"
#import "SYHeader.h"

@interface DiscoverEatShareSecondViewController ()<SYTextViewDelegate>{
    SYPopOut *popOut;
}

@end

@implementation DiscoverEatShareSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"餐品描述";
    self.view.backgroundColor = SYBackgroundColorExtraLight;
    
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mainScrollView.backgroundColor = SYBackgroundColorExtraLight;
    [self.view addSubview:mainScrollView];
    
    MEID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
    _shareDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:MEID,@"email",@"1",@"category",@"2099-01-01",@"expire_date", nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"SYBackColor4"] forState:UIControlStateNormal];
    [backBtn setTitle:@"吃" forState:UIControlStateNormal];
    [backBtn setTitleColor:SYColor1 forState:UIControlStateNormal];
    [backBtn.titleLabel setFont:SYFont15];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backBtn.bounds = CGRectMake(0, 0, 80, 40);
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
    popOut = [SYPopOut new];
    [self dataSetup];
    [self viewsSetup];
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
    float originX = 60;
    
    
    /*share rent*/
    typeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 45)];
    [mainScrollView addSubview:typeView];
    [viewsArray addObject:typeView];
    UIButton *regionTypeButton = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth/2-150, 0, 150, 40)];
    [regionTypeButton setTitle:@"国家地区" forState:UIControlStateNormal];
    [regionTypeButton setTitleColor:SYColor8 forState:UIControlStateNormal];
    [regionTypeButton.titleLabel setFont:SYFont20];
    regionTypeButton.tag = 11;
    [regionTypeButton addTarget:self action:@selector(typeResponse:) forControlEvents:UIControlEventTouchUpInside];
    [typeView addSubview:regionTypeButton];
    UIButton *foodTypeButton = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth/2, 0, 150, 40)];
    [foodTypeButton setTitle:@"餐品种类" forState:UIControlStateNormal];
    [foodTypeButton setTitleColor:SYColor8 forState:UIControlStateNormal];
    [foodTypeButton.titleLabel setFont:SYFont20];
    foodTypeButton.tag = 10;
    [foodTypeButton addTarget:self action:@selector(typeResponse:) forControlEvents:UIControlEventTouchUpInside];
    [typeView addSubview:foodTypeButton];
    
    
    /*region type*/
    regionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 50)];
    UILabel *regionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 100, 50)];
    regionTitleLabel.text = @"地域";
    [regionTitleLabel setFont:SYFont25];
    regionTitleLabel.textColor = SYColor4;
    [regionView addSubview:regionTitleLabel];
    UIButton *regionButton = [[UIButton alloc] initWithFrame:CGRectMake(190, 0, viewWidth-2*originX, 50)];
    [regionButton setTitle:@"请选择国家" forState:UIControlStateNormal];
    [regionButton setTitleColor:SYColor10 forState:UIControlStateNormal];
    [regionButton setTitleColor:SYColor4 forState:UIControlStateSelected];
    [regionButton.titleLabel setFont:SYFont20];
    regionButton.tag = 11;
    regionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
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
    subRegionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 50)];
    subRegionView.hidden = YES;
    
    UILabel *subregionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 100, 50)];
    subregionTitleLabel.text = @"菜系";
    subregionTitleLabel.textColor = SYColor4;
    [subregionTitleLabel setFont:SYFont25];
    [subRegionView addSubview:subregionTitleLabel];
    UIButton *subregionButton = [[UIButton alloc] initWithFrame:CGRectMake(190, 0, viewWidth-2*originX, 50)];
    [subregionButton setTitle:@"请选择菜系" forState:UIControlStateNormal];
    [subregionButton setTitleColor:SYColor10 forState:UIControlStateNormal];
    [subregionButton setTitleColor:SYColor4 forState:UIControlStateSelected];
    [subregionButton.titleLabel setFont:SYFont20];
    subregionButton.tag = 11;
    subregionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [subregionButton addTarget:self action:@selector(subRegionResponse:) forControlEvents:UIControlEventTouchUpInside];
    [subRegionView addSubview:subregionButton];
    subRegionPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216, self.view.frame.size.width, 216)];
    subRegionPickerView.delegate = self;
    subRegionPickerView.dataSource = self;
    subRegionPickerView.backgroundColor = [UIColor whiteColor];
    subRegionPickerView.hidden = YES;
    [self.view addSubview:subRegionPickerView];
    
    /*food type*/
    foodView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 50)];
    
    UILabel *foodTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 100, 50)];
    foodTitleLabel.text = @"食材";
    foodTitleLabel.textColor = SYColor4;
    [foodTitleLabel setFont:SYFont25];
    [foodView addSubview:foodTitleLabel];
    UIButton *foodButton = [[UIButton alloc] initWithFrame:CGRectMake(190, 0, viewWidth-2*originX, 50)];
    [foodButton setTitle:@"请选择食材" forState:UIControlStateNormal];
    [foodButton setTitleColor:SYColor10 forState:UIControlStateNormal];
    [foodButton setTitleColor:SYColor4 forState:UIControlStateSelected];
    [foodButton.titleLabel setFont:SYFont20];
    foodButton.tag = 11;
    foodButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [foodButton addTarget:self action:@selector(foodResponse:) forControlEvents:UIControlEventTouchUpInside];
    [foodView addSubview:foodButton];
    foodPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216, self.view.frame.size.width, 216)];
    foodPickerView.delegate = self;
    foodPickerView.dataSource = self;
    foodPickerView.backgroundColor = [UIColor whiteColor];
    foodPickerView.hidden = YES;
    [self.view addSubview:foodPickerView];
    
    /*location*/
    locationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 50)];
    locationView.hidden = YES;
    
    UILabel *locationTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 100, 50)];
    locationTitleLabel.text = @"位置";
    locationTitleLabel.textColor = SYColor4;
    [locationTitleLabel setFont:SYFont25];
    [locationView addSubview:locationTitleLabel];
    UIButton *locationButton = [[UIButton alloc] initWithFrame:CGRectMake(190, 0, viewWidth-190, 50)];
    locationButton.tag = 11;
    [locationButton setTitleColor:SYColor10 forState:UIControlStateNormal];
    [locationButton setTitleColor:SYColor4 forState:UIControlStateSelected];
    [locationButton.titleLabel setFont:SYFont20];
    [locationButton setTitle:@"请选择位置" forState:UIControlStateNormal];
    [locationButton addTarget:self action:@selector(locationResponse) forControlEvents:UIControlEventTouchUpInside];
    locationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [locationView addSubview:locationButton];
    
    /*price*/
    priceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 70)];
    priceView.hidden = YES;
    UILabel *priceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 100, 50)];
    priceTitleLabel.text = @"价格";
    priceTitleLabel.textColor = SYColor4;
    [priceTitleLabel setFont:SYFont25];
    [priceView addSubview:priceTitleLabel];
    UITextField *priceTextField = [[UITextField alloc] initWithFrame:CGRectMake(210, 0, 90, 50)];
    priceTextField.textColor = SYColor4;
    [priceTextField setFont:SYFont20];
    priceTextField.textAlignment = NSTextAlignmentRight;
    priceTextField.tag = 11;
    priceTextField.keyboardType = UIKeyboardTypeNumberPad;
    [priceTextField addTarget:self action:@selector(priceEmptyCheck) forControlEvents:UIControlEventEditingChanged];
    [priceView addSubview:priceTextField];
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(210, 37, 90, SYSeparatorHeight)];
    separator.backgroundColor = SYColor4;
    [priceView addSubview:separator];
    UILabel *dollarLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 0, 20, 50)];
    dollarLabel.text = @"$";
    dollarLabel.textColor = SYColor4;
    [dollarLabel setFont:SYFont20];
    [priceView addSubview:dollarLabel];
    UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(310, 0, 40, 50)];
    monthLabel.text = @"/份";
    monthLabel.textColor = SYColor4;
    [monthLabel setFont:SYFont20];
    monthLabel.tag = 12;
    [priceView addSubview:monthLabel];
    
    originX = 30;
    /*introduction*/
    introductionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 130)];
    introductionView.hidden = YES;
    SYTextView *textView = [[SYTextView alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 90) type:SYTextViewShare];
    textView.tag = 11;
    textView.SYDelegate = self;
    [textView setPlaceholder:@"菜品详细介绍（选填）"];
    [introductionView addSubview:textView];
    
    nextButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 32)];
    [nextButton setTitle:@"提交" forState:UIControlStateNormal];
    [nextButton setBackgroundColor:SYColor4];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton.titleLabel setFont:SYFont20M];
    [nextButton addTarget:self action:@selector(nextResponse) forControlEvents:UIControlEventTouchUpInside];
    nextButton.layer.cornerRadius = 8;
    nextButton.clipsToBounds = YES;
    nextButton.hidden = YES;
    
    
    
    
    [mainScrollView addSubview:locationView];
    [viewsArray addObject:locationView];
    [mainScrollView addSubview:priceView];
    [viewsArray addObject:priceView];
    [mainScrollView addSubview:introductionView];
    [viewsArray addObject:introductionView];
    [mainScrollView addSubview:nextButton];
    [viewsArray addObject:nextButton];
    [self viewsLayout];
}

-(void)viewsLayout{
    float height = 20;
    for (UIView *view in viewsArray){
        if ([view isEqual:subRegionView]) {
            NSLog(@"has subregion");
        }
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
        _controllerType = discoverEatRegion;
        [button setTitleColor:SYColor4 forState:UIControlStateNormal];
        UIButton *button2 = [typeView viewWithTag:10];
        [button2 setTitleColor:SYColor8 forState:UIControlStateNormal];
        [button.titleLabel setFont:SYFont25M];
        [button2.titleLabel setFont:SYFont20];
        [foodView removeFromSuperview];
        [viewsArray removeObject:foodView];
        [mainScrollView addSubview:regionView];
        [viewsArray insertObject:regionView atIndex:1];
        [mainScrollView addSubview:subRegionView];
        [viewsArray insertObject:subRegionView atIndex:2];
        regionView.hidden = NO;
    }
    else{
        _controllerType = discoverEatFood;
        [button setTitleColor:SYColor4 forState:UIControlStateNormal];
        UIButton *button2 = [typeView viewWithTag:11];
        [button2 setTitleColor:SYColor8 forState:UIControlStateNormal];
        [button.titleLabel setFont:SYFont25M];
        [button2.titleLabel setFont:SYFont20];
        [regionView removeFromSuperview];
        [viewsArray removeObject:regionView];
        [subRegionView removeFromSuperview];
        [viewsArray removeObject:subRegionView];
        [mainScrollView addSubview:foodView];
        [viewsArray insertObject:foodView atIndex:1];
        foodView.hidden = NO;
    }
    
    [self viewsLayout];
}
-(IBAction)regionResponse:(id)sender{
    [self pickerConfirmResponse];
    UIButton *button = sender;
    button.selected = YES;
    if (!regionString) {
        regionString = @"0";
        [button setTitle:[regionArray objectAtIndex:0] forState:UIControlStateSelected];
        subRegionView.hidden = NO;
    }
    regionPickerView.hidden = NO;
    confirmBackgroundView.hidden = NO;
    
}
-(IBAction)subRegionResponse:(id)sender{
    [self pickerConfirmResponse];
    UIButton *button = sender;
    button.selected = YES;
    if (!subRegionString) {
        subRegionString = @"0";
        [button setTitle:[subRegionArray objectAtIndex:0] forState:UIControlStateSelected];
        locationView.hidden = NO;
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
    locationView.hidden = NO;
}

- (void)pickerConfirmResponse{
    confirmBackgroundView.hidden = YES;
    
    regionPickerView.hidden = YES;
    subRegionPickerView.hidden = YES;
    foodPickerView.hidden = YES;
}

-(void)locationResponse{
    [self pickerConfirmResponse];
    
    DiscoverLocationViewController *viewController = [DiscoverLocationViewController new];
    viewController.previousController = self;
    viewController.nextControllerType = SYDiscoverNextShareEat;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)locationCompleteResponse{
    UIButton *locationButton = [locationView viewWithTag:11];
    locationButton.selected = YES;
    [locationButton setTitle:[[[_selectedItem placemark] addressDictionary] valueForKey:@"Street"] forState:UIControlStateSelected];
    priceView.hidden = NO;
}
-(void)priceEmptyCheck{
    UITextField *textField = [priceView viewWithTag:11];
    if ([textField.text length]) {
        introductionView.hidden = NO;
        nextButton.hidden = NO;
    }
}
-(void)nextResponse{
    NSString *subCate;
    if (_controllerType==discoverEatRegion) {
        subCate= [NSString stringWithFormat:@"01%02ld%02ld01",[regionString integerValue],[subRegionString integerValue]];
    }
    else if (_controllerType == discoverEatFood){
        subCate= [NSString stringWithFormat:@"01%02ld0002",[foodString integerValue]];
    }
    UITextView *introduction = [introductionView viewWithTag:11];
    NSString *price = [(UITextField*)[priceView viewWithTag:11] text];
    NSString *requestBody;
    if (is_other) {
        requestBody = [NSString stringWithFormat:@"email=%@&latitude=%f&longitude=%f&category=1&subcate=%@&title=%@&description=%@&is_other=1&price=%@",MEID,[[_selectedItem placemark] coordinate].latitude,[[_selectedItem placemark] coordinate].longitude,subCate,_titleString, introduction.text,price];
    }
    else
        requestBody = [NSString stringWithFormat:@"email=%@&latitude=%f&longitude=%f&category=1&subcate=%@&title=%@&introduction=%@&is_other=0&price=%@",MEID,[[_selectedItem placemark] coordinate].latitude,[[_selectedItem placemark] coordinate].longitude,subCate,_titleString, introduction.text,price];
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

-(void)SYTextView:(SYTextView *)textView isEmpty:(BOOL)empty{
    nextButton.hidden = !empty;
}
-(void)dismissKeyboard {
    UITextField *textField = [priceView viewWithTag:11];
    [textField resignFirstResponder];
    UITextView *textView = [introductionView viewWithTag:11];
    [textView resignFirstResponder];
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
            locationView.hidden = NO;
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
        is_other = (row==foodArray.count-1)?YES:NO;
        
        UIButton *foodButton = [foodView viewWithTag:11];
        [foodButton setTitle:[foodArray objectAtIndex:row] forState:UIControlStateSelected];
        foodString = (row==foodArray.count-1)?@"99":[NSString stringWithFormat:@"%ld",row];
    }
    
}

@end
