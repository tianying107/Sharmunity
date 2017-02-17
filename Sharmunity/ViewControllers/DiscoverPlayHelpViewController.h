//
//  DiscoverPlayHelpViewController.h
//  Sharmunity
//
//  Created by st chen on 2017/2/14.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscoverPlayHelpViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    UITableView *helpTable;
    NSString *MEID;
    NSArray *helpIDArray;
    NSMutableArray *basicViewArray;
}
@property (weak, nonatomic) IBOutlet UIButton *partnerButton;
@property (weak, nonatomic) IBOutlet UIButton *activityButton;
@property (weak, nonatomic) IBOutlet UIButton *articalButton;
@property (weak, nonatomic) IBOutlet UIButton *otherButton;

@end
