//
//  SYChoiceDetail.m
//  Sharmunity
//
//  Created by st chen on 2017/2/15.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import "SYChoiceDetail.h"
#import "SYHeader.h"
#import "SYChoiceCommentBasic.h"
#import "SYShare.h"
#define uncommentOriginY [[UIScreen mainScreen] bounds].size.height
@interface SYChoiceDetail(){
    SYProfileHead *headView;
    SYProfileExtend *extendView;
    float unextend;
    float extend;
    BOOL extended;
    
    UIView *choiceContentView;
}
@end
@implementation SYChoiceDetail
@synthesize choiceDict, helpeeID, shareDict, helpDict;
-(id)initWithChoiceDict:(NSDictionary*)Dict helpDict:(NSDictionary*)help frame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 500)];
    if (self) {
        choiceDict = Dict;
        helpDict = help;
        [self shareChoiceSetup];
    }
    return self;
}
-(void)shareChoiceSetup{
    helpeeID = [choiceDict valueForKey:@"helpee_id"];
    MEID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
    extended = NO;
    float heightCount = 0;
    headView = [[SYProfileHead alloc] initWithUserID:helpeeID frame:CGRectMake(0, heightCount, self.frame.size.width, 0)];
    
    heightCount += headView.frame.size.height;
    [self addSubview:headView];
    [headView.avatarButton addTarget:self action:@selector(extendResponse) forControlEvents:UIControlEventTouchUpInside];
    
    extendView = [[SYProfileExtend alloc] initWithUserID:helpeeID frame:CGRectMake(0, heightCount, self.frame.size.width, 0)];
    unextend = heightCount-extendView.frame.size.height;
    extend = heightCount;
    extendView.frame = CGRectMake(0, unextend, extendView.frame.size.width, extendView.frame.size.height);
    [self addSubview:extendView];
    [self sendSubviewToBack:extendView];
    
    choiceContentView = [[UIView alloc] initWithFrame:CGRectMake(0, heightCount, self.frame.size.width, 500)];
    [self addSubview:choiceContentView];
    /****choice content view setup****/
    float originX = 20;
    heightCount = 10;
    float width = self.frame.size.width-2*originX;
    SYHelpContentView *helpView = [[SYHelpContentView alloc] initContentWithFrame:CGRectMake(originX, heightCount, width, 0) helpDict:helpDict];
    heightCount += helpView.frame.size.height;
    [choiceContentView addSubview:helpView];
    
    UIView *functionView = [[UIView alloc] initWithFrame:CGRectMake(originX, heightCount, width, 40)];
    heightCount += functionView.frame.size.height;
    [choiceContentView addSubview:functionView];
    /*3 buttons*/
    UIButton *messageButton = [[UIButton alloc] initWithFrame:CGRectMake(functionView.frame.size.width-120, 10, 40, 40)];
    [messageButton setImage:[UIImage imageNamed:@"choiceMsgButton"] forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(writeCommentResponse) forControlEvents:UIControlEventTouchUpInside];
    [functionView addSubview: messageButton];
    
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(functionView.frame.size.width-80, 10, 40, 40)];
    [shareButton setImage:[UIImage imageNamed:@"choiceShareButton"] forState:UIControlStateNormal];
    [functionView addSubview: shareButton];
    
    UIButton *contactButton = [[UIButton alloc] initWithFrame:CGRectMake(functionView.frame.size.width-40, 10, 40, 40)];
    [contactButton addTarget:self action:@selector(contactReponse) forControlEvents:UIControlEventTouchUpInside];
    [contactButton setImage:[UIImage imageNamed:@"choiceContactButton"] forState:UIControlStateNormal];
    [functionView addSubview: contactButton];
    
    
    /*comment table*/
    float commentYStart = heightCount;
    commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, commentYStart+5, self.frame.size.width, self.frame.size.height-commentYStart-44-5) style:UITableViewStylePlain];
    [choiceContentView addSubview:commentTableView];
    [commentTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    commentTableView.delegate = self;
    commentTableView.dataSource = self;
    commentTableView.hidden = YES;
    commentTableView.backgroundColor = SYBackgroundColorExtraLight;
    //        commentTableView.alwaysBounceVertical = NO;
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer *timer){
        [commentTableView reloadData];
        [NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer *timer){
            commentTableView.hidden = NO;
            //            [loading endLoading];
        }];
    }];
    heightCount += commentTableView.frame.size.height;
    
    CGRect cframe = choiceContentView.frame;
    cframe.size.height = heightCount;
    
    
    
    
    
    //comment textField at the bottom of the view
    commentBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, uncommentOriginY, [[UIScreen mainScreen] bounds].size.width, 50)];
    commentBackgroundView.backgroundColor = SYBackgroundColorExtraLight;
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:commentBackgroundView];
    commentTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 5, commentBackgroundView.frame.size.width-90, 40)];
    commentTextField.backgroundColor = SYBackgroundColorExtraLight;
    commentTextField.delegate = self;
    [commentTextField addTarget:self action:@selector(checkEmpty) forControlEvents:UIControlEventEditingChanged];
    [commentTextField setFont:SYFont13S];
    commentTextField.textColor = SYColor1;
    [commentBackgroundView addSubview:commentTextField];
    sendMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendMessageButton.bounds = CGRectMake(0, 0, 32, 32);
    [sendMessageButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendMessageButton setTitleColor:SYColor4 forState:UIControlStateNormal];
    //    [sendMessageButton setImage:[UIImage imageNamed:@"sendMsgButton"] forState:UIControlStateNormal];
    sendMessageButton.frame = CGRectMake(commentTextField.frame.origin.x+commentTextField.frame.size.width+10, 9, 50, 32);
    sendMessageButton.enabled = NO;
    [sendMessageButton addTarget:self action:@selector(submitCommentResponse) forControlEvents:UIControlEventTouchUpInside];
    [commentBackgroundView addSubview:sendMessageButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowUp:) name:UIKeyboardWillShowNotification object:nil];
    
    
}









