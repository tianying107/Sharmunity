//
//  SYTitle.m
//  Sharmunity
//
//  Created by st chen on 2017/2/16.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "SYTitle.h"
#define titleHelp 1
#define titleShare 2
@implementation SYTitle
-(NSString*)titleFromShareDict:(NSDictionary*)shareDict{
    NSString *categoryString = [shareDict valueForKey:@"category"];
    NSString *subcateString = [shareDict valueForKey:@"subcate"];
    NSDictionary *keywordDict = [shareDict valueForKey:@"keyword"];
    NSString *result = [self shareTitleFromCategory:categoryString subcate:subcateString keyword:keywordDict];
    return result;
}
-(NSString*)shareTitleFromCategory:(NSString*)categoryString subcate:(NSString*)subcateString keyword:(NSDictionary*)keywordDict{
    category = [categoryString integerValue];
    subcate = subcateString;
    keyword = keywordDict;
    NSString *titleString = [NSString new];
//    if ([keyword valueForKey:@"title"] && ![[keyword valueForKey:@"title"] isEqualToString:@""]) {
//        titleString = [keyword valueForKey:@"title"];
//    }
//    else{
        switch (category) {
            case DiscoverEat:
                titleString = [self category1Response:titleShare];
                break;
            case DiscoverLive:
                titleString = [self category2Response:titleShare];
                break;
            case DiscoverLearn:
                titleString = [self category3Response:titleShare];
                break;
            case DiscoverPlay:
                titleString = [self category4Response:titleShare];
                break;
            case DiscoverTravel:
                titleString = [self category5Response:titleShare];
                break;
                
            default:
                break;
        }
//    }
    
    
    
    
    
    
    return titleString;
}












-(NSString*)titleFromHelpDict:(NSDictionary*)helpDict{
    NSString *categoryString = [helpDict valueForKey:@"category"];
    NSString *subcateString = [helpDict valueForKey:@"subcate"];
    NSDictionary *keywordDict = [helpDict valueForKey:@"keyword"];
    NSString *result = [self helpTitleFromCategory:categoryString subcate:subcateString keyword:keywordDict];
    return result;
}
-(NSString*)helpTitleFromCategory:(NSString*)categoryString subcate:(NSString*)subcateString keyword:(NSDictionary*)keywordDict{
    category = [categoryString integerValue];
    subcate = subcateString;
    keyword = keywordDict;
    NSString *titleString = [NSString new];
    
    switch (category) {
        case DiscoverEat:
            titleString = [self category1Response:titleHelp];
            break;
        case DiscoverLive:
            titleString = [self category2Response:titleHelp];
            break;
        case DiscoverLearn:
            titleString = [self category3Response:titleHelp];
            break;
        case DiscoverPlay:
            titleString = [self category4Response:titleHelp];
            break;
            
        case DiscoverTravel:
            titleString = [self category5Response:titleHelp];
            break;
            
        default:
            break;
    }
    
    
    
    
    return titleString;
}
/*category 1 EAT*/
-(NSString*)category1Response:(NSInteger)titleType{
    NSString *result = [NSString new];
    /*region data*/
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"EatRegion_cn"
                                                         ofType:@"txt"];
    NSString *categoryString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *regionArray = [NSArray new];
    regionArray = [categoryString componentsSeparatedByString:@","];
    /*subregion data*/
    filePath = [[NSBundle mainBundle] pathForResource:@"EatSubRegion_cn"
                                               ofType:@"txt"];
    categoryString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *subRegionArray = [NSArray new];
    subRegionArray = [categoryString componentsSeparatedByString:@","];
    /*food data*/
    filePath = [[NSBundle mainBundle] pathForResource:@"EatFood_cn"
                                               ofType:@"txt"];
    categoryString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *foodArray = [NSArray new];
    foodArray = [categoryString componentsSeparatedByString:@","];
    NSInteger type = [[subcate substringWithRange:NSMakeRange(6, 2)] integerValue];
    NSInteger cate = [[subcate substringWithRange:NSMakeRange(2, 2)] integerValue];
    NSInteger chinese = [[subcate substringWithRange:NSMakeRange(4, 2)] integerValue];
    
    if (titleType == titleHelp) {
        if (type==1) {
            if (cate==0) {
                result = [NSString stringWithFormat:@"想吃%@%@\n%@",[regionArray objectAtIndex:cate],[subRegionArray objectAtIndex:chinese],[keyword valueForKey:@"keyword"]];
            }
            else
                result = [NSString stringWithFormat:@"想吃%@\n%@",[regionArray objectAtIndex:cate],[keyword valueForKey:@"keyword"]];
        }
        else if (type==2){
                result = [NSString stringWithFormat:@"想吃%@\n%@",[foodArray objectAtIndex:cate],[keyword valueForKey:@"keyword"]];
        }
    }
    else{
        if (type==1) {
            if (cate==0) {
                result = [NSString stringWithFormat:@"提供%@%@\n%@",[regionArray objectAtIndex:cate],[subRegionArray objectAtIndex:chinese],[keyword valueForKey:@"title"]];
            }
            else
                result = [NSString stringWithFormat:@"提供%@\n%@",[regionArray objectAtIndex:cate],[keyword valueForKey:@"title"]];
            
            if ([keyword valueForKey:@"price"]&&[[keyword valueForKey:@"price"] integerValue]) {
                result = [NSString stringWithFormat:@"%@ $%@每份",result,[keyword valueForKey:@"price"]];
            }
        }
        else if (type==2){
                result = [NSString stringWithFormat:@"提供%@\n%@",[foodArray objectAtIndex:cate],[keyword valueForKey:@"title"]];
            if ([keyword valueForKey:@"price"]&&[[keyword valueForKey:@"price"] integerValue]) {
                result = [NSString stringWithFormat:@"%@ $%@每份",result,[keyword valueForKey:@"price"]];
            }
            }
        else if (type==30){
            result = [NSString stringWithFormat:@"吃货攻略%@",[keyword valueForKey:@"title"]];
        }
        
    }
    return result;
}

