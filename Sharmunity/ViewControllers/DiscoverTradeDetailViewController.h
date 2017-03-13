//
//  DiscoverTradeDetailViewController.h
//  Sharmunity
//
//  Created by Star Chen on 3/12/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface DiscoverTradeDetailViewController : UIViewController<UIScrollViewDelegate,CLLocationManagerDelegate>{
    UIScrollView *mainScrollView;
    UIScrollView *imagePageScroller;
    NSInteger imageNumbers;
    NSDictionary *shareDict;
    NSDictionary *personDict;
    UIImageView *avatarImageView;
}
@property NSString *shareID;
@property UIImage *firstImage;
@property (strong, nonatomic) CLLocationManager *locationManager;
@end
