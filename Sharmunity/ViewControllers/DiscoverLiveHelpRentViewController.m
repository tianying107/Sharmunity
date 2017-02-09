//
//  DiscoverLiveHelpRentViewController.m
//  Sharmunity
//
//  Created by st chen on 2017/2/9.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "DiscoverLiveHelpRentViewController.h"
#import "DiscoverLocationViewController.h"
#import "Header.h"
@interface DiscoverLiveHelpRentViewController ()

@end

@implementation DiscoverLiveHelpRentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"租房子";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: SYColor1,
                                                                    NSFontAttributeName: SYFont20S};
    self.view.backgroundColor = SYBackgroundColorExtraLight;
    
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mainScrollView.backgroundColor = SYBackgroundColorExtraLight;
    [self.view addSubview:mainScrollView];
    
    MEID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
    _helpDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:MEID,@"email",@"2",@"category",@"2099-01-01",@"expire_date",@"0",@"distance", nil];
    
    /*room type data*/
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"roomType"
                                                         ofType:@"txt"];
    NSString *categoryString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    roomTypeArray = [[NSArray alloc] init];
    roomTypeArray = [categoryString componentsSeparatedByString:@","];
    
    [self viewsSetup];
}
-(void) viewWillAppear:(BOOL)animated{
    mainScrollView.delegate=self;
    [self scrollViewDidScroll:mainScrollView];
}
-(void) viewDidAppear:(BOOL)animated{
    [mainScrollView setScrollEnabled:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewsSetup{
    viewsArray = [NSMutableArray new];
    float viewWidth = mainScrollView.frame.size.width;
    float originX = 30;
    
    /*share rent*/
    shareRentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    [mainScrollView addSubview:shareRentView];
    [viewsArray addObject:shareRentView];
    UIButton *shareRentButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 20, 150, 60)];
    [shareRentButton setTitle:@"合租" forState:UIControlStateNormal];
    [shareRentButton setTitleColor:SYColor1 forState:UIControlStateNormal];
    shareRentButton.tag = 11;
    [shareRentButton addTarget:self action:@selector(shareRentResponse:) forControlEvents:UIControlEventTouchUpInside];
    [shareRentView addSubview:shareRentButton];
    UIButton *soloRentButton = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth-originX-150, 20, 150, 60)];
    [soloRentButton setTitle:@"独住" forState:UIControlStateNormal];
    [soloRentButton setTitleColor:SYColor1 forState:UIControlStateNormal];
    soloRentButton.tag = 10;
    [soloRentButton addTarget:self action:@selector(shareRentResponse:) forControlEvents:UIControlEventTouchUpInside];
    [shareRentView addSubview:soloRentButton];
    /*gender*/
    genderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    UIButton *noLimitButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 20, 150, 60)];
    [noLimitButton setTitle:@"不限" forState:UIControlStateNormal];
    [noLimitButton setTitleColor:SYColor1 forState:UIControlStateNormal];
    noLimitButton.tag = 10;
    [noLimitButton addTarget:self action:@selector(genderReponse:) forControlEvents:UIControlEventTouchUpInside];
    [genderView addSubview:noLimitButton];
    UIButton *boyOnlyButton = [[UIButton alloc] initWithFrame:CGRectMake((viewWidth-150)/2, 20, 150, 60)];
    [boyOnlyButton setTitle:@"男生" forState:UIControlStateNormal];
    [boyOnlyButton setTitleColor:SYColor1 forState:UIControlStateNormal];
    boyOnlyButton.tag = 11;
    [boyOnlyButton addTarget:self action:@selector(genderReponse:) forControlEvents:UIControlEventTouchUpInside];
    [genderView addSubview:boyOnlyButton];
    UIButton *girlOnlyButton = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth-originX-150, 20, 150, 60)];
    [girlOnlyButton setTitle:@"女生" forState:UIControlStateNormal];
    [girlOnlyButton setTitleColor:SYColor1 forState:UIControlStateNormal];
    girlOnlyButton.tag = 12;
    [girlOnlyButton addTarget:self action:@selector(genderReponse:) forControlEvents:UIControlEventTouchUpInside];
    [genderView addSubview:girlOnlyButton];
    
    /*house or apartment*/
    houseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    houseView.hidden = YES;
    [mainScrollView addSubview:houseView];
    [viewsArray addObject:houseView];
    UIButton *houseButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 20, 150, 60)];
    [houseButton setTitle:@"独栋" forState:UIControlStateNormal];
    [houseButton setTitleColor:SYColor1 forState:UIControlStateNormal];
    houseButton.tag = 10;
    [houseButton addTarget:self action:@selector(houseResponse:) forControlEvents:UIControlEventTouchUpInside];
    [houseView addSubview:houseButton];
    UIButton *apartmentButton = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth-originX-150, 20, 150, 60)];
    [apartmentButton setTitle:@"公寓" forState:UIControlStateNormal];
    [apartmentButton setTitleColor:SYColor1 forState:UIControlStateNormal];
    apartmentButton.tag = 11;
    [apartmentButton addTarget:self action:@selector(houseResponse:) forControlEvents:UIControlEventTouchUpInside];
    [houseView addSubview:apartmentButton];
    
    /*room type*/
    typeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    typeView.hidden = YES;
    [mainScrollView addSubview:typeView];
    [viewsArray addObject:typeView];
    UILabel *typeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 20, 100, 60)];
    typeTitleLabel.text = @"户型";
    typeTitleLabel.textColor = SYColor1;
    [typeView addSubview:typeTitleLabel];
    UIButton *typeButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 20, viewWidth-2*originX, 60)];
    [typeButton setTitle:@"请选择户型" forState:UIControlStateNormal];
    [typeButton setTitleColor:SYColor3 forState:UIControlStateNormal];
    [typeButton setTitleColor:SYColor1 forState:UIControlStateSelected];
    typeButton.tag = 11;
    typeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [typeButton addTarget:self action:@selector(typeResponse:) forControlEvents:UIControlEventTouchUpInside];
    [typeView addSubview:typeButton];
    typePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216, self.view.frame.size.width, 216)];
    typePickerView.delegate = self;
    typePickerView.dataSource = self;
    typePickerView.backgroundColor = [UIColor whiteColor];
    typePickerView.hidden = YES;
    [self.view addSubview:typePickerView];
    confirmBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216-30, self.view.frame.size.width, 30)];
    confirmBackgroundView.hidden = YES;
    confirmBackgroundView.backgroundColor = [UIColor whiteColor];
    confirmBackgroundView.tag = 9013;
    [self.view addSubview:confirmBackgroundView];
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(confirmBackgroundView.frame.size.width-60, 0, 40, 30)];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:SYColor1 forState:UIControlStateNormal];
    //    [confirmButton.titleLabel setFont:goFont15S];
    [confirmButton addTarget:self action:@selector(pickerConfirmResponse) forControlEvents:UIControlEventTouchUpInside];
    [confirmBackgroundView addSubview:confirmButton];
    CALayer *layer = confirmBackgroundView.layer;
    layer.masksToBounds = NO;
    layer.shadowOffset = CGSizeMake(0, -2);
    layer.shadowColor = [UIColorFromRGB(0xBBBBBB) CGColor];
    layer.shadowRadius = 2;
    layer.shadowOpacity = .25f;
    layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
    
    /*furniture*/
    furnitureView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 140)];
    furnitureView.hidden = YES;
    [mainScrollView addSubview:furnitureView];
    [viewsArray addObject:furnitureView];
    UIButton *needFurnitureButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 20, 150, 60)];
    [needFurnitureButton setTitle:@"需要家具" forState:UIControlStateNormal];
    [needFurnitureButton setTitleColor:SYColor1 forState:UIControlStateNormal];
    needFurnitureButton.tag = 11;
    [needFurnitureButton addTarget:self action:@selector(needFurniture:) forControlEvents:UIControlEventTouchUpInside];
    [furnitureView addSubview:needFurnitureButton];
    UIButton *noFurnitureButton = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth-originX-150, 20, 150, 60)];
    [noFurnitureButton setTitle:@"无需家具" forState:UIControlStateNormal];
    [noFurnitureButton setTitleColor:SYColor1 forState:UIControlStateNormal];
    noFurnitureButton.tag = 10;
    [noFurnitureButton addTarget:self action:@selector(needFurniture:) forControlEvents:UIControlEventTouchUpInside];
    [furnitureView addSubview:noFurnitureButton];
    
    nextButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 0, viewWidth-2*originX, 44)];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setBackgroundColor:SYColor4];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton.titleLabel setFont:SYFont20S];
    [nextButton addTarget:self action:@selector(nextResponse) forControlEvents:UIControlEventTouchUpInside];
    nextButton.layer.cornerRadius = nextButton.frame.size.height/2;
    nextButton.clipsToBounds = YES;
    [mainScrollView addSubview:nextButton];
    [viewsArray addObject:nextButton];
    nextButton.hidden = YES;
    
    [self viewsLayout];
}

