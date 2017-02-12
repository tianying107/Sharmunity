//
//  DiscoverEatShareRegionViewController.h
//  Sharmunity
//
//  Created by Star Chen on 2/11/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#define discoverEatRegion 101
#define discoverEatFood 102
@interface DiscoverEatShareSecondViewController : UIViewController<UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource,UITextViewDelegate>{
    UIScrollView *mainScrollView;
    UIView *regionView;
    UIView *subRegionView;
    UIView *foodView;
    UIView *locationView;
    UIView *titleView;
    UIView *introductionView;
    UIPickerView *regionPickerView;
    UIPickerView *subRegionPickerView;
    UIPickerView *foodPickerView;
    UIView *confirmBackgroundView;
    UIButton *nextButton;
    
    NSString *MEID;
    NSString *regionString;
    NSString *subRegionString;
    NSString *foodString;
    
    NSArray *regionArray;
    NSArray *subRegionArray;
    NSArray *foodArray;
    NSMutableArray *viewsArray;
}

-(void)locationCompleteResponse;
@property NSInteger controllerType;
@property NSMutableDictionary *shareDict;
@property MKMapItem *selectedItem;


@end
