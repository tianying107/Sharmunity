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
    if ([mode isEqualToString:@"01"]) {
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
            result = [NSString stringWithFormat:@"我要租%@%@离%@%@公里之内\n价格$%@-$%@",typeString,houseString,placemark,distance,lowerPrice,upperPrice];
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
    else if ([mode isEqualToString:@"02"]){
        /*keyword*/
        NSString *placemark = [keyword valueForKey:@"placemark"];
        if (titleType == titleHelp) {
            NSString *lowerPrice = [keyword valueForKey:@"lower_price"];
            NSString *upperPrice = [keyword valueForKey:@"upper_price"];
            NSString *dateString = [keyword valueForKey:@"date"];
            result = [NSString stringWithFormat:@"我要搬家%@在%@\n价格$%@-$%@",dateString,placemark,lowerPrice,upperPrice];
        }
        else{
            NSString *price = [keyword valueForKey:@"price"];
            result = [NSString stringWithFormat:@"我提供搬家服务在%@附近\n价格$%@",placemark,price];
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
    NSString *travelString = [travelTypeArray objectAtIndex:[mode integerValue]-1];
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
    
    
    return result;
}
@end