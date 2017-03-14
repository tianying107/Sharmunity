//
//  DiscoverArticalDetailViewController.h
//  Sharmunity
//
//  Created by Star Chen on 3/13/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscoverArticalDetailViewController : UIViewController<UIScrollViewDelegate>{
    UIScrollView *mainScrollView;
    UIView *titleView;
    UIView *introductionView;
    UIView *imageSelectView;
    UIView *functionView;
    
    NSDictionary *shareDict;
    NSMutableArray *viewsArray;
    
    NSInteger imageNumbers;
}
@property NSString *shareID;
@end
