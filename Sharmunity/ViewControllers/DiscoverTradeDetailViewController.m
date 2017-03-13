//
//  DiscoverTradeDetailViewController.m
//  Sharmunity
//
//  Created by Star Chen on 3/12/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import "DiscoverTradeDetailViewController.h"
#import "Header.h"
#import "SYHeader.h"
#import <AWSCore/AWSCore.h>
#import <AWSS3/AWSS3.h>
@interface DiscoverTradeDetailViewController ()

@end

@implementation DiscoverTradeDetailViewController
@synthesize shareID;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SYBackgroundColorExtraLight;
    
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mainScrollView.delegate = self;
    mainScrollView.backgroundColor = SYBackgroundColorExtraLight;
    [self.view addSubview:mainScrollView];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
        
    }
    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
    if (authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
        authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
    }
    
    [self requestShareFromServer];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"SYBackColor5"] forState:UIControlStateNormal];
    [backBtn setTitle:@"交易" forState:UIControlStateNormal];
    [backBtn setTitleColor:SYColor1 forState:UIControlStateNormal];
    [backBtn.titleLabel setFont:SYFont15];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backBtn.bounds = CGRectMake(0, 0, 80, 40);
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
}
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewsSetup{
    [self requestPersonFromServer];
    float viewWidth = mainScrollView.frame.size.width;
    float originX = 23;
    float heightCount = 0;
    
    /*image pages*/
    imagePageScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, heightCount, viewWidth, 320)];
    imagePageScroller.backgroundColor = [UIColor blackColor];
    [mainScrollView addSubview:imagePageScroller];
    imagePageScroller.pagingEnabled = YES;
    imagePageScroller.contentSize =
    CGSizeMake(viewWidth * imageNumbers,0);
    imagePageScroller.showsHorizontalScrollIndicator = NO;
    imagePageScroller.showsVerticalScrollIndicator = NO;
    imagePageScroller.scrollsToTop = NO;
    imagePageScroller.delegate = self;
    for (int i = 0; i<imageNumbers; i++) {
        UIImageView *showcaseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*viewWidth, 0, viewWidth, imagePageScroller.frame.size.height)];
        showcaseImageView.tag = 10+i;
        [showcaseImageView setContentMode:UIViewContentModeScaleAspectFit];
        [imagePageScroller addSubview:showcaseImageView];
        
    }
    heightCount += imagePageScroller.frame.size.height;
    [self requestImageFromServerAtIndex];

    
    /*price*/
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, heightCount-40, 120, 40)];
    priceLabel.text = [NSString stringWithFormat:@"$%@",[shareDict valueForKey:@"price"]];
    priceLabel.textColor = [UIColor whiteColor];
    [priceLabel setFont:SYFont20];
    [mainScrollView addSubview:priceLabel];
    
    /*avatar*/
    avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth-originX-40, heightCount-20, 40, 40)];
    avatarImageView.layer.cornerRadius = avatarImageView.frame.size.height/2;
    avatarImageView.clipsToBounds = YES;
    avatarImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    avatarImageView.layer.borderWidth = 2;
    [mainScrollView addSubview:avatarImageView];
    [self requestAvatarFromServer];
    
    /*Title*/
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, heightCount+40, viewWidth-2*originX, 25)];
    titleLabel.text = [shareDict valueForKey:@"title"];
    titleLabel.textColor = SYColor1;
    [titleLabel setFont:SYFont20];
    [mainScrollView addSubview:titleLabel];
    heightCount += titleLabel.frame.size.height+40;
    
    /*post DATE*/
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, heightCount, viewWidth-2*originX, 20)];
    dateLabel.text = [shareDict valueForKey:@"post_date"];
    dateLabel.textColor = SYColor4;
    [dateLabel setFont:SYFont13];
    [mainScrollView addSubview:dateLabel];
    
    
    /*function buttons*/
    UIView *functionView = [[UIView alloc] initWithFrame:CGRectMake(originX, heightCount, viewWidth-2*originX, 40)];
    [mainScrollView addSubview:functionView];
    /*3 buttons*/
//    UIButton *messageButton = [[UIButton alloc] initWithFrame:CGRectMake(functionView.frame.size.width-120, 10, 40, 40)];
//    [messageButton setImage:[UIImage imageNamed:@"choiceMsgButton"] forState:UIControlStateNormal];
//    [messageButton addTarget:self action:@selector(writeCommentResponse) forControlEvents:UIControlEventTouchUpInside];
//    [functionView addSubview: messageButton];
    
