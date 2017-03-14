//
//  DiscoverArticalDetailViewController.m
//  Sharmunity
//
//  Created by Star Chen on 3/13/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import "DiscoverArticalDetailViewController.h"
#import "Header.h"
#import "SYHeader.h"
#import <AWSCore/AWSCore.h>
#import <AWSS3/AWSS3.h>
@interface DiscoverArticalDetailViewController ()

@end

@implementation DiscoverArticalDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = SYBackgroundColorExtraLight;
    
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mainScrollView.backgroundColor = SYBackgroundColorExtraLight;
    [self.view addSubview:mainScrollView];
    
    [self requestShareFromServer];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"SYBackColor5"] forState:UIControlStateNormal];
    [backBtn setTitleColor:SYColor1 forState:UIControlStateNormal];
    [backBtn.titleLabel setFont:SYFont15];
    [backBtn setTitle:@"找攻略" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backBtn.bounds = CGRectMake(0, 0, 80, 40);
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;

}
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) viewWillAppear:(BOOL)animated{
    mainScrollView.delegate=self;
    [self scrollViewDidScroll:mainScrollView];
}
-(void) viewDidAppear:(BOOL)animated{
    [mainScrollView setScrollEnabled:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewsSetup{
    viewsArray = [NSMutableArray new];
    float viewWidth = mainScrollView.frame.size.width;
    float originX = 30;
    
    /*introduction*/
    introductionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 50)];
    NSMutableAttributedString *attributeSting = [[NSMutableAttributedString alloc] initWithString:[[shareDict valueForKey:@"keyword"] valueForKey:@"introduction"] attributes:@{NSFontAttributeName:SYFont15,NSForegroundColorAttributeName:SYColor1}];
    NSMutableParagraphStyle *paragraphstyle = [[NSMutableParagraphStyle alloc] init];
    paragraphstyle.lineSpacing = 2.f;
    [attributeSting addAttribute:NSParagraphStyleAttributeName value:paragraphstyle range:NSMakeRange(0, attributeSting.length)];
    CGRect rect = [attributeSting boundingRectWithSize:(CGSize){viewWidth-2*originX, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    float height = rect.size.height;
    UILabel *introductionLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, height)];
    introductionLabel.attributedText = attributeSting;
    introductionLabel.numberOfLines = 0;
    [introductionView addSubview:introductionLabel];
    CGRect frame = introductionView.frame;
    frame.size.height = height + 20;
    
    /*select image*/
    imageSelectView = [[UIView alloc] init];
    float imageHeight = 0;
    for (int i=0; i<[[[shareDict valueForKey:@"keyword"] valueForKey:@"images"] integerValue]; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, imageHeight, viewWidth-originX*2, 0.7*(viewWidth-originX*2))];
        imageView.tag = 10+i;
        imageHeight += imageView.frame.size.height+10;
        [imageSelectView addSubview:imageView];
    }
    imageSelectView.frame = CGRectMake(0, 0, viewWidth, imageHeight);
    [self requestImageFromServerAtIndex];
    
    
    
    
    [mainScrollView addSubview:introductionView];
    [viewsArray addObject:introductionView];
    [mainScrollView addSubview:imageSelectView];
    [viewsArray addObject:imageSelectView];
    
    [self viewsLayout];
}
-(void)viewsLayout{
    float height = 20;
    for (UIView *view in viewsArray){
        CGRect frame = view.frame;
        frame.origin.y = height;
        [view setFrame:frame];
        height += frame.size.height;
    }
    mainScrollView.contentSize = CGSizeMake(0, height+20+44+10);
}


-(void)requestShareFromServer{
    NSString *requestQuery = [NSString stringWithFormat:@"share_id=%@",_shareID];
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
                                            [self viewsSetup];
                                        });
                                        
                                    }];
    [task resume];
}

-(void)requestImageFromServerAtIndex{
    for (int i = 0; i<imageNumbers; i++) {
        UIImageView *imageView = [imageSelectView viewWithTag:10+i];
            AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
            // Construct the NSURL for the download location.
            NSString *downloadingFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%d.jpg",_shareID,i]];
            NSURL *downloadingFileURL = [NSURL fileURLWithPath:downloadingFilePath];
            
            AWSS3TransferManagerDownloadRequest *downloadRequest = [AWSS3TransferManagerDownloadRequest new];
            
            downloadRequest.bucket = @"sharmunitymobile";
            downloadRequest.key = [NSString stringWithFormat:@"discover/share/%@-%d.jpg",_shareID,i];
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
                                                                           imageView.image = [UIImage imageWithContentsOfFile:downloadingFilePath];
                                                                       }
                                                                       return nil;
                                                                   }];
            
        }
}
@end
