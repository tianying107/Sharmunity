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
#import "DiscoverLocationViewController.h"
@interface DiscoverLiveShareSubmitViewController ()<SYTextViewDelegate>{
    SYDistanceSlider *distanceSlider;
    SYPopOut *popOut;
}

@end

@implementation DiscoverLiveShareSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"搬家服务";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: SYColor1,
                                                                    NSFontAttributeName: SYFont20};
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
    [backBtn setImage:[UIImage imageNamed:@"SYBackColor4"] forState:UIControlStateNormal];
    [backBtn setTitle:@"住" forState:UIControlStateNormal];
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
    priceString = @"1";
    
    /*title*/
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 50)];
    [mainScrollView addSubview:titleView];
    [viewsArray addObject:titleView];
    SYTextField *textfield = [[SYTextField alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 40) type:SYTextFieldShare];
    textfield.tag = 11;
    textfield.placeholder = @"提供服务标题";
    [textfield addTarget:self action:@selector(titleEmptyCheck) forControlEvents:UIControlEventEditingChanged];
    [titleView addSubview:textfield];
    
    /*introduction*/
    introductionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 120)];
    introductionView.hidden = YES;
    [mainScrollView addSubview:introductionView];
    [viewsArray addObject:introductionView];
    SYTextView *textView = [[SYTextView alloc] initWithFrame:CGRectMake(originX, 10, viewWidth-2*originX, 110) type:SYTextViewShare];
    textView.tag = 11;
    textView.SYDelegate = self;
    [textView setPlaceholder:@"提供服务介绍"];
    [introductionView addSubview:textView];
    
    /*location*/
    locationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 160)];
    [mainScrollView addSubview:locationView];
    [viewsArray addObject:locationView];
    locationView.hidden = YES;
    UILabel *locationTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 100, 60)];
    locationTitleLabel.text = @"位置";
    locationTitleLabel.textColor = SYColor4;
    [locationTitleLabel setFont:SYFont25];
    [locationView addSubview:locationTitleLabel];
    UIButton *locationButton = [[UIButton alloc] initWithFrame:CGRectMake(155, 0, viewWidth-155, 60)];
    locationButton.tag = 11;
    [locationButton setTitleColor:SYColor10 forState:UIControlStateNormal];
    [locationButton setTitleColor:SYColor4 forState:UIControlStateSelected];
    [locationButton setTitle:@"请选择位置" forState:UIControlStateNormal];
    [locationButton.titleLabel setFont:SYFont20];
    [locationButton addTarget:self action:@selector(locationResponse) forControlEvents:UIControlEventTouchUpInside];
    locationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [locationView addSubview:locationButton];
    
    /*next button*/
    nextButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 32)];
    [nextButton setTitle:@"提交" forState:UIControlStateNormal];
    [nextButton setBackgroundColor:SYColor4];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton.titleLabel setFont:SYFont20M];
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
    titleView.hidden = NO;
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
-(void)titleEmptyCheck{
    UITextField *textField = [titleView viewWithTag:11];
    if ([textField.text length]) {
        introductionView.hidden = NO;
    }
}
-(void)locationResponse{
    [self dismissKeyboard];
    DiscoverLocationViewController *viewController = [DiscoverLocationViewController new];
    viewController.previousController = self;
    viewController.needDistance = YES;
    viewController.nextControllerType = SYDiscoverNextHelp;
    [self presentViewController:viewController animated:YES completion:nil];

}
-(void)locationCompleteResponse{
    UIButton *locationButton = [locationView viewWithTag:11];
    locationButton.selected = YES;
    [locationButton setTitle:[NSString stringWithFormat:@"%@附近%@英里",[[[_selectedItem placemark] addressDictionary] valueForKey:@"Street"],_distanceString] forState:UIControlStateSelected];
    nextButton.hidden = NO;
    
}
-(void)SYTextView:(SYTextView *)textView isEmpty:(BOOL)empty{
    locationView.hidden = !empty;
}

- (void)nextResponse{
    UITextField *title = [titleView viewWithTag:11];
    UITextView *introduction = [introductionView viewWithTag:11];
    NSString *requestBody = [NSString stringWithFormat:@"email=%@&latitude=%f&longitude=%f&category=2&subcate=%@&price=%@&available_date=%@&distance=%@&placemark=%@&title=%@&introduction=%@&short_term=",MEID,[[_selectedItem placemark] coordinate].latitude,[[_selectedItem placemark] coordinate].longitude,_subcate,priceString,dateString,_distanceString,_selectedItem.name,title.text,introduction.text];
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
    UITextField *title = [titleView viewWithTag:11];
    [title resignFirstResponder];
}

-(void)submitHandle:(NSDictionary*)dict{
    if ([[dict valueForKey:@"success"] boolValue]){
        [popOut showUpPop:SYPopDiscoverShareSuccess];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else [popOut showUpPop:SYPopDiscoverShareFail];
    
}
@end
