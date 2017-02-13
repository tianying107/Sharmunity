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
}

@end

@implementation DiscoverLearnHelpSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (_controllerType) {
        case discoverLearnExper:
            self.navigationItem.title = @"找学长";
            break;
        case discoverLearnTutor:
            self.navigationItem.title = @"找辅导";
            break;
        case discoverLearnInterest:
            self.navigationItem.title = @"上兴趣班";
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
    majorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    UILabel *majorTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 100, 40)];
    majorTitleLabel.text = @"专业编码";
    majorTitleLabel.textColor = SYColor1;
    [majorView addSubview:majorTitleLabel];
    UITextField *majorTextfield = [[UITextField alloc] initWithFrame:CGRectMake(originX, 40, viewWidth-2*originX, 30)];
    majorTextfield.tag = 11;
    [majorTextfield addTarget:self action:@selector(majorEmptyCheck) forControlEvents:UIControlEventEditingChanged];
    majorTextfield.backgroundColor = [UIColor whiteColor];
    [majorView addSubview:majorTextfield];
    
    /*number type*/
    numberView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    UILabel *numberTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 100, 40)];
    numberTitleLabel.text = @"专业编码";
    numberTitleLabel.textColor = SYColor1;
    [numberView addSubview:numberTitleLabel];
    UITextField *numberTextfield = [[UITextField alloc] initWithFrame:CGRectMake(originX, 40, viewWidth-2*originX, 30)];
    numberTextfield.tag = 11;
    numberTextfield.backgroundColor = [UIColor whiteColor];
    [numberView addSubview:numberTextfield];
    
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
    [locationButton setTitle:@"请选择位置" forState:UIControlStateNormal];
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
        case discoverLearnExper:
            [mainScrollView addSubview:majorView];
            [viewsArray addObject:majorView];
            [mainScrollView addSubview:numberView];
            [viewsArray addObject:numberView];
            [mainScrollView addSubview:keywordView];
            [viewsArray addObject:keywordView];
            break;
        case discoverLearnTutor:
            [mainScrollView addSubview:majorView];
            [viewsArray addObject:majorView];
            [mainScrollView addSubview:numberView];
            [viewsArray addObject:numberView];
            [mainScrollView addSubview:keywordView];
            [viewsArray addObject:keywordView];
            [mainScrollView addSubview:priceView];
            [viewsArray addObject:priceView];
            break;
        case discoverLearnInterest:
            keywordView.hidden = NO;
            [mainScrollView addSubview:keywordView];
            [viewsArray addObject:keywordView];
            [mainScrollView addSubview:locationView];
            [viewsArray addObject:locationView];
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
    priceView.hidden = NO;
    nextButton.hidden = NO;
}

-(void)nextResponse{
    NSString *subCate;
    NSString *majorString;
    NSString *numberString;
    NSString *latitude;
    NSString *longitude;
    UITextField *major = [majorView viewWithTag:11];
    UITextField *number = [numberView viewWithTag:11];
    switch (_controllerType) {
        case discoverLearnExper:
            subCate= @"01000000";
            majorString = major.text;
            numberString = number.text;
            latitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
            longitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.longitude];
            break;
        case discoverLearnTutor:
            subCate= @"02000000";
            majorString = major.text;
            numberString = number.text;
            latitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
            longitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.longitude];
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
    
    UITextField *keyword = [keywordView viewWithTag:11];
    
    NSString *requestBody = [NSString stringWithFormat:@"email=%@&latitude=%@&longitude=%@&category=3&subcate=%@&title=%@&major=%@&number=%@&lower_price=%@&upper_price=%@",MEID,latitude,longitude,subCate,keyword.text,majorString,numberString,lowerPriceString,upperPriceString];
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
    UITextField *textField = [majorView viewWithTag:11];
    [textField resignFirstResponder];
    textField = [numberView viewWithTag:11];
    [textField resignFirstResponder];
    textField = [keywordView viewWithTag:11];
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

@end
