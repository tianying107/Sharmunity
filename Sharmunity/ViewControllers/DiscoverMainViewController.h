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
#import "DiscoverPlayShareViewController.h"
#import "DiscoverPlayHelpViewController.h"
#import "DiscoverTravelShareViewController.h"
#import "DiscoverTravelHelpViewController.h"

@interface DiscoverMainViewController : UIViewController{
    BOOL isHelp;
    NSString *MEID;
}
@property (weak, nonatomic) IBOutlet UIButton *currentShareButton;
@property (weak, nonatomic) IBOutlet UIButton *currentHelpButton;

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *travelButton;
@property (weak, nonatomic) IBOutlet UIButton *tradeButton;

@property (weak, nonatomic) IBOutlet UIButton *eatButton;
@property (weak, nonatomic) IBOutlet UIButton *liveButton;
@property (weak, nonatomic) IBOutlet UIButton *learnButton;
@property (weak, nonatomic) IBOutlet UITableView *discoverTable;
@property (weak, nonatomic) IBOutlet UIImageView *buttonBackgroundImageView;
@end
