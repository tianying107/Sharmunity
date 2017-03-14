//
//  SYProfileHead.m
//  Sharmunity
//
//  Created by st chen on 2017/2/15.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "SYProfileHead.h"
#import "Header.h"
#import <AWSCore/AWSCore.h>
#import <AWSS3/AWSS3.h>
@implementation SYProfileHead
@synthesize userDict;
-(id)initWithUserID:(NSString*)ID frame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 100)];
    if (self) {
        userID = ID;
        _avatarButton = [UIButton new];
        [self requestionUserInformation];
    }
    return self;
}

-(void)viewsSetup{
    self.backgroundColor = SYBackgroundColorExtraLight;
    
    avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 80, 80)];
    avatarImageView.image = [UIImage imageNamed:@"defaultAvatar"];
    avatarImageView.layer.cornerRadius = 3;
    avatarImageView.clipsToBounds = YES;
    [self addSubview:avatarImageView];
    _avatarButton.frame = avatarImageView.frame;
    [self addSubview:_avatarButton];
    [self requestAvatarFromServer];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(avatarImageView.frame.origin.x*2+avatarImageView.frame.size.width, 10, 200, 40)];
    nameLabel.text = [NSString stringWithFormat:@"昵称: %@",[userDict valueForKey:@"name"]];
    nameLabel.textColor = SYColor1;
    [nameLabel setFont:SYFont15M];
    [self addSubview:nameLabel];
    
    UILabel *signUpLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.size.height+nameLabel.frame.origin.y, 200, nameLabel.frame.size.height)];
    signUpLabel.text = [NSString stringWithFormat:@"注册时间: %@",[userDict valueForKey:@"join_date"]];
    signUpLabel.textColor = SYColor1;
    [signUpLabel setFont:SYFont15M];
    [self addSubview:signUpLabel];
    
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
-(void)requestAvatarFromServer{
    avatarImageView.image = [UIImage imageNamed:@"defaultAvatar"];
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    // Construct the NSURL for the download location.
    NSString *downloadingFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"avatar%@.jpg",userID]];
    NSURL *downloadingFileURL = [NSURL fileURLWithPath:downloadingFilePath];
    
    AWSS3TransferManagerDownloadRequest *downloadRequest = [AWSS3TransferManagerDownloadRequest new];
    
    downloadRequest.bucket = @"sharmunitymobile";
    downloadRequest.key = [NSString stringWithFormat:@"account/Avatar%@.jpg",userID];
    downloadRequest.downloadingFileURL = downloadingFileURL;
    // Download the file.
    [[transferManager download:downloadRequest] continueWithExecutor:[AWSExecutor mainThreadExecutor]
                                                           withBlock:^id(AWSTask *task) {
                                                               if (task.error){
                                                                   if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                                                                       switch (task.error.code) {
                                                                           case AWSS3TransferManagerErrorCancelled:
                                                                           case AWSS3TransferManagerErrorPaused:
                                                                               break;
                                                                           default:
                                                                               NSLog(@"Error: %@", task.error);
                                                                               break;
                                                                       }
                                                                   } else {
                                                                       NSLog(@"Error: %@", task.error);
                                                                   }
                                                               }
                                                               
                                                               if (task.result) {
                                                                   avatarImageView.image = ([UIImage imageWithContentsOfFile:downloadingFilePath])?[UIImage imageWithContentsOfFile:downloadingFilePath]:[UIImage imageNamed:@"defaultAvatar"];
                                                               }
                                                               return nil;
                                                           }];
    
}
@end
