//
//  SYHelp.m
//  Sharmunity
//
//  Created by st chen on 2017/2/9.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "SYHelp.h"
#import "Header.h"
#import "SYChoiceAbstract.h"
@implementation SYHelp
@synthesize helpID, helpDict;
-(id)initWithFrame:(CGRect)frame helpID:(NSString*)ID{
    self = [super initWithFrame:frame];
    if (self) {
        helpID = ID;
        
        [self requestHelpFromServer];
    }
    return self;
}

-(void)viewsSetup{
    NSArray *choiceArray = [helpDict valueForKey:@"choices"];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 200, 40)];
    
    label.text = [NSString stringWithFormat:@"为你匹配到%ld条信息", choiceArray.count];
    [self addSubview:label];
    float heightCount = 60;
    for (int i=0; i<choiceArray.count; i++) {
        SYChoiceAbstract *choiceAbstract = [[SYChoiceAbstract alloc] initWithFrame:CGRectMake(0, heightCount, self.frame.size.width, 0) choiceID:[choiceArray objectAtIndex:i]];
        [self addSubview:choiceAbstract];
        heightCount += choiceAbstract.frame.size.height;
        
    }
}

-(void)requestHelpFromServer{
    NSString *requestQuery = [NSString stringWithFormat:@"help_id=%@",helpID];
    NSString *urlString = [NSString stringWithFormat:@"%@reqhelp?%@",basicURL,requestQuery];
    NSLog(@"%@",requestQuery);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionTask *task = [session dataTaskWithURL:url
                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                        NSLog(@"server said: %@",string);
                                                                                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                                     options:kNilOptions
                                                                                                                                       error:&error];
                                                                                NSLog(@"server said: %@",dict);
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     helpDict = dict;
                                                     [self viewsSetup];
//                                                        [self handleSubmit:dict];
                                                  });
                                        
                                    }];
    [task resume];
}
@end
