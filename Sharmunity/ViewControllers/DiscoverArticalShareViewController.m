//
//  DiscoverEatArticalShareViewController.m
//  Sharmunity
//
//  Created by st chen on 2017/2/28.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "DiscoverArticalShareViewController.h"
#import "Header.h"
#import "SYHeader.h"
#import <AWSCore/AWSCore.h>
#import <AWSS3/AWSS3.h>
@interface DiscoverArticalShareViewController (){
    SYPopOut *popOut;
}

@end

@implementation DiscoverArticalShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    switch (_shareType) {
        case discoverEat:
            self.navigationItem.title = @"吃货攻略";
            break;
        case discoverPlay:
            self.navigationItem.title = @"上传攻略";
            break;
            
        default:
            break;
    }
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: SYColor1,
                                                                    NSFontAttributeName: SYFont20};
    self.view.backgroundColor = SYBackgroundColorExtraLight;
    
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
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
    
    
    MEID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [mainScrollView addGestureRecognizer:tap];
    
    popOut = [SYPopOut new];
    [self viewsSetup];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"SYBackColor4"] forState:UIControlStateNormal];
    [backBtn setTitleColor:SYColor1 forState:UIControlStateNormal];
    [backBtn.titleLabel setFont:SYFont15];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backBtn.bounds = CGRectMake(0, 0, 80, 40);
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    subCate = [NSString new];
    switch (_shareType) {
        case discoverEat:
            [backBtn setTitle:@"吃" forState:UIControlStateNormal];
            subCate = @"03000000";
            break;
        case discoverLive:
            [backBtn setTitle:@"住" forState:UIControlStateNormal];
            break;
        case discoverLearn:
            [backBtn setTitle:@"学" forState:UIControlStateNormal];
            break;
        case discoverPlay:
            [backBtn setTitle:@"玩" forState:UIControlStateNormal];
            subCate = @"02000000";
            break;
        case discoverTravel:
            [backBtn setTitle:@"行" forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }

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
    
    
    /*title*/
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 50)];
    [mainScrollView addSubview:titleView];
    [viewsArray addObject:titleView];
    SYTextField *textfield = [[SYTextField alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 40) type:SYTextFieldShare];
    textfield.tag = 11;
    textfield.placeholder = @"标题";
    [titleView addSubview:textfield];
    
    /*introduction*/
    introductionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 400)];
    [mainScrollView addSubview:introductionView];
    [viewsArray addObject:introductionView];
    SYTextView *textView = [[SYTextView alloc] initWithFrame:CGRectMake(originX, 10, viewWidth-2*originX, 355) type:SYTextViewShare];
    textView.tag = 11;
    [textView setPlaceholder:@"提供服务介绍"];
    [introductionView addSubview:textView];
    
    /*image select view*/
    float cellWidth = (viewWidth-2*originX-9)/3;
    imageArray = [NSMutableArray new];
    imageSelectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, cellWidth*0.8*2+3+20)];
    UIButton *imageButton1 = [[UIButton alloc] initWithFrame:CGRectMake(originX, 0, cellWidth, cellWidth*0.8)];
    [imageButton1 setImage:[UIImage imageNamed:@"addImageButton"] forState:UIControlStateNormal];
    [imageButton1 addTarget:self action:@selector(addImageResponse:) forControlEvents:UIControlEventTouchUpInside];
    imageButton1.tag = 1;
    imageButton1.layer.cornerRadius = 8;
    imageButton1.clipsToBounds = YES;
    [[imageButton1 imageView] setContentMode: UIViewContentModeScaleAspectFill];
    [imageSelectView addSubview:imageButton1];
    UIButton *imageButton2 = [[UIButton alloc] initWithFrame:CGRectMake((viewWidth-cellWidth)/2, 0, cellWidth, cellWidth*0.8)];
    [imageButton2 setImage:[UIImage imageNamed:@"addImageButton"] forState:UIControlStateNormal];
    [imageButton2 addTarget:self action:@selector(addImageResponse:) forControlEvents:UIControlEventTouchUpInside];
    imageButton2.tag = 2;
    imageButton2.layer.cornerRadius = 8;
    imageButton2.clipsToBounds = YES;
    [[imageButton2 imageView] setContentMode: UIViewContentModeScaleAspectFill];
    [imageSelectView addSubview:imageButton2];
    UIButton *imageButton3 = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth-originX-cellWidth, 0, cellWidth, cellWidth*0.8)];
    [imageButton3 setImage:[UIImage imageNamed:@"addImageButton"] forState:UIControlStateNormal];
    [imageButton3 addTarget:self action:@selector(addImageResponse:) forControlEvents:UIControlEventTouchUpInside];
    imageButton3.tag = 3;
    imageButton3.layer.cornerRadius = 8;
    imageButton3.clipsToBounds = YES;
    [[imageButton3 imageView] setContentMode: UIViewContentModeScaleAspectFill];
    [imageSelectView addSubview:imageButton3];
    UIButton *imageButton4 = [[UIButton alloc] initWithFrame:CGRectMake(originX, cellWidth*0.8+3, cellWidth, cellWidth*0.8)];
    [imageButton4 setImage:[UIImage imageNamed:@"addImageButton"] forState:UIControlStateNormal];
    [imageButton4 addTarget:self action:@selector(addImageResponse:) forControlEvents:UIControlEventTouchUpInside];
    imageButton4.tag = 4;
    imageButton4.layer.cornerRadius = 8;
    imageButton4.clipsToBounds = YES;
    [[imageButton4 imageView] setContentMode: UIViewContentModeScaleAspectFill];
    [imageSelectView addSubview:imageButton4];
    UIButton *imageButton5 = [[UIButton alloc] initWithFrame:CGRectMake((viewWidth-cellWidth)/2, cellWidth*0.8+3, cellWidth, cellWidth*0.8)];
    [imageButton5 setImage:[UIImage imageNamed:@"addImageButton"] forState:UIControlStateNormal];
    [imageButton5 addTarget:self action:@selector(addImageResponse:) forControlEvents:UIControlEventTouchUpInside];
    imageButton5.tag = 5;
    imageButton5.layer.cornerRadius = 8;
    imageButton5.clipsToBounds = YES;
    [[imageButton5 imageView] setContentMode: UIViewContentModeScaleAspectFill];
    [imageSelectView addSubview:imageButton5];
    UIButton *imageButton6 = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth-originX-cellWidth, cellWidth*0.8+3, cellWidth, cellWidth*0.8)];
    [imageButton6 setImage:[UIImage imageNamed:@"addImageButton"] forState:UIControlStateNormal];
    [imageButton6 addTarget:self action:@selector(addImageResponse:) forControlEvents:UIControlEventTouchUpInside];
    imageButton6.tag = 6;
    imageButton6.layer.cornerRadius = 8;
    imageButton6.clipsToBounds = YES;
    [[imageButton6 imageView] setContentMode: UIViewContentModeScaleAspectFill];
    [imageSelectView addSubview:imageButton6];
    [mainScrollView addSubview:imageSelectView];
    [viewsArray addObject:imageSelectView];
    
    /*next button*/
    nextButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 32)];
    [nextButton setTitle:@"提交" forState:UIControlStateNormal];
    [nextButton setBackgroundColor:SYColor4];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton.titleLabel setFont:SYFont20M];
    [nextButton addTarget:self action:@selector(nextResponse) forControlEvents:UIControlEventTouchUpInside];
    nextButton.layer.cornerRadius = 8;
    nextButton.clipsToBounds = YES;
    [mainScrollView addSubview:nextButton];
    [viewsArray addObject:nextButton];
    
    
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

