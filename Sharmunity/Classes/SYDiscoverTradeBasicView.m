//
//  SYDiscoverTradeBasicView.m
//  Sharmunity
//
//  Created by Star Chen on 3/12/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import "SYDiscoverTradeBasicView.h"
#import "Header.h"
#import <AWSCore/AWSCore.h>
#import <AWSS3/AWSS3.h>
@implementation SYDiscoverTradeBasicView
@synthesize imageButton, shareID;
-(id)initWithFrame:(CGRect)frame shareID:(NSString*)ID{
    self = [super initWithFrame:frame];
    if (self) {
        shareID = ID;
        imageButton = [UIButton new];
        [self viewSetup];
    }
    return self;
}
-(void)viewSetup{
    self.backgroundColor = SYBackgroundColorExtraLight;
    imageButton.frame = CGRectMake(5, 5, self.frame.size.width-10, self.frame.size.height-10);
    imageButton.layer.cornerRadius = 10;
    imageButton.clipsToBounds = YES;
    [[imageButton imageView] setContentMode: UIViewContentModeScaleAspectFill];
    [imageButton addTarget:self action:@selector(imageButtonSelected) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:imageButton];
    [self requestImage];
    
    
}

-(void)requestImage{
    if ([shareID isEqualToString:@"tradeMoney"]) {
        imageButton.backgroundColor = SYColor7;
        [imageButton setImage:[UIImage imageNamed:@"tradeMoney"] forState:UIControlStateNormal];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, (self.frame.size.height-40)/2)];
        titleLabel.text = @" 换钱?";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [titleLabel setFont:SYFont25];
        titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:titleLabel];
    }
    else{
        AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
        // Construct the NSURL for the download location.
        NSString *downloadingFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-0.jpg",shareID]];
        NSURL *downloadingFileURL = [NSURL fileURLWithPath:downloadingFilePath];
        
        AWSS3TransferManagerDownloadRequest *downloadRequest = [AWSS3TransferManagerDownloadRequest new];
        
        downloadRequest.bucket = @"sharmunitymobile";
        downloadRequest.key = [NSString stringWithFormat:@"discover/share/%@-0.jpg",shareID];
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
                                                                        [imageButton setImage:[UIImage imageWithContentsOfFile:downloadingFilePath] forState:UIControlStateNormal];
                                                                   }
                                                                   return nil;
                                                               }];
    }
    
    
}
-(void)imageButtonSelected{
    [self.delegate tradeBasicView:self didSelected:imageButton image:imageButton.imageView.image];
}
@end
