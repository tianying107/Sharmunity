//
//  SYTextField.h
//  Sharmunity
//
//  Created by Star Chen on 2/23/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SYTextFieldHelp 1
#define SYTextFieldShare 2
#define SYTextFieldSeparator 3
@interface SYTextField : UITextField{
    NSInteger UIType;
}
- (id)initWithFrame:(CGRect)frame type:(NSInteger)type;
@end
