//
//  SYActiveMap.h
//  Sharmunity
//
//  Created by st chen on 2017/2/9.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "MapPin.h"
#import "SYAnnotationView.h"
@class SYActiveMap;
@protocol SYActiveMapDelegate <NSObject>

-(void)jobMap:(SYActiveMap*)jobMap didSelectedJobPin:(MKAnnotationView*)jobPin orderNumber:(NSString*)orderNumber;
-(void)jobMap:(SYActiveMap*)jobMap didDeselectedJobPin:(MKAnnotationView*)jobPin orderNumber:(NSString*)orderNumber;

@end
@interface SYActiveMap : MKMapView

@end
