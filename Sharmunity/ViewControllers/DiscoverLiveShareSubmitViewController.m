//
//  DiscoverLiveShareSubmitViewController.m
//  Sharmunity
//
//  Created by st chen on 2017/2/9.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "DiscoverLiveShareSubmitViewController.h"
#import "Header.h"
#import "SYHeader.h"
@interface DiscoverLiveShareSubmitViewController ()<SYPriceSliderDelegate>{
    SYDistanceSlider *distanceSlider;
    SYPopOut *popOut;
}

@end

@implementation DiscoverLiveShareSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"详细信息";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: SYColor1,
                                                                    NSFontAttributeName: SYFont20S};
    self.view.backgroundColor = SYBackgroundColorExtraLight;

    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mainScrollView.backgroundColor = SYBackgroundColorExtraLight;
    [self.view addSubview:mainScrollView];
    
    MEID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
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
    
    /*location*/
    locationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    [mainScrollView addSubview:locationView];
    [viewsArray addObject:locationView];
    UILabel *locationTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 20, 100, 60)];
    locationTitleLabel.text = @"位置";
    locationTitleLabel.textColor = SYColor1;
    [locationView addSubview:locationTitleLabel];
    UIButton *locationButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 20, viewWidth-2*originX, 60)];
    [locationButton setTitle:[[[_selectedItem placemark] addressDictionary] valueForKey:@"Street"] forState:UIControlStateNormal];
    [locationButton setTitleColor:SYColor1 forState:UIControlStateNormal];
    [locationButton setTitleColor:SYColor1 forState:UIControlStateSelected];
    locationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [locationView addSubview:locationButton];
    
    /*date*/
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"1970-01-01", @"available_date", nil];
    [_shareDict addEntriesFromDictionary:dict];
    if (_dateAvailable) {
        dateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
        [mainScrollView addSubview:dateView];
        [viewsArray addObject:dateView];
        UILabel *dateTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 20, 100, 60)];
        dateTitleLabel.text = @"日期";
        dateTitleLabel.textColor = SYColor1;
        [dateView addSubview:dateTitleLabel];
        UIButton *dateButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 20, viewWidth-2*originX, 60)];
        [dateButton setTitle:@"请选择入住日期" forState:UIControlStateNormal];
        [dateButton setTitleColor:SYColor3 forState:UIControlStateNormal];
        [dateButton setTitleColor:SYColor1 forState:UIControlStateSelected];
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
        
    }
    
    /*price*/
    priceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 140)];
    priceView.hidden = YES;
    [mainScrollView addSubview:priceView];
    [viewsArray addObject:priceView];
    UILabel *priceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 100, 60)];
    priceTitleLabel.text = @"价格";
    priceTitleLabel.textColor = SYColor1;
    [priceView addSubview:priceTitleLabel];
    SYPriceSlider *priceSlider = [[SYPriceSlider alloc] initWithFrame:CGRectMake(originX, 60, viewWidth-2*originX, 50) type:SYPriceSliderSingle];
    priceSlider.delegate = self;
    [priceView addSubview:priceSlider];
    priceString = @"150";
    
    /*distance*/
    distanceString = @"1000";
    if (_distanceAvailable) {
        distanceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 140)];
        distanceView.hidden = YES;
        [mainScrollView addSubview:distanceView];
        [viewsArray addObject:distanceView];
        UILabel *distanceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 200, 60)];
        distanceTitleLabel.text = @"服务的范围";
        distanceTitleLabel.textColor = SYColor1;
        [distanceView addSubview:distanceTitleLabel];
        distanceSlider = [[SYDistanceSlider alloc] initWithFrame:CGRectMake(originX, 50, viewWidth-2*originX, 70)];
        [distanceSlider.distanceSlider addTarget:self action:@selector(updateDistance) forControlEvents:UIControlEventValueChanged];
        [distanceView addSubview:distanceSlider];
        distanceString = @"3";


    }
    
    /*introduction*/
    introductionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 180)];
    introductionView.hidden = YES;
    [mainScrollView addSubview:introductionView];
    [viewsArray addObject:introductionView];
    UILabel *introductionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 100, 40)];
    introductionTitleLabel.text = @"简介";
    introductionTitleLabel.textColor = SYColor1;
    [introductionView addSubview:introductionTitleLabel];
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(originX, 40, viewWidth-2*originX, 100)];
    textView.tag = 11;
    textView.backgroundColor = [UIColor whiteColor];
    [introductionView addSubview:textView];
    
    /*next button*/
    nextButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 44)];
    [nextButton setTitle:@"发布" forState:UIControlStateNormal];
    [nextButton setBackgroundColor:SYColor4];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton.titleLabel setFont:SYFont20S];
    [nextButton addTarget:self action:@selector(nextResponse) forControlEvents:UIControlEventTouchUpInside];
    nextButton.layer.cornerRadius = nextButton.frame.size.height/2;
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
    mainScrollView.contentSize = CGSizeMake(0, height+20+44+10);
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
        [_shareDict addEntriesFromDictionary:dict];
        dateString = dtrDate;
    }
    datePicker.hidden = NO;
    confirmBackgroundView.hidden = NO;
    priceView.hidden = NO;
    distanceView.hidden = NO;
    nextButton.hidden = NO;
    introductionView.hidden = NO;
}
-(void)datePickerChanged{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dtrDate = [dateFormatter stringFromDate:datePicker.date];
    UIButton *button = [dateView viewWithTag:11];
    [button setTitle:dtrDate forState:UIControlStateSelected];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:dtrDate, @"available_date", nil];
    [_shareDict addEntriesFromDictionary:dict];
    dateString = dtrDate;
}
- (void)pickerConfirmResponse{
    confirmBackgroundView.hidden = YES;
    
    datePicker.hidden = YES;
}


- (void)priceSlider:(UISlider *)slider priceChangeToValue:(NSInteger)price{
    priceString = [NSString stringWithFormat:@"%ld",price];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:priceString, @"price", nil];
    [_shareDict addEntriesFromDictionary:dict];
}
-(void)lowerPriceChangeToValue:(NSInteger)lowerPrice upperToValue:(NSInteger)upperPrice{
    
}
- (void)updateDistance{
    distanceString = [NSString stringWithFormat:@"%ld",distanceSlider.distanceInteger];
}

- (void)nextResponse{
    NSString *requestBody = [NSString stringWithFormat:@"email=%@&latitude=%f&longitude=%f&category=2&subcate=%@&price=%@&available_date=%@&distance=%@",MEID,[[_selectedItem placemark] coordinate].latitude,[[_selectedItem placemark] coordinate].longitude,[_shareDict valueForKey:@"subcate"],priceString,dateString,distanceString];
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

-(void)dismissKeyboard {
    UITextView *textField = [introductionView viewWithTag:11];
    [textField resignFirstResponder];
}

-(void)submitHandle:(NSDictionary*)dict{
    if ([[dict valueForKey:@"success"] boolValue]){
        [popOut showUpPop:SYPopDiscoverShareSuccess];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else [popOut showUpPop:SYPopDiscoverShareFail];
    
}
@end
