//
//  DiscoverLiveHelpViewController.m
//  Sharmunity
//
//  Created by Star Chen on 2/5/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import "DiscoverLiveHelpViewController.h"
#import "DiscoverLiveHelpRentViewController.h"
#import "DiscoverLiveShareLeaseViewController.h"
#import "DiscoverLocationViewController.h"
#import "Header.h"
#import "SYHeader.h"
@interface DiscoverLiveHelpViewController ()

@end

@implementation DiscoverLiveHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MEID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
    [self viewsSetup];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewsSetup{
    [_rentButton addTarget:self action:@selector(rentHomeResponse) forControlEvents:UIControlEventTouchUpInside];
    [_leaseButton addTarget:self action:@selector(leaseResponse) forControlEvents:UIControlEventTouchUpInside];
    [_moveButton addTarget:self action:@selector(moveResponse) forControlEvents:UIControlEventTouchUpInside];
    
    helpTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 250, self.view.frame.size.width, self.view.frame.size.height-250) style:UITableViewStylePlain];
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

-(void)rentHomeResponse{
    DiscoverLiveHelpRentViewController *viewController = [DiscoverLiveHelpRentViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)leaseResponse{
    DiscoverLiveShareLeaseViewController *viewController = [DiscoverLiveShareLeaseViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)moveResponse{
    NSString *subCate = @"02000000";
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:subCate, @"subcate", nil];
    NSMutableDictionary *shareDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:MEID,@"email",@"2",@"category",@"2099-01-01",@"expire_date", nil];;
    [shareDict addEntriesFromDictionary:dict];
    DiscoverLocationViewController *viewController = [DiscoverLocationViewController new];
    viewController.subCate = subCate;
    viewController.summaryDict = shareDict;
    viewController.needDistance = NO;
    viewController.nextControllerType = SYDiscoverNextHelpMove;
    [self.navigationController pushViewController:viewController animated:YES];
}



-(void)requestHelpFromServer{
    basicViewArray = [NSMutableArray new];
    MEID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
    NSString *requestQuery = [NSString stringWithFormat:@"email=%@&category=2",MEID];
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
