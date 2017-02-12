//
//  DiscoverMainViewController.h
//  Sharmunity
//
//  Created by st chen on 2017/1/20.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYHeader.h"
#import "Header.h"
#import "DiscoverLiveHelpViewController.h"
#import "DiscoverLiveShareViewController.h"
#import "DiscoverEatShareViewController.h"
#import "DiscoverEatHelpViewController.h"
@interface DiscoverMainViewController : UIViewController{
    BOOL isHelp;
}
@property (weak, nonatomic) IBOutlet UIButton *currentShareButton;
@property (weak, nonatomic) IBOutlet UIButton *currentHelpButton;

@property (weak, nonatomic) IBOutlet UIButton *eatButton;
@property (weak, nonatomic) IBOutlet UIButton *liveButton;
@property (weak, nonatomic) IBOutlet UITableView *discoverTable;
@end