/*category 2 Live*/
-(NSString*)category2Response:(NSInteger)titleType{
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"roomType"
                                                         ofType:@"txt"];
    NSString *categoryString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *roomTypeArray = [[NSArray alloc] init];
    roomTypeArray = [categoryString componentsSeparatedByString:@","];
    
    NSString *result = [NSString new];
    NSString *mode = [subcate substringToIndex:2];
    
    if ([mode isEqualToString:@"01"]||[mode isEqualToString:@"02"]) {
        NSInteger shortTerm = [[subcate substringWithRange:NSMakeRange(0, 2)] integerValue];
        NSInteger share = [[subcate substringWithRange:NSMakeRange(2, 1)] integerValue];
        NSInteger gender = [[subcate substringWithRange:NSMakeRange(2, 1)] integerValue];
        NSInteger house = [[subcate substringWithRange:NSMakeRange(4, 1)] integerValue];
        NSInteger room = [[subcate substringWithRange:NSMakeRange(5, 1)] integerValue];
        NSString *houseString = (house)?@"公寓":@"独栋";
        NSString *typeString = [roomTypeArray objectAtIndex:room];
        /*keyword*/
        NSString *placemark = [keyword valueForKey:@"placemark"];
        
        if (titleType == titleHelp) {
            NSString *lowerPrice = [keyword valueForKey:@"lower_price"];
            NSString *upperPrice = [keyword valueForKey:@"upper_price"];
            NSString *distance = [keyword valueForKey:@"distance"];
            if (shortTerm==1) {
            result = [NSString stringWithFormat:@"求租%@%@离%@%@公里之内价格$%@-$%@ %@入住",typeString,houseString,placemark,distance,lowerPrice,upperPrice,[keyword valueForKey:@"date"]];
            }
            else if (shortTerm == 2){
                NSString *shortString = [[keyword valueForKey:@"short_term"] stringByReplacingOccurrencesOfString:@"月" withString:@"个月"];
                result = [NSString stringWithFormat:@"短租%@%@%@ 离%@%@公里之内价格$%@-$%@ %@入住",typeString,houseString,shortString,placemark,distance,lowerPrice,upperPrice,[keyword valueForKey:@"date"]];
            }
            
        }
        else if (titleType == titleShare){
            NSString *genderString;
            if (gender==5)
                genderString = @"女";
            else if (gender==1)
                genderString = @"男";
            else
                genderString = @"";
            
            NSString *price = [keyword valueForKey:@"price"];
            
            NSString *mateString = (share)?[NSString stringWithFormat:@"找%@室友",genderString]:@"";
            if (shortTerm==1) {
                result = [NSString stringWithFormat:@"出租%@%@%@ %@附近 价格每月$%@ 从%@开始",typeString,houseString,mateString,placemark,price,[keyword valueForKey:@"available_date"]];
            }
            else if (shortTerm == 2){
                NSString *shortString = [[keyword valueForKey:@"short_term"] stringByReplacingOccurrencesOfString:@"月" withString:@"个月"];
                result = [NSString stringWithFormat:@"短租%@%@%@ %@ %@附近 价格每月$%@ 从%@开始",typeString,houseString,shortString,mateString,placemark,price,[keyword valueForKey:@"available_date"]];
            }
            
        }
        
    }
    else if ([mode isEqualToString:@"03"]){
        /*keyword*/
        NSString *placemark = [keyword valueForKey:@"placemark"];
        if (titleType == titleHelp) {
            NSString *dateString = [keyword valueForKey:@"date"];
            NSString *contentString = ([[keyword valueForKey:@"introduction"] isEqualToString:@""])?@"":[NSString stringWithFormat:@"主要物品为: %@",[keyword valueForKey:@"introduction"]];
            result = [NSString stringWithFormat:@"我要搬家%@从%@出发 %@",dateString,placemark,contentString];
        }
        else{
            result = [NSString stringWithFormat:@"提供搬家服务在%@附近%@英里 %@",placemark,[keyword valueForKey:@"distance"],[keyword valueForKey:@"title"]];
        }
        
    }
    return result;
}

