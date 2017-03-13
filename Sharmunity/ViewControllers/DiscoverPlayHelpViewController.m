//
//  DiscoverPlayHelpViewController.m
//  Sharmunity
//
//  Created by st chen on 2017/2/14.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "DiscoverPlayHelpViewController.h"
#import "DiscoverPlayHelpActiveViewController.h"
#import "DiscoverArticalHelpViewController.h"
#import "DiscoverPlayPartnerHelpViewController.h"
#import "Header.h"
#import "SYHeader.h"
@interface DiscoverPlayHelpViewController ()

@end

@implementation DiscoverPlayHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MEID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
    
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
    _partnerButton.layer.cornerRadius = 5;
    _partnerButton.clipsToBounds = YES;
    _partnerButton.layer.borderColor = [SYColor6 CGColor];
    _partnerButton.layer.borderWidth = 1;
    
    _activityButton.layer.cornerRadius = 5;
    _activityButton.clipsToBounds = YES;
    _activityButton.layer.borderColor = [SYColor6 CGColor];
    _activityButton.layer.borderWidth = 1;
    
    _articalButton.layer.cornerRadius = 5;
    _articalButton.clipsToBounds = YES;
    _articalButton.layer.borderColor = [SYColor6 CGColor];
    _articalButton.layer.borderWidth = 1;
    
    _questionButton.layer.cornerRadius = 5;
    _questionButton.clipsToBounds = YES;
    _questionButton.layer.borderColor = [UIColorFromRGB(0x70C1B3) CGColor];
    _questionButton.layer.borderWidth = 1;
    
    [_partnerButton addTarget:self action:@selector(partnerResponse) forControlEvents:UIControlEventTouchUpInside];
    [_activityButton addTarget:self action:@selector(activityResponse) forControlEvents:UIControlEventTouchUpInside];
    [_articalButton addTarget:self action:@selector(articalResponse) forControlEvents:UIControlEventTouchUpInside];
    
    
    float heightCount = 400;
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

-(void)partnerResponse{
    DiscoverPlayPartnerHelpViewController *viewController = [DiscoverPlayPartnerHelpViewController new];
//    viewController.controllerType = DiscoverPlayPartner;
    [self.navigationController pushViewController:viewController animated:YES];
}
-(void)activityResponse{
    DiscoverPlayHelpActiveViewController *viewController = [DiscoverPlayHelpActiveViewController new];

    [self.navigationController pushViewController:viewController animated:YES];
    
}
-(void)articalResponse{
    DiscoverArticalHelpViewController *viewController = [DiscoverArticalHelpViewController new];
    viewController.helpType = discoverPlay;
    [self.navigationController pushViewController:viewController animated:YES];
}







-(void)requestHelpFromServer{
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
