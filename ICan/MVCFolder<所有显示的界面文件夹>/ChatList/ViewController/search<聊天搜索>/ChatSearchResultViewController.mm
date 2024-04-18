//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 16/1/2021
- File name:  ChatSearchResultViewController.m
- Description:
- Function List:
*/
        

#import "ChatSearchResultViewController.h"
#import "ChatSearchHistoryResultTableViewCell.h"
#import "WCDBManager+UserMessageInfo.h"
#import "WCDBManager+GroupListInfo.h"
#import "CTMediator+CTMediatorModuleChatActions.h"
#import "ChatModel.h"
@interface ChatSearchResultViewController ()

@end

@implementation ChatSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ChatModel*model=[self.historyItems objectAtIndex:0];
    if ([model.chatType isEqualToString:GroupChat]) {
        [[WCDBManager sharedManager]fetchOneGroupListInfoWithGroupId:model.chatID successBlock:^(GroupListInfo * _Nonnull info) {
            self.title=info.name;
            
        }];
    }else{
        [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:model.chatID successBlock:^(UserMessageInfo * _Nonnull info) {
            self.title=info.remarkName?:info.nickname;
            
        }];
    }
    //friend.detail.chat 聊天
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem qmui_itemWithTitle:@"friend.detail.chat".icanlocalized target:self action:@selector(chatAction)];
}
-(void)chatAction{
    ChatModel*model=self.historyItems.firstObject;
    UIViewController*vc= [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:model.chatID,kchatType:model.chatType,kauthorityType:model.authorityType,ksearchText:self.searchText,kshouldStartLoad:@(1)}];
     [self.navigationController pushViewController:vc animated:YES];
}
-(void)initTableView{
    [super initTableView];
    [self.tableView registNibWithNibName:kChatSearchHistoryResultTableViewCell];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.historyItems.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatSearchHistoryResultTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:kChatSearchHistoryResultTableViewCell];
    cell.searchText=self.searchText;
    cell.chatModel=[self.historyItems objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatModel*model=self.historyItems.firstObject;
    UIViewController*vc= [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:model.chatID,kchatType:model.chatType,kauthorityType:model.authorityType,ksearchText:self.searchText,kshouldStartLoad:@(1),kmessageTime:model.messageTime}];
     [self.navigationController pushViewController:vc animated:YES];
}
@end
