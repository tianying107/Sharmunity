//
//  SYChoiceCommentBasic.h
//  Sharmunity
//
//  Created by st chen on 2017/2/16.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYChoiceCommentBasic : UIView{
    NSString *MEID;
    NSString *HEID;
    NSDictionary *commentDict;
    UIImageView *headImage;
    UIButton *nameButton;
}
- (id)initWithFrame:(CGRect)frame content:(NSDictionary*)content MEID:(NSString*)myid;
@property UIButton *actionButton;
@property BOOL myComment;

@end
