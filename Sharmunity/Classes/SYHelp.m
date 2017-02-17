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
@synthesize helpID, helpDict;
-(id)initAbstractWithFrame:(CGRect)frame helpID:(NSString*)ID{
    self = [super initWithFrame:frame];
    if (self) {
        helpID = ID;
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
    
    UILabel *absTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(postDateLabel.frame.size.width, 0, self.frame.size.width-postDateLabel.frame.size.width, height)];
    absTitleLabel.textColor = SYColor1;
    [absTitleLabel setFont:SYFont13];
    SYTitle *titleGenerator = [SYTitle new];
    NSString *titleString =[[titleGenerator titleFromHelpDict:helpDict] stringByReplacingOccurrencesOfString:@"我" withString:@" "];
    absTitleLabel.text = [titleString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    [self addSubview:absTitleLabel];
    
    
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
                                        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                        NSLog(@"server said: %@",string);
                                                                                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                                     options:kNilOptions
                                                                                                                                       error:&error];
                                                                                NSLog(@"server said: %@",dict);
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     helpDict = dict;
                                                     (abstract)?[self abstractSetup]:[self viewsSetup];
                                                  });
                                        
                                    }];
    [task resume];
}
@end
