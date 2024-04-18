//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 20/1/2021
- File name:  SecertChatListViewController.m
- Description:
- Function List:
*/
        

#import "SecretChatListViewController.h"
#import "WCDBManager+ChatList.h"
#import "ChatListModel.h"
#import "SecretChatListCell.h"
#import "CTMediator+CTMediatorModuleChatActions.h"
#import "WCDBManager+ChatModel.h"
@interface SecretChatListViewController ()
//消息数据源
@property (nonatomic, strong) NSMutableArray<ChatListModel*> *messagesArray;
@end

@implementation SecretChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getMessage) name:KChatListRefreshNotification object:nil];
    //friend.detail.privateChat私聊
    self.title=@"friend.detail.privateChat".icanlocalized;
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem qmui_itemWithTitle:@"Close".icanlocalized target:self action:@selector(dimssViewController)];
    [self getMessage];
}
-(void)getMessage{
    self.messagesArray= [NSMutableArray arrayWithArray:[[WCDBManager sharedManager]getSecretChatListModel]];
    [self.tableView reloadData];
}
-(void)dimssViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)initTableView{
    [super initTableView];
    self.tableView.rowHeight       = kSecretChatListCellHeight;
    [self.tableView registNibWithNibName:kSecretChatListCell];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(@(NavBarHeight));
        make.bottom.equalTo(@(-TabBarHeight));
    }];
    
    self.tableView.showsVerticalScrollIndicator=YES;
}
-(void)layoutTableView{
    
}

#pragma mark - dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messagesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SecretChatListCell *listCell  = [tableView dequeueReusableCellWithIdentifier:kSecretChatListCell];
    listCell.chatListModel = self.messagesArray[indexPath.row];
    return listCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatListModel *seletedChatListModel = self.messagesArray[indexPath.row];
    UIViewController*vc= [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:seletedChatListModel.chatID,kchatType:UserChat,kauthorityType:AuthorityType_secret}];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kSecretChatListCellHeight;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteOneRowWithChatList:[self.messagesArray objectAtIndex:indexPath.row]];
//        [self.messagesArray removeObjectAtIndex:indexPath.row];
//        [self.tableView reloadData];
//        [[NSNotificationCenter defaultCenter]postNotificationName:KChatListRefreshNotification object:nil];
    }
}

// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [@"timeline.post.operation.delete" icanlocalized:@"删除"];
}
-(void)deleteOneRowWithChatList:(ChatListModel*)chatList{
    ChatModel * config = [[ChatModel alloc]init];
    config.authorityType = AuthorityType_secret;
    config.chatID = chatList.chatID;
    config.chatType = chatList.chatType;
    [[WCDBManager sharedManager]deleteOneChatListWithChatModel:config];
    [[WCDBManager sharedManager]deleteAllChatModelWith:config];
    UserRemoveMessageRequest*request=[UserRemoveMessageRequest request];
    request.userId=chatList.chatID;
    request.type=@"UserAll";
    request.deleteAll=true;
    request.authorityType=AuthorityType_secret;
    request.parameters=[request mj_JSONString];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        WebSocketManager.sharedManager.currentChatID=@"";
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
    [self getMessage];
   
   
}

@end
