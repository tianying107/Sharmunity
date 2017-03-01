//
//  DiscoverOtherShareViewController.m
//  Sharmunity
//
//  Created by st chen on 2017/2/28.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "DiscoverOtherShareViewController.h"
#import "DiscoverLocationViewController.h"
#import "Header.h"
#import "SYHeader.h"
@interface DiscoverOtherShareViewController ()<SYTextViewDelegate>{
    SYPopOut *popOut;
}

@end

@implementation DiscoverOtherShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        [super viewDidLoad];
        self.navigationItem.title = @"新帮助";
    
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mainScrollView.backgroundColor = SYBackgroundColorExtraLight;
    [self.view addSubview:mainScrollView];
    
    
    
    
    MEID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
    [self viewsSetup];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"SYBackColor4"] forState:UIControlStateNormal];
    [backBtn setTitleColor:SYColor1 forState:UIControlStateNormal];
    [backBtn.titleLabel setFont:SYFont15];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backBtn.bounds = CGRectMake(0, 0, 80, 40);
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    switch (_shareType) {
        case discoverEat:
            [backBtn setTitle:@"吃" forState:UIControlStateNormal];
            break;
        case discoverLive:
            [backBtn setTitle:@"住" forState:UIControlStateNormal];
            break;
        case discoverLearn:
            [backBtn setTitle:@"学" forState:UIControlStateNormal];
            break;
        case discoverPlay:
            [backBtn setTitle:@"玩" forState:UIControlStateNormal];
            break;
        case discoverTravel:
            [backBtn setTitle:@"行" forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
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
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 80)];
    [mainScrollView addSubview:titleView];
    [viewsArray addObject:titleView];
    SYTextField *textfield = [[SYTextField alloc] initWithFrame:CGRectMake(originX, 10, viewWidth-2*originX, 40) type:SYTextFieldShare];
    textfield.tag = 11;
    textfield.placeholder = @"提供标题";
    [textfield addTarget:self action:@selector(titleEmptyCheck) forControlEvents:UIControlEventEditingChanged];
    [titleView addSubview:textfield];
    
    /*introduction*/
    introductionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 130)];
    introductionView.hidden = YES;
    [mainScrollView addSubview:introductionView];
    [viewsArray addObject:introductionView];
    SYTextView *textView = [[SYTextView alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 110) type:SYTextViewShare];
    textView.tag = 11;
    textView.SYDelegate = self;
    [textView setPlaceholder:@"提供介绍"];
    [introductionView addSubview:textView];
    
    /*location*/
    locationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 160)];
    locationView.hidden = YES;
    [mainScrollView addSubview:locationView];
    [viewsArray addObject:locationView];
    UILabel *locationTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 100, 40)];
    locationTitleLabel.text = @"位置";
    locationTitleLabel.textColor = SYColor4;
    [locationTitleLabel setFont:SYFont20];
    [locationView addSubview:locationTitleLabel];
    UIButton *locationButton = [[UIButton alloc] initWithFrame:CGRectMake(155, 0, viewWidth-155, 40)];
    locationButton.tag = 11;
    [locationButton setTitleColor:SYColor10 forState:UIControlStateNormal];
    [locationButton setTitleColor:SYColor4 forState:UIControlStateSelected];
    [locationButton.titleLabel setFont:SYFont20];
    [locationButton setTitle:@"请选择位置" forState:UIControlStateNormal];
    [locationButton addTarget:self action:@selector(locationResponse) forControlEvents:UIControlEventTouchUpInside];
    locationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [locationView addSubview:locationButton];
    
    nextButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 35)];
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
    mainScrollView.contentSize = CGSizeMake(0, height+20+44+20);
}
-(void)titleEmptyCheck{
    UITextField *textField = [titleView viewWithTag:11];
    if ([textField.text length]) {
        introductionView.hidden = NO;
    }
}
-(void)SYTextView:(SYTextView *)textView isEmpty:(BOOL)empty{
    locationView.hidden = !empty;
}
-(void)locationResponse{
    [self dismissKeyboard];
    
    DiscoverLocationViewController *viewController = [DiscoverLocationViewController new];
    viewController.previousController = self;
    viewController.needDistance = NO;
    viewController.nextControllerType = SYDiscoverNextShareLearn;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)locationCompleteResponse{
    UIButton *locationButton = [locationView viewWithTag:11];
    locationButton.selected = YES;
    [locationButton setTitle:[[[_selectedItem placemark] addressDictionary] valueForKey:@"Street"] forState:UIControlStateSelected];
    nextButton.hidden = NO;
    
}

-(void)dismissKeyboard {
    UITextView *textField = [introductionView viewWithTag:11];
    [textField resignFirstResponder];
    
    UITextField *title = [titleView viewWithTag:11];
    [title resignFirstResponder];
}

-(void)nextResponse{
    UITextField *title = [titleView viewWithTag:11];
    UITextView *introduction = [introductionView viewWithTag:11];
    NSString *requestBody = [NSString stringWithFormat:@"email=%@&latitude=%f&longitude=%f&category=%ld&subcate=99999999&distance=1000&placemark=%@&title=%@&introduction=%@",MEID,[[_selectedItem placemark] coordinate].latitude,[[_selectedItem placemark] coordinate].longitude,_shareType,_selectedItem.name,title.text,introduction.text];
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
@end
