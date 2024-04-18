//
//  GroupListViewController.m
//  EasyPay
//
//  Created by 刘志峰 on 2019/8/28.
//  Copyright © 2019 EasyPay. All rights reserved.
//

#import "GroupListViewController.h"
#import "GroupListTableViewCell.h"
#import "CTMediator+CTMediatorModuleChatActions.h"
#import "WCDBManager+GroupListInfo.h"
#import "WCDBManager+ChatList.h"
#import "WCDBManager+ChatModel.h"
#import "SelectMembersViewController.h"
@interface GroupListViewController ()
@property (nonatomic,strong) NSMutableArray *modelArr;
@property (nonatomic,strong) NSMutableArray<GroupListInfo*> * listItems;

@end

@implementation GroupListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=NSLocalizedString(@"Group Chats", 群聊);
    if (!self.fromTranpond) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"New Chat".icanlocalized style:UIBarButtonItemStylePlain target:self action:@selector(addGroup)];
    }
    [self getGroupList];
    self.listItems = [NSMutableArray arrayWithArray:[[WCDBManager sharedManager]getAllGroupListInfo]];
    [self.tableView reloadData];
}

-(void)addGroup{
    SelectMembersViewController * vc = [SelectMembersViewController new];
    vc.createGroupSuccessBlock = ^(NSString *groupId, NSString *groupName) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    };
    vc.chatWithFriendSuccessBlock = ^(ChatModel *model) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    };
    vc.selectMemberType=SelectMembersType_chatList;
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
    
    
}
-(void)initTableView{
    [super initTableView];
    [self.tableView registerClass:[GroupListTableViewCell class] forCellReuseIdentifier:kGroupListTableViewCell];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return !self.fromTranpond;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self quickGroupAtIndexPath:indexPath];
        
    }
}

// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [@"timeline.post.operation.delete" icanlocalized:@"删除"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listItems.count;;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GroupListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGroupListTableViewCell];
    cell.groupListInfo = self.listItems[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self goNextVCWithModel:self.listItems[indexPath.row]];
}

#pragma mark -- 退出群聊
-(void)quickGroupAtIndexPath:(NSIndexPath *)indexPath{
    GroupListInfo*info=[self.listItems objectAtIndex:indexPath.row];
    QuitGroupRequest*request=[QuitGroupRequest request];
    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/group/exit/%@",info.groupId];
    [QMUITipsTool showLoadingWihtMessage:NSLocalizedString(@"Exit Group...", 退群中...) inView:self.view];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        [QMUITipsTool showSuccessWithMessage:NSLocalizedString(@"Quit successfully", 成功退出) inView:self.view];
        ChatModel * config = [[ChatModel alloc]init];
        config.authorityType = AuthorityType_friend;
        config.chatID = info.groupId;
        config.chatType = GroupChat;
        [[WCDBManager sharedManager]deleteOneChatListWithChatModel:config];
        
        [[WCDBManager sharedManager]deleteAllChatModelWith:config];
        [[WebSocketManager sharedManager]unsubscribeGroupWithGroupId:info.groupId];
        [self.listItems removeObject:info];
        [self.tableView reloadData];
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
    
}
#pragma mark -- 获取群聊列表
-(void)getGroupList {
    GetGroupListRequest*request=[GetGroupListRequest request];
    [QMUITipsTool showLoadingWihtMessage:nil inView:self.view];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[GroupListInfo class] success:^(NSArray * response) {
        [QMUITips hideAllTips];
        self.listItems=[NSMutableArray arrayWithArray:response];
        [self.tableView reloadData];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}

#pragma mark -- 点击群列表跳转到聊天页
-(void)goNextVCWithModel:(GroupListInfo *)model {
    if (self.fromTranpond) {
        if (self.selectBlock) {
            self.selectBlock(@[model]);
        }
    }else{
        UIViewController*vc= [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:model.groupId,kchatType:GroupChat,kauthorityType:AuthorityType_friend,kshowName:model.name}];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

@end
