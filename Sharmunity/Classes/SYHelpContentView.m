//
//  SYHelpContentView.m
//  Sharmunity
//
//  Created by st chen on 2017/2/21.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "SYHelpContentView.h"
#import "Header.h"
#import "SYHeader.h"
#define DiscoverEat 1
#define DiscoverLive 2
#define DiscoverTravel 5
@implementation SYHelpContentView
@synthesize helpDict;
-(id)initContentWithFrame:(CGRect)frame helpDict:(NSDictionary*)help{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0)];
    if (self) {
        helpDict = help;
        [self contentViewSetup];
    }
    return self;
}
-(void)contentViewSetup{
    category = [[helpDict valueForKey:@"category"] integerValue];
    subcate = [helpDict valueForKey:@"subcate"];
    keyword = [helpDict valueForKey:@"keyword"];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-100, 20)];
    titleLabel.textColor = SYColor1;
    [titleLabel setFont:SYFont13S];
    [self addSubview:titleLabel];
    
    postDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, titleLabel.frame.size.height, self.frame.size.width-100, 30)];
    postDateLabel.text = [helpDict valueForKey:@"post_date"];
    postDateLabel.textColor = SYColor1;
    [postDateLabel setFont:SYFont13];
    [self addSubview:postDateLabel];
    
    
    
    if ([keyword valueForKey:@"introduction"]) {
        float contentWidth = self.frame.size.width;
        NSMutableAttributedString *attributeSting = [[NSMutableAttributedString alloc] initWithString:[keyword valueForKey:@"introduction"] attributes:@{NSFontAttributeName:SYFont13, NSForegroundColorAttributeName:SYColor1}];
        
        NSMutableParagraphStyle *paragraphstyle = [[NSMutableParagraphStyle alloc] init];
        paragraphstyle.lineSpacing = 8.f;
        [attributeSting addAttribute:NSParagraphStyleAttributeName value:paragraphstyle range:NSMakeRange(0, attributeSting.length)];
        CGRect rect = [attributeSting boundingRectWithSize:(CGSize){contentWidth, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        float height = rect.size.height;
        
        introductionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, postDateLabel.frame.size.height+postDateLabel.frame.origin.y, contentWidth, height)];
        introductionLabel.attributedText = attributeSting;
        introductionLabel.numberOfLines = 0;
        [self addSubview:introductionLabel];
    }
    
    switch (category) {
        case DiscoverEat:
            [self category1Response:NO];
            break;
        case DiscoverLive:
            [self category2Response:NO];
            break;
            
        case DiscoverTravel:
            [self category5Response:NO];
            break;
            
        default:
            break;
    }
}
-(void)category1Response:(BOOL)abstract{
    titleLabel.text = [keyword valueForKey:@"title"];
    if(abstract) return;
    CGRect frame = self.frame;
    frame.size.height = introductionLabel.frame.size.height+introductionLabel.frame.origin.y+20;
    self.frame = frame;
}
-(void)category2Response:(BOOL)abstract{
    SYTitle *titleGenerator = [SYTitle new];
    titleLabel.text = [titleGenerator titleFromHelpDict:helpDict];
    if(abstract) return;
    CGRect frame = self.frame;
    frame.size.height = titleLabel.frame.size.height+titleLabel.frame.origin.y+20;
    self.frame = frame;
}

-(void)category5Response:(BOOL)abstract{
    
}

@end
