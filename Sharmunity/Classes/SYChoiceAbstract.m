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
        [self requestHelpFromServer];
    }
    return self;
}
-(void)shareChoiceSetup{
    self.backgroundColor = SYBackgroundColorExtraLight;
    float heightCount = 0;
    if (helpDict&&personDict) {
        
        
        avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 20, 20)];
        avatarImageView.image = [UIImage imageNamed:@"defaultAvatar"];
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.height/2;
        avatarImageView.clipsToBounds = YES;
        [self addSubview:avatarImageView];
        
        
        SYTitle *titleGenerator = [SYTitle new];
        NSString *titleString = [[titleGenerator titleFromHelpDict:helpDict] stringByReplacingOccurrencesOfString:@"我" withString:[personDict valueForKey:@"name"]];
        NSMutableAttributedString *attributeSting = [[NSMutableAttributedString alloc] initWithString:titleString attributes:@{NSFontAttributeName:SYFont15,NSForegroundColorAttributeName:SYColor1}];
        NSMutableParagraphStyle *paragraphstyle = [[NSMutableParagraphStyle alloc] init];
        paragraphstyle.lineSpacing = 2.f;
        [attributeSting addAttribute:NSParagraphStyleAttributeName value:paragraphstyle range:NSMakeRange(0, attributeSting.length)];
        CGRect rect = [attributeSting boundingRectWithSize:(CGSize){self.frame.size.width-80, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        float height = rect.size.height;
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, heightCount, self.frame.size.width-80, height)];
        titleLabel.textColor = SYColor1;
        [titleLabel setFont:SYFont13];
        [self addSubview:titleLabel];
        titleLabel.text = titleString;
        heightCount += titleLabel.frame.size.height;
        
        UILabel *postLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, heightCount, self.frame.size.width-40, 20)];
        postLabel.text = [helpDict valueForKey:@"post_date"];
        postLabel.textColor = SYColor3;
        [postLabel setFont: SYFont13];
        postLabel.textAlignment = NSTextAlignmentRight;
        heightCount += postLabel.frame.size.height;
        [self addSubview:postLabel];
        
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
                                            [self shareChoiceSetup];
                                            if ([choiceDict valueForKey:@"helpee_id"]) {
                                                [self requestPersonFromServer];
                                            }
                                        });
                                        
                                    }];
    [task resume];
}





-(id)initWithFrame:(CGRect)frame choiceID:(NSString*)ID{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 60)];
    if (self) {
        choiceID = ID;
        helpChoice = YES;
        [self requestChoiceFromServer];
    }
    return self;
}

-(void)helpChoiceSetup{
    self.backgroundColor = SYBackgroundColorExtraLight;
    float heightCount = 15;
    if (shareDict&&personDict) {
        
        
        avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 20, 20)];
        avatarImageView.image = [UIImage imageNamed:@"defaultAvatar"];
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.height/2;
        avatarImageView.clipsToBounds = YES;
        [self addSubview:avatarImageView];
        
        
        SYTitle *titleGenerator = [SYTitle new];
        NSString *titleString = [NSString stringWithFormat:@"%@%@",[titleGenerator titleFromShareDict:shareDict],[personDict valueForKey:@"name"]];
        NSMutableAttributedString *attributeSting = [[NSMutableAttributedString alloc] initWithString:titleString attributes:@{NSFontAttributeName:SYFont13,NSForegroundColorAttributeName:SYColor1}];
        NSMutableParagraphStyle *paragraphstyle = [[NSMutableParagraphStyle alloc] init];
        paragraphstyle.lineSpacing = 2.f;
        [attributeSting addAttribute:NSParagraphStyleAttributeName value:paragraphstyle range:NSMakeRange(0, attributeSting.length)];
        CGRect rect = [attributeSting boundingRectWithSize:(CGSize){self.frame.size.width-80, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        float height = rect.size.height;
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, heightCount, self.frame.size.width-80, height)];
        titleLabel.numberOfLines = 0;
        titleLabel.attributedText = attributeSting;
        [self addSubview:titleLabel];
        heightCount += titleLabel.frame.size.height;

        UILabel *postLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, heightCount, self.frame.size.width-40, 20)];
        postLabel.text = [shareDict valueForKey:@"post_date"];
        postLabel.textColor = SYColor3;
        [postLabel setFont: SYFont13];
        postLabel.textAlignment = NSTextAlignmentRight;
        heightCount += postLabel.frame.size.height;
        [self addSubview:postLabel];
        
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
