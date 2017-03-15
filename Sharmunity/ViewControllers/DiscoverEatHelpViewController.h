//
//  DiscoverEatHelpViewController.h
//  Sharmunity
//
//  Created by Star Chen on 1/29/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Header.h"

@interface DiscoverEatHelpViewController : UIViewController<CLLocationManagerDelegate,UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate>{
    UITableView *helpTable;
    NSString *MEID;
    NSArray *helpIDArray;
    NSMutableArray *basicViewArray;
}
@property (weak, nonatomic) IBOutlet UIButton *testButton;
@property (weak, nonatomic) IBOutlet UIButton *helpTestButton;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (weak, nonatomic) IBOutlet UIButton *articalButton;
@property (weak, nonatomic) IBOutlet UIButton *questionButton;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@end
