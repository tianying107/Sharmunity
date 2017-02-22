//
//  SYRelatedShare.m
//  Sharmunity
//
//  Created by st chen on 2017/2/21.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "SYRelatedShare.h"
#import "SYHeader.h"
#import "Header.h"
@implementation SYRelatedShare
@synthesize shareDict, choiceArray;
-(id)initRelatedWithFrame:(CGRect)frame shareID:(NSString*)ID{
    self = [super initWithFrame:frame];
    if (self) {
        shareID = ID;
        choiceArray = [NSArray new];
        [self requestShareFromServer];
        [self requestChoiceFromServer];
    }
    return self;
}
-(void)viewsSetup{
    float heightCount = 10;
    self.backgroundColor = SYBackgroundColorExtraLight;
    
    UIImageView *cateIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 25, 25)];
    cateIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"cate%@Help",[shareDict valueForKey:@"category"]]];
    [self addSubview:cateIcon];
    
    SYTitle *titleGenerator = [SYTitle new];
    NSMutableAttributedString *attributeSting = [[NSMutableAttributedString alloc] initWithString:[titleGenerator titleFromShareDict:shareDict] attributes:@{NSFontAttributeName:SYFont15S,NSForegroundColorAttributeName:SYColor1}];
    NSMutableParagraphStyle *paragraphstyle = [[NSMutableParagraphStyle alloc] init];
    paragraphstyle.lineSpacing = 2.f;
    [attributeSting addAttribute:NSParagraphStyleAttributeName value:paragraphstyle range:NSMakeRange(0, attributeSting.length)];
    CGRect rect = [attributeSting boundingRectWithSize:(CGSize){self.frame.size.width-40, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    float height = MIN(150, rect.size.height);
    UILabel *shareInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, heightCount, self.frame.size.width-40, height)];
    shareInfoLabel.attributedText = attributeSting;
    shareInfoLabel.numberOfLines = 0;
    [self addSubview:shareInfoLabel];
    heightCount += MAX(shareInfoLabel.frame.size.height, cateIcon.frame.size.height) ;
    
    UILabel *postLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, heightCount, self.frame.size.width-40, 20)];
    postLabel.text = [shareDict valueForKey:@"post_date"];
    postLabel.textColor = SYColor3;
    [postLabel setFont: SYFont13];
    postLabel.textAlignment = NSTextAlignmentRight;
    
    [self addSubview:postLabel];
    
    UIButton *editButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-170, heightCount+2, 18, 16)];
    [editButton setImage:[UIImage imageNamed:@"editButton"] forState:UIControlStateNormal];
    [self addSubview:editButton];
    
    
    heightCount += postLabel.frame.size.height+10;
    for (int i=0; i<choiceArray.count; i++) {
        SYChoiceAbstract *choiceAbstract = [[SYChoiceAbstract alloc] initWithFrame:CGRectMake(10, heightCount, self.frame.size.width-20, 0) choiceDict:[choiceArray objectAtIndex:i] helpID:[[choiceArray objectAtIndex:i] valueForKey:@"help_id"]];
        [self addSubview:choiceAbstract];
        heightCount += choiceAbstract.frame.size.height;
        
    }
    
    CGRect frame = self.frame;
    frame.size.height = heightCount;//MIN(heightCount, 200);
    self.frame = frame;

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
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            shareDict = dict;
                                            [self requestChoiceFromServer];
                                        });
                                        
                                    }];
    [task resume];
}

-(void)requestChoiceFromServer{
    NSString *requestQuery = [NSString stringWithFormat:@"share_id=%@",shareID];
    NSString *urlString = [NSString stringWithFormat:@"%@relatechoice?%@",basicURL,requestQuery];
    NSLog(@"%@",requestQuery);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionTask *task = [session dataTaskWithURL:url
                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                        NSArray *array = [NSJSONSerialization JSONObjectWithData:data
                                                                                             options:kNilOptions
                                                                                               error:&error];
                                        NSLog(@"server said: %@",array);
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            choiceArray = array;
                                            [self viewsSetup];
                                        });
                                        
                                    }];
    [task resume];
}
@end
