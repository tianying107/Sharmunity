//
//  SYShare.h
//  Sharmunity
//
//  Created by st chen on 2017/2/16.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYShare : UIView{
    NSInteger category;
    NSString *subcate;
    NSDictionary *keyword;
    
    NSString *shareID;
    
    UILabel *titleLabel;
    UILabel *priceLabel;
    UILabel *postDateLabel;
    UILabel *introductionLabel;
    
    UILabel *statusLabel;
}

-(id)initContentWithFrame:(CGRect)frame shareDict:(NSDictionary*)share;

-(id)initAbstractWithFrame:(CGRect)frame shareID:(NSString*)ID;
@property NSDictionary *shareDict;
@property UIButton *interestButton;
@end
