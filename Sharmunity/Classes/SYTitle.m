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
    if ([keyword valueForKey:@"title"] && ![[keyword valueForKey:@"title"] isEqualToString:@""]) {
        titleString = [keyword valueForKey:@"title"];
    }
    else{
        switch (category) {
            case DiscoverEat:
                titleString = [self category1Response:titleShare];
                break;
            case DiscoverLive:
                titleString = [self category2Response:titleShare];
                break;
                
            case DiscoverTravel:
                titleString = [self category5Response:titleShare];
                break;
                
            default:
                break;
        }
    }
    
    
    
    
    
    
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
            
        case DiscoverTravel:
            titleString = [self category5Response:titleHelp];
            break;
            
        default:
            break;
    }
    
    
    
    
    return titleString;
}

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
    NSInteger type = [[subcate substringWithRange:NSMakeRange(0, 2)] integerValue];
    NSInteger cate = [[subcate substringWithRange:NSMakeRange(2, 2)] integerValue];
    NSInteger chinese = [[subcate substringWithRange:NSMakeRange(4, 2)] integerValue];
    
    if (type==1) {
        if (cate==0) {
            result = [NSString stringWithFormat:@"想吃%@%@\n%@",[regionArray objectAtIndex:cate],[subRegionArray objectAtIndex:chinese],[keyword valueForKey:@"keyword"]];
        }
        else
            result = [NSString stringWithFormat:@"想吃%@\n%@",[regionArray objectAtIndex:cate],[keyword valueForKey:@"keyword"]];
    }
    else if (type==2){
        if (titleType == titleHelp) {
            result = [NSString stringWithFormat:@"想吃%@\n%@",[foodArray objectAtIndex:cate],[keyword valueForKey:@"keyword"]];
        }
    }
    
    
    return result;
}
-(NSString*)category2Response:(NSInteger)titleType{
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"roomType"
                                                         ofType:@"txt"];
    NSString *categoryString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *roomTypeArray = [[NSArray alloc] init];
    roomTypeArray = [categoryString componentsSeparatedByString:@","];
    
    NSString *result = [NSString new];
    NSString *mode = [subcate substringToIndex:2];
    if ([mode isEqualToString:@"01"]||[mode isEqualToString:@"02"]) {
        NSInteger share = [[subcate substringWithRange:NSMakeRange(2, 1)] integerValue];
        NSInteger gender = [[subcate substringWithRange:NSMakeRange(2, 1)] integerValue];
        NSInteger house = [[subcate substringWithRange:NSMakeRange(4, 1)] integerValue];
        NSInteger room = [[subcate substringWithRange:NSMakeRange(5, 1)] integerValue];
        NSString *houseString = (house)?@"公寓":@"独栋";
        NSString *typeString = [roomTypeArray objectAtIndex:room];
        /*keyword*/
        NSString *lowerPrice = [keyword valueForKey:@"lower_price"];
        NSString *upperPrice = [keyword valueForKey:@"upper_price"];
        NSString *distance = [keyword valueForKey:@"distance"];
        NSString *placemark = [keyword valueForKey:@"placemark"];
        
        if (titleType == titleHelp) {
            result = [NSString stringWithFormat:@"我要求租%@%@离%@%@公里之内价格$%@-$%@",typeString,houseString,placemark,distance,lowerPrice,upperPrice];
        }
        else{
            NSString *genderString;
            if (gender==2)
                genderString = @"女";
            else if (gender==1)
                genderString = @"男";
            else
                genderString = @"";
            NSString *mateString = (share)?[NSString stringWithFormat:@"找%@室友",genderString]:@"";
            result = [NSString stringWithFormat:@"出租%@%@ %@离%@%@公里之内\n价格$%@-$%@",typeString,houseString,mateString,placemark,distance,lowerPrice,upperPrice];
        }
        
    }
    else if ([mode isEqualToString:@"03"]){
        /*keyword*/
        NSString *placemark = [keyword valueForKey:@"placemark"];
        if (titleType == titleHelp) {
            NSString *dateString = [keyword valueForKey:@"date"];
            result = [NSString stringWithFormat:@"我要搬家%@在%@",dateString,placemark];
        }
        else{
            result = [NSString stringWithFormat:@"我提供搬家服务在%@附近",placemark];
        }
        
    }
    return result;
}

