//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 20/1/2021
- File name:  SecertChatListViewController.m
- Description:
- Function List:
*/
        

#import "CircleChatListViewController.h"
#import "WCDBManager+ChatList.h"
#import "CircleChatListCell.h"
#import "ChatViewController.h"
#import "WCDBManager+ChatModel.h"
@interface CircleChatListViewController ()
//消息数据源
@property (nonatomic, strong) NSMutableArray<ChatListModel*> *messagesArray;
@end

@implementation CircleChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getMessage) name:KChatListRefreshNotification object:nil];
    //friend.detail.privateChat私聊
    self.title=@"friend.detail.privateChat".icanlocalized;
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem qmui_itemWithTitle:@"Close".icanlocalized target:self action:@selector(dimssViewController)];
    [self getMessage];
}
-(void)getMessage{
    self.messagesArray= [NSMutableArray arrayWithArray:[[WCDBManager sharedManager]getAllCircleChatListModel]];
    [self.tableView reloadData];
}
-(void)dimssViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)initTableView{
    [super initTableView];
    self.tableView.rowHeight       = kCircleChatListCellHeight;
    [self.tableView registNibWithNibName:kCircleChatListCell];
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
    CircleChatListCell *listCell  = [tableView dequeueReusableCellWithIdentifier:kCircleChatListCell];
    listCell.chatListModel = self.messagesArray[indexPath.row];
    return listCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatListModel *seletedChatListModel = self.messagesArray[indexPath.row];
    ChatViewController *chatVc = [[ChatViewController alloc]init];
    ChatModel *chatModel   = [[ChatModel alloc]init];
    chatModel.showName = seletedChatListModel.showName;
    chatModel.chatID = seletedChatListModel.chatID;
    chatModel.headImageUrl = seletedChatListModel.headImageUrl;
    chatModel.chatType = seletedChatListModel.chatType;
    chatModel.authorityType=AuthorityType_circle;
    chatVc.config = chatModel;
    [self.navigationController pushViewController:chatVc animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCircleChatListCellHeight;
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
    }
}

// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [@"timeline.post.operation.delete" icanlocalized:@"删除"];
}
-(void)deleteOneRowWithChatList:(ChatListModel*)chatList{
    [[WCDBManager sharedManager]deleteOneChatListWithChatId:chatList.chatID chatType:chatList.chatType authorityType:AuthorityType_circle];
    [[WCDBManager sharedManager]deleteAllChatModelWithChatId:chatList.chatID chatType:chatList.chatType authorityType:AuthorityType_circle];
    UserRemoveMessageRequest*request=[UserRemoveMessageRequest request];
    request.userId=chatList.chatID;
    request.type=@"UserAll";
    request.deleteAll=true;
    request.authorityType=AuthorityType_circle;
    request.parameters=[request mj_JSONString];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        [WebSocketManager sharedManager].currentChatID=@"";
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
    [self getMessage];
   
   
}

@end
