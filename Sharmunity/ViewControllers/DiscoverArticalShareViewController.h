//
//  DiscoverEatArticalShareViewController.h
//  Sharmunity
//
//  Created by st chen on 2017/2/28.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#define discoverEat 1
#define discoverLive 2
#define discoverLearn 3
#define discoverPlay 4
#define discoverTravel 5
@interface DiscoverArticalShareViewController : UIViewController<UIScrollViewDelegate,UITextViewDelegate,CLLocationManagerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UIScrollView *mainScrollView;
    UIView *titleView;
    UIView *introductionView;
    UIButton *nextButton;
    UIView *imageSelectView;
    
    NSString *MEID;
    NSString *subCate;
    NSMutableArray *viewsArray;
    NSMutableArray *imageArray;
    
    NSInteger selectedIndex;
    BOOL completeImages;
}
@property NSInteger shareType;
@property (strong, nonatomic) CLLocationManager *locationManager;
@end