/*category 3 Learn*/
-(NSString*)category3Response:(NSInteger)titleType{
    NSInteger type = [[subcate substringWithRange:NSMakeRange(0, 2)] integerValue];
    NSInteger subtype = [[subcate substringWithRange:NSMakeRange(2, 2)] integerValue];
    NSString *result = [NSString new];

    NSString *keywordString = [keyword valueForKey:@"keyword"];
    if (titleType == titleHelp) {
        if (type==1) {
            NSString *majorString = [keyword valueForKey:@"major"];
            NSString *school = [keyword valueForKey:@"school"];
            NSString *price = [keyword valueForKey:@"price"];
            BOOL priceAgg = [[keyword valueForKey:@"changeable"] boolValue];
            NSString *priceString;
            if (priceAgg || [price isEqualToString:@""]) {
                priceString=@"面谈";
            }else if ([price integerValue]==0){
                priceString = @"免费";
            }
            else{
                priceString = price;
            }
            
            if (subtype==1) {
                result = [NSString stringWithFormat:@"我要%@学长%@的留学专业咨询",school,majorString];
            }
            else if (subtype==2){
                result = [NSString stringWithFormat:@"我要%@学长%@的留学申请辅导",school,priceString];
            }
        }
        else if(type==2){
            NSString *majorString = [keyword valueForKey:@"major"];
            NSString *school = [keyword valueForKey:@"school"];
            result = [NSString stringWithFormat:@"%@学长提供%@的专业辅导",school,majorString
                      ];
        }
        else if(type==3){
            NSString *age = [keyword valueForKey:@"age"];
            NSString *gender = [keyword valueForKey:@"gender"];
            result = [NSString stringWithFormat:@"找%@兴趣班\n%@岁,%@",keywordString,age,gender];
        }
    }
    else if (titleType == titleShare){
        if (type==1) {
            NSString *majorString = [keyword valueForKey:@"major"];
            NSString *school = [keyword valueForKey:@"school"];
            NSString *price = [keyword valueForKey:@"price"];
            BOOL priceAgg = [[keyword valueForKey:@"changeable"] boolValue];
            NSString *priceString;
            if (priceAgg || [price isEqualToString:@""]) {
                priceString=@"面谈";
            }else if ([price integerValue]==0){
                priceString = @"免费";
            }
            else{
                priceString = price;
            }
            
            if (subtype==1) {
                result = [NSString stringWithFormat:@"%@学长提供%@的专业咨询 价格%@",school,majorString,priceString];
            }
            else if (subtype==2){
                result = [NSString stringWithFormat:@"%@学长提供申请辅导 价格%@",school,priceString];
            }
            
            
        }
        else if(type==2){
            NSString *majorString = [keyword valueForKey:@"major"];
            NSString *school = [keyword valueForKey:@"school"];
            NSString *price = [keyword valueForKey:@"price"];
            BOOL priceAgg = [[keyword valueForKey:@"changeable"] boolValue];
            NSString *priceString;
            if (priceAgg || [price isEqualToString:@""]) {
                priceString=@"面谈";
            }else if ([price integerValue]==0){
                priceString = @"免费";
            }
            else{
                priceString = price;
            }
            result = [NSString stringWithFormat:@"%@学长提供%@的专业辅导",school,majorString
                      ];
        }
        else if(type==3){
            NSString *key = [keyword valueForKey:@"major"];
            NSString *name = [keyword valueForKey:@"department"];
            NSString *price = [keyword valueForKey:@"price"];
            NSString *priceString;
            if ([price integerValue]==0){
                priceString = @"免费";
            }
            else{
                priceString = price;
            }
            result = [NSString stringWithFormat:@"开%@兴趣班\n%@ 价格$%@每课时",key,name,price];
        }
    }
    
    return result;
}

