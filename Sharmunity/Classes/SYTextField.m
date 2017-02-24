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
        self.textColor = SYColor1;
        [self setFont:SYFont15];
//        self.tintColor = goColor1;
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderWidth = 1;
        
        self.layer.cornerRadius = 6;
        self.clipsToBounds = YES;
        if (type==SYTextFieldHelp) {
            self.layer.borderColor = [SYColor6 CGColor];
        }
        else if (type == SYTextFieldShare){
            self.layer.borderColor = [SYColor8 CGColor];
        }
    }
    return self;
}
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 2);
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 2);
}


@end
