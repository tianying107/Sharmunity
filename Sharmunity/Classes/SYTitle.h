//
//  SYTitle.h
//  Sharmunity
//
//  Created by st chen on 2017/2/16.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <Foundation/Foundation.h>
#define DiscoverEat 1
#define DiscoverLive 2
#define DiscoverLearn 3
#define DiscoverPlay 4
#define DiscoverTravel 5
@interface SYTitle : NSObject{
    NSInteger category;
    NSString *subcate;
    NSDictionary *keyword;
}
-(NSString*)titleFromHelpDict:(NSDictionary*)helpDict;
-(NSString*)helpTitleFromCategory:(NSString*)categoryString subcate:(NSString*)subcateString keyword:(NSDictionary*)keywordDict;

-(NSString*)titleFromShareDict:(NSDictionary*)shareDict;
-(NSString*)shareTitleFromCategory:(NSString*)categoryString subcate:(NSString*)subcateString keyword:(NSDictionary*)keywordDict;
@end
