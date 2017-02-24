//
//  DiscoverLiveHelpRentViewController.m
//  Sharmunity
//
//  Created by st chen on 2017/2/9.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "DiscoverLiveHelpRentViewController.h"
#import "DiscoverLocationViewController.h"
#import "Header.h"
#import "SYHeader.h"
@interface DiscoverLiveHelpRentViewController ()<SYPriceSliderDelegate>{
    SYPopOut *popOut;
}

@end

@implementation DiscoverLiveHelpRentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = (_shortRent)?@"短租":@"求租";
    self.view.backgroundColor = SYBackgroundColorExtraLight;
    
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mainScrollView.backgroundColor = SYBackgroundColorExtraLight;
    [self.view addSubview:mainScrollView];
    
    MEID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
    _helpDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:MEID,@"email",@"2",@"category",@"2099-01-01",@"expire_date",@"0",@"distance", nil];
    
    /*room type data*/
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"roomType"
                                                         ofType:@"txt"];
    NSString *categoryString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    roomTypeArray = [[NSArray alloc] init];
    roomTypeArray = [categoryString componentsSeparatedByString:@","];
    
    shortArray = @[ @[@"1", @"2", @"3", @"4",@"5", @"6", @"7", @"8",@"9", @"10", @"11", @"12",@"13", @"14", @"15", @"16",@"17", @"18", @"19", @"20",@"21", @"22", @"23", @"24",@"25", @"26", @"27", @"28",@"29", @"30"],
                    @[@"日", @"月"]];
    shortNumber = 30;
    shortString=@"";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [mainScrollView addGestureRecognizer:tap];
    popOut = [SYPopOut new];
    
    [self viewsSetup];
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"SYBackColor5"] forState:UIControlStateNormal];
    [backBtn setTitle:@"住" forState:UIControlStateNormal];
    [backBtn setTitleColor:SYColor1 forState:UIControlStateNormal];
    [backBtn.titleLabel setFont:SYFont13S];
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
}

