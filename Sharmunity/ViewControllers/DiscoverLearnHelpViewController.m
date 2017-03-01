//
//  DiscoverLearnHelpViewController.m
//  Sharmunity
//
//  Created by st chen on 2017/2/13.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "DiscoverLearnHelpViewController.h"
#import "DiscoverLearnHelpSubmitViewController.h"
#import "DiscoverLearnHelpExpViewController.h"
#import "Header.h"
#import "SYHeader.h"
@interface DiscoverLearnHelpViewController ()

@end

@implementation DiscoverLearnHelpViewController

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
    _experienceButton.layer.cornerRadius = 5;
    _experienceButton.clipsToBounds = YES;
    _experienceButton.layer.borderColor = [SYColor6 CGColor];
    _experienceButton.layer.borderWidth = 1;
    
    _tutorButton.layer.cornerRadius = 5;
    _tutorButton.clipsToBounds = YES;
    _tutorButton.layer.borderColor = [SYColor6 CGColor];
    _tutorButton.layer.borderWidth = 1;
    
    _interestButton.layer.cornerRadius = 5;
    _interestButton.clipsToBounds = YES;
    _interestButton.layer.borderColor = [SYColor6 CGColor];
    _interestButton.layer.borderWidth = 1;
    
    
    _questionButton.layer.cornerRadius = 5;
    _questionButton.clipsToBounds = YES;
    _questionButton.layer.borderColor = [UIColorFromRGB(0x70C1B3) CGColor];
    _questionButton.layer.borderWidth = 1;
    
//    [_experienceButton addTarget:self action:@selector(experienceResponse) forControlEvents:UIControlEventTouchUpInside];
    [_tutorButton addTarget:self action:@selector(tutorResponse) forControlEvents:UIControlEventTouchUpInside];
    [_interestButton addTarget:self action:@selector(interestResponse) forControlEvents:UIControlEventTouchUpInside];
    
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
//-(void)experienceResponse{
//    DiscoverLearnHelpSubmitViewController *viewController = [DiscoverLearnHelpSubmitViewController new];
//    viewController.controllerType = discoverLearnExper;
//    [self.navigationController pushViewController:viewController animated:YES];
//}
-(void)tutorResponse{
    DiscoverLearnHelpSubmitViewController *viewController = [DiscoverLearnHelpSubmitViewController new];
    viewController.controllerType = discoverLearnTutor;
    [self.navigationController pushViewController:viewController animated:YES];
}
-(void)interestResponse{
    DiscoverLearnHelpSubmitViewController *viewController = [DiscoverLearnHelpSubmitViewController new];
    viewController.controllerType = discoverLearnInterest;
    [self.navigationController pushViewController:viewController animated:YES];
}







-(void)requestHelpFromServer{
    basicViewArray = [NSMutableArray new];
    MEID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
    NSString *requestQuery = [NSString stringWithFormat:@"email=%@&category=3",MEID];
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
