//
//  DiscoverLearnHelpSubmitViewController.m
//  Sharmunity
//
//  Created by st chen on 2017/2/13.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "DiscoverLearnHelpSubmitViewController.h"
#import "DiscoverLocationViewController.h"
#import "Header.h"
#import "SYHeader.h"
@interface DiscoverLearnHelpSubmitViewController ()<SYPriceSliderDelegate>{
    SYPopOut *popOut;
    SYTextView *contentTextView;
}

@end

@implementation DiscoverLearnHelpSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (_controllerType) {
        case discoverLearnExper:
            self.navigationItem.title = ([_typeString isEqualToString:@"01"])?@"留学专业咨询":@"留学申请辅导";
            break;
        case discoverLearnTutor:
            self.navigationItem.title = @"找辅导";
            break;
        case discoverLearnInterest:
            self.navigationItem.title = @"找兴趣班";
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
    [backBtn setImage:[UIImage imageNamed:@"SYBackColor5"] forState:UIControlStateNormal];
    [backBtn setTitle:(_controllerType==discoverLearnExper)?@"找学长":@"学" forState:UIControlStateNormal];
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
    float originX = 30;
    
    /*major type*/
    schoolContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, (_controllerType==discoverLearnExper)?280:320)];
    schoolContentView.hidden = YES;
    SYTextField *schoolTextfield = [[SYTextField alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 40) type:SYTextFieldHelp];
    schoolTextfield.tag = 11;
    [schoolContentView addSubview:schoolTextfield];
    SYTextField *collegeTextfield = [[SYTextField alloc] initWithFrame:CGRectMake(originX, 50, viewWidth-2*originX, 40) type:SYTextFieldHelp];
    collegeTextfield.tag = 12;
    collegeTextfield.backgroundColor = [UIColor whiteColor];
    [schoolContentView addSubview:collegeTextfield];
    SYTextField *departmentTextfield = [[SYTextField alloc] initWithFrame:CGRectMake(originX, 100, viewWidth-2*originX, 40) type:SYTextFieldHelp];
    departmentTextfield.tag = 13;
    departmentTextfield.backgroundColor = [UIColor whiteColor];
    [schoolContentView addSubview:departmentTextfield];
    SYTextField *majorTextfield = [[SYTextField alloc] initWithFrame:CGRectMake(originX, 150, viewWidth-2*originX, 40) type:SYTextFieldHelp];
    majorTextfield.tag = 14;
    //    [majorTextfield addTarget:self action:@selector(majorEmptyCheck) forControlEvents:UIControlEventEditingChanged];
    majorTextfield.backgroundColor = [UIColor whiteColor];
    [schoolContentView addSubview:majorTextfield];
    if (_controllerType==discoverLearnTutor){
        contentTextView = [[SYTextView alloc] initWithFrame:CGRectMake(originX, 205, viewWidth-2*originX, 70) type:SYTextViewHelp];
        [schoolContentView addSubview:contentTextView];
    }
    
    /*interest*/
    interestView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 250)];
    schoolContentView.hidden = YES;
    SYTextField *titleTextfield = [[SYTextField alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 40) type:SYTextFieldHelp];
    titleTextfield.tag = 11;
    [interestView addSubview:titleTextfield];
    SYTextField *genderTextfield = [[SYTextField alloc] initWithFrame:CGRectMake(originX, 65, 70, 40) type:SYTextFieldHelp];
    genderTextfield.tag = 12;
    genderTextfield.backgroundColor = [UIColor whiteColor];
    [interestView addSubview:genderTextfield];
    SYTextField *ageTextfield = [[SYTextField alloc] initWithFrame:CGRectMake(originX+70+15, 65, 70, 40) type:SYTextFieldHelp];
    ageTextfield.tag = 14;
    ageTextfield.backgroundColor = [UIColor whiteColor];
    [interestView addSubview:ageTextfield];
    SYTextView *interestTextView = [[SYTextView alloc] initWithFrame:CGRectMake(originX, 130, viewWidth-2*originX, 80) type:SYTextViewHelp];
    interestTextView.tag = 13;
    [interestView addSubview:interestTextView];
    
    /*location*/
    locationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 90)];
    UILabel *locationTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 100, 45)];
    locationTitleLabel.text = @"我的位置";
    locationTitleLabel.textColor = UIColorFromRGB(0x389E63);
    [locationTitleLabel setFont:SYFont20];
    [locationView addSubview:locationTitleLabel];
    UIButton *locationButton = [[UIButton alloc] initWithFrame:CGRectMake(145, 0, viewWidth-145-45, 45)];
    locationButton.tag = 11;
    [locationButton setTitleColor:SYColor6 forState:UIControlStateNormal];
    [locationButton setTitleColor:UIColorFromRGB(0x389E63) forState:UIControlStateSelected];
    [locationButton.titleLabel setFont:SYFont20];
    [locationButton setTitle:@"请选择位置" forState:UIControlStateNormal];
    [locationButton addTarget:self action:@selector(locationResponse) forControlEvents:UIControlEventTouchUpInside];
    locationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [locationView addSubview:locationButton];
    

    