-(void)viewsSetup{
    viewsArray = [NSMutableArray new];
    float viewWidth = mainScrollView.frame.size.width;
    float originX = 30;
    
    /*share rent*/
    shareRentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    [mainScrollView addSubview:shareRentView];
    [viewsArray addObject:shareRentView];
    UIButton *shareRentButton = [[UIButton alloc] initWithFrame:CGRectMake(originX+30, 20, 150, 60)];
    [shareRentButton setTitle:@"合租" forState:UIControlStateNormal];
    [shareRentButton setTitleColor:SYColor1 forState:UIControlStateNormal];
    [shareRentButton.titleLabel setFont:SYFont20];
    shareRentButton.tag = 11;
    [shareRentButton addTarget:self action:@selector(shareRentResponse:) forControlEvents:UIControlEventTouchUpInside];
    [shareRentView addSubview:shareRentButton];
    UIButton *soloRentButton = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth-originX-30-150, 20, 150, 60)];
    [soloRentButton setTitle:@"独租" forState:UIControlStateNormal];
    [soloRentButton setTitleColor:SYColor1 forState:UIControlStateNormal];
    [soloRentButton.titleLabel setFont:SYFont20];
    soloRentButton.tag = 10;
    [soloRentButton addTarget:self action:@selector(shareRentResponse:) forControlEvents:UIControlEventTouchUpInside];
    [shareRentView addSubview:soloRentButton];
    /*gender*/
    genderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    UIButton *noLimitButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 20, 150, 60)];
    [noLimitButton setTitle:@"不限" forState:UIControlStateNormal];
    [noLimitButton setTitleColor:SYColor1 forState:UIControlStateNormal];
    [noLimitButton.titleLabel setFont:SYFont20];
    noLimitButton.tag = 10;
    [noLimitButton addTarget:self action:@selector(genderReponse:) forControlEvents:UIControlEventTouchUpInside];
    [genderView addSubview:noLimitButton];
    UIButton *boyOnlyButton = [[UIButton alloc] initWithFrame:CGRectMake((viewWidth-150)/2, 20, 150, 60)];
    [boyOnlyButton setTitle:@"男生" forState:UIControlStateNormal];
    [boyOnlyButton setTitleColor:SYColor1 forState:UIControlStateNormal];
    [boyOnlyButton.titleLabel setFont:SYFont20];
    boyOnlyButton.tag = 11;
    [boyOnlyButton addTarget:self action:@selector(genderReponse:) forControlEvents:UIControlEventTouchUpInside];
    [genderView addSubview:boyOnlyButton];
    UIButton *girlOnlyButton = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth-originX-150, 20, 150, 60)];
    [girlOnlyButton setTitle:@"女生" forState:UIControlStateNormal];
    [girlOnlyButton setTitleColor:SYColor1 forState:UIControlStateNormal];
    [girlOnlyButton.titleLabel setFont:SYFont20];
    girlOnlyButton.tag = 12;
    [girlOnlyButton addTarget:self action:@selector(genderReponse:) forControlEvents:UIControlEventTouchUpInside];
    [genderView addSubview:girlOnlyButton];
    
    /*house or apartment*/
    houseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    houseView.hidden = YES;
    [mainScrollView addSubview:houseView];
    [viewsArray addObject:houseView];
    UIButton *houseButton = [[UIButton alloc] initWithFrame:CGRectMake(originX+30, 20, 150, 60)];
    [houseButton setTitle:@"独栋" forState:UIControlStateNormal];
    [houseButton setTitleColor:SYColor1 forState:UIControlStateNormal];
    [houseButton.titleLabel setFont:SYFont20];
    houseButton.tag = 10;
    [houseButton addTarget:self action:@selector(houseResponse:) forControlEvents:UIControlEventTouchUpInside];
    [houseView addSubview:houseButton];
    UIButton *apartmentButton = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth-originX-30-150, 20, 150, 60)];
    [apartmentButton setTitle:@"公寓" forState:UIControlStateNormal];
    [apartmentButton setTitleColor:SYColor1 forState:UIControlStateNormal];
    [apartmentButton.titleLabel setFont:SYFont20];
    apartmentButton.tag = 11;
    [apartmentButton addTarget:self action:@selector(houseResponse:) forControlEvents:UIControlEventTouchUpInside];
    [houseView addSubview:apartmentButton];
    
    originX = 50;
    /*room type*/
    typeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    typeView.hidden = YES;
    [mainScrollView addSubview:typeView];
    [viewsArray addObject:typeView];
    UILabel *typeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 20, 100, 60)];
    typeTitleLabel.text = @"户型";
    [typeTitleLabel setFont:SYFont20];
    typeTitleLabel.textColor = SYColor1;
    [typeView addSubview:typeTitleLabel];
    UIButton *typeButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 20, viewWidth-2*originX, 60)];
    [typeButton setTitle:@"请选择户型" forState:UIControlStateNormal];
    [typeButton setTitleColor:SYColor9 forState:UIControlStateNormal];
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
    
    /*date view*/
    dateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    dateView.hidden = YES;
    [mainScrollView addSubview:dateView];
    [viewsArray addObject:dateView];
    UILabel *dateTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 20, 100, 60)];
    dateTitleLabel.text = @"日期";
    [dateTitleLabel setFont:SYFont20];
    dateTitleLabel.textColor = SYColor1;
    [dateView addSubview:dateTitleLabel];
    UIButton *dateButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 20, viewWidth-2*originX, 60)];
    [dateButton setTitle:@"请选择入住日期" forState:UIControlStateNormal];
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
    
    if (_shortRent) {
        /*short view*/
        shortView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
        shortView.hidden = YES;
        [mainScrollView addSubview:shortView];
        [viewsArray addObject:shortView];
        UILabel *shortTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 20, 100, 60)];
        shortTitleLabel.text = @"租期";
        [shortTitleLabel setFont:SYFont20];
        shortTitleLabel.textColor = SYColor1;
        [shortView addSubview:shortTitleLabel];
        UIButton *shortButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 20, viewWidth-2*originX, 60)];
        [shortButton setTitle:@"请选择租期" forState:UIControlStateNormal];
        [shortButton setTitleColor:SYColor9 forState:UIControlStateNormal];
        [shortButton setTitleColor:SYColor1 forState:UIControlStateSelected];
        [shortButton.titleLabel setFont:SYFont20];
        shortButton.tag = 11;
        shortButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [shortButton addTarget:self action:@selector(shortResponse:) forControlEvents:UIControlEventTouchUpInside];
        [shortView addSubview:shortButton];
        
        shortPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216, self.view.frame.size.width, 216)];
        shortPickerView.delegate = self;
        shortPickerView.dataSource = self;
        shortPickerView.backgroundColor = [UIColor whiteColor];
        shortPickerView.hidden = YES;
        [self.view addSubview:shortPickerView];
    }
    
    /*price*/
    priceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 140)];
    priceView.hidden = YES;
    [mainScrollView addSubview:priceView];
    [viewsArray addObject:priceView];
    UILabel *priceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 200, 60)];
    priceTitleLabel.text = @"接受的价格区间";
    priceTitleLabel.textColor = SYColor1;
    [priceView addSubview:priceTitleLabel];
    SYPriceSlider *priceSlider = [[SYPriceSlider alloc] initWithFrame:CGRectMake(originX, 60, viewWidth-2*originX, 50) type:SYPriceSliderDouble];
    priceSlider.delegate = self;
    [priceView addSubview:priceSlider];
    lowerPriceString = @"100";
    upperPriceString = @"1000";
    
    /*location*/
    locationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    locationView.hidden = YES;
    [mainScrollView addSubview:locationView];
    [viewsArray addObject:locationView];
    UILabel *locationTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 20, 100, 60)];
    locationTitleLabel.text = @"位置";
    locationTitleLabel.textColor = SYColor1;
    [locationTitleLabel setFont:SYFont20];
    [locationView addSubview:locationTitleLabel];
    UIButton *locationButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 20, viewWidth-2*originX, 60)];
    locationButton.tag = 11;
    [locationButton setTitleColor:SYColor9 forState:UIControlStateNormal];
    [locationButton setTitleColor:SYColor1 forState:UIControlStateSelected];
    [locationButton setTitle:@"请选择位置" forState:UIControlStateNormal];
    [locationButton addTarget:self action:@selector(locationResponse) forControlEvents:UIControlEventTouchUpInside];
    [locationButton.titleLabel setFont:SYFont20];
    locationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [locationView addSubview:locationButton];
    
    nextButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 32)];
    [nextButton setTitle:@"提交" forState:UIControlStateNormal];
    [nextButton setBackgroundColor:SYColor7];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton.titleLabel setFont:SYFont20S];
    [nextButton addTarget:self action:@selector(nextResponse) forControlEvents:UIControlEventTouchUpInside];
    nextButton.layer.cornerRadius = 8;
    nextButton.clipsToBounds = YES;
    [mainScrollView addSubview:nextButton];
    [viewsArray addObject:nextButton];
    nextButton.hidden = YES;
    
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
    mainScrollView.contentSize = CGSizeMake(0, height+20+44+20);
}

