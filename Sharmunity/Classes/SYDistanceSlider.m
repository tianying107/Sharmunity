//
//  SYDistanceSlider.m
//  Sharmunity
//
//  Created by st chen on 2017/2/9.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "SYDistanceSlider.h"
#import "Header.h"
@implementation SYDistanceSlider
@synthesize distanceSlider;
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self basicSetup];
    }
    return self;
}
- (void)basicSetup{
    [self setUserInteractionEnabled:YES];
    distanceArray = [NSArray arrayWithObjects:@"1",@"5",@"10",@"20",@"50", nil];
    _distanceInteger = 3;
    _distanceString = [NSString stringWithFormat:@"%ld",_distanceInteger];
    UIImageView *sliderTrackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 14+25-6.5, self.frame.size.width-30, 13)];
    sliderTrackImageView.image = [UIImage imageNamed:@"sliderTrackImage2"];
    [self addSubview:sliderTrackImageView];
    for (int i = 0; i<distanceArray.count; i++) {
        UILabel *sliderIndicater = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
        sliderIndicater.text = [NSString stringWithFormat:@"%@mile",distanceArray[i]];
        sliderIndicater.textAlignment = NSTextAlignmentCenter;
        sliderIndicater.textColor = SYColor1;
        [sliderIndicater setFont:[UIFont fontWithName:@"SFUIDisplay-Bold" size:10]];
        sliderIndicater.center = CGPointMake(20+i*(sliderTrackImageView.frame.size.width-10)/(distanceArray.count-1), sliderIndicater.center.y);
        [self addSubview:sliderIndicater];
    }
    distanceSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 14, self.frame.size.width, 50)];
    distanceSlider.userInteractionEnabled = YES;
    [self addSubview:distanceSlider];
    [distanceSlider setMinimumValue:10];
    [distanceSlider setMaximumValue:14];
    [distanceSlider setValue:10];
    [distanceSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [distanceSlider setThumbImage:[UIImage imageNamed:@"sliderThumbImageSmall"] forState:UIControlStateNormal];
    [distanceSlider setMinimumTrackImage:[UIImage new] forState:UIControlStateNormal];
    [distanceSlider setMaximumTrackImage:[UIImage new] forState:UIControlStateNormal];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, distanceSlider.frame.size.height+distanceSlider.frame.origin.y);
}
- (void)setdistanceWithString:(NSString*)distanceString{
    if (distanceString) {
        _distanceString = distanceString;
        _distanceInteger = [_distanceString integerValue];
        NSInteger distan = [distanceArray indexOfObject:_distanceString]+10;
        [distanceSlider setValue:distan];
    }
}
- (void)setdistanceWithInteger:(NSInteger)distanceInteger{
    _distanceInteger = distanceInteger;
    _distanceString = [NSString stringWithFormat:@"%ld",(long)_distanceInteger];
    [distanceSlider setValue:[distanceArray indexOfObject:_distanceString]+10];
}
- (IBAction)sliderValueChanged:(id)sender{
    //    UISlider *distanceSlider = sender;
    if (distanceSlider.value<10.5) {
        [distanceSlider setValue:10];
    }
    else if (distanceSlider.value>=10.5 && distanceSlider.value<11.5){
        [distanceSlider setValue:11];
    }
    else if (distanceSlider.value>=11.5 && distanceSlider.value<12.5){
        [distanceSlider setValue:12];
    }
    else if (distanceSlider.value>=12.5 && distanceSlider.value<13.5){
        [distanceSlider setValue:13];
    }
    else{
        [distanceSlider setValue:14];
    }
    //    NSLog(@"%lf",distanceSlider.value-10);
    _distanceInteger = [distanceArray[(NSInteger)distanceSlider.value-10] integerValue];
    _distanceString = [NSString stringWithFormat:@"%ld",(long)_distanceInteger];
}


@end