//    /*price*/
//    priceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 140)];
//    priceView.hidden = YES;
//    UILabel *priceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 200, 60)];
//    priceTitleLabel.text = @"接受的价格区间";
//    priceTitleLabel.textColor = SYColor1;
//    [priceView addSubview:priceTitleLabel];
//    SYPriceSlider *priceSlider = [[SYPriceSlider alloc] initWithFrame:CGRectMake(originX, 60, viewWidth-2*originX, 50) type:SYPriceSliderDouble];
//    priceSlider.delegate = self;
//    [priceView addSubview:priceSlider];
//    lowerPriceString = @"100";
//    upperPriceString = @"1000";
    
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
        case discoverLearnExper:
            schoolContentView.hidden = NO;
            [mainScrollView addSubview:schoolContentView];
            [viewsArray addObject:schoolContentView];
            schoolTextfield.placeholder = @"目标学校（请输入英文全称）";
            collegeTextfield.placeholder = @"目标学院（请输入英文全称）";
            departmentTextfield.placeholder = @"目标专业（请输入英文全称）";
            majorTextfield.placeholder = @"专业编号";
            nextButton.hidden = NO;

            break;
        case discoverLearnTutor:
            schoolContentView.hidden = NO;
            [mainScrollView addSubview:schoolContentView];
            [viewsArray addObject:schoolContentView];
            schoolTextfield.placeholder = @"学校（请输入英文全称）";
            collegeTextfield.placeholder = @"学院（请输入英文全称）";
            departmentTextfield.placeholder = @"专业（请输入英文全称）";
            majorTextfield.placeholder = @"课程编号";
            [contentTextView setPlaceholder:@"自我描述（选填）"];
            nextButton.hidden = NO;
            break;
        case discoverLearnInterest:
            interestView.hidden = NO;
            [mainScrollView addSubview:interestView];
            [viewsArray addObject:interestView];
            [mainScrollView addSubview:locationView];
            [viewsArray addObject:locationView];
            titleTextfield.placeholder = @"关键字（如美术， 钢琴，瑜伽，跆拳道等）";
            genderTextfield.placeholder = @"性别";
            ageTextfield.placeholder = @"年龄";
            [interestTextView setPlaceholder:@"个人描述（选填）"];
            break;
        default:
            break;
    }
    
    
    [mainScrollView addSubview:nextButton];
    [viewsArray addObject:nextButton];
    [self viewsLayout];
}

-(void)viewsLayout{
    float height = (_controllerType==discoverLearnExper)?40:20;
    for (UIView *view in viewsArray){
        CGRect frame = view.frame;
        frame.origin.y = height;
        [view setFrame:frame];
        height += frame.size.height;
    }
    mainScrollView.contentSize = CGSizeMake(0, height+20+44+10);
}

-(void)locationResponse{
    [self dismissKeyboard];
    
    DiscoverLocationViewController *viewController = [DiscoverLocationViewController new];
    viewController.previousController = self;
    viewController.nextControllerType = SYDiscoverNextShareLearn;
    [self presentViewController:viewController animated:YES completion:nil];
}

-(void)locationCompleteResponse{
    UIButton *locationButton = [locationView viewWithTag:11];
    locationButton.selected = YES;
    [locationButton setTitle:[[[_selectedItem placemark] addressDictionary] valueForKey:@"Street"] forState:UIControlStateSelected];
    priceView.hidden = NO;
    nextButton.hidden = NO;
}

