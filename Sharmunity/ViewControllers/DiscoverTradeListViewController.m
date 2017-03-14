//
//  DiscoverTradeListViewController.m
//  Sharmunity
//
//  Created by Star Chen on 3/12/17.
//  Copyright © 2017 Sharmunity. All rights reserved.
//

#import "DiscoverTradeListViewController.h"
#import "Header.h"
#import "SYHeader.h"
#import "SYDiscoverTradeBasicView.h"
#import "DiscoverTradeDetailViewController.h"
#import "DiscoverTradeSellSubmitViewController.h"
#import "DiscoverTradeSortViewController.h"
@interface DiscoverTradeListViewController ()<SYDiscoverTradeBasicViewDelegate>

@end

@implementation DiscoverTradeListViewController
@synthesize mainScrollView;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"交易";
    
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
    
    [self requestShareFromServer];
    
    _sellButton.layer.cornerRadius = _sellButton.frame.size.height/2;
    _sellButton.clipsToBounds = YES;
    [_sellButton addTarget:self action:@selector(takePictureResponse) forControlEvents:UIControlEventTouchUpInside];
    
    scrollReady = NO;
    currentButtonIndex = 0;
    heightCount = 0;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"SYBackColor5"] forState:UIControlStateNormal];
    [backBtn setTitle:@"我要求助" forState:UIControlStateNormal];
    [backBtn setTitleColor:SYColor1 forState:UIControlStateNormal];
    [backBtn.titleLabel setFont:SYFont15];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backBtn.bounds = CGRectMake(0, 0, 80, 40);
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIButton *sortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sortBtn setImage:[UIImage imageNamed:@"sortIcon"] forState:UIControlStateNormal];
    [sortBtn addTarget:self action:@selector(sortResponse) forControlEvents:UIControlEventTouchUpInside];
    sortBtn.bounds = CGRectMake(0, 0, 40, 40);
    sortBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem *sortButton = [[UIBarButtonItem alloc] initWithCustomView:sortBtn] ;
    self.navigationItem.rightBarButtonItem = sortButton;
    
}
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) viewWillAppear:(BOOL)animated{
    mainScrollView.delegate=self;
    [self scrollViewDidScroll:mainScrollView];
}
-(void) viewDidAppear:(BOOL)animated{
    [mainScrollView setScrollEnabled:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollReady&&scrollView.contentOffset.y+mainScrollView.bounds.size.height>scrollView.contentSize.height-50) {
        [self addButtons];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addButtons{
    NSInteger start = currentButtonIndex;
    float splitPoint = mainScrollView.frame.size.width*0.35;
    float cellHeight = splitPoint*1.23;
    if (start<shareIDArray.count-1) {
        float feedback = 0;
        for (NSInteger i = start; i<MIN(start+10, shareIDArray.count); i++) {
            NSString *shareID = [shareIDArray objectAtIndex:i];
            NSInteger remain = i%4;
            CGRect cellFrame;
            switch (remain) {
                case 0:
                    cellFrame = CGRectMake(0, heightCount, mainScrollView.frame.size.width-splitPoint, cellHeight);
                    feedback = cellHeight;
                    break;
                case 1:
                    cellFrame = CGRectMake(mainScrollView.frame.size.width-splitPoint, heightCount, splitPoint, cellHeight);
                    feedback = cellHeight;
                    break;
                case 2:
                    cellFrame = CGRectMake(0, heightCount+cellHeight, splitPoint, cellHeight);
                    feedback = 2*cellHeight;
                    break;
                case 3:
                    cellFrame = CGRectMake(splitPoint, heightCount+cellHeight, mainScrollView.frame.size.width-splitPoint, cellHeight);
                    heightCount += 2*cellHeight;
                    feedback = 0;
                    break;
                default:
                    break;
            }
            SYDiscoverTradeBasicView *view = [[SYDiscoverTradeBasicView alloc] initWithFrame:cellFrame shareID:shareID];
            view.imageButton.tag = i;
            view.delegate = self;
            [mainScrollView addSubview:view];
            
            
            currentButtonIndex ++;
        }
        
        mainScrollView.contentSize = CGSizeMake(0, heightCount+feedback);
        if (mainScrollView.contentSize.height > mainScrollView.bounds.size.height) {
            scrollReady = YES;
        }
    }
    
}
-(void)takePictureResponse{
    DiscoverTradeSellSubmitViewController *viewController = [DiscoverTradeSellSubmitViewController new];
    [self.navigationController pushViewController:viewController animated:NO];
    [viewController addImageAtIndex:0];
}
-(void)tradeBasicView:(SYDiscoverTradeBasicView *)basicView didSelected:(UIButton *)selectedButton image:(UIImage *)image{
    NSString *selectedShareID = basicView.shareID;
    
    if ([selectedShareID isEqualToString:@"tradeMoney"]) {
        
    }
    else{
        DiscoverTradeDetailViewController *viewController = [DiscoverTradeDetailViewController new];
        viewController.shareID = selectedShareID;
        viewController.firstImage = image;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}
-(void)sortResponse{
    DiscoverTradeSortViewController *viewController = [DiscoverTradeSortViewController new];
    viewController.previousController = self;
    [self.navigationController pushViewController:viewController animated:YES];
}
-(void)requestShareFromServer{
    shareIDArray = [NSArray new];
    MEID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
//    NSString *requestQuery = [NSString stringWithFormat:@"category=6&latitude=%f&longitude=%f&distance=50",self.locationManager.location.coordinate.latitude,self.locationManager.location.coordinate.longitude];
    NSString *requestQuery = @"category=6";
    NSString *urlString = [NSString stringWithFormat:@"%@searchshare?%@",basicURL,requestQuery];
    NSLog(@"%@",requestQuery);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionTask *task = [session dataTaskWithURL:url
                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                        NSArray *array = [NSJSONSerialization JSONObjectWithData:data
                                                                                         options:kNilOptions
                                                                                           error:&error];
                                        
                                        NSMutableArray *muArray = [[NSMutableArray alloc] initWithArray:array];
                                        
                                        NSLog(@"server said: %@",array);
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            
                                            [muArray insertObject:@"tradeMoney" atIndex:MIN(2, muArray.count)];
                                            
                                            shareIDArray = muArray;
                                            [self addButtons];
                                            
                                        });
                                        
                                    }];
    [task resume];
}

-(void)reloadButtonsWithArray:(NSArray*)array{
    for (UIView *view in mainScrollView.subviews){
        [view removeFromSuperview];
    }
    scrollReady = NO;
    currentButtonIndex = 0;
    heightCount = 0;
    
    shareIDArray = array;
    [self addButtons];
}

@end
