//
//  SYArticalAbstract.m
//  Sharmunity
//
//  Created by Star Chen on 3/13/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import "SYArticalAbstract.h"
#import "Header.h"
@implementation SYArticalAbstract

- (id)initWithFrame:(CGRect)frame shareID:(NSString*)ID{
    self = [super initWithFrame:frame];
    if (self) {
        shareID = ID;
        
        [self requestShareFromServer];
    }
    return self;
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
                                        //                                        NSLog(@"server said: %@",dict);
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            shareDict = dict;
                                            [self viewSetup];
                                        });
                                        
                                    }];
    [task resume];
}
- (void)viewSetup{
    float width = self.frame.size.width;
    //Head Image
    UIImageView *cateIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 25, 25)];
    cateIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"cate%@Help",[shareDict valueForKey:@"category"]]];
    cateIcon.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:cateIcon];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, self.frame.size.width-35, 20)];
    titleLabel.text = [[shareDict valueForKey:@"keyword"] valueForKey:@"title"];
    titleLabel.textColor = SYColor1;
    [titleLabel setFont:SYFont15];
    [self addSubview:titleLabel];
    
    UILabel *postLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 28, self.frame.size.width, 15)];
    postLabel.text = [shareDict valueForKey:@"post_date"];
    postLabel.textColor = SYColor3;
    [postLabel setFont: SYFont11];
    [self addSubview:postLabel];
    

}
@end
