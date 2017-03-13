//
//  SYArticalAbstract.h
//  Sharmunity
//
//  Created by Star Chen on 3/13/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYArticalAbstract : UIView{
    NSString *shareID;
    NSDictionary *shareDict;
    UIImageView *headImage;
}
- (id)initWithFrame:(CGRect)frame shareID:(NSString*)ID;
@end
