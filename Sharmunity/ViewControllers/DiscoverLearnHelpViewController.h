//
//  DiscoverLearnHelpViewController.h
//  Sharmunity
//
//  Created by st chen on 2017/2/13.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscoverLearnHelpViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    UITableView *helpTable;
    NSString *MEID;
    NSArray *helpIDArray;
    NSMutableArray *basicViewArray;
}
@property (weak, nonatomic) IBOutlet UIButton *experienceButton;
@property (weak, nonatomic) IBOutlet UIButton *tutorButton;
@property (weak, nonatomic) IBOutlet UIButton *interestButton;
@property (weak, nonatomic) IBOutlet UIButton *questionButton;

@end
