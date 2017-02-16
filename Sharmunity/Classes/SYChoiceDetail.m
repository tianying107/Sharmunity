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
    
    float heightCount = 0;
    headView = [[SYProfileHead alloc] initWithUserID:helpeeID frame:CGRectMake(0, 0, self.frame.size.width, 0)];
    heightCount += headView.frame.size.height;
    [self addSubview:headView];
    
}
@end
