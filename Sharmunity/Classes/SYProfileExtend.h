//
//  SYProfileExtend.h
//  Sharmunity
//
//  Created by st chen on 2017/2/15.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYProfileExtend : UIView{
    NSString *userID;
}
-(id)initWithUserID:(NSString*)ID frame:(CGRect)frame;
@property NSDictionary *userDict;
@end
