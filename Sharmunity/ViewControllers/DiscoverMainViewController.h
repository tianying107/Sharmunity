//
//  DiscoverMainViewController.h
//  Sharmunity
//
//  Created by st chen on 2017/1/20.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
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

@interface DiscoverMainViewController : UIViewController<CLLocationManagerDelegate>{
    BOOL isHelp;
    NSString *MEID;
    
    NSArray *recentHelpArray;
    NSArray *recentShareArray;
    
    UIButton *cityButton;

}
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIImageView *slogenImageView;
@property (weak, nonatomic) IBOutlet UIView *recentHelpView;
@property (weak, nonatomic) IBOutlet UIView *recentShareView;

@property (weak, nonatomic) IBOutlet UIButton *currentShareButton;
@property (weak, nonatomic) IBOutlet UIButton *currentHelpButton;

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *travelButton;
@property (weak, nonatomic) IBOutlet UIButton *tradeButton;

@property (weak, nonatomic) IBOutlet UIButton *eatButton;
@property (weak, nonatomic) IBOutlet UIButton *liveButton;
@property (weak, nonatomic) IBOutlet UIButton *learnButton;
@property (weak, nonatomic) IBOutlet UIImageView *buttonBackgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *liveLabel;
@property (weak, nonatomic) IBOutlet UILabel *eatLabel;
@property (weak, nonatomic) IBOutlet UILabel *travelLabel;
@property (weak, nonatomic) IBOutlet UILabel *playLabel;
@property (weak, nonatomic) IBOutlet UILabel *learnLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeLabel;
@end