/*category 4 Play*/
-(NSString*)category4Response:(NSInteger)titleType{
    NSArray *activityArray = [[NSArray alloc] initWithObjects:@"体育运动",@"社交活动",@"户外冒险",@"旅游度假",@"棋牌游戏",@"其他活动", nil];
    NSArray *partnerArray = [[NSArray alloc] initWithObjects:@"学伴儿",@"聊伴儿",@"游伴儿",@"商伴儿",@"玩伴儿", nil];
    NSInteger type = [[subcate substringWithRange:NSMakeRange(0, 2)] integerValue];
    NSString *result = [NSString new];
    NSInteger subtype = [[subcate substringWithRange:NSMakeRange(2, 2)] integerValue];
    NSInteger acttype = [[subcate substringWithRange:NSMakeRange(4, 2)] integerValue];
    
    if (titleType == titleHelp) {
        if (type==1) {
            NSString *activityString = (subtype==99)?[activityArray lastObject]:[activityArray objectAtIndex:subtype-1];
            
            NSString *actString;
            if (subtype != 99) {
                NSString* filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"PlayType%ld_cn",subtype]
                                                                     ofType:@"txt"];
                NSString *categoryString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
                NSArray *typeArray = [NSArray new];
                typeArray = [categoryString componentsSeparatedByString:@","];
                actString = (acttype==99)?@"":[typeArray objectAtIndex:acttype];
            }
            else
                actString = @"";
            
            result = [NSString stringWithFormat:@"找活动 %@%@",activityString,actString];
        }
        else if (type == 3){
            NSString *partnerString = [partnerArray objectAtIndex:subtype-1];
            
            result = [NSString stringWithFormat:@"找%@ %@",partnerString,[(NSArray*)[keyword valueForKey:@"keyword"] componentsJoinedByString:@","]];

        }
    }
    else if (titleType == titleShare){
        if (type==1) {
            NSString *activityString = (subtype==99)?[activityArray lastObject]:[activityArray objectAtIndex:subtype-1];
            
            NSString *actString;
            if (subtype != 99) {
                NSString* filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"PlayType%ld_cn",subtype]
                                                                     ofType:@"txt"];
                NSString *categoryString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
                NSArray *typeArray = [NSArray new];
                typeArray = [categoryString componentsSeparatedByString:@","];
                actString = (acttype==99)?@"":[typeArray objectAtIndex:acttype];
            }
            else
                actString = @"";
            
            /*number*/
            NSString *number = [keyword valueForKey:@"number"];
            NSString *numberString;
            if ([number integerValue]==999 || ![keyword valueForKey:@"number"]){
                numberString = @"不限";
            }
            else{
                numberString = number;
            }
            /*time*/
            BOOL timeAgg = NO;
            if ([[keyword valueForKey:@"start_time"] isEqualToString:@"2099-01-01 09:00"] || [[keyword valueForKey:@"end_time"] isEqualToString:@"2099-01-01 09:00"]) {
                timeAgg = YES;
            }
            NSString *timeString = (timeAgg)?@"":[NSString stringWithFormat:@"从%@到%@",[keyword valueForKey:@"start_time"],[keyword valueForKey:@"end_time"]];
            
            if ([keyword valueForKey:@"title"] && ![[keyword valueForKey:@"title"] isEqualToString:@""]) {
                result = [NSString stringWithFormat:@"%@ %@ 价格$%@每人 人数%@",[keyword valueForKey:@"title"],timeString,[keyword valueForKey:@"price"],numberString];
            }
            else
                result = [NSString stringWithFormat:@"发起%@%@  %@ 价格$%@每人 人数%@",activityString,actString,timeString,[keyword valueForKey:@"price"],numberString];
        }
        else if (type==2){
            result = [NSString stringWithFormat:@"攻略%@",[keyword valueForKey:@"title"]];
        }
        else if (type == 3){
            
            NSString *partnerString = [partnerArray objectAtIndex:subtype-1];
            
            result = [NSString stringWithFormat:@"找%@ %@",partnerString,[keyword valueForKey:@"keyword"]];
        }
        
    }

    return result;
}

