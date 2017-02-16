//
//  SYChoiceDetail.h
//  Sharmunity
//
//  Created by st chen on 2017/2/15.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYChoiceDetail : UIView{
    
}

-(id)initWithChoiceDict:(NSDictionary*)Dict frame:(CGRect)frame;
@property NSDictionary *choiceDict;
@property NSString *helpeeID;
@end
