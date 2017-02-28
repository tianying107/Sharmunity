//
//  DiscoverLiveShareViewController.m
//  Sharmunity
//
//  Created by st chen on 2017/2/9.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "DiscoverLiveShareViewController.h"
#import "DiscoverLiveShareLeaseViewController.h"
#import "DiscoverLiveShareSubmitViewController.h"
#import "SYHeader.h"
@interface DiscoverLiveShareViewController ()

@end

@implementation DiscoverLiveShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: SYColor1,
                                                                    NSFontAttributeName: SYFont20};
    
    MEID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
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
    _rentButton.layer.cornerRadius = 5;
    _rentButton.clipsToBounds = YES;
    _rentButton.layer.borderColor = [SYColor4 CGColor];
    _rentButton.layer.borderWidth = 1;
    
    _shortButton.layer.cornerRadius = 5;
    _shortButton.clipsToBounds = YES;
    _shortButton.layer.borderColor = [SYColor4 CGColor];
    _shortButton.layer.borderWidth = 1;
    
    _moveButton.layer.cornerRadius = 5;
    _moveButton.clipsToBounds = YES;
    _moveButton.layer.borderColor = [SYColor4 CGColor];
    _moveButton.layer.borderWidth = 1;
    
    _otherButton.layer.cornerRadius = 5;
    _otherButton.clipsToBounds = YES;
    _otherButton.layer.borderColor = [SYColor9 CGColor];
    _otherButton.layer.borderWidth = 1;
    
    [_rentButton addTarget:self action:@selector(leaseResponse) forControlEvents:UIControlEventTouchUpInside];
    [_shortButton addTarget:self action:@selector(shortResponse) forControlEvents:UIControlEventTouchUpInside];
    [_moveButton addTarget:self action:@selector(moveResponse) forControlEvents:UIControlEventTouchUpInside];
    
    float heightCount = 400;
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

-(void)leaseResponse{
    DiscoverLiveShareLeaseViewController *viewController = [DiscoverLiveShareLeaseViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)shortResponse{
    DiscoverLiveShareLeaseViewController *viewController = [DiscoverLiveShareLeaseViewController new];
    viewController.shortRent = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)moveResponse{
    NSString *subCate = @"03000000";
    DiscoverLiveShareSubmitViewController *viewController = [DiscoverLiveShareSubmitViewController new];
    viewController.subcate = subCate;
    [self.navigationController pushViewController:viewController animated:YES];
}










-(void)requestShareFromServer{
    basicViewArray = [NSMutableArray new];
    MEID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
    NSString *requestQuery = [NSString stringWithFormat:@"email=%@&category=2",MEID];
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
    
    return shareIDArray.count;
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
