//
//  DiscoverTravelShareViewController.h
//  Sharmunity
//
//  Created by Star Chen on 2/15/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscoverTravelShareViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    UITableView *shareTable;
    NSString *MEID;
    NSArray *shareIDArray;
    NSMutableArray *basicViewArray;
}
@property (weak, nonatomic) IBOutlet UIButton *partnerButton;
@property (weak, nonatomic) IBOutlet UIButton *driveButton;
@property (weak, nonatomic) IBOutlet UIButton *carpoolButton;
@property (weak, nonatomic) IBOutlet UIButton *pickupButton;
@property (weak, nonatomic) IBOutlet UIButton *buyCarButton;
@property (weak, nonatomic) IBOutlet UIButton *repairButton;
@property (weak, nonatomic) IBOutlet UIButton *deliverButton;
@property (weak, nonatomic) IBOutlet UIButton *otherButton;

@property (weak, nonatomic) IBOutlet UIButton *airplaneButton;
@property (weak, nonatomic) IBOutlet UIButton *catButton;
@property (weak, nonatomic) IBOutlet UILabel *airplaneLabel;
@property (weak, nonatomic) IBOutlet UILabel *carLabel;

@end
