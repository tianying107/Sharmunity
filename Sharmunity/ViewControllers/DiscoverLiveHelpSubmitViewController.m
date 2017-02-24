//
//  DiscoverLiveHelpSubmitViewController.m
//  Sharmunity
//
//  Created by st chen on 2017/2/9.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "DiscoverLiveHelpSubmitViewController.h"
#import "Header.h"
#import "SYHeader.h"
#import "DiscoverLocationViewController.h"
@interface DiscoverLiveHelpSubmitViewController ()<SYTextViewDelegate>{
    SYPopOut *popOut;
}

@end

@implementation DiscoverLiveHelpSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"搬家";
    self.view.backgroundColor = SYBackgroundColorExtraLight;
    
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mainScrollView.backgroundColor = SYBackgroundColorExtraLight;
    [self.view addSubview:mainScrollView];
    
    MEID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];

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
    // Dispose of any resources that can be recreated.
}

-(void)viewsSetup{
    viewsArray = [NSMutableArray new];
    float viewWidth = mainScrollView.frame.size.width;
    float originX = 30;
    
    /*location*/
    locationOutView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    [mainScrollView addSubview:locationOutView];
    [viewsArray addObject:locationOutView];
    UIButton *locationButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 20, viewWidth-2*originX, 40)];
    locationButton.tag = 11;
    [locationButton setTitleColor:SYColor3 forState:UIControlStateNormal];
    [locationButton setTitleColor:SYColor1 forState:UIControlStateSelected];
    [locationButton setTitle:@"搬出地址" forState:UIControlStateNormal];
    [locationButton.titleLabel setFont:SYFont15];
    locationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [locationButton addTarget:self action:@selector(locationOutResponse) forControlEvents:UIControlEventTouchUpInside];
    [locationButton setContentEdgeInsets:UIEdgeInsetsMake(4, 10, 4, 10)];
    locationButton.layer.cornerRadius = 6;
    locationButton.clipsToBounds = YES;
    locationButton.layer.borderColor = [SYColor6 CGColor];
    locationButton.layer.borderWidth = 1;
    [locationOutView addSubview:locationButton];
    
    /*location*/
    locationInView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    [mainScrollView addSubview:locationInView];
    [viewsArray addObject:locationInView];
    UIButton *locationInButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 20, viewWidth-2*originX, 40)];
    locationInButton.tag = 11;
    [locationInButton setTitleColor:SYColor3 forState:UIControlStateNormal];
    [locationInButton setTitleColor:SYColor1 forState:UIControlStateSelected];
    [locationInButton setTitle:@"搬入地址" forState:UIControlStateNormal];
    [locationInButton.titleLabel setFont:SYFont15];
    locationInButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [locationInButton addTarget:self action:@selector(locationInResponse) forControlEvents:UIControlEventTouchUpInside];
    [locationInButton setContentEdgeInsets:UIEdgeInsetsMake(4, 10, 4, 10)];
    locationInButton.layer.cornerRadius = 6;
    locationInButton.clipsToBounds = YES;
    locationInButton.layer.borderColor = [SYColor6 CGColor];
    locationInButton.layer.borderWidth = 1;
    [locationInView addSubview:locationInButton];
    
    /*date view*/
    dateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    dateView.hidden = YES;
    [mainScrollView addSubview:dateView];
    [viewsArray addObject:dateView];
    UILabel *dateTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 20, 100, 60)];
    dateTitleLabel.text = @"搬家日期";
    [dateTitleLabel setFont:SYFont20];
    dateTitleLabel.textColor = SYColor1;
    [dateView addSubview:dateTitleLabel];
    UIButton *dateButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 20, viewWidth-2*originX, 60)];
    [dateButton setTitle:@"请选择搬家时间" forState:UIControlStateNormal];
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
    
    
    /*price*/
    lowerPriceString = @"0";
    upperPriceString = @"2";
    
    /*distance*/
    distanceString = @"0";

    /*introduction*/
    introductionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 120)];
    introductionView.hidden = YES;
    [mainScrollView addSubview:introductionView];
    [viewsArray addObject:introductionView];
    SYTextView *textView = [[SYTextView alloc] initWithFrame:CGRectMake(originX, 10, viewWidth-2*originX, 100) type:SYTextViewHelp];
    textView.tag = 11;
    textView.SYDelegate = self;
    [textView setPlaceholder:@"搬家物品"];
    [introductionView addSubview:textView];
    
    /*next button*/
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
    mainScrollView.contentSize = CGSizeMake(0, height+20+44+10);
}
-(void)locationInResponse{
    [self dismissKeyboard];
    [self pickerConfirmResponse];
    
    DiscoverLocationViewController *viewController = [DiscoverLocationViewController new];
    viewController.previousController = self;
    viewController.needDistance = NO;
    viewController.nextControllerType = SYDiscoverNextHelpMoveIn;
    [self.navigationController pushViewController:viewController animated:YES];
}
-(void)locationInCompleteResponse{
    UIButton *locationButton = [locationInView viewWithTag:11];
    locationButton.selected = YES;
    [locationButton setTitle:[[[_selectedInItem placemark] addressDictionary] valueForKey:@"Street"] forState:UIControlStateSelected];
}
-(void)locationOutResponse{
    [self dismissKeyboard];
    [self pickerConfirmResponse];
    
    DiscoverLocationViewController *viewController = [DiscoverLocationViewController new];
    viewController.previousController = self;
    viewController.needDistance = NO;
    viewController.nextControllerType = SYDiscoverNextHelpMoveOut;
    [self.navigationController pushViewController:viewController animated:YES];
}
-(void)locationOutCompleteResponse{
    UIButton *locationButton = [locationOutView viewWithTag:11];
    locationButton.selected = YES;
    [locationButton setTitle:[[[_selectedOutItem placemark] addressDictionary] valueForKey:@"Street"] forState:UIControlStateSelected];
    dateView.hidden = NO;
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
    [_helpDict addEntriesFromDictionary:dict];
    dateString = dtrDate;
}
- (void)pickerConfirmResponse{
    confirmBackgroundView.hidden = YES;
    
    datePicker.hidden = YES;
}
-(void)SYTextView:(SYTextView *)textView isEmpty:(BOOL)empty{
    nextButton.hidden = !empty;
}
- (void)nextResponse{
    NSString *requestBody = [NSString stringWithFormat:@"email=%@&latitude=%f&longitude=%f&category=2&subcate=%@&lower_price=%@&upper_price=%@&date=%@&distance=%@&placemark=%@&expire_date=2099-01-01",MEID,[[_selectedOutItem placemark] coordinate].latitude,[[_selectedOutItem placemark] coordinate].longitude,_subcate,lowerPriceString,upperPriceString,dateString,distanceString,_selectedOutItem.name];
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [self submitHandle:dict];
        });
    }];
    [task resume];
}

-(void)dismissKeyboard {
    [self pickerConfirmResponse];
    UITextView *textField = [introductionView viewWithTag:11];
    [textField resignFirstResponder];
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
@end
