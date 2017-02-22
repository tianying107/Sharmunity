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
    BOOL helpChoice;
}
-(id)initWithFrame:(CGRect)frame choiceID:(NSString*)ID;

-(id)initWithFrame:(CGRect)frame choiceDict:(NSDictionary*)choiceDic helpID:(NSString*)ID;
@property NSString *choiceID;
@property NSString *helpID;
@property NSDictionary *helpDict;
@property NSDictionary *choiceDict;
@property NSDictionary *shareDict;
@property NSDictionary *personDict;
@property UIButton *selectButton;
@end
