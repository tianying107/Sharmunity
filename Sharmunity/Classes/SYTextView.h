//
//  SYTextView.h
//  Sharmunity
//
//  Created by Star Chen on 2/23/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SYTextViewHelp 1
#define SYTextViewShare 2
@class SYTextView;
@protocol SYTextViewDelegate <NSObject>

-(void)SYTextView:(SYTextView*)textView isEmpty:(BOOL)empty;

@end
@interface SYTextView : UITextView<UITextViewDelegate>{
    UILabel *placeholderLabel;
}
- (id)initWithFrame:(CGRect)frame type:(NSInteger)type;
-(void)setPlaceholder:(NSString*)placeholder;

@property (nonatomic, weak) id <SYTextViewDelegate> SYDelegate;
@end
