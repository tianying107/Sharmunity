//
//  SYHelpContentView.h
//  Sharmunity
//
//  Created by st chen on 2017/2/21.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYHelpContentView : UIView{
    NSInteger category;
    NSString *subcate;
    NSDictionary *keyword;
    
    NSString *helpID;
    
    UILabel *titleLabel;
//    UILabel *priceLabel;
    UILabel *postDateLabel;
    UILabel *introductionLabel;
}
-(id)initContentWithFrame:(CGRect)frame helpDict:(NSDictionary*)help;
@property NSDictionary *helpDict;
@end