-(id)initWithChoiceDict:(NSDictionary*)Dict shareDict:(NSDictionary*)share frame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 500)];
    if (self) {
        choiceDict = Dict;
        shareDict = share;
        [self viewsSetup];
    }
    return self;
}
-(void)viewsSetup{
    helpeeID = [choiceDict valueForKey:@"helpee_id"];
    MEID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"];
    extended = NO;
    float heightCount = 0;
    headView = [[SYProfileHead alloc] initWithUserID:helpeeID frame:CGRectMake(0, heightCount, self.frame.size.width, 0)];
    
    heightCount += headView.frame.size.height;
    [self addSubview:headView];
    [headView.avatarButton addTarget:self action:@selector(extendResponse) forControlEvents:UIControlEventTouchUpInside];
    
    extendView = [[SYProfileExtend alloc] initWithUserID:helpeeID frame:CGRectMake(0, heightCount, self.frame.size.width, 0)];
    unextend = heightCount-extendView.frame.size.height;
    extend = heightCount;
    extendView.frame = CGRectMake(0, unextend, extendView.frame.size.width, extendView.frame.size.height);
    [self addSubview:extendView];
    [self sendSubviewToBack:extendView];
    
    choiceContentView = [[UIView alloc] initWithFrame:CGRectMake(0, heightCount, self.frame.size.width, 500)];
    [self addSubview:choiceContentView];
    /****choice content view setup****/
    float originX = 20;
    heightCount = 10;
    float width = self.frame.size.width-2*originX;
    SYShare *shareView = [[SYShare alloc] initContentWithFrame:CGRectMake(originX, heightCount, width, 0) shareDict:shareDict];
    heightCount += shareView.frame.size.height;
    [choiceContentView addSubview:shareView];
    
    UIView *functionView = [[UIView alloc] initWithFrame:CGRectMake(originX, heightCount, width, 40)];
    heightCount += functionView.frame.size.height;
    [choiceContentView addSubview:functionView];
    /*3 buttons*/
    UIButton *messageButton = [[UIButton alloc] initWithFrame:CGRectMake(functionView.frame.size.width-120, 10, 40, 40)];
    [messageButton setImage:[UIImage imageNamed:@"choiceMsgButton"] forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(writeCommentResponse) forControlEvents:UIControlEventTouchUpInside];
    [functionView addSubview: messageButton];
    
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(functionView.frame.size.width-80, 10, 40, 40)];
    [shareButton setImage:[UIImage imageNamed:@"choiceShareButton"] forState:UIControlStateNormal];
    [functionView addSubview: shareButton];
    
    UIButton *contactButton = [[UIButton alloc] initWithFrame:CGRectMake(functionView.frame.size.width-40, 10, 40, 40)];
    [contactButton addTarget:self action:@selector(contactReponse) forControlEvents:UIControlEventTouchUpInside];
    [contactButton setImage:[UIImage imageNamed:@"choiceContactButton"] forState:UIControlStateNormal];
    [functionView addSubview: contactButton];
    
    
    /*comment table*/
    float commentYStart = heightCount;
    commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, commentYStart+5, self.frame.size.width, self.frame.size.height-commentYStart-44-5) style:UITableViewStylePlain];
    [choiceContentView addSubview:commentTableView];
    [commentTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    commentTableView.delegate = self;
    commentTableView.dataSource = self;
    commentTableView.hidden = YES;
    commentTableView.backgroundColor = SYBackgroundColorExtraLight;
    //        commentTableView.alwaysBounceVertical = NO;
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer *timer){
        [commentTableView reloadData];
        [NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer *timer){
            commentTableView.hidden = NO;
            //            [loading endLoading];
        }];
    }];
    heightCount += commentTableView.frame.size.height;
    
    CGRect cframe = choiceContentView.frame;
    cframe.size.height = heightCount;
    
    
    
    
    
    //comment textField at the bottom of the view
    commentBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, uncommentOriginY, [[UIScreen mainScreen] bounds].size.width, 50)];
    commentBackgroundView.backgroundColor = SYBackgroundColorExtraLight;
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:commentBackgroundView];
    commentTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 5, commentBackgroundView.frame.size.width-90, 40)];
    commentTextField.backgroundColor = SYBackgroundColorExtraLight;
    commentTextField.delegate = self;
    [commentTextField addTarget:self action:@selector(checkEmpty) forControlEvents:UIControlEventEditingChanged];
    [commentTextField setFont:SYFont13S];
    commentTextField.textColor = SYColor1;
    [commentBackgroundView addSubview:commentTextField];
    sendMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendMessageButton.bounds = CGRectMake(0, 0, 32, 32);
    [sendMessageButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendMessageButton setTitleColor:SYColor4 forState:UIControlStateNormal];
