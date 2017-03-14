//
//  SingleImageEditor.h
//  Sharmunity
//
//  Created by Star Chen on 3/13/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>


#define SYImageTpyeAvatar 21
#define SYImageTpyeBackground 22
@interface SingleImageEditor : UIViewController<UIScrollViewDelegate>{
    UIButton *acceptButton;
    UIScrollView *scrollView;
    UIView *baseView;
    //    UIImageView *stencilView;
    UIImageView *imageView;
    UIView *specialEffectsView;
    UILabel *infoLabel;
    UIVisualEffectView *stencilView1;
    UIVisualEffectView *stencilView2;
}
- (id)initWithType:(NSInteger)type;
@property UIImage *inputImage;
@property UIImage *outputImage;
@property CGSize *outputSize;
@property NSInteger imageTpye;
@property NSString *MEID;

@property id previousController;
@property id senderObject;
@end
