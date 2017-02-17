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
@synthesize choiceID, choiceDict,shareDict, personDict;
-(id)initWithFrame:(CGRect)frame choiceID:(NSString*)ID{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 50)];
    if (self) {
        choiceID = ID;
        
        [self requestChoiceFromServer];
    }
    return self;
}

-(void)viewsSetup{
    self.backgroundColor = SYBackgroundColorExtraLight;
    float heightCount = 0;
    if (shareDict&&personDict) {
        
        
        avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 20, 20)];
        avatarImageView.image = [UIImage imageNamed:@"defaultAvatar"];
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.height/2;
        avatarImageView.clipsToBounds = YES;
        [self addSubview:avatarImageView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, heightCount, self.frame.size.width-40, 50)];
        titleLabel.textColor = SYColor1;
        [titleLabel setFont:SYFont13];
        [self addSubview:titleLabel];
        
        priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, heightCount, self.frame.size.width-40, 50)];
        priceLabel.textColor = SYColor1;
        priceLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:priceLabel];
        
        NSString *abstractInformation = [NSString new];
        NSInteger category = [[shareDict valueForKey:@"category"] integerValue];
        NSInteger subcate = [[shareDict valueForKey:@"subcate"] integerValue];
        if (category ==1) {
            abstractInformation = @"美食信息";
            
            titleLabel.text = ([[personDict valueForKey:@"name"] isEqualToString:@""])?abstractInformation:[NSString stringWithFormat:@"%@发布的%@",[personDict valueForKey:@"name"],abstractInformation];
        }
        else if (category==2) {
            NSInteger mode = subcate/1000000;
            if (mode==1) {
                abstractInformation = @"租房信息";
            }
            else if (mode==2){
                abstractInformation = @"搬家信息";
            }
            titleLabel.text = ([[personDict valueForKey:@"name"] isEqualToString:@""])?abstractInformation:[NSString stringWithFormat:@"%@发布的%@",[personDict valueForKey:@"name"],abstractInformation];
//            priceLabel.text = [NSString stringWithFormat:@"$%@",[[shareDict valueForKey:@"keyword"] valueForKey:@"price"]];
        }else{
            titleLabel.text = [NSString stringWithFormat:@"%@发布的信息",[personDict valueForKey:@"name"]];
        }

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
    SYChoiceDetail *detailView = [[SYChoiceDetail alloc] initWithChoiceDict:self.choiceDict shareDict:shareDict frame:CGRectMake(0, 44+20, baseView.cardSize.width, 0)];
    detailView.personDict = personDict;
    [baseView addGoSubview:detailView];
    
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
                                            [self viewsSetup];
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
                                            [self viewsSetup];
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
                                            [self viewsSetup];
                                        });
                                        
                                    }];
    [task resume];
}

@end
