//
//  DiscoverTravelHelpViewController.m
//  Sharmunity
//
//  Created by Star Chen on 2/15/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import "DiscoverTravelHelpViewController.h"
#import "DiscoverTravelHelpSecondViewController.h"
#import "DiscoverOtherShareViewController.h"
#import "Header.h"
#import "SYHeader.h"
@interface DiscoverTravelHelpViewController ()

@end

@implementation DiscoverTravelHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"行";
    [self viewsSetup];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"SYBackColor5"] forState:UIControlStateNormal];
    [backBtn setTitle:@"我要求助" forState:UIControlStateNormal];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewsSetup{
    [_catButton addTarget:self action:@selector(typeResponse:) forControlEvents:UIControlEventTouchUpInside];
    [_airplaneButton addTarget:self action:@selector(typeResponse:) forControlEvents:UIControlEventTouchUpInside];
    [_carLabel setFont:SYFont13];
    [_airplaneLabel setFont:SYFont20M];
    
    _partnerButton.layer.cornerRadius = 5;
    _partnerButton.clipsToBounds = YES;
    _partnerButton.layer.borderColor = [SYColor6 CGColor];
    _partnerButton.layer.borderWidth = 1;
    
    _driveButton.layer.cornerRadius = 5;
    _driveButton.clipsToBounds = YES;
    _driveButton.layer.borderColor = [SYColor6 CGColor];
    _driveButton.layer.borderWidth = 1;
    
    _carpoolButton.layer.cornerRadius = 5;
    _carpoolButton.clipsToBounds = YES;
    _carpoolButton.layer.borderColor = [SYColor6 CGColor];
    _carpoolButton.layer.borderWidth = 1;
    
    _pickupButton.layer.cornerRadius = 5;
    _pickupButton.clipsToBounds = YES;
    _pickupButton.layer.borderColor = [SYColor6 CGColor];
    _pickupButton.layer.borderWidth = 1;
    
    _buyCarButton.layer.cornerRadius = 5;
    _buyCarButton.clipsToBounds = YES;
    _buyCarButton.layer.borderColor = [SYColor6 CGColor];
    _buyCarButton.layer.borderWidth = 1;
    
    _deliverButton.layer.cornerRadius = 5;
    _deliverButton.clipsToBounds = YES;
    _deliverButton.layer.borderColor = [SYColor6 CGColor];
    _deliverButton.layer.borderWidth = 1;
    
    _questionButton.layer.cornerRadius = 5;
    _questionButton.clipsToBounds = YES;
    _questionButton.layer.borderColor = [UIColorFromRGB(0x70C1B3) CGColor];
    _questionButton.layer.borderWidth = 1;
    
    _partnerButton.tag = DiscoverTravelPartner;
    _driveButton.tag = DiscoverTravelDrive;
    _carpoolButton.tag = DiscoverTravelCarpool;
    _pickupButton.tag = DiscoverTravelPickup;
    _buyCarButton.tag = DiscoverTravelBuyCar;
    _repairButton.tag = DiscoverTravelRepair;
    _deliverButton.tag = DiscoverTravelDeliver;
    _otherButton.tag = DiscoverTravelOther;
    [_partnerButton addTarget:self action:@selector(selectResponse:) forControlEvents:UIControlEventTouchUpInside];
    [_driveButton addTarget:self action:@selector(selectResponse:) forControlEvents:UIControlEventTouchUpInside];
    [_carpoolButton addTarget:self action:@selector(selectResponse:) forControlEvents:UIControlEventTouchUpInside];
    [_pickupButton addTarget:self action:@selector(selectResponse:) forControlEvents:UIControlEventTouchUpInside];
    [_buyCarButton addTarget:self action:@selector(selectResponse:) forControlEvents:UIControlEventTouchUpInside];
    [_repairButton addTarget:self action:@selector(selectResponse:) forControlEvents:UIControlEventTouchUpInside];
    [_deliverButton addTarget:self action:@selector(selectResponse:) forControlEvents:UIControlEventTouchUpInside];
    [_otherButton addTarget:self action:@selector(selectResponse:) forControlEvents:UIControlEventTouchUpInside];
    
    
    float heightCount = 430;
    float originX = 20;
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, heightCount, self.view.frame.size.width, SYSeparatorHeight)];
    separator.backgroundColor = SYSeparatorColor;
    [self.view addSubview:separator];
    UILabel *matchLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, heightCount, self.view.frame.size.width, 40)];
    matchLabel.text = @"匹配结果";
    matchLabel.textColor = SYColor5;
    [matchLabel setFont:SYFontW25];
    [self.view addSubview:matchLabel];
    heightCount += matchLabel.frame.size.height;
    
    helpTable = [[UITableView alloc] initWithFrame:CGRectMake(0, heightCount, self.view.frame.size.width, self.view.frame.size.height-heightCount) style:UITableViewStylePlain];
    helpTable.delegate = self;
    helpTable.dataSource = self;
    helpTable.alwaysBounceVertical = NO;
    [self.view addSubview:helpTable];
    [self requestHelpFromServer];
    [NSTimer scheduledTimerWithTimeInterval:2 repeats:NO block:^(NSTimer *timer){
        [helpTable reloadData];
        [NSTimer scheduledTimerWithTimeInterval:.1 repeats:NO block:^(NSTimer *timer){
            helpTable.hidden = NO;
        }];
    }];
}
-(IBAction)typeResponse:(id)sender{
    if ([sender isEqual:_catButton]) {
        [_carLabel setFont:SYFont20M];
        [_airplaneLabel setFont:SYFont13];
        _driveButton.hidden = NO;
        _carpoolButton.hidden = NO;
        _pickupButton.hidden = YES;
        _buyCarButton.hidden = NO;
        _deliverButton.hidden = YES;
        _partnerButton.hidden = YES;
    }
    else if ([sender isEqual:_airplaneButton]){
        [_carLabel setFont:SYFont13];
        [_airplaneLabel setFont:SYFont20M];
        _driveButton.hidden = YES;
        _carpoolButton.hidden = YES;
        _pickupButton.hidden = NO;
        _buyCarButton.hidden = YES;
        _deliverButton.hidden = NO;
        _partnerButton.hidden = NO;
    }
}
-(IBAction)selectResponse:(id)sender{
    UIButton *button = sender;
    DiscoverTravelHelpSecondViewController *viewController = [DiscoverTravelHelpSecondViewController new];
    viewController.controllerType = button.tag;
    [self.navigationController pushViewController:viewController animated:YES];
}








-(void)requestHelpFromServer{
    basicViewArray = [NSMutableArray new];
    MEID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
    NSString *requestQuery = [NSString stringWithFormat:@"email=%@&category=5",MEID];
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
    float height;
    if (indexPath.row<basicViewArray.count)
        height = [(SYHelp*)[basicViewArray objectAtIndex:indexPath.row] frame].size.height;
    else
        height = 200;
    return height;
    return height;
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
        SYHelp *helpView = [[SYHelp alloc] initWithFrame:CGRectMake(0, 0, helpTable.frame.size.width, 60) helpID:[helpIDArray objectAtIndex:indexPath.row] withHeadView:NO];
        [basicViewArray addObject:helpView];
        [cell setBasicView:helpView];
    }
    else{
        [cell setBasicView:[basicViewArray objectAtIndex:indexPath.row]];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
