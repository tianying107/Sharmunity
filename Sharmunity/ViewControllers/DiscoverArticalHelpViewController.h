//
//  DiscoverArticalHelpViewController.h
//  Sharmunity
//
//  Created by Star Chen on 3/10/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#define discoverEat 1
#define discoverLive 2
#define discoverLearn 3
#define discoverPlay 4
#define discoverTravel 5
@interface DiscoverArticalHelpViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate,UITextFieldDelegate>{
    UITableView *helpTable;
    NSString *MEID;
    NSArray *helpIDArray;
    NSMutableArray *basicViewArray;
    
    UIView *titleView;
}
@property NSInteger helpType;
@property (strong, nonatomic) CLLocationManager *locationManager;
@end
