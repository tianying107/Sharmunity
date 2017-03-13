//
//  DiscoverTradeTakePictureViewController.m
//  Sharmunity
//
//  Created by Star Chen on 3/12/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import "DiscoverTradeTakePictureViewController.h"
#import "DiscoverTradeSellSubmitViewController.h"
#import "SYHeader.h"
@interface DiscoverTradeTakePictureViewController ()

@end

@implementation DiscoverTradeTakePictureViewController

-(void)viewDidLoad{
    [super viewDidLoad];
//    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
//        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.vImagePreview = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.vImagePreview];
    previewImage = [[UIImage alloc] init];
    
    previewBackgroundView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:previewBackgroundView];
    previewImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    previewBackgroundView.hidden = YES;
    [previewBackgroundView addSubview:previewImageView];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
//    if ([_verifyTpye isEqualToString:@"passport"]) {
//        UIView *base3 = [[UIView alloc] initWithFrame:CGRectMake(50, self.view.frame.size.height/15, 50, 5)];
//        base3.backgroundColor = SYColor4;
//        [self.view addSubview:base3];
//        UIView *base4 = [[UIView alloc] initWithFrame:CGRectMake(50, self.view.frame.size.height/15, 5, 50)];
//        base4.backgroundColor = SYColor4;
//        [self.view addSubview:base4];
//        UIView *base5 = [[UIView alloc] initWithFrame:CGRectMake(50, 14*self.view.frame.size.height/15, 50, 5)];
//        base5.backgroundColor = SYColor4;
//        [self.view addSubview:base5];
//        UIView *base6 = [[UIView alloc] initWithFrame:CGRectMake(50, 14*self.view.frame.size.height/15-50, 5, 50)];
//        base6.backgroundColor = SYColor4;
//        [self.view addSubview:base6];
//        UIView *base7 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50-50, self.view.frame.size.height/15, 50, 5)];
//        base7.backgroundColor = SYColor4;
//        [self.view addSubview:base7];
//        UIView *base8 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-55, self.view.frame.size.height/15, 5, 50)];
//        base8.backgroundColor = SYColor4;
//        [self.view addSubview:base8];
//        UIView *base9 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50-50, 14*self.view.frame.size.height/15, 50, 5)];
//        base9.backgroundColor = SYColor4;
//        [self.view addSubview:base9];
//        UIView *base10 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-55, 14*self.view.frame.size.height/15-50, 5, 50)];
//        base10.backgroundColor = SYColor4;
//        [self.view addSubview:base10];
//        
//        /***go back button***/
//        UIButton *goBackButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-42, self.view.frame.size.height/15-10, 10, 10)];
//        [goBackButton setBackgroundImage:[UIImage imageNamed:@"cancelWhite"] forState:UIControlStateNormal];
//        [goBackButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:goBackButton];
//        /***take a photo button***/
//        takePictureButton = [[UIButton alloc] initWithFrame:CGRectMake(30, self.view.frame.size.height/2-32, 64, 64)];
//        [takePictureButton setBackgroundColor:SYColor4];
//        [takePictureButton addTarget:self action:@selector(captureNow) forControlEvents:UIControlEventTouchUpInside];
//        takePictureButton.layer.cornerRadius = takePictureButton.frame.size.height/2;
//        takePictureButton.clipsToBounds = YES;
//        takePictureButton.layer.borderColor = [[UIColor whiteColor] CGColor];
//        takePictureButton.layer.borderWidth = 8;
//        [self.view addSubview:takePictureButton];
//        
//        cancelButton = [[UIButton alloc] initWithFrame:takePictureButton.frame];
//        [cancelButton setImage:[UIImage imageNamed:@"rephotoButton90"] forState:UIControlStateNormal];
//        [cancelButton addTarget:self action:@selector(cancelResponse) forControlEvents:UIControlEventTouchUpInside];
//        [previewBackgroundView addSubview:cancelButton];
//        useButton = [[UIButton alloc] initWithFrame:CGRectMake(38, self.view.frame.size.height/2+32+30, 48, 48)];
//        [useButton setImage:[UIImage imageNamed:@"confirmSolidColor590"] forState:UIControlStateNormal];
//        [useButton addTarget:self action:@selector(useResponse) forControlEvents:UIControlEventTouchUpInside];
//        [previewBackgroundView addSubview:useButton];
//    }
//    else if ([_verifyTpye isEqualToString:@"photo"]){
//        
        UIView *base3 = [[UIView alloc] initWithFrame:CGRectMake(50, self.view.frame.size.height/15, 50, 5)];
        base3.backgroundColor = SYColor4;
        [self.view addSubview:base3];
        UIView *base4 = [[UIView alloc] initWithFrame:CGRectMake(50, self.view.frame.size.height/15, 5, 50)];
        base4.backgroundColor = SYColor4;
        [self.view addSubview:base4];
        UIView *base5 = [[UIView alloc] initWithFrame:CGRectMake(50, 14*self.view.frame.size.height/15, 50, 5)];
        base5.backgroundColor = SYColor4;
        [self.view addSubview:base5];
        UIView *base6 = [[UIView alloc] initWithFrame:CGRectMake(50, 14*self.view.frame.size.height/15-50, 5, 50)];
        base6.backgroundColor = SYColor4;
        [self.view addSubview:base6];
        UIView *base7 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50-50, self.view.frame.size.height/15, 50, 5)];
        base7.backgroundColor = SYColor4;
        [self.view addSubview:base7];
        UIView *base8 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-55, self.view.frame.size.height/15, 5, 50)];
        base8.backgroundColor = SYColor4;
        [self.view addSubview:base8];
        UIView *base9 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50-50, 14*self.view.frame.size.height/15, 50, 5)];
        base9.backgroundColor = SYColor4;
        [self.view addSubview:base9];
        UIView *base10 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-55, 14*self.view.frame.size.height/15-50, 5, 50)];
        base10.backgroundColor = SYColor4;
        [self.view addSubview:base10];
        
        /***go back button***/
        UIButton *goBackButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-12, self.view.frame.size.height/15-10, 10, 10)];
        [goBackButton setBackgroundImage:[UIImage imageNamed:@"cancelWhite"] forState:UIControlStateNormal];
        [goBackButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:goBackButton];
        /***take a photo button***/
        takePictureButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-32, self.view.frame.size.height-100, 64, 64)];
        [takePictureButton setBackgroundColor:SYColor4];
        [takePictureButton addTarget:self action:@selector(captureNow) forControlEvents:UIControlEventTouchUpInside];
        takePictureButton.layer.cornerRadius = takePictureButton.frame.size.height/2;
        takePictureButton.clipsToBounds = YES;
        takePictureButton.layer.borderColor = [[UIColor whiteColor] CGColor];
        takePictureButton.layer.borderWidth = 8;
        [self.view addSubview:takePictureButton];
        
        cancelButton = [[UIButton alloc] initWithFrame:takePictureButton.frame];
        [cancelButton setImage:[UIImage imageNamed:@"rephotoButton"] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelResponse) forControlEvents:UIControlEventTouchUpInside];
        [previewBackgroundView addSubview:cancelButton];
        useButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-24, self.view.frame.size.height-180, 48, 48)];
        [useButton setImage:[UIImage imageNamed:@"confirmSolidColor5"] forState:UIControlStateNormal];
        [useButton addTarget:self action:@selector(useResponse) forControlEvents:UIControlEventTouchUpInside];
        [previewBackgroundView addSubview:useButton];
