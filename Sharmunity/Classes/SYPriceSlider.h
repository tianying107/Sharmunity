//
//  SYPriceSlider.h
//  Sharmunity
//
//  Created by st chen on 2017/2/9.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMRangeSlider.h"
#define SYPriceSliderSingle 331
#define SYPriceSliderDouble 332
@class SYPriceSlider;
@protocol SYPriceSliderDelegate <NSObject>

- (void)priceSlider:(UISlider*)slider priceChangeToValue:(NSInteger)price;
- (void)lowerPriceChangeToValue:(NSInteger)lowerPrice upperToValue:(NSInteger)upperPrice;

@end
@interface SYPriceSlider : UIView{
    UILabel *lowerLabel;
    UILabel *upperLabel;
    NMRangeSlider *rangeSlider;
    
}
- (id)initWithFrame:(CGRect)frame type:(NSInteger)type;

- (void)setPriceWithString:(NSString*)priceString;
- (void)setPriceWithInteger:(NSInteger)priceInteger;
@property (nonatomic, weak) id <SYPriceSliderDelegate> delegate;
@property UISlider *priceSlider;
@property UISlider *price2Slider;
@property NSString *priceString;
@property NSInteger priceInteger;
@property NSInteger price2Integer;

@property NSInteger sliderType;

@end