-(NSString*)category3Response:(NSInteger)titleType{
    NSInteger type = [[subcate substringWithRange:NSMakeRange(0, 2)] integerValue];
    NSString *result = [NSString new];

    NSString *keywordString = [keyword valueForKey:@"keyword"];
    if (type==1) {
        NSString *majorString = [keyword valueForKey:@"major"];
        result = [NSString stringWithFormat:@"我要%@专业的相关经验\n%@",majorString,keywordString];
        }
    else if(type==2){
        NSString *majorString = [keyword valueForKey:@"major"];
        NSString *numberString = [keyword valueForKey:@"number"];
        if (titleType == titleHelp) {
            result = [NSString stringWithFormat:@"我要%@%@的相关辅导\n%@",majorString,numberString,keywordString];
            
        }
    }
    else if(type==3){
        if (titleType == titleHelp) {
            result = [NSString stringWithFormat:@"找兴趣班\n%@",keywordString];
        }
    }
    return result;
}

-(NSString*)category4Response:(NSInteger)titleType{
    NSInteger type = [[subcate substringWithRange:NSMakeRange(0, 2)] integerValue];
    NSString *result = [NSString new];
    
    NSString *keywordString = [keyword valueForKey:@"keyword"];
    if (type==1) {
        NSString *majorString = [keyword valueForKey:@"major"];
        result = [NSString stringWithFormat:@"我要%@专业的相关经验\n%@",majorString,keywordString];
    }
    else if(type==2){
        NSString *majorString = [keyword valueForKey:@"major"];
        NSString *numberString = [keyword valueForKey:@"number"];
        if (titleType == titleHelp) {
            result = [NSString stringWithFormat:@"我要%@%@的相关辅导\n%@",majorString,numberString,keywordString];
            
        }
    }
    else if(type==3){
        if (titleType == titleHelp) {
            result = [NSString stringWithFormat:@"找兴趣班\n%@",keywordString];
        }
    }
    return result;
}

-(NSString*)category5Response:(NSInteger)titleType{
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"TravelType_cn"
                                                         ofType:@"txt"];
    NSString *categoryString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *travelTypeArray = [[NSArray alloc] init];
    travelTypeArray = [categoryString componentsSeparatedByString:@","];
    
    NSString *result = [NSString new];
    NSString *mode = [subcate substringToIndex:2];
    NSString *travelString = ([mode isEqualToString:@"99"])? @"其他" : [travelTypeArray objectAtIndex:[mode integerValue]-1];
    NSString *keywordString = [keyword valueForKey:@"keyword"];
    if ([mode isEqualToString:@"01"]) {
        NSString *ticketString = [subcate substringWithRange:NSMakeRange(2, 2)];
        if ([ticketString isEqualToString:@"01"]) {
            NSString *dateString = [keyword valueForKey:@"date"];
            NSString *flightString = [keyword valueForKey:@"flight"];
                result = [NSString stringWithFormat:@"我要%@\n%@乘坐%@",travelString,dateString,flightString];
            
        }
        else{
            NSString *departString = [keyword valueForKey:@"depart"];
            NSString *arriveString = [keyword valueForKey:@"arrive"];
            if (titleType == titleHelp) {
                result = [NSString stringWithFormat:@"我要%@\n从%@到%@",travelString,departString,arriveString];
            }
            else{
                
            }
            
        }
    }
    else if ([mode isEqualToString:@"05"]){
        if (titleType == titleHelp) {
            result = [NSString stringWithFormat:@"找人帮忙%@\n%@",travelString,keywordString];
        }
    }
        
    
    
    return result;
}
@end