-(IBAction)shareRentResponse:(id)sender{
    UIButton *button = sender;
    if (button.tag-10) {
        shareRentString = @"10";
        [button setTitleColor:SYColor1 forState:UIControlStateNormal];
        UIButton *button2 = [shareRentView viewWithTag:10];
        [button2 setTitleColor:SYColor6 forState:UIControlStateNormal];
        [mainScrollView addSubview:genderView];
        [viewsArray insertObject:genderView atIndex:1];
    }
    else{
        shareRentString = @"00";
        [button setTitleColor:SYColor1 forState:UIControlStateNormal];
        UIButton *button2 = [shareRentView viewWithTag:11];
        [button2 setTitleColor:SYColor6 forState:UIControlStateNormal];
        [genderView removeFromSuperview];
        [viewsArray removeObject:genderView];
        houseView.hidden = NO;
    }
    [self viewsLayout];
}
-(IBAction)genderReponse:(id)sender{
    UIButton *button = sender;
    shareRentString = [NSString stringWithFormat:@"%ld",button.tag];
    if (button.tag == 11) {
        [button setTitleColor:SYColor1 forState:UIControlStateNormal];
        UIButton *button2 = [genderView viewWithTag:10];
        [button2 setTitleColor:SYColor6 forState:UIControlStateNormal];
        UIButton *button3 = [genderView viewWithTag:12];
        [button3 setTitleColor:SYColor6 forState:UIControlStateNormal];
    }
    else if(button.tag == 12){
        [button setTitleColor:SYColor1 forState:UIControlStateNormal];
        UIButton *button2 = [genderView viewWithTag:10];
        [button2 setTitleColor:SYColor6 forState:UIControlStateNormal];
        UIButton *button3 = [genderView viewWithTag:11];
        [button3 setTitleColor:SYColor6 forState:UIControlStateNormal];
    }
    else{
        [button setTitleColor:SYColor1 forState:UIControlStateNormal];
        UIButton *button2 = [genderView viewWithTag:12];
        [button2 setTitleColor:SYColor6 forState:UIControlStateNormal];
        UIButton *button3 = [genderView viewWithTag:11];
        [button3 setTitleColor:SYColor6 forState:UIControlStateNormal];
    }
    houseView.hidden = NO;
}