//    }
}
-(void)goBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
-(void)viewDidAppear:(BOOL)animated
{
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetHigh;
    
    CALayer *viewLayer = self.vImagePreview.layer;
    NSLog(@"viewLayer = %@", viewLayer);
    
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    
    captureVideoPreviewLayer.frame = self.vImagePreview.bounds;
    [self.vImagePreview.layer addSublayer:captureVideoPreviewLayer];
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *device;// = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    for (AVCaptureDevice *tdevice in devices) {
        if ([tdevice position] == AVCaptureDevicePositionBack) {
            device = tdevice;
        }
    }
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        // Handle the error appropriately.
        NSLog(@"ERROR: trying to open camera: %@", error);
    }
    [session addInput:input];
    
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    [session addOutput:stillImageOutput];
    
    [session startRunning];
}
-(IBAction)captureNow {
    takePictureButton.hidden = YES;
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in stillImageOutput.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection)
        {
            break;
        }
    }
    
    NSLog(@"about to request a capture from: %@", stillImageOutput);
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         CFDictionaryRef exifAttachments = CMGetAttachment( imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
         NSInteger intx = 1920;
         NSInteger inty = 1080;
         if (exifAttachments)
         {
             // Do something with the attachments.
             NSLog(@"attachements: %@", exifAttachments);
             NSDictionary *dictionary = (__bridge NSDictionary *)exifAttachments;
             NSString* dx = [dictionary valueForKey:@"PixelXDimension"];
             NSString* dy = [dictionary valueForKey:@"PixelYDimension"];
             intx = [dx integerValue];
             inty = [dy integerValue];
         } else {
             NSLog(@"no attachments");
         }
         
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *image = [[UIImage alloc] initWithData:imageData];
         
         //         [self.view bringSubviewToFront:previewImageView];
         //         CGRect clippedRect  = CGRectMake(10, self.view.frame.size.height/8, self.view.frame.size.width-20, 6*self.view.frame.size.height/8);
         CGRect clippedRect  = CGRectMake(intx/8, 10*inty/self.view.frame.size.width, 6*intx/8, inty-20*inty/self.view.frame.size.width);
         CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], clippedRect);
         UIImage *newImage   = [UIImage imageWithCGImage:imageRef];
         
         previewImage = image;
         previewImageView.image = image;
         previewBackgroundView.hidden = NO;
         
         
         UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
         CGAffineTransform transform;
         switch (orientation) {
             case UIDeviceOrientationPortrait:
                 transform = CGAffineTransformIdentity;
                 break;
             case UIDeviceOrientationPortraitUpsideDown:
                 //transform = CGAffineTransformMakeRotation(180*M_PI/180);
                 transform = CGAffineTransformIdentity;
                 break;
             case UIDeviceOrientationLandscapeLeft:
                 //transform = CGAffineTransformMakeRotation(90*M_PI/180);
                 transform = CGAffineTransformIdentity;
                 previewImage = newImage;
                 break;
             case UIDeviceOrientationLandscapeRight:
                 //transform = CGAffineTransformMakeRotation(-90.0*M_PI/180);
                 transform = CGAffineTransformMakeRotation(180*M_PI/180);
                 break;
             default:
                 transform = CGAffineTransformIdentity;
                 break;
         }

