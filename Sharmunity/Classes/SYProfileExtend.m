//
//  SYProfileExtend.m
//  Sharmunity
//
//  Created by st chen on 2017/2/15.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "SYProfileExtend.h"
#import "Header.h"
@implementation SYProfileExtend
@synthesize userDict;
-(id)initWithUserID:(NSString*)ID frame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 140)];
    if (self) {
        userID = ID;
        [self requestionUserInformation];
    }
    return self;
}

-(void)viewsSetup{
    UILabel *expTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 200, 30)];
    expTitleLabel.text = @"经验值：";
    expTitleLabel.textColor = SYColor1;
    [expTitleLabel setFont:SYFont15M];
    [self addSubview:expTitleLabel];
    

    UILabel *reviewTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 35, 200, 30)];
    reviewTitleLabel.text = @"评价：";
    reviewTitleLabel.textColor = SYColor1;
    [reviewTitleLabel setFont:SYFont15M];
    [self addSubview:reviewTitleLabel];
    
    
    UILabel *goldenTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 65, 200, 30)];
    goldenTitleLabel.text = @"徽章：";
    goldenTitleLabel.textColor = SYColor1;
    [goldenTitleLabel setFont:SYFont15M];
    [self addSubview:goldenTitleLabel];
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-SYSeparatorHeight, self.frame.size.width, SYSeparatorHeight)];
    separator.backgroundColor = SYSeparatorColor;
    [self addSubview:separator];
    
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
