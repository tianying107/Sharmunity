//
//  SYChoiceAbstract.m
//  Sharmunity
//
//  Created by st chen on 2017/2/9.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "SYChoiceAbstract.h"
#import "Header.h"
#import "SYHeader.h"
@implementation SYChoiceAbstract
@synthesize choiceID, choiceDict,shareDict, personDict, helpID, helpDict;
-(id)initWithFrame:(CGRect)frame choiceDict:(NSDictionary*)choiceDic helpID:(NSString*)ID{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 60)];
    if (self) {
        choiceDict = choiceDic;
        choiceID = [choiceDict valueForKey:@"choice_id"];
        helpID = ID;
        helpChoice = NO;
        self.clipsToBounds = YES;
        [self requestHelpFromServer];
    }
    return self;
}
-(void)shareChoiceSetup{
    self.backgroundColor = SYBackgroundColorExtraLight;
    float heightCount = 0;
    if (helpDict&&personDict) {
        
        
        avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, heightCount, 20, 20)];
        avatarImageView.image = [UIImage imageNamed:@"defaultAvatar"];
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.height/2;
        avatarImageView.clipsToBounds = YES;
        [self addSubview:avatarImageView];
        
        
        SYTitle *titleGenerator = [SYTitle new];
        NSString *titleString = [[titleGenerator titleFromHelpDict:helpDict] stringByReplacingOccurrencesOfString:@"我" withString:@""];
        NSMutableAttributedString *attributeSting = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",[personDict valueForKey:@"name"],titleString] attributes:@{NSFontAttributeName:SYFont13,NSForegroundColorAttributeName:SYColor1}];
        NSMutableParagraphStyle *paragraphstyle = [[NSMutableParagraphStyle alloc] init];
        paragraphstyle.lineSpacing = 2.f;
        [attributeSting addAttribute:NSParagraphStyleAttributeName value:paragraphstyle range:NSMakeRange(0, attributeSting.length)];
        CGRect rect = [attributeSting boundingRectWithSize:(CGSize){self.frame.size.width-35, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        float height = rect.size.height;
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, heightCount, self.frame.size.width-35, 20)];
        [self addSubview:titleLabel];
        titleLabel.numberOfLines = 1;
        titleLabel.attributedText = attributeSting;
        heightCount += titleLabel.frame.size.height;
        
        UILabel *postLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, heightCount, self.frame.size.width, 20)];
        postLabel.text = [helpDict valueForKey:@"post_date"];
        postLabel.textColor = SYColor3;
        [postLabel setFont: SYFont11];
        postLabel.textAlignment = NSTextAlignmentRight;
        heightCount += postLabel.frame.size.height;
        [self addSubview:postLabel];
        
        UIView *functionView = [[UIView alloc] initWithFrame:CGRectMake(35, heightCount, self.frame.size.width-35, 24)];
        heightCount += functionView.frame.size.height;
        [self addSubview:functionView];
        UIButton *shareFriendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 85, 24)];
        [shareFriendButton setTitle:@"分享给朋友" forState:UIControlStateNormal];
        [shareFriendButton setTitleColor:SYColor2 forState:UIControlStateNormal];
        [shareFriendButton.titleLabel setFont:SYFont11];
        shareFriendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [functionView addSubview:shareFriendButton];
        /*3 buttons*/
        UIButton *messageButton = [[UIButton alloc] initWithFrame:CGRectMake(functionView.frame.size.width-18-10-16, 0, 16, 24)];
        [messageButton setImage:[UIImage imageNamed:@"choiceMsgButton"] forState:UIControlStateNormal];
        //        [messageButton addTarget:self action:@selector(writeCommentResponse) forControlEvents:UIControlEventTouchUpInside];
        [functionView addSubview: messageButton];
        
        
        UIButton *contactButton = [[UIButton alloc] initWithFrame:CGRectMake(functionView.frame.size.width-18, 0, 18, 24)];
        //        [contactButton addTarget:self action:@selector(contactReponse) forControlEvents:UIControlEventTouchUpInside];
        [contactButton setImage:[UIImage imageNamed:@"choiceContactButton"] forState:UIControlStateNormal];
        [functionView addSubview: contactButton];
        
        CGRect frame = self.frame;
        frame.size.height = heightCount;
        self.frame = frame;
        
        _selectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [_selectButton addTarget:self action:@selector(selectChoice:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_selectButton];
    }
    
    
    
    
}
-(void)requestHelpFromServer{
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
                                            if ([choiceDict valueForKey:@"helpee_id"]) {
                                                [self requestPersonFromServer];
                                            }
                                        });
                                        
                                    }];
    [task resume];
}





-(id)initWithFrame:(CGRect)frame choiceID:(NSString*)ID{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 80)];
    if (self) {
        choiceID = ID;
        helpChoice = YES;
        self.clipsToBounds = YES;
        [self requestChoiceFromServer];
    }
    return self;
}

-(void)helpChoiceSetup{
    self.backgroundColor = SYBackgroundColorExtraLight;
    float heightCount = 0;
    if (shareDict&&personDict) {
        
        
        avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, heightCount, 20, 20)];
        avatarImageView.image = [UIImage imageNamed:@"defaultAvatar"];
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.height/2;
        avatarImageView.clipsToBounds = YES;
        [self addSubview:avatarImageView];
        
        
        SYTitle *titleGenerator = [SYTitle new];
        NSString *titleString = [NSString stringWithFormat:@"%@%@",[personDict valueForKey:@"name"],[titleGenerator titleFromShareDict:shareDict]];
        NSMutableAttributedString *attributeSting = [[NSMutableAttributedString alloc] initWithString:titleString attributes:@{NSFontAttributeName:SYFont13,NSForegroundColorAttributeName:SYColor1}];
        NSMutableParagraphStyle *paragraphstyle = [[NSMutableParagraphStyle alloc] init];
