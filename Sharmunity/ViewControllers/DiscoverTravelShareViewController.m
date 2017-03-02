//
//  DiscoverTravelShareViewController.m
//  Sharmunity
//
//  Created by Star Chen on 2/15/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import "DiscoverTravelShareViewController.h"
#import "DiscoverTravelShareSecondViewController.h"
#import "DiscoverOtherShareViewController.h"
#import "Header.h"
#import "SYHeader.h"
@interface DiscoverTravelShareViewController ()

@end

@implementation DiscoverTravelShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"行";
    [self viewsSetup];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"SYBackColor4"] forState:UIControlStateNormal];
    [backBtn setTitle:@"我要帮助" forState:UIControlStateNormal];
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
    
    
    _driveButton.layer.cornerRadius = 5;
    _driveButton.clipsToBounds = YES;
    _driveButton.layer.borderColor = [SYColor4 CGColor];
    _driveButton.layer.borderWidth = 1;
    
    _carpoolButton.layer.cornerRadius = 5;
    _carpoolButton.clipsToBounds = YES;
    _carpoolButton.layer.borderColor = [SYColor4 CGColor];
    _carpoolButton.layer.borderWidth = 1;
    
    _pickupButton.layer.cornerRadius = 5;
    _pickupButton.clipsToBounds = YES;
    _pickupButton.layer.borderColor = [SYColor4 CGColor];
    _pickupButton.layer.borderWidth = 1;
    
    _buyCarButton.layer.cornerRadius = 5;
    _buyCarButton.clipsToBounds = YES;
    _buyCarButton.layer.borderColor = [SYColor4 CGColor];
    _buyCarButton.layer.borderWidth = 1;
    
    _deliverButton.layer.cornerRadius = 5;
    _deliverButton.clipsToBounds = YES;
    _deliverButton.layer.borderColor = [SYColor4 CGColor];
    _deliverButton.layer.borderWidth = 1;
    
    _otherButton.layer.cornerRadius = 5;
    _otherButton.clipsToBounds = YES;
    _otherButton.layer.borderColor = [SYColor9 CGColor];
    _otherButton.layer.borderWidth = 1;
    
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
    [_otherButton addTarget:self action:@selector(otherResponse) forControlEvents:UIControlEventTouchUpInside];
    
    
    float heightCount = 430;
    float originX = 30;
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, heightCount, self.view.frame.size.width, SYSeparatorHeight)];
    separator.backgroundColor = SYSeparatorColor;
    [self.view addSubview:separator];
    UILabel *matchLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, heightCount, self.view.frame.size.width, 40)];
    matchLabel.text = @"匹配结果";
    matchLabel.textColor = SYColor4;
    [matchLabel setFont:SYFontW25];
    [self.view addSubview:matchLabel];
    heightCount += matchLabel.frame.size.height;
    
    shareTable = [[UITableView alloc] initWithFrame:CGRectMake(0, heightCount, self.view.frame.size.width, self.view.frame.size.height-heightCount) style:UITableViewStylePlain];
    shareTable.delegate = self;
    shareTable.dataSource = self;
    shareTable.hidden = YES;
    shareTable.alwaysBounceVertical = NO;
    [self.view addSubview:shareTable];
    [self requestShareFromServer];
    [NSTimer scheduledTimerWithTimeInterval:2 repeats:NO block:^(NSTimer *timer){
        [shareTable reloadData];
        [NSTimer scheduledTimerWithTimeInterval:.1 repeats:NO block:^(NSTimer *timer){
            shareTable.hidden = NO;
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
    }
    else if ([sender isEqual:_airplaneButton]){
        [_carLabel setFont:SYFont13];
        [_airplaneLabel setFont:SYFont20M];
        _driveButton.hidden = YES;
        _carpoolButton.hidden = YES;
        _pickupButton.hidden = NO;
        _buyCarButton.hidden = YES;
        _deliverButton.hidden = NO;
    }
}
-(IBAction)selectResponse:(id)sender{
    UIButton *button = sender;
    DiscoverTravelShareSecondViewController *viewController = [DiscoverTravelShareSecondViewController new];
    viewController.controllerType = button.tag;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)otherResponse{
    DiscoverOtherShareViewController *viewController = [DiscoverOtherShareViewController new];
    viewController.shareType = discoverTravel;
    [self.navigationController pushViewController:viewController animated:YES];
}







-(void)requestShareFromServer{
    basicViewArray = [NSMutableArray new];
    MEID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
    NSString *requestQuery = [NSString stringWithFormat:@"email=%@&category=5",MEID];
    NSString *urlString = [NSString stringWithFormat:@"%@allshares?%@",basicURL,requestQuery];
    NSLog(@"%@",requestQuery);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionTask *task = [session dataTaskWithURL:url
                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                        NSLog(@"server string: %@",string);
                                        NSArray *array = [NSJSONSerialization JSONObjectWithData:data
                                                                                         options:kNilOptions
                                                                                           error:&error];
                                        NSLog(@"server said: %@",array);
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            shareIDArray = array;
                                            [shareTable reloadData];
                                            
                                        });
                                        
                                    }];
    [task resume];
}
/* tableView data source and delegate*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return MIN(5, shareIDArray.count);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float height;
    if (indexPath.row<basicViewArray.count)
        height = [(SYRelatedShare*)[basicViewArray objectAtIndex:indexPath.row] frame].size.height;
    else
        height = 60;
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
        SYRelatedShare *shareView = [[SYRelatedShare alloc] initRelatedWithFrame:CGRectMake(0, 0, shareTable.frame.size.width, 60) shareID:[shareIDArray objectAtIndex:indexPath.row]];
        [basicViewArray addObject:shareView];
        [cell setBasicView:shareView];
    }
    else{
        [cell setBasicView:[basicViewArray objectAtIndex:indexPath.row]];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
@end
