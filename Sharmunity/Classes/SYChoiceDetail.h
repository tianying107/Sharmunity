//
//  SYChoiceDetail.h
//  Sharmunity
//
//  Created by st chen on 2017/2/15.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYChoiceDetail : UIView<UITextViewDelegate,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>{
    UITapGestureRecognizer *tap;
    
    UILabel *commentLabel;
    UITableView *commentTableView;
    NSMutableArray *commentBasicView;
    UIView *commentBackgroundView;
    UITextField *commentTextField;
    UIButton *sendMessageButton;
    
    NSString *MEID;
}

-(id)initWithChoiceDict:(NSDictionary*)Dict shareDict:(NSDictionary*)share frame:(CGRect)frame;
-(id)initWithChoiceDict:(NSDictionary*)Dict helpDict:(NSDictionary*)help frame:(CGRect)frame;
@property NSDictionary *choiceDict;
@property NSDictionary *helpDict;
@property NSDictionary *shareDict;
@property NSDictionary *personDict;
@property NSString *helpeeID;
@end
