//
//  DiscoverEatShareViewController.h
//  Sharmunity
//
//  Created by Star Chen on 2/11/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscoverEatShareViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    UITableView *shareTable;
    NSString *MEID;
    NSArray *shareIDArray;
    NSMutableArray *basicViewArray;
}
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIButton *articalButton;
@property (weak, nonatomic) IBOutlet UIButton *otherButton;

@property (weak, nonatomic) IBOutlet UIButton *describeButton;
@property (weak, nonatomic) IBOutlet UITextField *titleTextFeild;

@end
