//
//  SingleImageEditor.m
//  Sharmunity
//
//  Created by Star Chen on 3/13/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import "SingleImageEditor.h"
#import "Header.h"
#import "UIImage+Resize.h"
#import <AWSCore/AWSCore.h>
#import <AWSS3/AWSS3.h>
#import "AccountMainViewController.h"

@implementation SingleImageEditor
@synthesize outputSize;
- (void)viewDidLoad{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = SYColor1;
    
    // back BUTTON
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.bounds = CGRectMake(0, 0, 48, 48);
    [backButton setImage:[UIImage imageNamed:@"SYBackBackground"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    // confirm BUTTON
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.bounds = CGRectMake(0, 0, 48, 48);
    [confirmButton setImage:[UIImage imageNamed:@"confirmCircle"] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(pickResult:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *selectItem = [[UIBarButtonItem alloc] initWithCustomView:confirmButton];
    [self.navigationItem setRightBarButtonItem:selectItem];
    
    
    // IMAGE
    
    UIImage *ferrariImage = _inputImage;
    
    // STENCIL VIEW
    CGRect frame1,frame2;
    switch (_imageTpye) {
        case SYImageTpyeAvatar:
            frame1 = CGRectMake(0, 0, self.view.frame.size.width, self.view.center.y-self.view.frame.size.width/2-10);
            frame2 = CGRectMake(0, self.view.center.y+self.view.frame.size.width/2, self.view.frame.size.width, self.view.center.y-self.view.frame.size.width/2);
            break;
//        case goImageTpyeBackground:
//            frame1 = CGRectMake(0, 0, self.view.frame.size.width, self.view.center.y-1.12*self.view.frame.size.width/2-10);
//            frame2 = CGRectMake(0, self.view.center.y+1.12*self.view.frame.size.width/2-10, self.view.frame.size.width, self.view.center.y-1.12*self.view.frame.size.width/2+10);
//            break;
        default:
            break;
    }
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    stencilView1 = [[UIVisualEffectView alloc] initWithEffect:blur];
    stencilView1.frame = frame1;
    stencilView1.backgroundColor = [SYColor5 colorWithAlphaComponent:0.2];
    stencilView2 = [[UIVisualEffectView alloc] initWithEffect:blur];
    stencilView2.frame = frame2;
    stencilView2.backgroundColor = [SYColor5 colorWithAlphaComponent:0.2];
    
    // SCROLL VIEW
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, frame1.origin.y+frame1.size.height, self.view.frame.size.width, frame2.origin.y-frame1.origin.y-frame1.size.height)];
    scrollView.minimumZoomScale = MAX(self.view.frame.size.width/ferrariImage.size.width, self.view.frame.size.width/ferrariImage.size.height);
    scrollView.maximumZoomScale = 2.0f;
    scrollView.delegate = self;
    scrollView.pagingEnabled = NO;
    scrollView.clipsToBounds = NO;
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    
    
    // BASE VIEW
    
    baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ferrariImage.size.width, ferrariImage.size.height)];
    baseView.backgroundColor = [UIColor whiteColor];
    
    // IMAGE VIEW
    
    imageView = [[UIImageView alloc] initWithImage:ferrariImage];
    imageView.frame = CGRectMake(0, 0, baseView.frame.size.width, baseView.frame.size.height);
    
    [self.view addSubview:scrollView];
    [self.view addSubview:stencilView1];
    [self.view addSubview:stencilView2];
    
    
    [scrollView addSubview:baseView];
    [baseView addSubview:imageView];
    
    
    scrollView.zoomScale = MIN(self.view.frame.size.width/ferrariImage.size.width, self.view.frame.size.height/ferrariImage.size.height); // for some reason this should be set last?
    scrollView.contentSize = CGSizeMake(baseView.frame.size.width, baseView.frame.size.height);
    scrollView.contentInset = UIEdgeInsetsMake(-65, 0, -60, 0);
}
- (void)goback{
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithType:(NSInteger)type{
    self = [super init];
    if (self) {
        _imageTpye = type;
    }
    return self;
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)ascrollView{
    return baseView;
}

- (void)pickResult:(id)sender{
    acceptButton.enabled = NO;
    
    specialEffectsView.alpha = 1.0f;
    [UIView animateWithDuration:1.0f animations:^{
        specialEffectsView.alpha = 0;
    } completion:^(BOOL finished) {
        infoLabel.alpha = 1.0f;
        [UIView animateWithDuration:1.0f animations:^{
            infoLabel.alpha = 0;
            acceptButton.enabled = YES;
        }];
    }];
    
    // 1. hide stencil overlay
    
    //    stencilView.hidden = YES;
    
    // 2. take a screenshot of the whole screen
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 3);//(self.view.frame.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 3. pick interesting area and crop
    CGRect frame;
    switch (_imageTpye) {
        case SYImageTpyeAvatar:
            frame = CGRectMake(0, 3*(self.view.center.y-self.view.frame.size.width/2-10), 3*self.view.frame.size.width, 3*self.view.frame.size.width);
            break;
//        case goImageTpyeBackground:
//            frame = CGRectMake(0, 3*(self.view.center.y-1.12*self.view.frame.size.width/2-10), 3*self.view.frame.size.width, 3*1.12*self.view.frame.size.width);
//            break;
        default:
            break;
    }
    CGImageRef imageRef = CGImageCreateWithImageInRect([screenshot CGImage],
                                                       frame);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    // 4. just for fun, resize image by factor 2
    CGSize size;
    NSString *urlString = [NSString new];
    switch (_imageTpye) {
        case SYImageTpyeAvatar:
            size = CGSizeMake(110, 110);
            urlString = @"Avatar";
            break;
//        case goImageTpyeBackground:
//            size = CGSizeMake(415, 465);
//            urlString = @"Background";
//            break;
        default:
            break;
    }
    _outputImage = [croppedImage resizedImageToSize:
                    size];
    
    //    // 5. save result to photo gallery
    if (_outputImage != nil){
        NSString* path = [NSString new];
        switch (_imageTpye) {
            case SYImageTpyeAvatar:
                path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"myAvatar.jpg"];
                break;
//            case goImageTpyeBackground:
//                path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"myBackground.jpg"];
//                break;
            default:
                break;
        }
        
        
        NSData* data = UIImageJPEGRepresentation(_outputImage, .7); //UIImagePNGRepresentation(_outputImage);
        [data writeToFile:path atomically:YES];
    }
    NSString* path = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"my%@.jpg",urlString]];
    NSURL *file = [NSURL fileURLWithPath:path];
    
    if (_MEID) {
//        [loading startLoading];
        AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
        // next we set up the S3 upload request manager
        AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
        // set the bucket
        uploadRequest.bucket = @"sharmunitymobile";
        uploadRequest.key = [NSString stringWithFormat:@"account/%@%@.jpg",urlString,_MEID];
        uploadRequest.body = file;
        uploadRequest.ACL =   AWSS3ObjectCannedACLAuthenticatedRead;
        [[transferManager upload:uploadRequest] continueWithExecutor:[AWSExecutor mainThreadExecutor]
                                                           withBlock:^id(AWSTask *task) {
                                                               if (task.error) {
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
                                                                       // Unknown error.
                                                                       NSLog(@"Error: %@", task.error);
                                                                   }
                                                               }
                                                               
                                                               if (task.result) {
                                                                   [self uploadComplete];
                                                               }
                                                               return nil;
                                                           }];
        
    }
    
}

- (void)uploadComplete{
    // 6. show stencil view again
    NSArray* navigationStackArray = self.navigationController.viewControllers;
    AccountMainViewController *viewController = [navigationStackArray objectAtIndex:navigationStackArray.count-2];
    switch (_imageTpye) {
        case SYImageTpyeAvatar:
            [(UIButton*)_senderObject setImage:_outputImage forState:UIControlStateNormal];
            break;
//        case goImageTpyeBackground:
//            viewController.backgroundImage = _outputImage;
//            break;
        default:
            break;
    }
    
    [self.navigationController popToViewController:viewController animated:YES];
}

@end