//    [sendMessageButton setImage:[UIImage imageNamed:@"sendMsgButton"] forState:UIControlStateNormal];
    sendMessageButton.frame = CGRectMake(commentTextField.frame.origin.x+commentTextField.frame.size.width+10, 9, 50, 32);
    sendMessageButton.enabled = NO;
    [sendMessageButton addTarget:self action:@selector(submitCommentResponse) forControlEvents:UIControlEventTouchUpInside];
    [commentBackgroundView addSubview:sendMessageButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowUp:) name:UIKeyboardWillShowNotification object:nil];
    

}


-(void)extendResponse{
    CGRect exFrame = extendView.frame;
    CGRect coFrame = choiceContentView.frame;
    if (extended) {
        exFrame.origin.y = unextend;
        coFrame.origin.y = unextend+exFrame.size.height;
        extended = NO;
    }
    else{
        exFrame.origin.y = extend;
        coFrame.origin.y = extend+exFrame.size.height;
        extended = YES;
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.258];
    extendView.frame = exFrame;
    choiceContentView.frame = coFrame;
    [UIView commitAnimations];
}
-(void)contactReponse{
    SYSuscard *baseView = [[SYSuscard alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen]bounds].size.height) withCardSize:CGSizeMake(320, 240) keyboard:NO];
    baseView.cardBackgroundView.backgroundColor = SYBackgroundColorExtraLight;
    baseView.scrollView.scrollEnabled = NO;
    baseView.backButton.hidden = YES;
    
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:baseView];
    baseView.alpha = 0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.258];
    baseView.alpha = 1;
    [UIView commitAnimations];
    
    /**************content***************/
    float originX = 20;
    float heightCount = 0;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, heightCount, baseView.cardSize.width, 60)];
    heightCount += titleLabel.frame.size.height;
    titleLabel.text = @"联系方式";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setFont:SYFont15S];
    titleLabel.textColor = SYColor1;
    [baseView addGoSubview:titleLabel];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, heightCount, baseView.cardSize.width, 40)];
    nameLabel.text = [_personDict valueForKey:@"name"];
    [nameLabel setFont:SYFont15S];
    nameLabel.textColor = SYColor4;
    [baseView addGoSubview:nameLabel];
    heightCount += nameLabel.frame.size.height;
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, heightCount, baseView.cardSize.width, 40)];
    phoneLabel.text = [NSString stringWithFormat:@"联系电话：%@",[_personDict valueForKey:@"phone"]];
    [phoneLabel setFont:SYFont13];
    phoneLabel.textColor = SYColor1;
    [baseView addGoSubview:phoneLabel];
    heightCount += phoneLabel.frame.size.height;
    
    UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, heightCount, baseView.cardSize.width, 40)];
    emailLabel.text = [NSString stringWithFormat:@"联系邮箱：%@",[_personDict valueForKey:@"email"]];
    [emailLabel setFont:SYFont13];
    emailLabel.textColor = SYColor1;
    [baseView addGoSubview:emailLabel];
    
    UIButton *emailButton = [[UIButton alloc] initWithFrame:emailLabel.frame];
    [emailButton addTarget:self action:@selector(emailResponse) forControlEvents:UIControlEventTouchUpInside];
    [baseView addGoSubview:emailButton];
}
-(void)emailResponse{
    NSLog(@"email");
}



