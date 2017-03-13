//
//  DiscoverTradeListViewController.h
//  Sharmunity
//
//  Created by Star Chen on 3/12/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscoverTradeListViewController : UIViewController<UIScrollViewDelegate>{
    NSString *MEID;
    NSArray *shareIDArray;
    NSMutableArray *sharesArray;
    NSInteger currentButtonIndex;
    float heightCount;
    BOOL scrollReady;
}
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIButton *sellButton;

-(void)reloadButtonsWithArray:(NSArray*)array;
@end