- (void)nextResponse{
    UITextField *title = [titleView viewWithTag:11];
    UITextView *introduction = [introductionView viewWithTag:11];
    NSString *requestBody = [NSString stringWithFormat:@"email=%@&latitude=%f&longitude=%f&category=%ld&subcate=%@&title=%@&introduction=%@&price=0&images=%ld",MEID,self.locationManager.location.coordinate.latitude,self.locationManager.location.coordinate.longitude,_shareType,subCate,title.text,introduction.text,imageArray.count];
    NSLog(@"%@/n",requestBody);
    /*改上面的 query 和 URLstring 就好了*/
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@newshare",basicURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [requestBody dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:&error];
        NSLog(@"server said: %@",dict);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self submitHandle:dict];
        });
    }];
    [task resume];
}
-(void)dismissKeyboard {
    UITextView *textField = [introductionView viewWithTag:11];
    [textField resignFirstResponder];
    UITextField *title = [titleView viewWithTag:11];
    [title resignFirstResponder];
}

-(void)submitHandle:(NSDictionary*)dict{
    if ([[dict valueForKey:@"success"] boolValue]){
        NSString *shareID = [dict valueForKey:@"share_id"];
        [self uploadImagesWithID:shareID];
    }
    else [popOut showUpPop:SYPopDiscoverShareFail];
    
}






/*image*/
-(IBAction)addImageResponse:(id)sender{
    UIButton *button = sender;
    if ([button isSelected]) {
        selectedIndex = button.tag;
//        [self addImageAtIndex:button.tag];
    }
    else{
        selectedIndex = 1+imageArray.count;
//        [self addImageAtIndex:1+imageArray.count];
    }
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
        UIImage *newHeadImg = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    CGSize newSize;
    if (newHeadImg.size.height>newHeadImg.size.width) {
        newSize = CGSizeMake(720*newHeadImg.size.width/newHeadImg.size.height, 720);
    }
    else{
        newSize = CGSizeMake(720, 720*newHeadImg.size.height/newHeadImg.size.width);
    }
    UIImage *newImage = [self imageWithImage:newHeadImg scaledToSize:newSize];
    NSData *data = UIImageJPEGRepresentation(newImage, 0.8);
    
        UIButton *imageButton = [imageSelectView viewWithTag:selectedIndex];
    [imageButton setImage: newImage forState:UIControlStateNormal];
    [imageArray addObject:data];
        [picker dismissViewControllerAnimated:YES completion:nil];
    
}
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)uploadImagesWithID:(NSString*)shareID{
    completeImages = 0;
    nextButton.enabled = NO;
    for (int i=0; i<imageArray.count; i++) {
        NSData *data = [imageArray objectAtIndex:i];
        NSString* path = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%d.jpg",shareID,i]];
        [data writeToFile:path atomically:YES];
        NSURL *file = [NSURL fileURLWithPath:path];
        
        AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
        // next we set up the S3 upload request manager
        AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
        // set the bucket
        uploadRequest.bucket = @"sharmunitymobile";
        uploadRequest.key = [NSString stringWithFormat:@"discover/share/%@-%d.jpg",shareID,i];
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
    if (imageArray.count==0) {
        [popOut showUpPop:SYPopDiscoverShareSuccess];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
- (void)uploadComplete{
    completeImages ++;
    if (completeImages == imageArray.count) {
        [popOut showUpPop:SYPopDiscoverShareSuccess];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
@end
