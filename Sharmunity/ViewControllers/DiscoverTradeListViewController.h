//
//  DiscoverTradeListViewController.h
//  Sharmunity
//
//  Created by Star Chen on 3/12/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface DiscoverTradeListViewController : UIViewController<UIScrollViewDelegate,CLLocationManagerDelegate>{
    NSString *MEID;
    NSArray *shareIDArray;
    NSMutableArray *sharesArray;
    NSInteger currentButtonIndex;
    float heightCount;
    BOOL scrollReady;
}
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIButton *sellButton;
@property (strong, nonatomic) CLLocationManager *locationManager;
-(void)reloadButtonsWithArray:(NSArray*)array;
@end
