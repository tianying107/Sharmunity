//
//  SYHelp.m
//  Sharmunity
//
//  Created by st chen on 2017/2/9.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "SYHelp.h"
#import "Header.h"
#import "SYHeader.h"
#import "SYChoiceAbstract.h"
@implementation SYHelp
@synthesize helpID, helpDict, helpButton;
-(id)initAbstractWithFrame:(CGRect)frame helpID:(NSString*)ID{
    self = [super initWithFrame:frame];
    if (self) {
        helpID = ID;
        helpButton = [UIButton new];
        [self requestHelpFromServer:YES];
    }
    return self;
}
-(void)abstractSetup{
    float height = self.frame.size.height;
    

    UILabel *postDateLabel = [[UILabel alloc] init];
    postDateLabel.textColor = SYColor5;
    [postDateLabel setFont:SYFont13];
    postDateLabel.text = [[[[helpDict valueForKey:@"post_date"] componentsSeparatedByString:@" "] firstObject] stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    [postDateLabel sizeToFit];
    postDateLabel.frame = CGRectMake(0, 0, postDateLabel.frame.size.width, height);
    [self addSubview:postDateLabel];
    
    UILabel *absTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(postDateLabel.frame.size.width+5, 0, self.frame.size.width-postDateLabel.frame.size.width, height)];
    absTitleLabel.textColor = SYColor1;
    [absTitleLabel setFont:SYFont13];
    SYTitle *titleGenerator = [SYTitle new];
    NSString *titleString =[[titleGenerator titleFromHelpDict:helpDict] stringByReplacingOccurrencesOfString:@"我" withString:@" "];
    absTitleLabel.text = [titleString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    [self addSubview:absTitleLabel];
    
    UIButton *selectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [selectButton addTarget:self action:@selector(abstractExpendResponse) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:selectButton];
    
}
-(void)abstractExpendResponse{
    SYSuscard *baseView = [[SYSuscard alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height) withCardSize:CGSizeMake( [[UIScreen mainScreen] bounds].size.width-20, 250) keyboard:NO];
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
    UILabel *absTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, heightCount, baseView.cardSize.width-originX*2, 80)];
    absTitleLabel.textColor = SYColor1;
    [absTitleLabel setFont:SYFont15M];
    absTitleLabel.numberOfLines = 0;
    SYTitle *titleGenerator = [SYTitle new];
    NSString *titleString =[[titleGenerator titleFromHelpDict:helpDict] stringByReplacingOccurrencesOfString:@"我" withString:@""];
    absTitleLabel.text = titleString;//[titleString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    [baseView addGoSubview:absTitleLabel];
    heightCount += absTitleLabel.frame.size.height;
    
    UILabel *postDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, heightCount, baseView.cardSize.width-2*originX, 20)];
    postDateLabel.textColor = SYColor1;
    [postDateLabel setFont:SYFont15];
    postDateLabel.text = [helpDict valueForKey:@"post_date"];
    [baseView addGoSubview:postDateLabel];
    heightCount += postDateLabel.frame.size.height;
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, heightCount, baseView.cardSize.width-40, 40)];
    NSInteger statusInteger = [[helpDict valueForKey:@"status"] integerValue];
    switch (statusInteger) {
        case 0:
            statusLabel.text = @"状态: 未完成匹配";
            break;
        case 1:
            statusLabel.text = @"状态: 已完成匹配";
            break;
        case 2:
            statusLabel.text = @"状态: 已解决";
            break;
        default:
            break;
    }
    statusLabel.textColor = SYColor1;
    [statusLabel setFont:SYFont15M];
    [baseView addGoSubview:statusLabel];
    heightCount += statusLabel.frame.size.height;
    
    
    if (!statusInteger) {
        helpButton.frame = CGRectMake(baseView.cardSize.width-originX-150, heightCount+10, 150, 40);
        helpButton.backgroundColor = SYColor4;
        [helpButton setTitle:@"我想提供帮助" forState:UIControlStateNormal];
        [helpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [helpButton.titleLabel setFont:SYFont18M];
        helpButton.layer.cornerRadius = helpButton.frame.size.height/2;
        helpButton.clipsToBounds = YES;
        [baseView addGoSubview:helpButton];
    }
}



-(id)initWithFrame:(CGRect)frame helpID:(NSString*)ID withHeadView:(BOOL)head{
    self = [super initWithFrame:frame];
    if (self) {
        helpID = ID;
        withHead = head;
        [self requestHelpFromServer:NO];
    }
    return self;
}

