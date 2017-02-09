//
//  SYAnnotationView.m
//  Sharmunity
//
//  Created by st chen on 2017/2/9.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "SYAnnotationView.h"
#import "Header.h"
@implementation SYAnnotationView

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    UIView* hitView = [super hitTest:point withEvent:event];
    if (hitView != nil)
    {
        [self.superview bringSubviewToFront:self];
    }
    return hitView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect rect = self.bounds;
    BOOL isInside = CGRectContainsPoint(rect, point);
    if(!isInside)
    {
        for (UIView *view in self.subviews)
        {
            isInside = CGRectContainsPoint(view.frame, point);
            if(isInside)
                break;
        }
    }
    return isInside;
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    NSLog(@"select");
}
- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    // Get the custom callout view.
    UIView *calloutView = [[UIView alloc] init];
    [calloutView drawRect:CGRectMake(0, 0, 20, 20)];
    calloutView.backgroundColor = SYColor5;
    if (selected) {
        CGRect annotationViewBounds = self.bounds;
        CGRect calloutViewFrame = calloutView.frame;
        // Center the callout view above and to the right of the annotation view.
        calloutViewFrame.origin.x = -(calloutViewFrame.size.width - annotationViewBounds.size.width) * 0.5;
        calloutViewFrame.origin.y = 0;
        calloutView.frame = calloutViewFrame;
        
        [self addSubview:calloutView];
    } else {
        [calloutView removeFromSuperview];
    }
}


-(void)addCallout:(UIView*)calloutView{
    [self addSubview:calloutView];
}

@end