//        paragraphstyle.lineSpacing = 2.f;
        [attributeSting addAttribute:NSParagraphStyleAttributeName value:paragraphstyle range:NSMakeRange(0, attributeSting.length)];
        CGRect rect = [attributeSting boundingRectWithSize:(CGSize){self.frame.size.width-35, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        float height = rect.size.height;
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, heightCount, self.frame.size.width-35, height)];
        titleLabel.numberOfLines = 0;
        titleLabel.attributedText = attributeSting;
        [self addSubview:titleLabel];
        heightCount += titleLabel.frame.size.height;

        UILabel *postLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, heightCount, self.frame.size.width, 20)];
        postLabel.text = [shareDict valueForKey:@"post_date"];
        postLabel.textColor = SYColor3;
        [postLabel setFont: SYFont11];
        postLabel.textAlignment = NSTextAlignmentRight;
        heightCount += postLabel.frame.size.height;
        [self addSubview:postLabel];
        
        UIView *functionView = [[UIView alloc] initWithFrame:CGRectMake(35, heightCount, self.frame.size.width-35, 24)];
        heightCount += functionView.frame.size.height;
        [self addSubview:functionView];
        UIButton *shareFriendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 85, 24)];
        [shareFriendButton setTitle:@"分享给朋友" forState:UIControlStateNormal];
        [shareFriendButton setTitleColor:SYColor2 forState:UIControlStateNormal];
        [shareFriendButton.titleLabel setFont:SYFont11];
        shareFriendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [functionView addSubview:shareFriendButton];
        /*3 buttons*/
        UIButton *messageButton = [[UIButton alloc] initWithFrame:CGRectMake(functionView.frame.size.width-60-16, 0, 16, 24)];
        [messageButton setImage:[UIImage imageNamed:@"choiceMsgButton"] forState:UIControlStateNormal];
        //        [messageButton addTarget:self action:@selector(writeCommentResponse) forControlEvents:UIControlEventTouchUpInside];
        [functionView addSubview: messageButton];
        
        UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(functionView.frame.size.width-18-10-20, 0, 20, 24)];
        [shareButton setImage:[UIImage imageNamed:@"choiceShareButton"] forState:UIControlStateNormal];
        [functionView addSubview: shareButton];
        
        UIButton *contactButton = [[UIButton alloc] initWithFrame:CGRectMake(functionView.frame.size.width-18, 0, 18, 24)];
        //        [contactButton addTarget:self action:@selector(contactReponse) forControlEvents:UIControlEventTouchUpInside];
        [contactButton setImage:[UIImage imageNamed:@"choiceContactButton"] forState:UIControlStateNormal];
        [functionView addSubview: contactButton];
        
        _selectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [_selectButton addTarget:self action:@selector(selectChoice:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_selectButton];
    }
    
    

    
}

-(IBAction)selectChoice:(id)sender{
    SYSuscard *baseView = [[SYSuscard alloc] initWithFullSize];
    baseView.cardBackgroundView.backgroundColor = SYBackgroundColorExtraLight;
    baseView.backButton.hidden = NO;
    baseView.cancelButton.hidden = YES;
    
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:baseView];
    baseView.alpha = 0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.258];
    baseView.alpha = 1;
    [UIView commitAnimations];
    
    /**************content***************/
    if(helpChoice){
        SYChoiceDetail *detailView = [[SYChoiceDetail alloc] initWithChoiceDict:self.choiceDict shareDict:shareDict frame:CGRectMake(0, 44+20, baseView.cardSize.width, 0)];
        detailView.personDict = personDict;
        [baseView addGoSubview:detailView];
    }
    else{
        SYChoiceDetail *detailView = [[SYChoiceDetail alloc] initWithChoiceDict:self.choiceDict helpDict:helpDict frame:CGRectMake(0, 44+20, baseView.cardSize.width, 0)];
        detailView.personDict = personDict;
        [baseView addGoSubview:detailView];
    }
    
    
}

-(void)requestChoiceFromServer{
    NSString *requestQuery = [NSString stringWithFormat:@"choice_id=%@",choiceID];
    NSString *urlString = [NSString stringWithFormat:@"%@reqchoice?%@",basicURL,requestQuery];
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
                                            choiceDict = dict;
                                            [self helpChoiceSetup];
                                            if ([choiceDict valueForKey:@"helpee_id"]) {
                                                [self requestPersonFromServer];
                                            }
                                            if ([choiceDict valueForKey:@"share_id"]) {
                                                [self requestShareFromServer];
                                            }
                                        });
                                        
                                    }];
    [task resume];
}
-(void)requestShareFromServer{
    
    NSString *requestQuery = [NSString stringWithFormat:@"share_id=%@",[choiceDict valueForKey:@"share_id"]];
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
                                            [self helpChoiceSetup];
//                                            [self handleShare];
                                        });
                                        
                                    }];
    [task resume];
}

-(void)requestPersonFromServer{
    NSString *requestQuery = [NSString stringWithFormat:@"email=%@",[choiceDict valueForKey:@"helpee_id"]];
    NSString *urlString = [NSString stringWithFormat:@"%@reqprofile?%@",basicURL,requestQuery];
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
                                            personDict = dict;
                                            nameLabel.text = [personDict valueForKey:@"name"];
                                            (helpChoice)?[self helpChoiceSetup]:[self shareChoiceSetup];
                                        });
                                        
                                    }];
    [task resume];
}

@end