//         previewImageView.transform = transform;
//         CGSize rotatedSize = previewImageView.frame.size;
//         // Create the bitmap context
//         UIGraphicsBeginImageContext(rotatedSize);
//         CGContextRef bitmap = UIGraphicsGetCurrentContext();
//         
//         // Move the origin to the middle of the image so we will rotate and scale around the center.
//         CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
//         
//         //   // Rotate the image context
//         CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
//         
//         // Now, draw the rotated/scaled image into the context
//         CGContextScaleCTM(bitmap, 1.0, -1.0);
//         CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
//         
//         UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//         UIGraphicsEndImageContext();
         [self useResponse];
         
     }];
}
-(void) cancelResponse{
    takePictureButton.hidden = NO;
    previewBackgroundView.hidden = YES;
    
}
-(void) useResponse{
    
    CGSize newSize;
    if (previewImage.size.height>previewImage.size.width) {
        newSize = CGSizeMake(720*previewImage.size.width/previewImage.size.height, 720);
    }
    else{
        newSize = CGSizeMake(720, 720*previewImage.size.height/previewImage.size.width);
    }
    UIImage *newImage = [self imageWithImage:previewImage scaledToSize:newSize];
    NSData *data = UIImageJPEGRepresentation(newImage, 0.8);
    
    DiscoverTradeSellSubmitViewController *viewController = (DiscoverTradeSellSubmitViewController*)_previousController;
    [viewController addImageCompleteAtIndex:_index image:newImage data:data];
    
    if (_needPrice) {
        [self priceResponse];
    }
    else
        [self dismissViewControllerAnimated:YES completion:nil];
//    if ([_previousClass isEqualToString:@"signUp"]) {
//        tcrSignUpViewController *viewController = (tcrSignUpViewController*)_previousController;
//        goSignUpPassport *passportview = (goSignUpPassport*)[viewController.viewArray lastObject];
//        if ([_verifyTpye isEqualToString:@"passport"]) {
//            [passportview setPassport:newImage];
//            [passportview uploadImage:data name:@"myPassport.jpg" url:@"Passport"];
//        }
//        else if ([_verifyTpye isEqualToString:@"photo"]){
//            [passportview setPhoto:newImage];
//            [passportview uploadImage:data name:@"myPhoto.jpg" url:@"Photo"];
//        }
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
//    else if ([_previousClass isEqualToString:@"account"]){
//        verifyMeViewController *viewController = (verifyMeViewController*)_previousController;
//        if ([_verifyTpye isEqualToString:@"passport"]) {
//            [viewController setPassport:newImage];
//            [viewController uploadImage:data name:@"myPassport.jpg" url:@"Passport"];
//        }
//        else if ([_verifyTpye isEqualToString:@"photo"]){
//            [viewController setPhoto:newImage];
//            [viewController uploadImage:data name:@"myPhoto.jpg" url:@"Photo"];
//        }
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
}
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}




