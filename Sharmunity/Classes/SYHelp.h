//
//  SYHelp.h
//  Sharmunity
//
//  Created by st chen on 2017/2/9.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SYHelp;
@interface SYHelp : UIView{
    BOOL withHead;
    UILabel *titleLabel;
}

-(id)initWithFrame:(CGRect)frame helpID:(NSString*)ID withHeadView:(BOOL)head;
@property NSString *helpID;
@property NSDictionary *helpDict;
@end
