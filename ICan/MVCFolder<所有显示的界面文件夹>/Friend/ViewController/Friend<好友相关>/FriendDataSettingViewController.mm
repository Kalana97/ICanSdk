//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 6/7/2020
- File name:  FriendDataSettingViewController.m
- Description:
- Function List:
*/
        

#import "FriendDataSettingViewController.h"
#import "WCDBManager+ChatList.h"
#import "WCDBManager+ChatModel.h"
#import "WCDBManager+UserMessageInfo.h"
#import "WCDBManager+FriendSubscriptionInfo.h"
#import "WCDBManager+ChatSetting.h"
#import "ChatSetting.h"
#import "ReportListTableViewController.h"

@interface FriendDataSettingViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *complaintLab;

@property (weak, nonatomic) IBOutlet UIControl *deleteBgCon;
@property (weak, nonatomic) IBOutlet UILabel *deleteLabel;
@property (weak, nonatomic) IBOutlet UILabel *blockLab;
@property (weak, nonatomic) IBOutlet UISwitch *blockSwitch;
@property (weak, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UIView *lineView2;

@end

@implementation FriendDataSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorBg243Color;
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.lineView1.backgroundColor=
    self.lineView2.backgroundColor= UIColorSeparatorColor;

    
    self.title=NSLocalizedString(@"InfoSetting", 资料设置);
    self.complaintLab.text = [@"friend.detail.setting.complaint" icanlocalized:@"投诉"];
    self.complaintLab.textColor =UIColorThemeMainTitleColor;

    self.deleteLabel.text = [@"friend.detail.setting.deleteFriend" icanlocalized:@"删除好友"];
    self.deleteLabel.textColor =UIColorThemeMainTitleColor;

    self.blockLab.text = [@"friend.detail.setting.addToBlockList" icanlocalized:@"加入黑名单"];
    self.blockLab.textColor =UIColorThemeMainTitleColor;

    self.blockSwitch.on=self.messageInfo.block;
    self.deleteBgCon.hidden = !self.messageInfo.isFriend;
}
- (IBAction)blockSwitchAction {
    BlockUserRequest*request=[BlockUserRequest request];
    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/blockUsers/%@",self.userId];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        self.messageInfo.block=!self.messageInfo.block;
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}
- (IBAction)complaintAction {
    ReportListTableViewController*vc=[[ReportListTableViewController alloc]init];
       vc.type=@"User";
       vc.userId=self.userId;
       [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)deleteAction {
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"UIAlertController.cancel.title".icanlocalized style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
    }];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:[@"timeline.post.operation.delete" icanlocalized:@"删除"] style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        [self deleteFriend];
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"DeleteFriendTips", 将联系人删除同时删除与该联系人的聊天记录) preferredStyle:QMUIAlertControllerStyleActionSheet];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController showWithAnimated:YES];
}
-(void)deleteFriend{
    DeleteFriendRequest*request=[DeleteFriendRequest request];
    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/userFriend/%@",self.userId];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        [QMUITipsTool showSuccessWithMessage:@"DeleteSuccess".icanlocalized inView:self.view];
        ChatModel * config = [[ChatModel alloc]init];
        config.authorityType = AuthorityType_friend;
        config.chatID = self.userId;
        config.chatType = UserChat;
        [[WCDBManager sharedManager]deleteOneChatListWithChatModel:config];
        [[WCDBManager sharedManager]deleteAllChatModelWith:config];
        [[WCDBManager sharedManager]deleteOneChatSettingWithChatId:self.userId chatType:UserChat authorityType:AuthorityType_friend];
        [[WCDBManager sharedManager]deleteFriendSubscriptionInfoWithSender:self.userId];
        [[WCDBManager sharedManager]updateFriendRelationWithUserId:self.userId isFriend:0];
        WebSocketManager.sharedManager.currentChatID=@"";
        [[NSNotificationCenter defaultCenter]postNotificationName:KChatListRefreshNotification object:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]postNotificationName:kDeleteFriendNotification object:self.userId userInfo:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
    
}
@end
