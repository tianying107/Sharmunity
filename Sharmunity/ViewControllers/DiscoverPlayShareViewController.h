//
//  DiscoverPlayShareViewController.h
//  Sharmunity
//
//  Created by st chen on 2017/2/14.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscoverPlayShareViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    UITableView *shareTable;
    NSString *MEID;
    NSArray *shareIDArray;
    NSMutableArray *basicViewArray;
}

@property (weak, nonatomic) IBOutlet UIButton *partnerButton;
@property (weak, nonatomic) IBOutlet UIButton *activityButton;
@property (weak, nonatomic) IBOutlet UIButton *articalButton;
@property (weak, nonatomic) IBOutlet UIButton *otherButton;

@end
