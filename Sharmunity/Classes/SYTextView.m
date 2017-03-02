//
//  SYTextView.m
//  Sharmunity
//
//  Created by Star Chen on 2/23/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import "SYTextView.h"
#import "Header.h"
@implementation SYTextView

- (id)initWithFrame:(CGRect)frame type:(NSInteger)type{
    self = [super initWithFrame:frame];
    if (self) {
        self.textColor = SYColor1;
        [self setFont:SYFont15];
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 6;
        self.clipsToBounds = YES;
        self.delegate = self;
        if (type==SYTextViewHelp) {
            self.layer.borderColor = [SYColor6 CGColor];
        }
        else if (type == SYTextViewShare){
            self.layer.borderColor = [SYColor8 CGColor];
        }
        self.contentInset = UIEdgeInsetsMake(4, 10, 4, -10);
    }
    return self;
}
-(void)setPlaceholder:(NSString *)placeholder{
    NSMutableAttributedString *attributeSting = [[NSMutableAttributedString alloc] initWithString:placeholder attributes:@{NSFontAttributeName:SYFont15,NSForegroundColorAttributeName:SYColor3}];
    NSMutableParagraphStyle *paragraphstyle = [[NSMutableParagraphStyle alloc] init];
    paragraphstyle.lineSpacing = 2.f;
    [attributeSting addAttribute:NSParagraphStyleAttributeName value:paragraphstyle range:NSMakeRange(0, attributeSting.length)];
    CGRect rect = [attributeSting boundingRectWithSize:(CGSize){self.frame.size.width-10, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    float height = rect.size.height;
    if (placeholderLabel) {
        placeholderLabel.frame = CGRectMake(4, 8, self.frame.size.width-10, height);
        placeholderLabel.attributedText = attributeSting;
    }
    else{
        placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 8, self.frame.size.width-10, height)];
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.attributedText = attributeSting;
        [self addSubview:placeholderLabel];
        [self sendSubviewToBack:placeholderLabel];
    }
    
    
}
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length != 0) {
        placeholderLabel.hidden = YES;
        [self.SYDelegate SYTextView:self isEmpty:NO];
    }
    else
        placeholderLabel.hidden = NO;
        [self.SYDelegate SYTextView:self isEmpty:YES];
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    UIView *superView = [textView superview];
    if ([[superView superview] isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView*)[superView superview];
        NSLog(@"%f",scrollView.contentOffset.y);
        if (scrollView.contentOffset.y<superView.frame.origin.y-216-44-MIN(40, self.frame.size.height)) {
            [scrollView setContentOffset:CGPointMake(0, superView.frame.origin.y-216-44-MIN(40, self.frame.size.height)) animated:YES];
        }
        
    }
}
@end