-(void)viewsLayout{
    float height = 20;
    for (UIView *view in viewsArray){
        CGRect frame = view.frame;
        frame.origin.y = height;
        [view setFrame:frame];
        height += frame.size.height;
    }
    mainScrollView.contentSize = CGSizeMake(0, height+20);
}

-(IBAction)shareRentResponse:(id)sender{
    UIButton *button = sender;
    if (button.tag-10) {
        shareRentString = @"10";
        [button setTitleColor:SYColor1 forState:UIControlStateNormal];
        UIButton *button2 = [shareRentView viewWithTag:10];
        [button2 setTitleColor:SYColor3 forState:UIControlStateNormal];
        [mainScrollView addSubview:genderView];
        [viewsArray insertObject:genderView atIndex:1];
    }
    else{
        shareRentString = @"00";
        [button setTitleColor:SYColor1 forState:UIControlStateNormal];
        UIButton *button2 = [shareRentView viewWithTag:11];
        [button2 setTitleColor:SYColor3 forState:UIControlStateNormal];
        [genderView removeFromSuperview];
        [viewsArray removeObject:genderView];
        houseView.hidden = NO;
    }
    [self viewsLayout];
}
-(IBAction)genderReponse:(id)sender{
    UIButton *button = sender;
    shareRentString = [NSString stringWithFormat:@"%ld",button.tag];
    if (button.tag == 11) {
        [button setTitleColor:SYColor1 forState:UIControlStateNormal];
        UIButton *button2 = [genderView viewWithTag:10];
        [button2 setTitleColor:SYColor3 forState:UIControlStateNormal];
        UIButton *button3 = [genderView viewWithTag:12];
        [button3 setTitleColor:SYColor3 forState:UIControlStateNormal];
    }
    else if(button.tag == 12){
        [button setTitleColor:SYColor1 forState:UIControlStateNormal];
        UIButton *button2 = [genderView viewWithTag:10];
        [button2 setTitleColor:SYColor3 forState:UIControlStateNormal];
        UIButton *button3 = [genderView viewWithTag:11];
        [button3 setTitleColor:SYColor3 forState:UIControlStateNormal];
    }
    else{
        [button setTitleColor:SYColor1 forState:UIControlStateNormal];
        UIButton *button2 = [genderView viewWithTag:12];
        [button2 setTitleColor:SYColor3 forState:UIControlStateNormal];
        UIButton *button3 = [genderView viewWithTag:11];
        [button3 setTitleColor:SYColor3 forState:UIControlStateNormal];
    }
    houseView.hidden = NO;
}

