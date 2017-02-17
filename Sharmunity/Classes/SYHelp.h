//
//  SYHelp.h
//  Sharmunity
//
//  Created by st chen on 2017/2/9.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SYHelp;
//@protocol SYHelpDelegate <NSObject>
//
//-(void)SYHelp:(SYHelp*)helpView didLayoutWithHeight:(float)height;
//
//@end
@interface SYHelp : UIView{
    BOOL withHead;
    UILabel *titleLabel;
}

/*full size help*/
-(id)initWithFrame:(CGRect)frame helpID:(NSString*)ID withHeadView:(BOOL)head;

/*abstract help*/
-(id)initAbstractWithFrame:(CGRect)frame helpID:(NSString*)ID;

@property NSString *helpID;
@property NSDictionary *helpDict;
//@property (nonatomic, weak) id <SYHelpDelegate> delegate;
@end
