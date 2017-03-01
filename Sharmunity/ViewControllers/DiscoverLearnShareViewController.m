//
//  DiscoverLearnShareViewController.m
//  Sharmunity
//
//  Created by st chen on 2017/2/13.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "DiscoverLearnShareViewController.h"
#import "DiscoverLearnShareSubmitViewController.h"
#import "DiscoverOtherShareViewController.h"
#import "Header.h"
#import "SYHeader.h"
@interface DiscoverLearnShareViewController ()

@end

@implementation DiscoverLearnShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"学";
    
    
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
    _experienceButton.layer.cornerRadius = 5;
    _experienceButton.clipsToBounds = YES;
    _experienceButton.layer.borderColor = [SYColor4 CGColor];
    _experienceButton.layer.borderWidth = 1;
    
    _tutorButton.layer.cornerRadius = 5;
    _tutorButton.clipsToBounds = YES;
    _tutorButton.layer.borderColor = [SYColor4 CGColor];
    _tutorButton.layer.borderWidth = 1;
    
    _interestButton.layer.cornerRadius = 5;
    _interestButton.clipsToBounds = YES;
    _interestButton.layer.borderColor = [SYColor4 CGColor];
    _interestButton.layer.borderWidth = 1;
    
    _otherButton.layer.cornerRadius = 5;
    _otherButton.clipsToBounds = YES;
    _otherButton.layer.borderColor = [SYColor9 CGColor];
    _otherButton.layer.borderWidth = 1;
    
    [_experienceButton addTarget:self action:@selector(experienceResponse) forControlEvents:UIControlEventTouchUpInside];
    [_tutorButton addTarget:self action:@selector(tutorResponse) forControlEvents:UIControlEventTouchUpInside];
    [_interestButton addTarget:self action:@selector(interestResponse) forControlEvents:UIControlEventTouchUpInside];
    [_otherButton addTarget:self action:@selector(otherResponse) forControlEvents:UIControlEventTouchUpInside];
    
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
-(void)experienceResponse{
    DiscoverLearnShareSubmitViewController *viewController = [DiscoverLearnShareSubmitViewController new];
    viewController.controllerType = discoverLearnExper;
    [self.navigationController pushViewController:viewController animated:YES];
}
-(void)tutorResponse{
    DiscoverLearnShareSubmitViewController *viewController = [DiscoverLearnShareSubmitViewController new];
    viewController.controllerType = discoverLearnTutor;
    [self.navigationController pushViewController:viewController animated:YES];
}
-(void)interestResponse{
    DiscoverLearnShareSubmitViewController *viewController = [DiscoverLearnShareSubmitViewController new];
    viewController.controllerType = discoverLearnInterest;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)otherResponse{
    DiscoverOtherShareViewController *viewController = [DiscoverOtherShareViewController new];
    viewController.shareType = discoverLearn;
    [self.navigationController pushViewController:viewController animated:YES];
}








-(void)requestShareFromServer{
    basicViewArray = [NSMutableArray new];
    MEID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
    NSString *requestQuery = [NSString stringWithFormat:@"email=%@&category=3",MEID];
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
