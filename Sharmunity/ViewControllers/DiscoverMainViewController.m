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
    isHelp = YES;
    
    [self viewsSetup];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewsSetup{
    [_currentShareButton addTarget:self action:@selector(shareHelpSwitch:) forControlEvents:UIControlEventTouchUpInside];
    [_currentHelpButton addTarget:self action:@selector(shareHelpSwitch:) forControlEvents:UIControlEventTouchUpInside];
    [_liveButton addTarget:self action:@selector(liveButtonResponse) forControlEvents:UIControlEventTouchUpInside];
}

-(IBAction)shareHelpSwitch:(id)sender{
    isHelp = ([sender isEqual:_currentHelpButton])?YES:NO;
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