-(IBAction)houseResponse:(id)sender{
    UIButton *button = sender;
    if (button.tag-10) {
        houseString = @"1";
        [button setTitleColor:SYColor1 forState:UIControlStateNormal];
        UIButton *button2 = [houseView viewWithTag:10];
        [button2 setTitleColor:SYColor3 forState:UIControlStateNormal];
    }
    else{
        houseString = @"0";
        [button setTitleColor:SYColor1 forState:UIControlStateNormal];
        UIButton *button2 = [houseView viewWithTag:11];
        [button2 setTitleColor:SYColor3 forState:UIControlStateNormal];
    }
    typeView.hidden = NO;
}

-(IBAction)typeResponse:(id)sender{
    UIButton *button = sender;
    button.selected = YES;
    if (!typeString) {
        typeString = @"0";
        [button setTitle:[roomTypeArray objectAtIndex:0] forState:UIControlStateSelected];
    }
    typePickerView.hidden = NO;
    confirmBackgroundView.hidden = NO;
    furnitureView.hidden = NO;
}
-(IBAction)needFurniture:(id)sender{
    UIButton *button = sender;
    if (button.tag-10) {
        furnitureString = @"10";
        [button setTitleColor:SYColor1 forState:UIControlStateNormal];
        UIButton *button2 = [furnitureView viewWithTag:10];
        [button2 setTitleColor:SYColor3 forState:UIControlStateNormal];
    }
    else{
        furnitureString = @"00";
        [button setTitleColor:SYColor1 forState:UIControlStateNormal];
        UIButton *button2 = [furnitureView viewWithTag:11];
        [button2 setTitleColor:SYColor3 forState:UIControlStateNormal];
    }
    nextButton.hidden = NO;
}

- (void)pickerConfirmResponse{
    confirmBackgroundView.hidden = YES;
    
    typePickerView.hidden = YES;
}

-(void)nextResponse{
    NSString *subCate = [NSString stringWithFormat:@"01%@%@%@%@",shareRentString,houseString,typeString,furnitureString];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:subCate, @"subcate", nil];
    [_helpDict addEntriesFromDictionary:dict];
    DiscoverLocationViewController *viewController = [DiscoverLocationViewController new];
    viewController.subCate = subCate;
    viewController.summaryDict = _helpDict;
    viewController.needDistance = YES;
    viewController.nextControllerType = SYDiscoverNextHelpRent;
    [self.navigationController pushViewController:viewController animated:YES];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:orderPlaceDateString, @"Order Placed Date", nil];
 [_orderSummary addEntriesFromDictionary:dict];
 */



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    float result;
    if ([pickerView isEqual:typePickerView]) {
        result = roomTypeArray.count;
    }
    return result;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component{
    NSString *resultString = [NSString new];
    if ([pickerView isEqual:typePickerView]) {
        resultString = [roomTypeArray objectAtIndex:row];
    }
    return resultString;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if ([pickerView isEqual:typePickerView]) {
        UIButton *typeButton = [typeView viewWithTag:11];
        [typeButton setTitle:[roomTypeArray objectAtIndex:row] forState:UIControlStateSelected];
        typeString = [NSString stringWithFormat:@"%ld",row];
    }
    
}
@end
