//
//  DiscoverLocationViewController.h
//  Sharmunity
//
//  Created by st chen on 2017/2/9.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#define SYDiscoverNextShareEat 1001
#define SYDiscoverNextHelpEat 1101
#define SYDiscoverNextShareLease 2001
#define SYDiscoverNextHelp 2101
#define SYDiscoverNextShareMove 2002
#define SYDiscoverNextHelpMoveOut 2102
#define SYDiscoverNextHelpMoveIn 2103
#define SYDiscoverNextShareLearn 3001
#define SYDiscoverNextHelpLearn 3101
#define SYDiscoverNextCarpoolDepart 5301
#define SYDiscoverNextCarpoolArrive 5302

@interface DiscoverLocationViewController : UIViewController{
    NSInteger previousDistance;
}

@property NSInteger nextControllerType;
@property NSString *subCate;
@property NSMutableDictionary *summaryDict;
@property BOOL needDistance;

@property NSMutableArray *locationSelected;
@property MKMapItem *selectedItem;
@property BOOL activeRange;
@property float preferLatitude;
@property float preferLongitude;
@property float preferDistance;
@property id previousController;

/*distance*/
@property NSString *distanceString;
@property NSInteger distanceInteger;
@end