-(void)viewsSetup{
    float heightCount = 0;
    if (withHead) {
        /*Head View*/
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, heightCount, self.frame.size.width, 50)];
        headView.backgroundColor = SYColor5;
        [self addSubview:headView];
        heightCount += headView.frame.size.height;
        
        UILabel *label1 = [UILabel new];
        label1.text = @"恭喜";
        label1.textColor = [UIColor whiteColor];
        [label1 setFont:SYFont20S];
        [label1 sizeToFit];
        UILabel *label2 = [UILabel new];
        label2.text = @"您的求助卡已生成！";
        label2.textColor = [UIColor whiteColor];
        [label2 setFont:SYFont15S];
        [label2 sizeToFit];
        float totalWidth = label2.frame.size.width+label1.frame.size.width;
        label1.frame = CGRectMake((self.frame.size.width-totalWidth)/2, 0, label1.frame.size.width, 50);
        label2.frame = CGRectMake((self.frame.size.width+totalWidth)/2-label2.frame.size.width, 5, label2.frame.size.width, 45);
        [headView addSubview:label1];
        [headView addSubview:label2];
        
        
    }
    self.backgroundColor = SYBackgroundColorGreen;
    
    SYTitle *titleGenerator = [SYTitle new];
    UILabel *helpInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, heightCount+10, self.frame.size.width-40, 60)];;
    helpInfoLabel.text = [titleGenerator titleFromHelpDict:helpDict];
    NSLog(@"%@",[titleGenerator titleFromHelpDict:helpDict]);
    helpInfoLabel.textColor = SYColor1;
    helpInfoLabel.textAlignment = NSTextAlignmentCenter;
    [helpInfoLabel setFont:SYFont15S];
    helpInfoLabel.numberOfLines = 0;
    [self addSubview:helpInfoLabel];
    heightCount += 70;
    
    UILabel *postLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, heightCount, self.frame.size.width-40, 20)];
    postLabel.text = [helpDict valueForKey:@"post_date"];
    postLabel.textColor = SYColor1;
    [postLabel setFont: SYFont13];
    postLabel.textAlignment = NSTextAlignmentCenter;
    heightCount += postLabel.frame.size.height;
    [self addSubview:postLabel];
    
    NSArray *choiceArray = [helpDict valueForKey:@"choices"];
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, heightCount, 200, 40)];
    titleLabel.backgroundColor = SYBackgroundColorExtraLight;
    titleLabel.text = [NSString stringWithFormat:@"系统已为您匹配到%ld条信息", choiceArray.count];
    [titleLabel setFont:SYFont15M];
    [self addSubview:titleLabel];
    heightCount += titleLabel.frame.size.height;

    for (int i=0; i<choiceArray.count; i++) {
        SYChoiceAbstract *choiceAbstract = [[SYChoiceAbstract alloc] initWithFrame:CGRectMake(10, heightCount, self.frame.size.width-20, 0) choiceID:[choiceArray objectAtIndex:i]];
        [self addSubview:choiceAbstract];
        heightCount += choiceAbstract.frame.size.height;
        
    }
    CGRect frame = self.frame;
    frame.size.height = heightCount;//MIN(heightCount, 200);
    self.frame = frame;
    UIView *frontgroundView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width-20, self.frame.size.height-20)];
    frontgroundView.backgroundColor = SYBackgroundColorExtraLight;
    frontgroundView.layer.cornerRadius = 5;
    frontgroundView.clipsToBounds = YES;
    [self addSubview:frontgroundView];
    [self sendSubviewToBack:frontgroundView];
//    [self.delegate SYHelp:self didLayoutWithHeight:heightCount];
}


-(void)requestHelpFromServer:(BOOL)abstract{
    NSString *requestQuery = [NSString stringWithFormat:@"help_id=%@",helpID];
    NSString *urlString = [NSString stringWithFormat:@"%@reqhelp?%@",basicURL,requestQuery];
    NSLog(@"%@",requestQuery);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionTask *task = [session dataTaskWithURL:url
                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                                     options:kNilOptions
                                                                                                                                       error:&error];
//                                                                                NSLog(@"server said: %@",dict);
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     helpDict = dict;
                                                     (abstract)?[self abstractSetup]:[self viewsSetup];
                                                  });
                                        
                                    }];
    [task resume];
}
@end
