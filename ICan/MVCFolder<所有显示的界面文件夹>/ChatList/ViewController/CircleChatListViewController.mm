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
#import "WCDBManager+ChatModel.h"
#import "BuyPackageViewController.h"
#import "CircleEditMydDataViewController.h"
#import "CTMediator+CTMediatorModuleChatActions.h"
#import "SureChatTipsView.h"
#import "WCDBManager+CircleUserInfo.h"
#import "BuyPackageView.h"
#import "ChatListModel.h"
#import "CircleUserInfo.h"
@interface CircleChatListViewController ()
//消息数据源
@property (nonatomic, strong) NSMutableArray<ChatListModel*> *messagesArray;

@property(nonatomic, strong) SureChatTipsView *sureChatTipsView;
@property(nonatomic, strong) BuyPackageView *buyPackView;
@end

@implementation CircleChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getMessage) name:KChatListRefreshNotification object:nil];
    //    "CircleChatListViewController.title"="交友消息";
    self.title=@"CircleChatListViewController.title".icanlocalized;
    [self getMessage];
    [self getPackInfoRequest];
}

-(void)getMessage{
    self.messagesArray= [NSMutableArray arrayWithArray:[[WCDBManager sharedManager]getAllCircleChatListModel]];
    [self.tableView reloadData];
}
-(void)initTableView{
    [super initTableView];
    self.tableView.rowHeight       = kCircleChatListCellHeight;
    [self.tableView registNibWithNibName:kCircleChatListCell];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.top.equalTo(@(NavBarHeight));
    }];
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
    if (seletedChatListModel.circleUserId) {
        [self checkCanPushtWith:seletedChatListModel.circleUserId chatId:seletedChatListModel.chatID];
    }else{
        GetCircleUserInfoRequest*request=[GetCircleUserInfoRequest request];
        request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/api/users/info/%@",seletedChatListModel.circleUserId];
        [[CircleNetRequestManager shareManager]startRequest:request responseClass:[CircleUserInfo class] contentClass:[CircleUserInfo class] success:^(CircleUserInfo* response) {
            [self checkCanPushtWith:response.userId chatId:seletedChatListModel.chatID];
            [[WCDBManager sharedManager]insertCircleUserInfoWithArray:@[response]];
        } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
            
        }];
    }
    
    
}
-(SureChatTipsView *)sureChatTipsView{
    if (!_sureChatTipsView) {
        _sureChatTipsView=[[NSBundle mainBundle]loadNibNamed:@"SureChatTipsView" owner:self options:nil].firstObject;
        _sureChatTipsView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }
    return _sureChatTipsView;
}
-(void)checkPaySuccessStatus:(NSString*)transactionId circleUserid:(NSString*)circleUserid chatId:(NSString*)chatId{
    CheckMyPackagesPaySuccessRequest*cRequest=[CheckMyPackagesPaySuccessRequest request];
    cRequest.pathUrlString=[cRequest.baseUrlString stringByAppendingFormat:@"/api/myPackages/pay/%@",transactionId];
    [[CircleNetRequestManager shareManager]startRequest:cRequest responseClass:[PayMyPackagesInfo class] contentClass:[PayMyPackagesInfo class] success:^(PayMyPackagesInfo* response) {
        if ([response.payStatus isEqualToString:@"Success"]) {
            [QMUITips hideAllTips];
            [self usePackgesWithCircleUserid:circleUserid chatId:chatId];
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self checkPaySuccessStatus:transactionId circleUserid:circleUserid chatId:chatId];
            });
            
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITips hideAllTips];
        [QMUITipsTool showErrorWihtMessage:@"CircleUserDetailViewController.payFailTip".icanlocalized inView:self.view];
    }];
}
/// 检查是否能跳转到聊天回话界面
/// @param circleUserid 对方的交友ID
/// @param chatId 对方的聊天ID
-(void)checkCanPushtWith:(NSString*)circleUserid chatId:(NSString*)chatId{
    [self toChatViewWith:chatId circleUserid:circleUserid];
}

-(BuyPackageView *)buyPackView{
    if (!_buyPackView) {
        _buyPackView=[[NSBundle mainBundle]loadNibNamed:@"BuyPackageView" owner:self options:nil].firstObject;
        _buyPackView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        
    }
    return _buyPackView;
}
-(void)usePackgesWithCircleUserid:(NSString*)circleUserid chatId:(NSString*)chatId{
    UsePackageRequest*urequest=[UsePackageRequest request];
    urequest.type=1;
    urequest.targetUserId=circleUserid;
    urequest.parameters=[urequest mj_JSONObject];
    [[CircleNetRequestManager shareManager]startRequest:urequest responseClass:[CheckMyPackagesInfo class] contentClass:[CheckMyPackagesInfo class] success:^(CheckMyPackagesInfo* response) {
        [QMUITips hideAllTips];
        if (response.available) {
            [self toChatViewWith:chatId circleUserid:circleUserid];
        }
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}
-(void)toChatViewWith:(NSString*)chatId circleUserid:(NSString*)circleUserid{
    UIViewController*vc= [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:chatId,kchatType:UserChat,kauthorityType:AuthorityType_circle,kcircleUserId:circleUserid}];
    [self.navigationController pushViewController:vc animated:YES];
    
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
    ChatModel * config = [[ChatModel alloc]init];
    config.authorityType = AuthorityType_circle;
    config.chatID = chatList.chatID;
    config.chatType = chatList.chatType;
    config.circleUserId = chatList.circleUserId;
    [[WCDBManager sharedManager]deleteOneChatListWithChatModel:config];
    [[WCDBManager sharedManager]deleteAllChatModelWith:config];
    UserRemoveMessageRequest*request=[UserRemoveMessageRequest request];
    request.userId=chatList.chatID;
    request.type=@"UserAll";
    request.deleteAll=true;
    request.authorityType=AuthorityType_circle;
    request.parameters=[request mj_JSONString];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        WebSocketManager.sharedManager.currentChatID=@"";
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
    [self getMessage];
    
    
}
-(void)getPackInfoRequest{
    GetPackagesRequest*request=[GetPackagesRequest request];
    [[CircleNetRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[PackagesInfo class] success:^(NSArray<PackagesInfo*>* response) {
        response.firstObject.select=YES;
        self.buyPackView.packagesItems=response;
        
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}
@end
