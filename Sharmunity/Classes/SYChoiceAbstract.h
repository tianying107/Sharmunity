//
//  SYChoiceAbstract.h
//  Sharmunity
//
//  Created by st chen on 2017/2/9.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SYChoiceAbstract;
@interface SYChoiceAbstract : UIView{
    UILabel *nameLabel;
    UILabel *titleLabel;
    UILabel *priceLabel;
    UIImageView *avatarImageView;
}
-(id)initWithFrame:(CGRect)frame choiceID:(NSString*)ID;
@property NSString *choiceID;
@property NSDictionary *choiceDict;
@property NSDictionary *shareDict;
@property NSDictionary *personDict;
@property UIButton *selectButton;
@end
