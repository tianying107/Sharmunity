//
//  DiscoverArticalHelpViewController.m
//  Sharmunity
//
//  Created by Star Chen on 3/10/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import "DiscoverArticalHelpViewController.h"
#import "Header.h"
#import "SYHeader.h"
#import "SYArticalAbstract.h"
@interface DiscoverArticalHelpViewController ()

@end

@implementation DiscoverArticalHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"找攻略";

    self.view.backgroundColor = SYBackgroundColorExtraLight;
    
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
    [self.view addGestureRecognizer:tap];
    
//    popOut = [SYPopOut new];
    [self viewsSetup];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"SYBackColor5"] forState:UIControlStateNormal];
    [backBtn setTitleColor:SYColor1 forState:UIControlStateNormal];
    [backBtn.titleLabel setFont:SYFont15];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backBtn.bounds = CGRectMake(0, 0, 80, 40);
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;

    switch (_helpType) {
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewsSetup{
    float viewWidth = self.view.frame.size.width;
    float originX = 30;
    float heightCount = 44+20;
    
    /*title*/
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, heightCount+15, viewWidth, 55)];
    [self.view addSubview:titleView];
    SYTextField *textfield = [[SYTextField alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 40) type:SYTextFieldHelp];
    textfield.tag = 11;
    textfield.delegate = self;
    textfield.placeholder = @"关键字";
    textfield.returnKeyType = UIReturnKeySearch;
    [titleView addSubview:textfield];
    heightCount += titleView.frame.size.height;
    
    
    
    helpTable = [[UITableView alloc] initWithFrame:CGRectMake(0, heightCount, self.view.frame.size.width, self.view.frame.size.height-heightCount) style:UITableViewStylePlain];
    helpTable.delegate = self;
    helpTable.dataSource = self;
    helpTable.alwaysBounceVertical = NO;
    helpTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:helpTable];
//    [self requestHelpFromServer];
    [NSTimer scheduledTimerWithTimeInterval:2 repeats:NO block:^(NSTimer *timer){
        [helpTable reloadData];
        [NSTimer scheduledTimerWithTimeInterval:.1 repeats:NO block:^(NSTimer *timer){
            helpTable.hidden = NO;
        }];
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self requestHelpFromServer:textField.text];
    
    return YES;
}

-(void)requestHelpFromServer:(NSString*)keyword{
    basicViewArray = [NSMutableArray new];
    MEID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
    NSString *requestQuery = [NSString stringWithFormat:@"email=%@&category=4",MEID];
    NSString *urlString = [NSString stringWithFormat:@"%@allhelps?%@",basicURL,requestQuery];
    NSLog(@"%@",requestQuery);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionTask *task = [session dataTaskWithURL:url
                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                        NSArray *array = [NSJSONSerialization JSONObjectWithData:data
                                                                                         options:kNilOptions
                                                                                           error:&error];
                                        NSLog(@"server said: %@",array);
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            helpIDArray = array;
                                            [helpTable reloadData];
                                            
                                        });
                                        
                                    }];
    [task resume];
}
/* tableView data source and delegate*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return helpIDArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    float height;
//    if (indexPath.row<basicViewArray.count)
//        height = [(SYHelp*)[basicViewArray objectAtIndex:indexPath.row] frame].size.height;
//    else
//        height = 200;
//    return height;
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"discoverCell";
    SYCell *cell;
    if (cell == nil) {
        cell = [[SYCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if ((indexPath.row+1)>basicViewArray.count) {
        SYArticalAbstract *abstractView = [[SYArticalAbstract alloc] initWithFrame:CGRectMake(0, 0, helpTable.frame.size.width, 50) shareID:[helpIDArray objectAtIndex:indexPath.row]];
//        SYHelp *helpView = [[SYHelp alloc] initWithFrame:CGRectMake(0, 0, helpTable.frame.size.width, 50) helpID:[helpIDArray objectAtIndex:indexPath.row] withHeadView:NO];
        [basicViewArray addObject:abstractView];
        [cell setBasicView:abstractView];
    }
    else{
        [cell setBasicView:[basicViewArray objectAtIndex:indexPath.row]];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
