//
//  AccountMainViewController.m
//  Sharmunity
//
//  Created by st chen on 2017/1/20.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "AccountMainViewController.h"
#import "SingleImageEditor.h"
#import "SYHeader.h"
@interface AccountMainViewController (){
    SYProfileHead *SYHeadView;
    SYProfileExtend *extendView;
}

@end

@implementation AccountMainViewController
@synthesize headView,mainScrollView;
- (void)viewDidLoad {
    [super viewDidLoad];
    MEID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
    // Do any additional setup after loading the view.
    mainScrollView.backgroundColor = SYBackgroundColorExtraLight;
    [self.view addSubview:mainScrollView];
    
    [self viewsSetup];
}
-(void) viewWillAppear:(BOOL)animated{
    mainScrollView.delegate=self;
    [self scrollViewDidScroll:mainScrollView];
    mainScrollView.contentSize = CGSizeMake(0, 1000);
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
    [_logoutButton addTarget:self action:@selector(logOutResponse) forControlEvents:UIControlEventTouchUpInside];
    
    SYHeadView = [[SYProfileHead alloc] initWithUserID:MEID frame:CGRectMake(0, 0, headView.frame.size.width, 0)];
    [headView addSubview:SYHeadView];
    [SYHeadView.avatarButton addTarget:self action:@selector(pickAvatarFromPhotoLibrary) forControlEvents:UIControlEventTouchUpInside];
    
    extendView = [[SYProfileExtend alloc] initWithUserID:MEID frame:CGRectMake(0, SYHeadView.frame.size.height, headView.frame.size.width, 0)];
    extendView.backgroundColor = SYBackgroundColorExtraLight;
//    unextend = heightCount-extendView.frame.size.height;
//    extend = heightCount;
//    extendView.frame = CGRectMake(0, unextend, extendView.frame.size.width, extendView.frame.size.height);
    [headView addSubview:extendView];
}
-(void)logOutResponse{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"admin"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"appliedOrder"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *docPath = [NSString new];
    docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSError *error;
    if ([fileManager fileExistsAtPath:docPath])
    {
        [fileManager removeItemAtPath:docPath error:&error];
    }
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"myHeadAvatar.jpg"];
    if ([fileManager fileExistsAtPath:path])
    {
        [fileManager removeItemAtPath:path error:&error];
    }
    path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"myBackground.jpg"];
    if ([fileManager fileExistsAtPath:path])
    {
        [fileManager removeItemAtPath:path error:&error];
    }
    
    
    UIViewController *viewController = (UIViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"WelcomeNavigator"];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)pickAvatarFromPhotoLibrary {
    avaterPicker = [[UIImagePickerController alloc] init];
    avaterPicker.delegate = self;
    avaterPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:avaterPicker animated:YES completion:nil];
}
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if (picker == avaterPicker) {
        UIImage *newHeadImg = [info valueForKey:UIImagePickerControllerOriginalImage];
        
//        [SYHeadView.avatarButton setImage: newHeadImg forState:UIControlStateNormal];
        //    [headImgButton setImage: newHeadImg forState:UIControlStateNormal];
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        SingleImageEditor *viewController = [[SingleImageEditor alloc] initWithType:SYImageTpyeAvatar];
        viewController.MEID = MEID;
        viewController.inputImage = newHeadImg;
        viewController.senderObject = SYHeadView.avatarButton;
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}
@end
