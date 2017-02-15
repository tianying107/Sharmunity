//
//  DiscoverMainViewController.m
//  Sharmunity
//
//  Created by st chen on 2017/1/20.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "DiscoverMainViewController.h"

@interface DiscoverMainViewController ()

@end

@implementation DiscoverMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: SYColor1,
                                                                    NSFontAttributeName: SYFont20};
    
    isHelp = YES;
    [self welcomeTitleRequest];
    [self viewsSetup];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewsSetup{
    float width = self.view.frame.size.width;
    _currentHelpButton.frame = CGRectMake(0, 8, 0.67*width, 30);
    _currentShareButton.frame = CGRectMake(0.67*width, 8, 0.33*width, 30);

    [_currentShareButton addTarget:self action:@selector(shareHelpSwitch:) forControlEvents:UIControlEventTouchUpInside];
    [_currentHelpButton addTarget:self action:@selector(shareHelpSwitch:) forControlEvents:UIControlEventTouchUpInside];
    
    [_eatButton addTarget:self action:@selector(eatButtonResponse) forControlEvents:UIControlEventTouchUpInside];
    [_liveButton addTarget:self action:@selector(liveButtonResponse) forControlEvents:UIControlEventTouchUpInside];
    [_learnButton addTarget:self action:@selector(learnButtonResponse) forControlEvents:UIControlEventTouchUpInside];
    [_playButton addTarget:self action:@selector(playButtonResponse) forControlEvents:UIControlEventTouchUpInside];
}

-(IBAction)shareHelpSwitch:(id)sender{
    isHelp = ([sender isEqual:_currentHelpButton])?YES:NO;
    float width = self.view.frame.size.width;
    if ([sender isEqual:_currentHelpButton]) {
        _currentHelpButton.frame = CGRectMake(0, 8, 0.67*width, 30);
        _currentShareButton.frame = CGRectMake(0.67*width, 8, 0.33*width, 30);
        _eatButton.selected = NO;
        _liveButton.selected = NO;
        _learnButton.selected = NO;
        _playButton.selected = NO;
        _buttonBackgroundImageView.image = [UIImage imageNamed:@"helpShareButtonBackground"];
    }
    else{
        _currentHelpButton.frame = CGRectMake(0, 8, 0.33*width, 30);
        _currentShareButton.frame = CGRectMake(0.33*width, 8, 0.67*width, 30);
        _eatButton.selected = YES;
        _liveButton.selected = YES;
        _learnButton.selected = YES;
        _playButton.selected = YES;
        _buttonBackgroundImageView.image = [UIImage imageNamed:@"shareHelpButtonBackground"];
    }
}

- (void)eatButtonResponse{
    if (isHelp) {
        DiscoverEatHelpViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"eatHelpFirst"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else{
        DiscoverEatShareViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"eatShareFirst"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}
- (void)liveButtonResponse{
    if (isHelp) {
        DiscoverLiveHelpViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"liveHelpFirst"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else{
        DiscoverLiveShareViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"liveShareFirst"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}
- (void)learnButtonResponse{
    if (isHelp) {
        DiscoverLiveHelpViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"learnHelpFirst"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else{
        DiscoverLiveShareViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"learnShareFirst"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}
- (void)playButtonResponse{
    if (isHelp) {
        DiscoverPlayHelpViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"playHelpFirst"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else{
        DiscoverPlayShareViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"playShareFirst"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


- (void)welcomeTitleRequest{
    MEID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
    NSString *requestQuery = [NSString stringWithFormat:@"email=%@",MEID];
    NSString *urlString = [NSString stringWithFormat:@"%@reqprofile?%@",basicURL,requestQuery];
    NSLog(@"%@",requestQuery);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionTask *task = [session dataTaskWithURL:url
                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                        NSLog(@"server said: %@",string);
                                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                                             options:kNilOptions
                                                                                               error:&error];
                                        NSLog(@"server said: %@",dict);
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            self.navigationItem.title = [NSString stringWithFormat:@"您好！%@",[dict valueForKey:@"name"]];
                                        });
                                        
                                    }];
    [task resume];
}













//** the number of section and rows
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
//** cell detail
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"discoverCell";
    SYCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SYCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = [NSString stringWithFormat:@"问题 %ld",indexPath.row+1];
    //    cell.backgroundColor = goBackgroundColorExtraLight;
    //
    //    if ((indexPath.row+1)>basicViewArray.count) {
    //        goTCRBasic *basicView = [[goTCRBasic alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 100) basic:[idList objectAtIndex:indexPath.row]];
    //        [basicViewArray addObject:basicView];
    //        [cell setBasicView:basicView];
    //    }
    //    else{
    //        [cell setBasicView:[basicViewArray objectAtIndex:indexPath.row]];
    //    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    homePageViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"homePage"];
    
    //    NSString*teacherID = [(NSDictionary*)[idList objectAtIndex:indexPath.row] valueForKey:@"id"];
    //    //        TeacherPersonalViewController* selectedTeacherPersonalView = [self.storyboard instantiateViewControllerWithIdentifier:@"tcrDetail"];
    //    //    selectedTeacherPersonalView.selectedTeacherID = teacherID;
    //    //    [self.navigationController pushViewController:selectedTeacherPersonalView animated:YES];
    //    goPersonMajorViewController *viewController = [goPersonMajorViewController new];
    //    viewController.selectedTeacherID = teacherID;
    //    viewController.clearNavigationBar = NO;
    //    viewController.hidesBottomBarWhenPushed = YES;
    
//    [self.navigationController pushViewController:viewController animated:YES];
}

@end
