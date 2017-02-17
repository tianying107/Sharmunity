//
//  SYShare.m
//  Sharmunity
//
//  Created by st chen on 2017/2/16.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "SYShare.h"
#import "SYHeader.h"
#define DiscoverEat 1
#define DiscoverLive 2
#define DiscoverTravel 5
@implementation SYShare
@synthesize shareDict;
-(id)initAbstractWithFrame:(CGRect)frame shareID:(NSString*)ID{
    self = [super initWithFrame:frame];
    if (self) {
        shareID = ID;
        [self requestShareFromServer];
    }
    return self;
}
-(void)abstractViewSetup{
    float height = self.frame.size.height;
    
    
    postDateLabel = [[UILabel alloc] init];
    postDateLabel.textColor = SYColor4;
    [postDateLabel setFont:SYFont13];
    postDateLabel.text = [[[[shareDict valueForKey:@"post_date"] componentsSeparatedByString:@" "] firstObject] stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    [postDateLabel sizeToFit];
    postDateLabel.frame = CGRectMake(0, 0, postDateLabel.frame.size.width, height);
    [self addSubview:postDateLabel];
    
    UILabel *absTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(postDateLabel.frame.size.width, 0, self.frame.size.width-postDateLabel.frame.size.width, height)];
    absTitleLabel.textColor = SYColor1;
    [absTitleLabel setFont:SYFont13];
    SYTitle *titleGenerator = [SYTitle new];
    NSString *titleString =[[titleGenerator titleFromShareDict:shareDict] stringByReplacingOccurrencesOfString:@"我" withString:@" "];
    absTitleLabel.text = [titleString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    [self addSubview:absTitleLabel];
}
-(void)requestShareFromServer{
    
    NSString *requestQuery = [NSString stringWithFormat:@"share_id=%@",shareID];
    NSString *urlString = [NSString stringWithFormat:@"%@reqShare?%@",basicURL,requestQuery];
    NSLog(@"%@",requestQuery);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionTask *task = [session dataTaskWithURL:url
                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                        NSLog(@"server said: %@",string);
                                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                                             options:kNilOptions
                                                                                               error:&error];
                                        NSLog(@"server said: %@",dict);
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            shareDict = dict;
                                            [self abstractViewSetup];
                                        });
                                        
                                    }];
    [task resume];
}




-(id)initContentWithFrame:(CGRect)frame shareDict:(NSDictionary*)share{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0)];
    if (self) {
        shareDict = share;
        [self contentViewSetup];
    }
    return self;
}
-(void)contentViewSetup{
    category = [[shareDict valueForKey:@"category"] integerValue];
    subcate = [shareDict valueForKey:@"subcate"];
    keyword = [shareDict valueForKey:@"keyword"];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-100, 20)];
    titleLabel.textColor = SYColor1;
    [titleLabel setFont:SYFont13S];
    [self addSubview:titleLabel];
    
    postDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, titleLabel.frame.size.height, self.frame.size.width-100, 30)];
    postDateLabel.text = [shareDict valueForKey:@"post_date"];
    postDateLabel.textColor = SYColor1;
    [postDateLabel setFont:SYFont13];
    [self addSubview:postDateLabel];
    
    priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-100, 0, 100, 20)];
    priceLabel.textColor = SYColor1;
    priceLabel.textAlignment = NSTextAlignmentRight;
    [priceLabel setFont:SYFont13S];
    [self addSubview:priceLabel];
    
    
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
    priceLabel.hidden = YES;
    if(abstract) return;
    CGRect frame = self.frame;
    frame.size.height = introductionLabel.frame.size.height+introductionLabel.frame.origin.y+20;
    self.frame = frame;
}
-(void)category2Response:(BOOL)abstract{
    titleLabel.text = [keyword valueForKey:@"title"];
    priceLabel.text = [NSString stringWithFormat:@"%@/月",[keyword valueForKey:@"price"]];
    if(abstract) return;
    CGRect frame = self.frame;
    frame.size.height = introductionLabel.frame.size.height+introductionLabel.frame.origin.y+20;
    self.frame = frame;
}

-(void)category5Response:(BOOL)abstract{

}

@end