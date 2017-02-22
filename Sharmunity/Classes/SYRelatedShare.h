//
//  SYRelatedShare.h
//  Sharmunity
//
//  Created by st chen on 2017/2/21.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYRelatedShare : UIView{
    NSInteger category;
    NSString *subcate;
    NSDictionary *keyword;
    
    NSString *shareID;
    
    UILabel *titleLabel;
    UILabel *priceLabel;
    UILabel *postDateLabel;
    UILabel *introductionLabel;
}
-(id)initRelatedWithFrame:(CGRect)frame shareID:(NSString*)ID;
@property NSDictionary *shareDict;
@property NSArray *choiceArray;

@end
