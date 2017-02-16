//
//  ChoiceDetailViewController.m
//  Sharmunity
//
//  Created by st chen on 2017/2/15.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "ChoiceDetailViewController.h"
#import "SYHeader.h"
@interface ChoiceDetailViewController (){
    SYProfileHead *headView;
}

@end

@implementation ChoiceDetailViewController
@synthesize userID;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"帮助卡";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: SYColor1,
                                                                    NSFontAttributeName: SYFont20S};
    
    
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mainScrollView.backgroundColor = SYBackgroundColorExtraLight;
    [self.view addSubview:mainScrollView];
    
    [self viewsSetup];
}
-(void) viewWillAppear:(BOOL)animated{
    mainScrollView.delegate=self;
    [self scrollViewDidScroll:mainScrollView];
}
-(void) viewDidAppear:(BOOL)animated{
    [mainScrollView setScrollEnabled:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewsSetup{
    userID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
    
    float heightCount = 0;
    headView = [[SYProfileHead alloc] initWithUserID:userID frame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    heightCount += headView.frame.size.height;
    [mainScrollView addSubview:headView];
    
}
@end