//    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(functionView.frame.size.width-80, 10, 40, 40)];
//    [shareButton setImage:[UIImage imageNamed:@"choiceShareButton"] forState:UIControlStateNormal];
//    [functionView addSubview: shareButton];
    
    UIButton *contactButton = [[UIButton alloc] initWithFrame:CGRectMake(functionView.frame.size.width-40, 10, 40, 40)];
    [contactButton addTarget:self action:@selector(contactReponse) forControlEvents:UIControlEventTouchUpInside];
    [contactButton setImage:[UIImage imageNamed:@"choiceContactButton"] forState:UIControlStateNormal];
    [functionView addSubview: contactButton];
    heightCount += functionView.frame.size.height;
    
    /*introduction*/
    NSMutableAttributedString *attributeSting = [[NSMutableAttributedString alloc] initWithString:[shareDict valueForKey:@"introduction"] attributes:@{NSFontAttributeName:SYFont15,NSForegroundColorAttributeName:SYColor1}];
    NSMutableParagraphStyle *paragraphstyle = [[NSMutableParagraphStyle alloc] init];
    paragraphstyle.lineSpacing = 2.f;
    [attributeSting addAttribute:NSParagraphStyleAttributeName value:paragraphstyle range:NSMakeRange(0, attributeSting.length)];
    CGRect rect = [attributeSting boundingRectWithSize:(CGSize){viewWidth-2*originX, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    float height = rect.size.height;
    UILabel *introductionLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, heightCount+20, viewWidth-2*originX, height)];
    introductionLabel.attributedText = attributeSting;
    introductionLabel.numberOfLines = 0;
    [mainScrollView addSubview:introductionLabel];
    heightCount += introductionLabel.frame.size.height+20;
    
    /*distance label*/
    UILabel *distance1Label = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth-originX-100, heightCount, 100, 40)];
    distance1Label.textColor = SYColor1;
    distance1Label.text = @"英里";
    distance1Label.textAlignment = NSTextAlignmentRight;
    [distance1Label setFont:SYFont15];
    [mainScrollView addSubview:distance1Label];
    UILabel *distance2Label = [[UILabel alloc] initWithFrame:CGRectMake(distance1Label.frame.origin.x-100, heightCount, 100, 40)];
    distance2Label.textColor = SYColor1;
    distance2Label.text = @"距离";
    distance2Label.textAlignment = NSTextAlignmentRight;
    [distance2Label setFont:SYFont15];
    [mainScrollView addSubview:distance2Label];
    UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(distance1Label.frame.origin.x, heightCount, 60, 40)];
    distanceLabel.textColor = SYColor4;
    distanceLabel.textAlignment = NSTextAlignmentCenter;
    [distanceLabel setFont:SYFont15];
    [mainScrollView addSubview:distanceLabel];
    CLLocation* helpeeLocation = [[CLLocation alloc] initWithLatitude:[[shareDict valueForKey:@"latitude"] floatValue] longitude:[[shareDict valueForKey:@"longitude"] floatValue]];
    CLLocationDistance meters = [helpeeLocation distanceFromLocation:self.locationManager.location];
    distanceLabel.text = [NSString stringWithFormat:@"%.1f",meters/1600];
    heightCount += distance1Label.frame.size.height;
    
    /*map view*/
    SYMap *mapView = [[SYMap alloc] initWithFrame:CGRectMake(originX, heightCount, viewWidth-2*originX, 110) ];
    [mapView setLocationWithLatitude:[[shareDict valueForKey:@"latitude"] floatValue] longitude:[[shareDict valueForKey:@"longitude"] floatValue]];
    [mapView addMapPinAnnotation:[[shareDict valueForKey:@"latitude"] floatValue] longitude:[[shareDict valueForKey:@"longitude"] floatValue]];
    [mainScrollView addSubview:mapView];
    heightCount += mapView.frame.size.height;
    
    /*social media*/
    
    
    
    mainScrollView.contentSize = CGSizeMake(0, heightCount+66);
}

