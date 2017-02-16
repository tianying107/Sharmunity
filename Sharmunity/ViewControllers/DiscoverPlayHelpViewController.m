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
    
    helpTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-300, self.view.frame.size.width, 300) style:UITableViewStylePlain];
    helpTable.delegate = self;
    helpTable.dataSource = self;
    helpTable.scrollEnabled = NO;
    helpTable.alwaysBounceVertical = NO;
    [self.view addSubview:helpTable];
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
    MEID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
    NSString *requestQuery = [NSString stringWithFormat:@"email=%@&category=4",MEID];
    NSString *urlString = [NSString stringWithFormat:@"%@reqhelp?%@",basicURL,requestQuery];
    NSLog(@"%@",requestQuery);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionTask *task = [session dataTaskWithURL:url
                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                                             options:kNilOptions
                                                                                               error:&error];
                                        NSLog(@"server said: %@",dict);
                                        dispatch_async(dispatch_get_main_queue(), ^{
//                                            helpIDArray = 
//                                            self.navigationItem.title = [NSString stringWithFormat:@"您好！%@",[dict valueForKey:@"name"]];
                                        });
                                        
                                    }];
    [task resume];
}
/* tableView data source and delegate*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger integer;
    
    
    return integer;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
//    if ([tableView isEqual:inviteTable]) {
//        static NSString *cellIdentifier = @"CellInv";
//        cell = (goPendingStatusCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//        if (cell == nil) {
//            if (_controllerType == goControllerSTD){
//                cell = [[goPendingStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier basic:[inviteArray objectAtIndex:indexPath.row] type:_controllerType];
//            }
//            //👆是学生发出的邀请，👇是老师发出的申请
//            else{ cell = [[goPendingStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier basic:[postArray objectAtIndex:indexPath.row] type:_controllerType];
//                
//                NSLog(@"application cell 1");
//            }
//        }
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }
//    else if ([tableView isEqual:postTable]){
//        static NSString *cellIdentifier = @"CellPost";
//        if (_controllerType == goControllerSTD) {
//            cell = (goPendingPostCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//            if (cell == nil) {
//                cell = [[goPendingPostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier basic:[postArray objectAtIndex:indexPath.row]];
//            }
//            cell.accessoryType = UITableViewCellAccessoryNone;
//        }
//        else{
//            cell = (goPendingStatusCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//            if (cell == nil) {
//                cell = [[goPendingStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier basic:[inviteArray objectAtIndex:indexPath.row] type:_controllerType];
//                NSLog(@"invitation cell 1");
//                ((goPendingStatusCell*)cell).hideStatus = YES;
//            }
//            
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        }
//    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.backgroundColor = goBackgroundColorExtraLight;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
