//
//  DiscoverPlayShareViewController.m
//  Sharmunity
//
//  Created by st chen on 2017/2/14.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "DiscoverPlayShareViewController.h"
#import "DiscoverPlayShareActiveViewController.h"
#import "DiscoverOtherShareViewController.h"
#import "DiscoverArticalShareViewController.h"
#import "Header.h"
#import "SYHeader.h"
@interface DiscoverPlayShareViewController ()

@end

@implementation DiscoverPlayShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"玩";
    
    
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
}
-(void)viewsSetup{
    _activityButton.layer.cornerRadius = 5;
    _activityButton.clipsToBounds = YES;
    _activityButton.layer.borderColor = [SYColor4 CGColor];
    _activityButton.layer.borderWidth = 1;
    
    _articalButton.layer.cornerRadius = 5;
    _articalButton.clipsToBounds = YES;
    _articalButton.layer.borderColor = [SYColor4 CGColor];
    _articalButton.layer.borderWidth = 1;
    
    _otherButton.layer.cornerRadius = 5;
    _otherButton.clipsToBounds = YES;
    _otherButton.layer.borderColor = [SYColor9 CGColor];
    _otherButton.layer.borderWidth = 1;
    
    
//    [_partnerButton addTarget:self action:@selector(partnerResponse) forControlEvents:UIControlEventTouchUpInside];
//    [_activityButton addTarget:self action:@selector(activityResponse) forControlEvents:UIControlEventTouchUpInside];
    [_articalButton addTarget:self action:@selector(articalResponse) forControlEvents:UIControlEventTouchUpInside];
    [_otherButton addTarget:self action:@selector(otherResponse) forControlEvents:UIControlEventTouchUpInside];
    
    float heightCount = 320;
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

//-(void)partnerResponse{
//    DiscoverPlayShareActiveViewController *viewController = [DiscoverPlayShareActiveViewController new];
//    viewController.controllerType = DiscoverPlayPartner;
//    [self.navigationController pushViewController:viewController animated:YES];
//}
//-(void)activityResponse{
//    DiscoverPlayShareActiveViewController *viewController = [DiscoverPlayShareActiveViewController new];
//    viewController.controllerType = DiscoverPlayActivity;
//    [self.navigationController pushViewController:viewController animated:YES];
//
//}
-(void)articalResponse{
    DiscoverArticalShareViewController *viewController = [DiscoverArticalShareViewController new];
    viewController.shareType = discoverPlay;
    [self.navigationController pushViewController:viewController animated:YES];
}
-(void)otherResponse{
    DiscoverOtherShareViewController *viewController = [DiscoverOtherShareViewController new];
    viewController.shareType = discoverPlay;
    [self.navigationController pushViewController:viewController animated:YES];
}
//-(void)otherResponse{
//    DiscoverPlayShareActiveViewController *viewController = [DiscoverPlayShareActiveViewController new];
//    viewController.controllerType = DiscoverPlayOther;
//    [self.navigationController pushViewController:viewController animated:YES];
//}







-(void)requestShareFromServer{
    basicViewArray = [NSMutableArray new];
    MEID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
    NSString *requestQuery = [NSString stringWithFormat:@"email=%@&category=4",MEID];
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
