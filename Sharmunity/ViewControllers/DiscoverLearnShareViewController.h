//
//  DiscoverLearnShareViewController.h
//  Sharmunity
//
//  Created by st chen on 2017/2/13.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscoverLearnShareViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    UITableView *shareTable;
    NSString *MEID;
    NSArray *shareIDArray;
    NSMutableArray *basicViewArray;
}
@property (weak, nonatomic) IBOutlet UIButton *experienceButton;
@property (weak, nonatomic) IBOutlet UIButton *tutorButton;
@property (weak, nonatomic) IBOutlet UIButton *interestButton;
@property (weak, nonatomic) IBOutlet UIButton *otherButton;

@end