/*******write comment*******/
-(void)dismissKeyboard {
    [commentTextField resignFirstResponder];
    [self removeGestureRecognizer:tap];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.038];
    commentBackgroundView.frame = CGRectMake(commentBackgroundView.frame.origin.x, uncommentOriginY, commentBackgroundView.frame.size.width, commentBackgroundView.frame.size.height);
    [UIView commitAnimations];
}
- (void)keyboardShowUp:(NSNotification *)notification{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    float height = keyboardFrameBeginRect.size.height;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.238];
    commentBackgroundView.frame = CGRectMake(commentBackgroundView.frame.origin.x, [[UIScreen mainScreen] bounds].size.height-50-height, commentBackgroundView.frame.size.width, commentBackgroundView.frame.size.height);
    [UIView commitAnimations];
}
- (void)writeCommentResponse{
    tap = [[UITapGestureRecognizer alloc]
           initWithTarget:self
           action:@selector(dismissKeyboard)];
    [self addGestureRecognizer:tap];
    [commentTextField becomeFirstResponder];
}
-(void) checkEmpty{
    if (commentTextField.text.length != 0) {
        sendMessageButton.enabled = YES;
    }
    else{
        sendMessageButton.enabled = NO;
    }
}
- (void)submitCommentResponse{
//    _edited = YES;
//    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"];
//    NSString *type = [dic valueForKey:@"type"];
    NSString *choiceID = [choiceDict valueForKey:@"choice_id"];
    NSString *requestBody = requestBody = [NSString stringWithFormat:@"choice_id=%@&author_id=%@&msg=%@",choiceID,MEID,commentTextField.text];
//
    NSLog(@"%@",requestBody);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sendmsg",basicURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [requestBody dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                            NSLog(@"server said: %@",string);
                                            
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                NSMutableArray *commentArray = [[NSMutableArray alloc] initWithArray:[choiceDict valueForKey:@"message"]];
                                                NSDictionary *commentEle = [[NSDictionary alloc] initWithObjectsAndKeys:choiceID,@"choice_id",MEID,@"author_id",commentTextField.text,@"msg_content", nil];
                                                [commentArray addObject:commentEle];
                                                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:commentArray, @"message", nil];
                                                NSMutableDictionary *temDict = [[NSMutableDictionary alloc] initWithDictionary:choiceDict];
                                                [temDict addEntriesFromDictionary:dict];
                                                choiceDict = (NSDictionary*)temDict;
//                                                NSInteger commentNumber = [[syllabusDict valueForKey:@"comment"] count];
//                                                commentLabel.text = [NSString stringWithFormat:@"%ld",commentNumber];
                                                [commentTableView reloadData];
                                                [self dismissKeyboard];
                                                commentTextField.text = @"";
                                            });
                                        }];
    [task resume];
}
- (void)removeCommentTextField{
    [commentBackgroundView removeFromSuperview];
}


/* tableView data source and delegate*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[choiceDict valueForKey:@"message"] count];;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float height;
    if (indexPath.row<commentBasicView.count)
        height = [(SYChoiceCommentBasic*)[commentBasicView objectAtIndex:indexPath.row] frame].size.height;
    else
        height = 30;
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    SYCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[SYCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = SYBackgroundColorExtraLight;
    
    if ((indexPath.row+1)>commentBasicView.count) {
        SYChoiceCommentBasic *basicView = [[SYChoiceCommentBasic alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30) content:[[choiceDict valueForKey:@"message"] objectAtIndex:indexPath.row] MEID:MEID];
        [commentBasicView addObject:basicView];
        [cell setBasicView:basicView];
    }
    else{
        [cell setBasicView:[commentBasicView objectAtIndex:indexPath.row]];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL myComment = ((SYChoiceCommentBasic*)[commentBasicView objectAtIndex:indexPath.row]).myComment;
    if (myComment) {
//        [self deleteWarningResponse:indexPath.row];
    }else{
        [self writeCommentResponse];
    }
}
@end
