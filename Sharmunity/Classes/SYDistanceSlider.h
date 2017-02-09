//
//  SYDistanceSlider.h
//  Sharmunity
//
//  Created by st chen on 2017/2/9.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SYDistanceSlider;
@interface SYDistanceSlider : UIView{
    NSArray *distanceArray;
}
- (void)setdistanceWithString:(NSString*)distanceString;
- (void)setdistanceWithInteger:(NSInteger)distanceInteger;
@property UISlider *distanceSlider;
@property NSString *distanceString;
@property NSInteger distanceInteger;
@end
