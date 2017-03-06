//
//  DiscoverEatArticalShareViewController.m
//  Sharmunity
//
//  Created by st chen on 2017/2/28.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "DiscoverEatArticalShareViewController.h"
#import "Header.h"
#import "SYHeader.h"
@interface DiscoverEatArticalShareViewController (){
    SYPopOut *popOut;
}

@end

@implementation DiscoverEatArticalShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"吃货攻略";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: SYColor1,
                                                                    NSFontAttributeName: SYFont20};
    self.view.backgroundColor = SYBackgroundColorExtraLight;
    
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mainScrollView.backgroundColor = SYBackgroundColorExtraLight;
    [self.view addSubview:mainScrollView];
    
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
    
    
    MEID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [mainScrollView addGestureRecognizer:tap];
    
    popOut = [SYPopOut new];
    [self viewsSetup];
    
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
    
    
    /*title*/
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 50)];
    [mainScrollView addSubview:titleView];
    [viewsArray addObject:titleView];
    SYTextField *textfield = [[SYTextField alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 40) type:SYTextFieldShare];
    textfield.tag = 11;
    textfield.placeholder = @"标题";
    [titleView addSubview:textfield];
    
    /*introduction*/
    introductionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 400)];
    [mainScrollView addSubview:introductionView];
    [viewsArray addObject:introductionView];
    SYTextView *textView = [[SYTextView alloc] initWithFrame:CGRectMake(originX, 10, viewWidth-2*originX, 355) type:SYTextViewShare];
    textView.tag = 11;
    [textView setPlaceholder:@"提供服务介绍"];
    [introductionView addSubview:textView];
    
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

- (void)nextResponse{
    UITextField *title = [titleView viewWithTag:11];
    UITextView *introduction = [introductionView viewWithTag:11];
    NSString *requestBody = [NSString stringWithFormat:@"email=%@&latitude=%f&longitude=%f&category=1&subcate=03000000&title=%@&introduction=%@&price=0",MEID,self.locationManager.location.coordinate.latitude,self.locationManager.location.coordinate.longitude,title.text,introduction.text];
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
