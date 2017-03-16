//
//  DiscoverPlayPartnerHelpViewController.m
//  Sharmunity
//
//  Created by Star Chen on 3/10/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import "DiscoverPlayPartnerHelpViewController.h"
#import "Header.h"
#import "SYHeader.h"
@interface DiscoverPlayPartnerHelpViewController (){
    SYPopOut *popOut;
}

@end

@implementation DiscoverPlayPartnerHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"找活动";
    self.view.backgroundColor = SYBackgroundColorExtraLight;
    
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mainScrollView.backgroundColor = SYBackgroundColorExtraLight;
    [self.view addSubview:mainScrollView];
    
    MEID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
    
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

-(void)viewsSetup{
    viewsArray = [NSMutableArray new];
    float viewWidth = mainScrollView.frame.size.width;
    float originX = 30;
    
    /*subcate view*/
    subcateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth-20, 160)];
    UILabel *partnerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 20)];
    partnerLabel.text = @"好山好水好无聊？来找伴儿吧！";
    partnerLabel.textColor = SYColor3;
    partnerLabel.textAlignment = NSTextAlignmentCenter;
    [partnerLabel setFont:SYFont15];
    [subcateView addSubview:partnerLabel];
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(originX, 20, viewWidth/2-originX, 40)];
    [button1 setTitle:@"学伴儿" forState:UIControlStateNormal];
    [button1 setTitleColor:SYColor7 forState:UIControlStateNormal];
    [button1.titleLabel setFont:SYFont20];
    button1.tag = 11;
    [button1 addTarget:self action:@selector(subcateResponse:) forControlEvents:UIControlEventTouchUpInside];
    [subcateView addSubview:button1];
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth/2, 20, viewWidth/2-originX, 40)];
    [button2 setTitle:@"聊伴儿" forState:UIControlStateNormal];
    [button2 setTitleColor:SYColor7 forState:UIControlStateNormal];
    [button2.titleLabel setFont:SYFont20];
    button2.tag = 12;
    [button2 addTarget:self action:@selector(subcateResponse:) forControlEvents:UIControlEventTouchUpInside];
    [subcateView addSubview:button2];
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(originX, 60, viewWidth/2-originX, 40)];
    [button3 setTitle:@"游伴儿" forState:UIControlStateNormal];
    [button3 setTitleColor:SYColor7 forState:UIControlStateNormal];
    [button3.titleLabel setFont:SYFont20];
    button3.tag = 13;
    [button3 addTarget:self action:@selector(subcateResponse:) forControlEvents:UIControlEventTouchUpInside];
    [subcateView addSubview:button3];
    UIButton *button4 = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth/2, 60, viewWidth/2-originX, 40)];
    [button4 setTitle:@"商伴儿" forState:UIControlStateNormal];
    [button4 setTitleColor:SYColor7 forState:UIControlStateNormal];
    [button4.titleLabel setFont:SYFont20];
    button4.tag = 14;
    [button4 addTarget:self action:@selector(subcateResponse:) forControlEvents:UIControlEventTouchUpInside];
    [subcateView addSubview:button4];
    UIButton *button5 = [[UIButton alloc] initWithFrame:CGRectMake(originX, 100, viewWidth/2-originX, 40)];
    [button5 setTitle:@"玩伴儿" forState:UIControlStateNormal];
    [button5 setTitleColor:SYColor7 forState:UIControlStateNormal];
    [button5.titleLabel setFont:SYFont20];
    button5.tag = 15;
    [button5 addTarget:self action:@selector(subcateResponse:) forControlEvents:UIControlEventTouchUpInside];
    [subcateView addSubview:button5];
    
    /*introduction*/
    introductionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    introductionView.hidden = YES;
    SYTextView *introduction = [[SYTextView alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 80) type:SYTextViewHelp];
    [introduction setPlaceholder:@"用一句话自我描述（50字以内）"];
    introduction.tag = 11;
    [introductionView addSubview:introduction];
    
    /*keyword*/
    keywordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 60)];
    keywordView.hidden = YES;
    keywordCount = 1;
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth-originX-30, 5, 30, 30)];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addButton setTitle:@"+" forState:UIControlStateNormal];
    addButton.backgroundColor = SYColor6;
    addButton.layer.cornerRadius = addButton.frame.size.height/2;
    addButton.clipsToBounds = YES;
    addButton.tag = 10;
    [addButton addTarget:self action:@selector(addKeywordResponse) forControlEvents:UIControlEventTouchUpInside];
    [keywordView addSubview:addButton];
    SYTextField *keyword1 = [[SYTextField alloc] initWithFrame:CGRectMake(originX, 2.5, 180, 35) type:SYTextFieldHelp];
    keyword1.placeholder = @"关键词1";
    keyword1.tag = 11;
    [keywordView addSubview:keyword1];
    
    
    
    
    
    
    [mainScrollView addSubview:subcateView];
    [viewsArray addObject:subcateView];
    [mainScrollView addSubview:introductionView];
    [viewsArray addObject:introductionView];
    [mainScrollView addSubview:keywordView];
    [viewsArray addObject:keywordView];
    
    /*next button*/
    nextButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 32)];
    [nextButton setTitle:@"提交" forState:UIControlStateNormal];
    [nextButton setBackgroundColor:SYColor7];
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
-(IBAction)subcateResponse:(id)sender{
    introductionView.hidden = NO;
    keywordView.hidden = NO;
    nextButton.hidden = NO;
    for (int i=11; i<16; i++) {
        UIButton *button = [subcateView viewWithTag:i];
        if ([button isEqual:sender]) {
            [button setTitleColor:SYColor5 forState:UIControlStateNormal];
            [button.titleLabel setFont:SYFont25];
            typeString = [NSString stringWithFormat:@"%d",i-10];
        }
        else{
            [button setTitleColor:SYColor7 forState:UIControlStateNormal];
            [button.titleLabel setFont:SYFont20];
        }
    }
}
-(void)dismissKeyboard {
    UITextView *textView = [introductionView viewWithTag:11];
    [textView resignFirstResponder];

//    textField = [dateView viewWithTag:11];
//    [textField resignFirstResponder];
//    textField = [dateView viewWithTag:12];
//    [textField resignFirstResponder];
//    textField = [dateView viewWithTag:13];
}
-(void)addKeywordResponse{
    UITextField *lastField = [keywordView viewWithTag:10+keywordCount];
    UIButton *addButton = [keywordView viewWithTag:10];
    if (![lastField.text isEqualToString:@""]) {
        if (keywordCount<3) {
            SYTextField *newField = [[SYTextField alloc] initWithFrame:CGRectMake(lastField.frame.origin.x, 40*keywordCount+2.5, lastField.frame.size.width, 35) type:SYTextFieldHelp];
            newField.tag = 10+keywordCount+1;
            addButton.frame = CGRectMake(addButton.frame.origin.x, 40*keywordCount+5, addButton.frame.size.width, addButton.frame.size.height);
            [keywordView addSubview:newField];
            keywordView.frame = CGRectMake(keywordView.frame.origin.x, keywordView.frame.origin.y, keywordView.frame.size.width, keywordView.frame.size.height+40);
            keywordCount ++;
            [self viewsLayout];
        }
        else{
            addButton.hidden = YES;
        }
    }
}

-(void)nextResponse{
    NSString *subCate= [NSString stringWithFormat:@"03%02ld0000",[typeString integerValue]];
    NSString *latitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.longitude];

    NSString *keyword = [(UITextField*)[keywordView viewWithTag:11] text];
    for (int i = 1; i<keywordCount; i++) {
        UITextField *keywordField = [keywordView viewWithTag:11+i];
        if (![keywordField.text isEqualToString:@""]) {
            keyword = [NSString stringWithFormat:@"%@,%@",keyword,keywordField.text];
        }
        
    }
//    UITextField *title = [titleView viewWithTag:11];
    UITextView *introduction = [introductionView viewWithTag:11];
    
    NSString *requestBody = [NSString stringWithFormat:@"expire_date=2099-01-01&email=%@&latitude=%@&longitude=%@&category=4&subcate=%@&keyword=%@&introduction=%@",MEID,latitude,longitude,subCate,keyword, introduction.text];
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
