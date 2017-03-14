//
//  DiscoverTradeSellSubmitViewController.m
//  Sharmunity
//
//  Created by Star Chen on 3/12/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import "DiscoverTradeSellSubmitViewController.h"
#import "DiscoverTradeTakePictureViewController.h"
#import "DiscoverLocationViewController.h"
#import "Header.h"
#import "SYHeader.h"
#import <AWSCore/AWSCore.h>
#import <AWSS3/AWSS3.h>
@interface DiscoverTradeSellSubmitViewController (){
    SYPopOut *popOut;
}

@end

@implementation DiscoverTradeSellSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SYBackgroundColorExtraLight;
    self.navigationItem.title = @"";
    
    imageArray = [NSMutableArray new];
    is_first = YES;
    
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mainScrollView.delegate = self;
    mainScrollView.backgroundColor = SYBackgroundColorExtraLight;
    [self.view addSubview:mainScrollView];
    
    MEID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
    
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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    
    popOut = [SYPopOut new];
    [self dataSetup];
    [self viewsSetup];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dismissKeyboard {
    UITextField *textField = [titleView viewWithTag:11];
    [textField resignFirstResponder];
    UITextView *textView = [introductionView viewWithTag:11];
    [textView resignFirstResponder];
}

-(void)dataSetup{
    is_other = NO;
    /*type data*/
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"TradeType_cn"
                                                         ofType:@"txt"];
    NSString *categoryString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    typeArray = [NSArray new];
    typeArray = [categoryString componentsSeparatedByString:@","];
}
-(void)viewsSetup{
    viewsArray = [NSMutableArray new];
    float viewWidth = mainScrollView.frame.size.width;
    float originX = 30;
    
    
    /*image select view*/
    float cellWidth = (viewWidth-2*originX-9)/3;
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
    
    
    
    
    /*location*/
    locationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 60)];
    UILabel *locationTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 140, 40)];
    locationTitleLabel.text = @"位置";
    locationTitleLabel.textColor = SYColor1;
    [locationTitleLabel setFont:SYFont20];
    [locationView addSubview:locationTitleLabel];
    UIButton *locationButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 40)];
    locationButton.tag = 11;
    [locationButton setTitleColor:SYColor1 forState:UIControlStateNormal];
    [locationButton.titleLabel setFont:SYFont15];
    locationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [locationButton addTarget:self action:@selector(locationResponse) forControlEvents:UIControlEventTouchUpInside];
    locationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [locationView addSubview:locationButton];
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:self.locationManager.location.coordinate.latitude longitude:self.locationManager.location.coordinate.longitude];
    [ceo reverseGeocodeLocation:loc
              completionHandler:^(NSArray *placemarks, NSError *error) {
                  CLPlacemark *placemark = [placemarks objectAtIndex:0];
                  [locationButton setTitle:placemark.locality forState:UIControlStateNormal];
              }
     ];
    
    /*activity type*/
    typeView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, viewWidth, 90)];
    UILabel *typeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 110, 40)];
    typeTitleLabel.text = @"分类";
    typeTitleLabel.textColor = SYColor1;
    [typeTitleLabel setFont:SYFont20];
    //    typeTitleLabel.textAlignment = NSTextAlignmentRight;
    [typeView addSubview:typeTitleLabel];
    UIButton *typeButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 40)];
    [typeButton setTitleColor:SYColor3 forState:UIControlStateNormal];
    [typeButton setTitleColor:SYColor1 forState:UIControlStateSelected];
    [typeButton.titleLabel setFont:SYFont15];
    [typeButton setTitle:@"请选择分类" forState:UIControlStateNormal];
    typeButton.tag = 11;
    typeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [typeButton addTarget:self action:@selector(typeResponse:) forControlEvents:UIControlEventTouchUpInside];
    [typeView addSubview:typeButton];
    typePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216, self.view.frame.size.width, 216)];
    typePickerView.delegate = self;
    typePickerView.dataSource = self;
    typePickerView.backgroundColor = [UIColor whiteColor];
    typePickerView.hidden = YES;
    [self.view addSubview:typePickerView];
    confirmBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216-30, self.view.frame.size.width, 30)];
    confirmBackgroundView.hidden = YES;
    confirmBackgroundView.backgroundColor = [UIColor whiteColor];
    confirmBackgroundView.tag = 9013;
    [self.view addSubview:confirmBackgroundView];
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(confirmBackgroundView.frame.size.width-60, 0, 40, 30)];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:SYColor1 forState:UIControlStateNormal];
    //    [confirmButton.titleLabel setFont:goFont15S];
    [confirmButton addTarget:self action:@selector(pickerConfirmResponse) forControlEvents:UIControlEventTouchUpInside];
    [confirmBackgroundView addSubview:confirmButton];
    CALayer *layer = confirmBackgroundView.layer;
    layer.masksToBounds = NO;
    layer.shadowOffset = CGSizeMake(0, -2);
    layer.shadowColor = [UIColorFromRGB(0xBBBBBB) CGColor];
    layer.shadowRadius = 2;
    layer.shadowOpacity = .25f;
    layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
    
    
    /*title*/
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 50)];
    SYTextField *textfield = [[SYTextField alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 40) type:SYTextFieldHelp];
    textfield.tag = 11;
    textfield.placeholder = @"标题（必填）";
    [titleView addSubview:textfield];
    
    /*introduction*/
    introductionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 110)];
    SYTextView *textView = [[SYTextView alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 90) type:SYTextFieldHelp];
    textView.tag = 11;
    [textView setPlaceholder:@"内容 (选填)"];
    [introductionView addSubview:textView];
    
    /*price*/
    priceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    UILabel *priceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, 100, 40)];
    priceTitleLabel.text = @"价格";
    priceTitleLabel.textColor = SYColor1;
    [priceTitleLabel setFont:SYFont20];
    [priceView addSubview:priceTitleLabel];
    SYTextField *upperTextField = [[SYTextField alloc] initWithFrame:CGRectMake(viewWidth-originX-50, 2.5, 50, 35) type:SYTextFieldSeparator];
    upperTextField.tag = 11;
    upperTextField.textAlignment = NSTextAlignmentRight;
    upperTextField.keyboardType = UIKeyboardTypeNumberPad;
    [priceView addSubview:upperTextField];
    UILabel *middleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 40, 60, 40)];
    middleLabel.text = @"免费";
    middleLabel.textColor = SYColor1;
    [middleLabel setFont:SYFont20];
    [priceView addSubview:middleLabel];
    UISwitch *freeSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(viewWidth-originX-50, 40+4, 50, 32)];
    freeSwitch.tag = 12;
    freeSwitch.tintColor = SYColor10;
    [priceView addSubview:freeSwitch];
    
    
    
    nextButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 35)];
    [nextButton setTitle:@"提交" forState:UIControlStateNormal];
    [nextButton setBackgroundColor:SYColor10];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton.titleLabel setFont:SYFont20M];
    [nextButton addTarget:self action:@selector(nextResponse) forControlEvents:UIControlEventTouchUpInside];
    nextButton.layer.cornerRadius = nextButton.frame.size.height/2;
    nextButton.clipsToBounds = YES;
    
    
    
    
    
    [mainScrollView addSubview:imageSelectView];
    [viewsArray addObject:imageSelectView];
    [mainScrollView addSubview:priceView];
    [viewsArray addObject:priceView];
    [mainScrollView addSubview:titleView];
    [viewsArray addObject:titleView];
    [mainScrollView addSubview:introductionView];
    [viewsArray addObject:introductionView];
    [mainScrollView addSubview:locationView];
    [viewsArray addObject:locationView];
    [mainScrollView addSubview:typeView];
    [viewsArray addObject:typeView];
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
-(void)locationResponse{
    //    [self dismissKeyboard];
    [self pickerConfirmResponse];
    
    DiscoverLocationViewController *viewController = [DiscoverLocationViewController new];
    viewController.previousController = self;
    viewController.needDistance = NO;
    viewController.nextControllerType = SYDiscoverNextHelp;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)locationCompleteResponse{
    UIButton *locationButton = [locationView viewWithTag:11];
    locationButton.selected = YES;
    [locationButton setTitle:[[[_selectedItem placemark] addressDictionary] valueForKey:@"Street"] forState:UIControlStateSelected];
}
- (void)pickerConfirmResponse{
    confirmBackgroundView.hidden = YES;
    typePickerView.hidden = YES;
}
-(IBAction)typeResponse:(id)sender{
    UIButton *button = sender;
    button.selected = YES;
    if (!typeString) {
        typeString = @"0";
        [button setTitle:[typeArray objectAtIndex:0] forState:UIControlStateSelected];
    }
    typePickerView.hidden = NO;
    confirmBackgroundView.hidden = NO;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    float result;
    if ([pickerView isEqual:typePickerView]) {
        result = typeArray.count;
    }
    return result;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component{
    NSString *resultString = [NSString new];
    if ([pickerView isEqual:typePickerView]) {
        resultString = [typeArray objectAtIndex:row];
    }
    return resultString;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if ([pickerView isEqual:typePickerView]) {
        is_other = (row==typeArray.count-1)?YES:NO;
        UIButton *typeButton = [typeView viewWithTag:11];
        [typeButton setTitle:[typeArray objectAtIndex:row] forState:UIControlStateSelected];
        typeString = (row==typeArray.count-1)?@"99":[NSString stringWithFormat:@"%02ld",row];
        
    }
}
-(IBAction)addImageResponse:(id)sender{
    UIButton *button = sender;
    if ([button isSelected]) {
        [self addImageAtIndex:button.tag];
    }
    else{
        [self addImageAtIndex:1+imageArray.count];
    }
    
}
-(void)addImageAtIndex:(NSInteger)index{
    DiscoverTradeTakePictureViewController *viewController = [DiscoverTradeTakePictureViewController new];
    if (index) {
        viewController.index = index;
        viewController.needPrice = NO;
    }
    else{
        viewController.index = 1;
        viewController.needPrice = YES;
    }
    viewController.previousController = self;
    [self presentViewController:viewController animated:YES completion:nil];
    
}
-(void)addImageCompleteAtIndex:(NSInteger)index image:(UIImage*)image data:(NSData*)data{
    [imageArray insertObject:data atIndex:index-1];
    UIButton *imageButton = [imageSelectView viewWithTag:index];
    imageButton.selected = YES;
    [imageButton setImage:image forState:UIControlStateSelected];
    
}
-(void)setPrice:(NSString*)price priceAgg:(BOOL)agg{
    UISwitch *freeSwitch = [priceView viewWithTag:12];
    UITextField *priceField = [priceView viewWithTag:11];
    [freeSwitch setOn:(![price integerValue]&&!agg)];
    priceField.text = (agg)?@"面谈":[NSString stringWithFormat:@"$%@",price];
    [priceField setUserInteractionEnabled:NO];
    [freeSwitch setUserInteractionEnabled:NO];
    priceString = price;
    priceAgg = agg;
    
}

-(void)nextResponse{
    NSString *subCate = [NSString stringWithFormat:@"01%@0000",typeString];
    NSString *latitude;
    NSString *longitude;
    latitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
    longitude = [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.longitude];
    if (_selectedItem) {
        latitude = [NSString stringWithFormat:@"%lf",[[_selectedItem placemark] coordinate].latitude];
        longitude = [NSString stringWithFormat:@"%lf",[[_selectedItem placemark] coordinate].longitude];
    }
    UITextField *title = [titleView viewWithTag:11];
    UITextView *introduction = [introductionView viewWithTag:11];
    
    NSString *requestBody = [NSString stringWithFormat:@"expire_date=2099-01-01&email=%@&latitude=%@&longitude=%@&category=6&subcate=%@&title=%@&introduction=%@&price=%@&changeable=%d&is_other=%d&images=%ld",MEID,latitude,longitude,subCate,title.text, introduction.text,priceString,priceAgg,is_other,imageArray.count];
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
-(void)submitHandle:(NSDictionary*)dict{
    BOOL success =[[dict valueForKey:@"success"] boolValue];
    NSString *shareID = [dict valueForKey:@"share_id"];
    if (success){
        /*insert S3 upload function here*/
        [self uploadImagesWithID:shareID];
    }
    else [popOut showUpPop:SYPopDiscoverShareFail];
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
}
- (void)uploadComplete{
    completeImages ++;
    if (completeImages == imageArray.count) {
        [popOut showUpPop:SYPopDiscoverShareSuccess];
                [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
@end
