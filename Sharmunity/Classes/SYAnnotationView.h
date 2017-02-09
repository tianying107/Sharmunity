//
//  SYAnnotationView.h
//  Sharmunity
//
//  Created by st chen on 2017/2/9.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface SYAnnotationView : MKAnnotationView
-(void)addCallout:(UIView*)calloutView;
@property (weak, nonatomic) NSDictionary *orderDict;
@property UIView *calloutView;
@end
