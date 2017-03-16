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
@synthesize shareDict, interestButton;
-(id)initAbstractWithFrame:(CGRect)frame shareID:(NSString*)ID{
    self = [super initWithFrame:frame];
    if (self) {
        shareID = ID;
        interestButton = [UIButton new];
        [self requestShareFromServer];
        [self testExist];
    }
    return self;
}
-(void)testExist{
    NSArray *shareArray = [[NSUserDefaults standardUserDefaults] arrayForKey:@"interestedShare"];
    if ([shareArray containsObject:shareID]) {
        interestButton.selected = YES;
        interestButton.userInteractionEnabled = NO;
    }
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
    
    UILabel *absTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(postDateLabel.frame.size.width+5, 0, self.frame.size.width-postDateLabel.frame.size.width, height)];
    absTitleLabel.textColor = SYColor1;
    [absTitleLabel setFont:SYFont13];
    SYTitle *titleGenerator = [SYTitle new];
    NSString *titleString =[[titleGenerator titleFromShareDict:shareDict] stringByReplacingOccurrencesOfString:@"我" withString:@" "];
    absTitleLabel.text = [titleString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    [self addSubview:absTitleLabel];
    
    UIButton *selectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [selectButton addTarget:self action:@selector(abstractExpendResponse) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:selectButton];
    
}
-(void)abstractExpendResponse{
    SYSuscard *baseView = [[SYSuscard alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height) withCardSize:CGSizeMake( [[UIScreen mainScreen] bounds].size.width-20, 200) keyboard:NO];
    baseView.cardBackgroundView.backgroundColor = SYBackgroundColorExtraLight;
    
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:baseView];
    baseView.alpha = 0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.258];
    baseView.alpha = 1;
    [UIView commitAnimations];
    
    /**************content***************/
    float heightCount = 10;
    float originX = 20;
    UILabel *absTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, heightCount, baseView.cardSize.width-2*originX, 40)];
    absTitleLabel.textColor = SYColor1;
    [absTitleLabel setFont:SYFont15M];
    absTitleLabel.numberOfLines = 0;
    SYTitle *titleGenerator = [SYTitle new];
    NSString *titleString =[[titleGenerator titleFromShareDict:shareDict] stringByReplacingOccurrencesOfString:@"我" withString:@" "];
    absTitleLabel.text = titleString;//[titleString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    [baseView addGoSubview:absTitleLabel];
    heightCount += absTitleLabel.frame.size.height;
    
    UILabel *postsDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, heightCount, baseView.cardSize.width-2*originX, 20)];
    postsDateLabel.textColor = SYColor1;
    [postsDateLabel setFont:SYFont15];
    postsDateLabel.text = [shareDict valueForKey:@"post_date"];
    [baseView addGoSubview:postsDateLabel];
    heightCount += postsDateLabel.frame.size.height;
    
    statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, heightCount, baseView.cardSize.width-40, 40)];
    NSString *statusString = [shareDict valueForKey:@"count"];
    statusLabel.text = [NSString stringWithFormat:@"已有%@人感兴趣",statusString];
    statusLabel.textColor = SYColor1;
    [statusLabel setFont:SYFont15M];
    [baseView addGoSubview:statusLabel];
    heightCount += statusLabel.frame.size.height;

    
    interestButton.frame = CGRectMake(baseView.cardSize.width-originX-150, heightCount+10, 150, 40);
    interestButton.backgroundColor = SYColor4;
    [interestButton setTitle:@"我感兴趣" forState:UIControlStateNormal];
    [interestButton setTitle:@"已感兴趣" forState:UIControlStateSelected];
    [interestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [interestButton.titleLabel setFont:SYFont18M];
    interestButton.layer.cornerRadius = interestButton.frame.size.height/2;
    interestButton.clipsToBounds = YES;
    [baseView addGoSubview:interestButton];
}
-(void)addInterest{
    NSInteger interestInt = [[shareDict valueForKey:@"count"] integerValue]+1;
    statusLabel.text = [NSString stringWithFormat:@"已有%ld人感兴趣",interestInt];
}
-(void)requestShareFromServer{
    NSString *requestQuery = [NSString stringWithFormat:@"share_id=%@",shareID];
    NSString *urlString = [NSString stringWithFormat:@"%@reqShare?%@",basicURL,requestQuery];
    NSLog(@"%@",requestQuery);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionTask *task = [session dataTaskWithURL:url
                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                                             options:kNilOptions
                                                                                               error:&error];
//                                        NSLog(@"server said: %@",dict);
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            shareDict = dict;
                                            [self abstractViewSetup];
                                        });
                                        
                                    }];
    [task resume];
}



/************FULL SIZE SHARE**************/
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
