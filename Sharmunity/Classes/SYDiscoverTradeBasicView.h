//
//  SYDiscoverTradeBasicView.h
//  Sharmunity
//
//  Created by Star Chen on 3/12/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SYDiscoverTradeBasicView;
@protocol SYDiscoverTradeBasicViewDelegate <NSObject>

-(void)tradeBasicView:(SYDiscoverTradeBasicView*)basicView didSelected:(UIButton*)selectedButton image:(UIImage*)image;

@end
@interface SYDiscoverTradeBasicView : UIView{
//    NSString *shareID;
}
-(id)initWithFrame:(CGRect)frame shareID:(NSString*)ID;
@property UIButton *imageButton;
@property NSString *shareID;
@property (nonatomic, weak) id <SYDiscoverTradeBasicViewDelegate> delegate;
@end
