//
/*
- Target_Chat.m
- PackName: ICan
- TargetName: ICan
- Author: dzl
- Create: 2021/6/7
- Description:
- Function List:
Copyright © 2021 dzl. All rights reserved.
*/
    

#import "Target_Chat.h"
#import "ChatViewController.h"
#import "NewFriendsViewController.h"
#import "CTMediator.h"
#import "ChatModel.h"
@implementation Target_Chat 
-(UIViewController *)Action_nativeFetchChatViewController:(NSDictionary *)params{
    ChatViewController*vc=[[ChatViewController alloc]init];
    ChatModel*model=[[ChatModel alloc]init];
    model.chatID=[params objectForKey:kchatID];
    model.chatType =[params objectForKey:kchatType];
    model.chatMode =[params objectForKey:kchatMode];
    model.authorityType=[params objectForKey:kauthorityType];
    model.circleUserId=[params objectForKey:kcircleUserId];
    model.showName =[params objectForKey:kchatType];
    model.headImageUrl=[params objectForKey:kheadImageUrl];
    model.messageTime=[params objectForKey:kmessageTime];
    model.c2cOrderId = [params objectForKey:kC2COrderId];
    model.c2cUserId = [params objectForKey:kC2CUserId];
    vc.searchText=[params objectForKey:ksearchText];
    NSNumber*star = [params objectForKey:kshouldStartLoad];
    vc.shouldStartLoad = star.boolValue;
    vc.config = model;
    
    return vc;
}

- (UIViewController *)Action_nativeFetchNewFriendsViewController:(NSString *)isAccept {
    NewFriendsViewController *vc = [[NewFriendsViewController alloc]initWithStyle:UITableViewStyleGrouped];
    return vc;
}
@end