-(IBAction)houseResponse:(id)sender{
    UIButton *button = sender;
    if (button.tag-10) {
        houseString = @"1";
        [button setTitleColor:SYColor1 forState:UIControlStateNormal];
        UIButton *button2 = [houseView viewWithTag:10];
        [button2 setTitleColor:SYColor6 forState:UIControlStateNormal];
    }
    else{
        houseString = @"0";
        [button setTitleColor:SYColor1 forState:UIControlStateNormal];
        UIButton *button2 = [houseView viewWithTag:11];
        [button2 setTitleColor:SYColor6 forState:UIControlStateNormal];
    }
    typeView.hidden = NO;
}

-(IBAction)typeResponse:(id)sender{
    UIButton *button = sender;
    button.selected = YES;
    if (!typeString) {
        typeString = @"0";
        [button setTitle:[roomTypeArray objectAtIndex:0] forState:UIControlStateSelected];
    }
    typePickerView.hidden = NO;
    confirmBackgroundView.hidden = NO;
    dateView.hidden = NO;
}


- (void)pickerConfirmResponse{
    confirmBackgroundView.hidden = YES;
    datePicker.hidden = YES;
    shortPickerView.hidden = YES;
    typePickerView.hidden = YES;
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
        [_helpDict addEntriesFromDictionary:dict];
        dateString = dtrDate;
    }
    datePicker.hidden = NO;
    confirmBackgroundView.hidden = NO;
    if (_shortRent) shortView.hidden = NO ;
    else {
        priceView.hidden = NO;
        locationView.hidden = NO;
    }
}
-(void)datePickerChanged{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dtrDate = [dateFormatter stringFromDate:datePicker.date];
    UIButton *button = [dateView viewWithTag:11];
    [button setTitle:dtrDate forState:UIControlStateSelected];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:dtrDate, @"available_date", nil];
    [_helpDict addEntriesFromDictionary:dict];
    dateString = dtrDate;
}
-(IBAction)shortResponse:(id)sender{
    UIButton *button = sender;
    button.selected = YES;
    if (!shortString) {
        shortString = @"1日";
        [button setTitle:[NSString stringWithFormat:@"%@%@",shortArray[0][0],shortArray[1][0]] forState:UIControlStateSelected];
    }
    shortPickerView.hidden = NO;
    confirmBackgroundView.hidden = NO;
    priceView.hidden = NO;
    locationView.hidden = NO;
}
-(void)nextResponse{
    NSString *subCate;
    if (_shortRent) {
        subCate = [NSString stringWithFormat:@"02%@%@%@00",shareRentString,houseString,typeString];
    }
    else subCate = [NSString stringWithFormat:@"01%@%@%@00",shareRentString,houseString,typeString];
    NSString *requestBody = [NSString stringWithFormat:@"email=%@&latitude=%f&longitude=%f&category=2&subcate=%@&lower_price=%@&upper_price=%@&date=%@&distance=%@&placemark=%@&shortTerm=%@",MEID,[[_selectedItem placemark] coordinate].latitude,[[_selectedItem placemark] coordinate].longitude,subCate,lowerPriceString,upperPriceString,dateString,_distanceString,_selectedItem.name,shortString];
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
        //        [popOut showUpPop:SYPopDiscoverShareSuccess];
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
-(void)locationResponse{
    [self dismissKeyboard];
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
    [locationButton setTitle:[NSString stringWithFormat:@"%@附近%@英里",[[[_selectedItem placemark] addressDictionary] valueForKey:@"Street"],_distanceString] forState:UIControlStateSelected];
    nextButton.hidden = NO;
    
}
-(void)dismissKeyboard {
//    UITextView *textField = [introductionView viewWithTag:11];
//    [textField resignFirstResponder];
//    textField = [priceView viewWithTag:11];
//    [textField resignFirstResponder];
//    
//    UITextField *title = [ viewWithTag:11];
//    [title resignFirstResponder];
}
- (void)priceSlider:(UISlider *)slider priceChangeToValue:(NSInteger)price{
    
}
-(void)lowerPriceChangeToValue:(NSInteger)lowerPrice upperToValue:(NSInteger)upperPrice{
    lowerPriceString = [NSString stringWithFormat:@"%ld",lowerPrice];
    upperPriceString = [NSString stringWithFormat:@"%ld",upperPrice];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:lowerPriceString, @"lower_price",upperPriceString,@"upper_price", nil];
    [_helpDict addEntriesFromDictionary:dict];
}







- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    float result;
    if ([pickerView isEqual:typePickerView]) {
        result = 1;
    }
    else if ([pickerView isEqual:shortPickerView]){
        result = 2;
    }
    return result;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    float result;
    if ([pickerView isEqual:typePickerView]) {
        result = roomTypeArray.count;
    }
    else if ([pickerView isEqual:shortPickerView]){
        if (component==0) {
            result=shortNumber;
        }
        else
            result = 2;
    }
    return result;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component{
    NSString *resultString = [NSString new];
    if ([pickerView isEqual:typePickerView]) {
        resultString = [roomTypeArray objectAtIndex:row];
    }
    else if ([pickerView isEqual:shortPickerView]){
        resultString = shortArray[component][row];
    }
    return resultString;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if ([pickerView isEqual:typePickerView]) {
        UIButton *typeButton = [typeView viewWithTag:11];
        [typeButton setTitle:[roomTypeArray objectAtIndex:row] forState:UIControlStateSelected];
        typeString = [NSString stringWithFormat:@"%ld",row];
    }
    else if ([pickerView isEqual:shortPickerView]){
        if (row==1 && component==1) {
            shortNumber = 3;
            [shortPickerView reloadComponent:0];
            short1 = MIN(2, short1);
        }
        if (component==0) {
            short1 = row;
        }
        else short2 = row;
        if (short2==1){
            
        }
        else{
            shortNumber = 30;
            [shortPickerView reloadComponent:0];
        }
        
        UIButton *button = [shortView viewWithTag:11];
        shortString = [NSString stringWithFormat:@"%@%@",shortArray[0][short1],shortArray[1][short2]];
        [button setTitle:shortString forState:UIControlStateSelected];
    }
    
}
@end
