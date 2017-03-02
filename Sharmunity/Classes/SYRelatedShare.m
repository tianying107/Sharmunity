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
        self.clipsToBounds = YES;
        choiceArray = [NSArray new];
        editButton = [[UIButton alloc] init];
        [self requestShareFromServer];
        [self requestChoiceFromServer];
    }
    return self;
}
-(void)viewsSetup{
    float heightCount = 10;
    self.backgroundColor = SYBackgroundColorExtraLight;
    
    UIImageView *cateIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 25, 25)];
    cateIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"cate%@Share",[shareDict valueForKey:@"category"]]];
    cateIcon.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:cateIcon];
    
    
    [editButton setImage:[UIImage imageNamed:@"editButton"] forState:UIControlStateNormal];
    [self addSubview:editButton];
    
    SYTitle *titleGenerator = [SYTitle new];
    NSMutableAttributedString *attributeSting = [[NSMutableAttributedString alloc] initWithString:[titleGenerator titleFromShareDict:shareDict] attributes:@{NSFontAttributeName:SYFont13M,NSForegroundColorAttributeName:SYColor1}];
    NSMutableParagraphStyle *paragraphstyle = [[NSMutableParagraphStyle alloc] init];
    paragraphstyle.lineSpacing = 2.f;
    [attributeSting addAttribute:NSParagraphStyleAttributeName value:paragraphstyle range:NSMakeRange(0, attributeSting.length)];
    CGRect rect = [attributeSting boundingRectWithSize:(CGSize){self.frame.size.width-100, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    float height = rect.size.height;
    UILabel *shareInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, heightCount, self.frame.size.width-45-55, height)];
    shareInfoLabel.attributedText = attributeSting;
    shareInfoLabel.numberOfLines = 0;
    [self addSubview:shareInfoLabel];
    heightCount += height ;
    
    UILabel *postLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, heightCount, self.frame.size.width-45, 20)];
    postLabel.text = [shareDict valueForKey:@"post_date"];
    postLabel.textColor = SYColor3;
    [postLabel setFont: SYFont11];
    postLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:postLabel];
    
    editButton.frame = CGRectMake(self.frame.size.width-170, heightCount+2, 18, 16);
    
    heightCount += 30;
    for (int i=0; i<choiceArray.count; i++) {
        SYChoiceAbstract *choiceAbstract = [[SYChoiceAbstract alloc] initWithFrame:CGRectMake(35, heightCount, self.frame.size.width-75, 80) choiceDict:[choiceArray objectAtIndex:i] helpID:[[choiceArray objectAtIndex:i] valueForKey:@"help_id"]];
        [self addSubview:choiceAbstract];
        heightCount += choiceAbstract.frame.size.height;
        
    }
    
    CGRect frame = self.frame;
    frame.size.height = MAX(heightCount, 55);
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
