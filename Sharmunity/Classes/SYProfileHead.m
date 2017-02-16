//
//  SYProfileHead.m
//  Sharmunity
//
//  Created by st chen on 2017/2/15.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "SYProfileHead.h"
#import "Header.h"
@implementation SYProfileHead
@synthesize userDict;
-(id)initWithUserID:(NSString*)ID frame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 100)];
    if (self) {
        userID = ID;
        [self requestionUserInformation];
    }
    return self;
}

-(void)viewsSetup{
    avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 80, 80)];
    avatarImageView.image = [UIImage imageNamed:@"defaultAvatar"];
    avatarImageView.layer.cornerRadius = 3;
    avatarImageView.clipsToBounds = YES;
    [self addSubview:avatarImageView];
    _avatarButton = [[UIButton alloc] initWithFrame:avatarImageView.frame];
    [self addSubview:_avatarButton];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(avatarImageView.frame.origin.x*2+avatarImageView.frame.size.width, 10, 200, 40)];
    nameLabel.text = [NSString stringWithFormat:@"昵称: %@",[userDict valueForKey:@"name"]];
    nameLabel.textColor = SYColor1;
    [nameLabel setFont:SYFont15M];
    [self addSubview:nameLabel];
    
    UILabel *signUpLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.size.height+nameLabel.frame.origin.y, 200, nameLabel.frame.size.height)];
    signUpLabel.text = [NSString stringWithFormat:@"注册时间: %@",[userDict valueForKey:@"join_data"]];
    signUpLabel.textColor = SYColor1;
    [signUpLabel setFont:SYFont15M];
    [self addSubview:signUpLabel];
}
-(void)requestionUserInformation{
    NSString *requestQuery = [NSString stringWithFormat:@"email=%@",userID];
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
                                            userDict = dict;
                                            [self viewsSetup];
                                        });
                                        
                                    }];
    [task resume];

}
@end
