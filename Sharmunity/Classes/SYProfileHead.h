//
//  SYProfileHead.h
//  Sharmunity
//
//  Created by st chen on 2017/2/15.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYProfileHead : UIView{
    NSString *userID;
    
    UIImageView *avatarImageView;
}

-(id)initWithUserID:(NSString*)ID frame:(CGRect)frame;

@property UIButton *avatarButton;
@property NSDictionary *userDict;
@end
