//
//  SYSuscard.h
//  Sharmunity
//
//  Created by st chen on 2017/1/20.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
@class SYSuscard;
@interface SYSuscard : UIView<UIScrollViewDelegate>{
    float scrollSize;
    //    CGRect leftButtonFrame;
    //    CGRect rightButtonFrame;
    UIButton *secondButton;
    BOOL hasKeyboard;
    NSMutableArray *cardArray;
    
}
- (void)setMultiButtonMode:(UIButton*)additionalButton;
- (id)initWithFrame:(CGRect)frame withCardSize:(CGSize)size keyboard:(BOOL)keyboard;
- (id)initWithFullSize;
- (void)scrollViewLayout;
- (void)addGoSubview:(UIView *)view;
- (void)resetCard;
- (void)pushInOneCard;
- (void)cancelResponse;
- (void)whiteButton;
@property CGRect leftButtonFrame;
@property CGRect rightButtonFrame;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *backButton;
@property CGSize cardSize;
@property UIView *cardBackgroundView;
@property UIVisualEffectView *effectView;

@end
