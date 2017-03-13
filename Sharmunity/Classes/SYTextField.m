//
//  SYTextField.m
//  Sharmunity
//
//  Created by Star Chen on 2/23/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import "SYTextField.h"
#import "Header.h"
@implementation SYTextField
- (id)initWithFrame:(CGRect)frame type:(NSInteger)type{
    self = [super initWithFrame:frame];
    if (self) {
        UIType = type;
        self.textColor = SYColor1;
        [self setFont:SYFont15];
//        self.tintColor = goColor1;
        self.backgroundColor = [UIColor clearColor];
        if (type==SYTextFieldHelp) {
            self.layer.borderWidth = 1;
            self.layer.cornerRadius = 6;
            self.clipsToBounds = YES;
            self.layer.borderColor = [SYColor6 CGColor];
        }
        else if (type == SYTextFieldShare){
            self.layer.borderWidth = 1;
            self.layer.cornerRadius = 6;
            self.clipsToBounds = YES;
            self.layer.borderColor = [SYColor8 CGColor];
        }
        else if (type == SYTextFieldSeparator){
            UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-SYSeparatorHeight, self.frame.size.width, SYSeparatorHeight)];
            separator.backgroundColor = SYSeparatorColor;
            [self addSubview:separator];
        }
    }
    return self;
}
- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect rect;
    if (UIType != SYTextFieldSeparator) {
        rect = CGRectInset(bounds, 10, 2);
    }
    else
        rect = CGRectInset(bounds, 0, 0);
    return rect;
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect rect;
    if (UIType != SYTextFieldSeparator) {
        rect = CGRectInset(bounds, 10, 2);
    }
    else
        rect = CGRectInset(bounds, 0, 0);
    return rect;
}


@end
