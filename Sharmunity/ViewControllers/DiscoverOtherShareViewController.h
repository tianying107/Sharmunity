//
//  DiscoverOtherShareViewController.h
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
@interface DiscoverOtherShareViewController : UIViewController<UIScrollViewDelegate>{
    UIScrollView *mainScrollView;
    UIView *titleView;
    UIView *introductionView;
    UIView *locationView;
    UIButton *nextButton;
    
    NSString *MEID;
    NSMutableArray *viewsArray;

}
@property NSInteger shareType;
@property MKMapItem *selectedItem;
@end
