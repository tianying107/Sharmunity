//
//  DiscoverLiveShareViewController.h
//  Sharmunity
//
//  Created by st chen on 2017/2/9.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscoverLiveShareViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    UITableView *shareTable;
    NSString *MEID;
    NSArray *shareIDArray;
    NSMutableArray *basicViewArray;
}
@property (weak, nonatomic) IBOutlet UIButton *rentButton;
@property (weak, nonatomic) IBOutlet UIButton *moveButton;
@property (weak, nonatomic) IBOutlet UIButton *shortButton;
@property (weak, nonatomic) IBOutlet UIButton *otherButton;

@end
