//
//  DiscoverPlayHelpViewController.m
//  Sharmunity
//
//  Created by st chen on 2017/2/14.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "DiscoverPlayHelpViewController.h"
#import "DiscoverPlayHelpActiveViewController.h"
#import "Header.h"
#import "SYHeader.h"
@interface DiscoverPlayHelpViewController ()

@end

@implementation DiscoverPlayHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    helpIDArray = [NSArray new];
    [self viewsSetup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewsSetup{
    [_partnerButton addTarget:self action:@selector(partnerResponse) forControlEvents:UIControlEventTouchUpInside];
    [_activityButton addTarget:self action:@selector(activityResponse) forControlEvents:UIControlEventTouchUpInside];
    [_articalButton addTarget:self action:@selector(articalResponse) forControlEvents:UIControlEventTouchUpInside];
    [_otherButton addTarget:self action:@selector(otherResponse) forControlEvents:UIControlEventTouchUpInside];
    
    helpTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 160, self.view.frame.size.width, self.view.frame.size.height-160) style:UITableViewStylePlain];
    helpTable.delegate = self;
    helpTable.dataSource = self;
    helpTable.alwaysBounceVertical = NO;
    [self.view addSubview:helpTable];
    [self requestHelpFromServer];
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer *timer){
        [helpTable reloadData];
        [NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer *timer){
            helpTable.hidden = NO;
        }];
    }];
}

-(void)partnerResponse{
    DiscoverPlayHelpActiveViewController *viewController = [DiscoverPlayHelpActiveViewController new];
    viewController.controllerType = DiscoverPlayPartner;
    [self.navigationController pushViewController:viewController animated:YES];
}
-(void)activityResponse{
    DiscoverPlayHelpActiveViewController *viewController = [DiscoverPlayHelpActiveViewController new];
    viewController.controllerType = DiscoverPlayActivity;
    [self.navigationController pushViewController:viewController animated:YES];
    
}
-(void)articalResponse{
    
}
-(void)otherResponse{
    DiscoverPlayHelpActiveViewController *viewController = [DiscoverPlayHelpActiveViewController new];
    viewController.controllerType = DiscoverPlayOther;
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
