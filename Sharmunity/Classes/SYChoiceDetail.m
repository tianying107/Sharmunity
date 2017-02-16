//
//  SYChoiceDetail.m
//  Sharmunity
//
//  Created by st chen on 2017/2/15.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "SYChoiceDetail.h"
#import "SYHeader.h"
@interface SYChoiceDetail(){
    SYProfileHead *headView;
    SYProfileExtend *extendView;
    float unextend;
    float extend;
    BOOL extended;
    
    UIView *choiceContentView;
}
@end
@implementation SYChoiceDetail
@synthesize choiceDict, helpeeID;
-(id)initWithChoiceDict:(NSDictionary*)Dict frame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 200)];
    if (self) {
        choiceDict = Dict;
        [self viewsSetup];
    }
    return self;
}
-(void)viewsSetup{
    helpeeID = [choiceDict valueForKey:@"helpee_id"];
    
    extended = NO;
    float heightCount = 0;
    headView = [[SYProfileHead alloc] initWithUserID:helpeeID frame:CGRectMake(0, heightCount, self.frame.size.width, 0)];
    
    heightCount += headView.frame.size.height;
    [self addSubview:headView];
    [headView.avatarButton addTarget:self action:@selector(extendResponse) forControlEvents:UIControlEventTouchUpInside];
    
    extendView = [[SYProfileExtend alloc] initWithUserID:helpeeID frame:CGRectMake(0, heightCount, self.frame.size.width, 0)];
    unextend = heightCount-extendView.frame.size.height;
    extend = heightCount;
    extendView.frame = CGRectMake(0, unextend, extendView.frame.size.width, extendView.frame.size.height);
    [self addSubview:extendView];
    [self sendSubviewToBack:extendView];
    
    choiceContentView = [[UIView alloc] initWithFrame:CGRectMake(0, heightCount, self.frame.size.width, 100)];
    [self addSubview:choiceContentView];
    
}


-(void)extendResponse{
    CGRect exFrame = extendView.frame;
    CGRect coFrame = choiceContentView.frame;
    if (extended) {
        exFrame.origin.y = unextend;
        coFrame.origin.y = unextend+exFrame.size.height;
        extended = NO;
    }
    else{
        exFrame.origin.y = extend;
        coFrame.origin.y = extend+exFrame.size.height;
        extended = YES;
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.258];
    extendView.frame = exFrame;
    choiceContentView.frame = coFrame;
    [UIView commitAnimations];
}
@end
