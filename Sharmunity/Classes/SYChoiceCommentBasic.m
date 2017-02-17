//
//  SYChoiceCommentBasic.m
//  Sharmunity
//
//  Created by st chen on 2017/2/16.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "SYChoiceCommentBasic.h"
#import "Header.h"
@implementation SYChoiceCommentBasic

- (id)initWithFrame:(CGRect)frame content:(NSDictionary*)content MEID:(NSString*)myid{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        MEID = myid;
        commentDict = content;
        [self viewSetup];
    }
    return self;
}
- (void)viewSetup{
    float width = self.frame.size.width;
    //Head Image
    headImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 9, 32, 32)];
    headImage.layer.cornerRadius = headImage.frame.size.width/2;//圆头像
    headImage.clipsToBounds =YES;
    headImage.image = [UIImage imageNamed:@"defaultAvatar"];
//    [self addSubview:headImage];
    HEID = [commentDict valueForKey:@"author_id"];
    nameButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 4, 50, 20)];
    nameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [nameButton setTitleColor:SYColor2 forState:UIControlStateNormal];
    [nameButton.titleLabel setFont:SYFont13S];
    [self addSubview:nameButton];
    if ([HEID isEqualToString:MEID]) {
        [nameButton setTitle:@"我: " forState:UIControlStateNormal];
    }
    else{
        
    }
//    [self requestAvatar];
    
    
    //message
    NSString *msgString = [commentDict valueForKey:@"msg_content"];
    NSMutableAttributedString *attributeSting = [[NSMutableAttributedString alloc] initWithString:msgString attributes:@{NSFontAttributeName:SYFont13,NSForegroundColorAttributeName:SYColor1}];
    NSMutableParagraphStyle *paragraphstyle = [[NSMutableParagraphStyle alloc] init];
    paragraphstyle.lineSpacing = 2.f;
    [attributeSting addAttribute:NSParagraphStyleAttributeName value:paragraphstyle range:NSMakeRange(0, attributeSting.length)];
    CGRect rect = [attributeSting boundingRectWithSize:(CGSize){width-140, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    float height1 = rect.size.height;
    
    
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, width-140, height1)];
    commentLabel.attributedText = attributeSting;
    commentLabel.numberOfLines = 0;
    [self addSubview:commentLabel];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, MAX(50, commentLabel.frame.origin.y+commentLabel.frame.size.height+headImage.frame.origin.y));
    
    
//    _actionButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-headImage.frame.origin.x-12, 9, 12, 12)];
//    
//    [self addSubview:_actionButton];
    if ([[commentDict valueForKey:@"author_id"] isEqualToString:MEID]) {
        _myComment = YES;
//        [_actionButton setImage:[UIImage imageNamed:@"cancelClearColor5"] forState:UIControlStateNormal];
    }
    else{
        _myComment = NO;
//        [_actionButton setImage:[UIImage imageNamed:@"commentReply"] forState:UIControlStateNormal];
    }
    
    
}


-(void)requestPersonFromServer{
    NSString *requestQuery = [NSString stringWithFormat:@"email=%@",HEID];
    NSString *urlString = [NSString stringWithFormat:@"%@reqprofile?%@",basicURL,requestQuery];
    NSLog(@"%@",requestQuery);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionTask *task = [session dataTaskWithURL:url
                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                                             options:kNilOptions
                                                                                               error:&error];
                                        NSLog(@"server said: %@",dict);
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [nameButton setTitle:[NSString stringWithFormat:@"%@: ",[dict valueForKey:@"name"]] forState:UIControlStateNormal];
                                        });
                                        
                                    }];
    [task resume];
}

@end
