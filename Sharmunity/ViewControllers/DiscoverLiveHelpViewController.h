//
//  DiscoverLiveHelpViewController.h
//  Sharmunity
//
//  Created by Star Chen on 2/5/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscoverLiveHelpViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    UITableView *helpTable;
    NSString *MEID;
    NSArray *helpIDArray;
    NSMutableArray *basicViewArray;
}
@property (weak, nonatomic) IBOutlet UIButton *rentButton;
@property (weak, nonatomic) IBOutlet UIButton *leaseButton;
@property (weak, nonatomic) IBOutlet UIButton *moveButton;
@property (weak, nonatomic) IBOutlet UIButton *shortButton;

@end