-(void)nextResponse{
    NSString *subCate;
    NSString *latitude;
    NSString *longitude;
    NSString *requestBody;

    UITextField *school = [schoolContentView viewWithTag:11];
    UITextField *college = [schoolContentView viewWithTag:12];
    UITextField *department = [schoolContentView viewWithTag:13];
    UITextField *major = [schoolContentView viewWithTag:14];
    UITextField *title = [interestView viewWithTag:11];
    UITextField *gender = [interestView viewWithTag:12];
    UITextField *age = [interestView viewWithTag:14];
    UITextView *interest = [interestView viewWithTag:13];
    switch (_controllerType) {
        case discoverLearnExper:
            subCate= [NSString stringWithFormat:@"01%@0000",_typeString];

            latitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
            longitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.longitude];
            
            requestBody = [NSString stringWithFormat:@"email=%@&latitude=%@&longitude=%@&category=3&subcate=%@&school=%@&major=%@&college=%@&department=%@&introduction=",MEID,latitude,longitude,subCate,school.text,major.text,college.text,department.text];
            break;
        case discoverLearnTutor:
            subCate= @"02000000";
            latitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
            longitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.longitude];
            requestBody = [NSString stringWithFormat:@"email=%@&latitude=%@&longitude=%@&category=3&subcate=%@&school=%@&introduction=%@&major=%@&college=%@&department=%@",MEID,latitude,longitude,subCate,school.text, contentTextView.text,major.text,college.text,department.text];
            break;
        case discoverLearnInterest:
            subCate= @"03000000";
            latitude = [NSString stringWithFormat:@"%f",[[_selectedItem placemark] coordinate].latitude];
            longitude = [NSString stringWithFormat:@"%f",[[_selectedItem placemark] coordinate].longitude];
            requestBody = [NSString stringWithFormat:@"email=%@&latitude=%@&longitude=%@&category=3&subcate=%@&keyword=%@&introduction=%@&gender=%@&age=%@",MEID,latitude,longitude,subCate,title.text, interest.text,gender.text,age.text];
            break;
            
        default:
            break;
    }
    
//    UITextField *keyword = [keywordView viewWithTag:11];
    
//    NSString *requestBody = [NSString stringWithFormat:@"email=%@&latitude=%@&longitude=%@&category=3&subcate=%@&title=%@&major=%@&number=%@&lower_price=%@&upper_price=%@",MEID,latitude,longitude,subCate,keyword.text,majorString,numberString,lowerPriceString,upperPriceString];
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

-(void)titleEmptyCheck{
    UITextField *textField = [keywordView viewWithTag:11];
    if ([textField.text length]) {
        if (_controllerType == discoverLearnInterest) {
            locationView.hidden = NO;
        }
        else if (_controllerType == discoverLearnTutor){
            priceView.hidden = NO;
            nextButton.hidden = NO;
        }
        else
            nextButton.hidden = NO;
    }
}
-(void)majorEmptyCheck{
    UITextView *textView = [majorView viewWithTag:11];
    if ([textView.text length]) {
        keywordView.hidden = NO;
    }
}
-(void)dismissKeyboard {
    
    UITextField *school = [schoolContentView viewWithTag:11];
    UITextField *college = [schoolContentView viewWithTag:12];
    UITextField *department = [schoolContentView viewWithTag:13];
    UITextField *major = [schoolContentView viewWithTag:14];
    [school resignFirstResponder];
    [college resignFirstResponder];
    [department resignFirstResponder];
    [major resignFirstResponder];
    [contentTextView resignFirstResponder];
    
    UITextField *title = [interestView viewWithTag:11];
    UITextField *gender = [interestView viewWithTag:12];
    UITextField *age = [interestView viewWithTag:14];
    UITextView *interest = [interestView viewWithTag:13];
    [title resignFirstResponder];
    [gender resignFirstResponder];
    [age resignFirstResponder];
    [interest resignFirstResponder];
    
}



- (void)priceSlider:(UISlider *)slider priceChangeToValue:(NSInteger)price{
    
}
-(void)lowerPriceChangeToValue:(NSInteger)lowerPrice upperToValue:(NSInteger)upperPrice{
    lowerPriceString = [NSString stringWithFormat:@"%ld",lowerPrice];
    upperPriceString = [NSString stringWithFormat:@"%ld",upperPrice];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:lowerPriceString, @"lower_price",upperPriceString,@"upper_price", nil];
    [_shareDict addEntriesFromDictionary:dict];
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

@end
