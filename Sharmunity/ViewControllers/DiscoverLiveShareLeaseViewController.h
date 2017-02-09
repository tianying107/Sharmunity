//
//  DiscoverLiveShareLeaseViewController.h
//  Sharmunity
//
//  Created by st chen on 2017/2/9.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscoverLiveShareLeaseViewController : UIViewController<UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>{
    UIScrollView *mainScrollView;
    UIView *shareRentView;
    UIView *genderView;
    UIView *houseView;
    UIView *typeView;
    UIView *furnitureView;
    UIPickerView *typePickerView;
    UIView *confirmBackgroundView;
    UIButton *nextButton;
    
    NSString *MEID;
    NSString *shareRentString;
    NSString *houseString;
    NSString *typeString;
    NSString *furnitureString;
    
    NSArray *roomTypeArray;
    NSMutableArray *viewsArray;
}

@property NSMutableDictionary *shareDict;

@end
