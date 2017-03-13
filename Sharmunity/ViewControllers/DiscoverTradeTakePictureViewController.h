//
//  DiscoverTradeTakePictureViewController.h
//  Sharmunity
//
//  Created by Star Chen on 3/12/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Header.h"
#import <ImageIO/ImageIO.h>
@interface DiscoverTradeTakePictureViewController : UIViewController{
    AVCaptureStillImageOutput *stillImageOutput;
    UIImage *previewImage;
    UIImageView *previewImageView;
    UIView *previewBackgroundView;
    UIButton *useButton;
    UIButton *cancelButton;
    UIButton *takePictureButton;
    
    
    UISwitch *freeSwitch;
    UITextField *priceField;
}
//+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
@property(nonatomic, retain) IBOutlet UIView *vImagePreview;
@property NSString *previousClass;
@property NSString *verifyTpye;
@property NSData *passportData;
@property NSData *photoData;
@property UIViewController *previousController;
//@property id passportView;

@property BOOL needPrice;
@property NSInteger index;
@end