-(NSString*)category5Response:(NSInteger)titleType{
    NSInteger type = [[subcate substringWithRange:NSMakeRange(0, 2)] integerValue];
    NSInteger subtype = [[subcate substringWithRange:NSMakeRange(2, 2)] integerValue];
    
    NSString *result = [NSString new];
//    NSString *keywordString = [keyword valueForKey:@"keyword"];
    if (titleType == titleHelp) {
        NSArray *cateArray = [[NSArray alloc] initWithObjects:@"找飞伴",@"学车考证",@"求搭车",@"接机",@"买车卖车",@"",@"求捎带", nil];
        NSString *cateString = (type==99)?@"其他出行帮助":[cateArray objectAtIndex:type-1];
        if (type==1) {
            if (subtype==1) {
                result = [NSString stringWithFormat:@"%@乘坐%@的%@航班",cateString,[keyword valueForKey:@"date"],[keyword valueForKey:@"flight"]];
                
            }
            else if (subtype == 2){
                result = [NSString stringWithFormat:@"%@从%@到%@",cateString,[keyword valueForKey:@"depart"],[keyword valueForKey:@"arrive"]];
            }
            
        }
        else if (type==2){
            /*price*/
            NSString *price = [keyword valueForKey:@"price"];
            BOOL priceAgg = [[keyword valueForKey:@"changeable"] boolValue];
            NSString *priceString = [NSString stringWithFormat:@"可接受价格每小时$%@",price];
            if ([price isEqualToString:@""]) {
                priceString = @"价格面谈";
            }
            else if (priceAgg) {
                priceString = [NSString stringWithFormat:@"%@ 价格可议",priceString];
            }
            
            result = [NSString stringWithFormat:@"要%@ %@",cateString,priceString];
        }
        else if (type == 3){
            if (subtype==1) {
                result = [NSString stringWithFormat:@"同城%@",cateString];
            }
            else if (subtype == 2){
                NSString *roundTripString = ([[keyword valueForKey:@"date"] boolValue])?@"往返":@"单程";
                result = [NSString stringWithFormat:@"异地%@ %@ %@",cateString,[keyword valueForKey:@"date"],roundTripString];
            }
        }
        else if (type == 4){
            result = [NSString stringWithFormat:@"找%@%@的%@ 之后去%@",[keyword valueForKey:@"time"],[keyword valueForKey:@"airport"],cateString,[keyword valueForKey:@"address"]];
        }
        else if (type == 5){
            NSString *buyCarString = ([[keyword valueForKey:@"buy_car"] boolValue])?@"买车":@"卖车";
            
            /*price*/
            NSString *price = [keyword valueForKey:@"price"];
            BOOL priceAgg = [[keyword valueForKey:@"changeable"] boolValue];
            NSString *priceString;
            if (priceAgg || ![price integerValue]) {
                priceString=@"面谈";
            }
            else{
                priceString = [NSString stringWithFormat:@"$%@",price];
            }
            
            result = [NSString stringWithFormat:@"找人帮忙%@ 辛苦费%@",buyCarString,priceString];
        }
        else if (type == 7){
            /*direction*/
            NSString *direction = ([[keyword valueForKey:@"to_cn"] boolValue])?@"去中国":@"去美国";
            NSString *cityString = ([[keyword valueForKey:@"to_cn"] boolValue])?[NSString stringWithFormat:@"从%@到%@",[keyword valueForKey:@"city"],[keyword valueForKey:@"cn_city"]]:[NSString stringWithFormat:@"从%@到%@",[keyword valueForKey:@"cn_city"],[keyword valueForKey:@"city"]];
            
            /*price*/
            NSString *price = [keyword valueForKey:@"price"];
            BOOL priceAgg = [[keyword valueForKey:@"changeable"] boolValue];
            NSString *priceString = [NSString stringWithFormat:@"$%@",price];
            if ([price isEqualToString:@""]) {
                priceString = @"价格面谈";
            }
            else if (priceAgg) {
                priceString = [NSString stringWithFormat:@"%@ 价格可议",priceString];
            }
            
            result = [NSString stringWithFormat:@"求捎%@%@%@ 愿意出价%@",[keyword valueForKey:@"introduction"],direction,cityString, priceString];
        }
    }
    else if (titleType == titleShare){
        NSArray *cateArray = [[NSArray alloc] initWithObjects:@"",@"教车考证",@"搭车帮助",@"接机帮助",@"买卖车帮助",@"",@"捎带帮助", nil];
        NSString *cateString = (type==99)?@"其他出行帮助":[cateArray objectAtIndex:type-1];
        if (type==2){
            NSString *carString;
            if ([keyword valueForKey:@"car"] && ![[keyword valueForKey:@"car"] isEqualToString:@""]) {
                carString = [NSString stringWithFormat:@"车辆%@",[keyword valueForKey:@"car"]];
            }
            else
                carString = @"";
            
            /*price*/
            NSString *priceString = ([[keyword valueForKey:@"price"] isEqualToString:@""])?[keyword valueForKey:@"price"]:[NSString stringWithFormat:@"价格$%@每小时",[keyword valueForKey:@"price"]];
            
            result = [NSString stringWithFormat:@"提供%@ %@年驾龄 %@月教龄 %@ %@",cateString,[keyword valueForKey:@"drive_time"],[keyword valueForKey:@"teach_time"],priceString,carString];
        }
        else if (type == 3){
            if (subtype==1) {
                /*car*/
                NSString *carString;
                if ([keyword valueForKey:@"car"] && ![[keyword valueForKey:@"car"] isEqualToString:@""]) {
                    carString = [NSString stringWithFormat:@"车辆%@",[keyword valueForKey:@"car"]];
                }
                else
                    carString = @"";
                
                /*price*/
                NSString *priceString = ([[keyword valueForKey:@"is_free"] isEqualToString:@"0"])?@"免费":@"收费";
                
                result = [NSString stringWithFormat:@"%@提供同城%@ %@",priceString,cateString,carString];
                
            }
            else if (subtype == 2){
                NSString *price = [keyword valueForKey:@"price"];
                BOOL priceAgg = [[keyword valueForKey:@"changeable"] boolValue];
                NSString *priceString;
                if (priceAgg || [price isEqualToString:@""]) {
                    priceString=@"面谈";
                }else if ([price integerValue]==0){
                    priceString = @"免费";
                }
                else{
                    priceString = [NSString stringWithFormat:@"$%@",price];
                }
                NSString *roundTripString = ([[keyword valueForKey:@"date"] boolValue])?@"往返":@"单程";
                result = [NSString stringWithFormat:@"提供异地%@ %@ 价格%@ %@",cateString,[keyword valueForKey:@"date"],priceString,roundTripString];
            }
        }
        else if (type == 4){
            /*car*/
            NSString *carString;
            if ([keyword valueForKey:@"car"] && ![[keyword valueForKey:@"car"] isEqualToString:@""]) {
                carString = [NSString stringWithFormat:@"车辆%@",[keyword valueForKey:@"car"]];
            }
            else
                carString = @"";
            
            /*price*/
            NSString *priceString = ([[keyword valueForKey:@"is_free"] isEqualToString:@"0"])?@"免费":@"收费";
            
            /*airport*/
            NSArray *airportArray = [keyword valueForKey:@"airport"];
            
            NSString *airportString = [NSString stringWithFormat:@"%@机场",[airportArray componentsJoinedByString:@","]];
            result = [NSString stringWithFormat:@"%@提供%@的%@ %@",priceString,airportString,cateString,carString];
        }
        else if (type == 5){
            /*car*/
            NSString *carString;
            if ([keyword valueForKey:@"car"] && ![[keyword valueForKey:@"car"] isEqualToString:@""]) {
                carString = [NSString stringWithFormat:@"车辆%@",[keyword valueForKey:@"car"]];
            }
            else
                carString = @"";
            
            /*price*/
            NSString *price = [keyword valueForKey:@"price"];
            BOOL priceAgg = [[keyword valueForKey:@"changeable"] boolValue];
            NSString *priceString;
            if (priceAgg || [price isEqualToString:@""]) {
                priceString=@"面谈";
            }else if ([price integerValue]==0){
                priceString = @"免费";
            }
            else{
                priceString = [NSString stringWithFormat:@"$%@",price];
            }
            
            result = [NSString stringWithFormat:@"提供%@ %@年驾龄 价格%@",cateString,[keyword valueForKey:@"drive_time"],priceString];
        }
        else if (type == 7){
            /*car*/
            NSString *direction = ([[keyword valueForKey:@"to_cn"] boolValue])?@"去中国":@"去美国";
            NSString *cityString = ([[keyword valueForKey:@"to_cn"] boolValue])?[NSString stringWithFormat:@"从%@到%@",[keyword valueForKey:@"city"],[keyword valueForKey:@"cn_city"]]:[NSString stringWithFormat:@"从%@到%@",[keyword valueForKey:@"cn_city"],[keyword valueForKey:@"city"]];
            
            result = [NSString stringWithFormat:@"提供%@%@%@",cateString,direction,cityString];
        }
        
    }
//       找飞伴,学车,搭车,接机,买卖车,修车保养,捎东西,出行服务 
    
    
    return result;
}
@end