-(void)priceResponse{
    SYSuscard *baseView = [[SYSuscard alloc] initWithFullSize];
    baseView.cardBackgroundView.backgroundColor = [UIColor clearColor];
    baseView.scrollView.scrollEnabled = NO;
    baseView.cancelButton.frame = baseView.leftButtonFrame;
    
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:baseView];
    baseView.alpha = 0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.258];
    baseView.alpha = 1;
    [UIView commitAnimations];
    
    /**************content***************/
    UIView *priceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 145)];
    priceView.center = CGPointMake(baseView.cardBackgroundView.center.x, baseView.cardBackgroundView.center.y-40);
    priceView.backgroundColor = SYBackgroundColorExtraLight;
    priceView.layer.cornerRadius = 34;
    priceView.clipsToBounds = YES;
    [baseView addGoSubview:priceView];
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(34, 34, 80, 40)];
    priceLabel.text = @"价格:  $";
    priceLabel.textColor = SYColor1;
    [priceLabel setFont:SYFont20];
    [priceView addSubview:priceLabel];
    priceField = [[UITextField alloc] initWithFrame:CGRectMake(priceLabel.frame.origin.x+priceLabel.frame.size.width, priceLabel.frame.origin.y, 140, priceLabel.frame.size.height)];
    priceField.textColor = SYColor1;
    priceField.keyboardType = UIKeyboardTypeNumberPad;
    [priceField setFont:SYFont20];
    [priceView addSubview:priceField];
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, priceView.frame.size.height/2, priceView.frame.size.width, SYSeparatorHeight)];
    separator.backgroundColor = SYSeparatorColor;
    [priceView addSubview:separator];
    UILabel *freeLabel = [[UILabel alloc] initWithFrame:CGRectMake(34, separator.frame.origin.y, 80, 40)];
    freeLabel.text = @"免费";
    freeLabel.textColor = SYColor1;
    [freeLabel setFont:SYFont20];
    [priceView addSubview:freeLabel];
    freeSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(priceView.frame.size.width/2, freeLabel.frame.origin.y+4, 100, 32)];
    freeSwitch.tintColor = SYColor10;
    [priceView addSubview:freeSwitch];
    
    UIButton *submitButton = [[UIButton alloc] initWithFrame:CGRectMake(priceView.frame.origin.x, priceView.frame.origin.y+priceView.frame.size.height+20, priceView.frame.size.width, 35)];
    submitButton.backgroundColor = SYColor10;
    submitButton.layer.cornerRadius = submitButton.frame.size.height/2;
    submitButton.clipsToBounds = YES;
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton.titleLabel setFont:SYFont20M];
    [submitButton addTarget:self action:@selector(submitPirceResponse) forControlEvents:UIControlEventTouchUpInside];
    [submitButton addTarget:baseView action:@selector(cancelResponse) forControlEvents:UIControlEventTouchUpInside];
    [baseView addGoSubview:submitButton];
}
-(void)submitPirceResponse{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString *priceString;
    BOOL priceAgg=NO;
    if ([freeSwitch isOn]) {
        priceString = @"0";
    }
    else{
        if ([priceField.text isEqualToString:@""]) {
            priceAgg = YES;
            priceString = @"0";
        }
        else{
            priceAgg = NO;
            priceString = priceField.text;
        }
    }
     DiscoverTradeSellSubmitViewController *viewController = (DiscoverTradeSellSubmitViewController*)_previousController;
    [viewController setPrice:priceString priceAgg:priceAgg];
    
}
@end