-(void)requestShareFromServer{
    shareDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"4500",@"price",@"红色丰田卡罗拉2003年",@"title",@"红色丰田卡罗拉，2003年产，现在走了11.5万迈， Clean title。回国急卖，价格还可商量。",@"introduction",@"37.781834",@"latitude",@"-122.406417",@"longitude",@"2017/3/8/ 15:30",@"post_date",@"starfrombeijing@gmail.com",@"owner_id", nil];
    imageNumbers = 2;
    
    [self viewsSetup];
}
-(void)requestImageFromServerAtIndex{
    for (int i = 0; i<imageNumbers; i++) {
        UIImageView *imageView = [imagePageScroller viewWithTag:10+i];
        if (i == 0) {
            imageView.image = _firstImage;
        }
        else{
            AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
            // Construct the NSURL for the download location.
            NSString *downloadingFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%d.jpg",shareID,i]];
            NSURL *downloadingFileURL = [NSURL fileURLWithPath:downloadingFilePath];
            
            AWSS3TransferManagerDownloadRequest *downloadRequest = [AWSS3TransferManagerDownloadRequest new];
            
            downloadRequest.bucket = @"sharmunitymobile";
            downloadRequest.key = [NSString stringWithFormat:@"discover/share/%@-%d.jpg",shareID,i];
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
}
-(void)requestAvatarFromServer{
    avatarImageView.image = [UIImage imageNamed:@"defaultAvatar"];
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    // Construct the NSURL for the download location.
    NSString *downloadingFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"avatar%@.jpg",[shareDict valueForKey:@"owner_id"]]];
    NSURL *downloadingFileURL = [NSURL fileURLWithPath:downloadingFilePath];
    
    AWSS3TransferManagerDownloadRequest *downloadRequest = [AWSS3TransferManagerDownloadRequest new];
    
    downloadRequest.bucket = @"sharmunitymobile";
    downloadRequest.key = [NSString stringWithFormat:@"account/%@.jpg",[shareDict valueForKey:@"owner_id"]];
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
-(void)requestPersonFromServer{
    NSString *requestQuery = [NSString stringWithFormat:@"email=%@",[shareDict valueForKey:@"owner_id"]];
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
//                                            nameLabel.text = [personDict valueForKey:@"name"];
//                                            (helpChoice)?[self helpChoiceSetup]:[self shareChoiceSetup];
                                        });
                                        
                                    }];
    [task resume];
}
-(void)contactReponse{
    SYSuscard *baseView = [[SYSuscard alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen]bounds].size.height) withCardSize:CGSizeMake(320, 240) keyboard:NO];
    baseView.cardBackgroundView.backgroundColor = SYBackgroundColorExtraLight;
    baseView.scrollView.scrollEnabled = NO;
    baseView.backButton.hidden = YES;
    
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:baseView];
    baseView.alpha = 0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.258];
    baseView.alpha = 1;
    [UIView commitAnimations];
    
    /**************content***************/
    float originX = 20;
    float heightCount = 0;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, heightCount, baseView.cardSize.width, 60)];
    heightCount += titleLabel.frame.size.height;
    titleLabel.text = @"联系方式";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setFont:SYFont15S];
    titleLabel.textColor = SYColor1;
    [baseView addGoSubview:titleLabel];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, heightCount, baseView.cardSize.width, 40)];
    nameLabel.text = [personDict valueForKey:@"name"];
    [nameLabel setFont:SYFont15S];
    nameLabel.textColor = SYColor4;
    [baseView addGoSubview:nameLabel];
    heightCount += nameLabel.frame.size.height;
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, heightCount, baseView.cardSize.width, 40)];
    phoneLabel.text = [NSString stringWithFormat:@"联系电话：%@",[personDict valueForKey:@"phone"]];
    [phoneLabel setFont:SYFont13];
    phoneLabel.textColor = SYColor1;
    [baseView addGoSubview:phoneLabel];
    heightCount += phoneLabel.frame.size.height;
    
    UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, heightCount, baseView.cardSize.width, 40)];
    emailLabel.text = [NSString stringWithFormat:@"联系邮箱：%@",[personDict valueForKey:@"email"]];
    [emailLabel setFont:SYFont13];
    emailLabel.textColor = SYColor1;
    [baseView addGoSubview:emailLabel];
    
    UIButton *emailButton = [[UIButton alloc] initWithFrame:emailLabel.frame];
    [emailButton addTarget:self action:@selector(emailResponse) forControlEvents:UIControlEventTouchUpInside];
    [baseView addGoSubview:emailButton];
}
-(void)emailResponse{
    
}
@end
