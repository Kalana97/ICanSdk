//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - Author: Created  by DZL on 26/12/2019
 - File name:  GroupManagerTableViewController.m
 - Description:
 - Function List:
 */


#import "GroupManagerTableViewController.h"

#import "OwnerTransferViewController.h"
#import "SettingGroupManagerViewController.h"
#import "WCDBManager+GroupMemberInfo.h"
#import "WCDBManager+ChatModel.h"
#import "WCDBManager+ChatList.h"



@interface GroupManagerTableViewController ()
@property (weak, nonatomic) IBOutlet UIControl *transferBgCon;
@property (weak, nonatomic) IBOutlet UILabel *transferLab;
@property (weak, nonatomic) IBOutlet UIControl *settingManagerBgCin;
@property (weak, nonatomic) IBOutlet UILabel *setManagerLab;
@property (weak, nonatomic) IBOutlet UIView *oneLineView;
@property (weak, nonatomic) IBOutlet UIView *twoLineView;
@property (weak, nonatomic) IBOutlet UIControl *deleteBgCon;


@property (weak, nonatomic) IBOutlet UILabel *allShutUpLab;
@property (weak, nonatomic) IBOutlet UILabel *visibleLab;
@property (weak, nonatomic) IBOutlet UILabel *inviteLab;
@property (weak, nonatomic) IBOutlet UILabel *deleteLab;
@property (weak, nonatomic) IBOutlet UISwitch *muteSwitchBtn;
@property (weak, nonatomic) IBOutlet UISwitch *visibleSwitchBtn;
@property (weak, nonatomic) IBOutlet UISwitch *inviteSwitchBtn;
@property (weak, nonatomic) IBOutlet UILabel *muteUserLbl;
@end

@implementation GroupManagerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorBg243Color;
    self.title=NSLocalizedString(@"group.detail.listCell.groupManagement", 群管理);
    self.transferLab.text = NSLocalizedString(@"Transfer owner", 转让群);
    self.setManagerLab.text = NSLocalizedString(@"AdministratorSettings", 设置管理员);
    self.allShutUpLab.text = NSLocalizedString(@"Muted", 全员禁言);
    self.visibleLab.text = NSLocalizedString(@"Group member information is visible", 群成员信息可见);
    self.deleteLab.text =@"GroupManagerTableViewController.deleteAllMessage".icanlocalized;
    self.inviteLab.text = @"Groupchatinvitationconfirmation".icanlocalized;
    self.oneLineView.hidden = self.twoLineView.hidden =
    self.transferBgCon.hidden = self.settingManagerBgCin.hidden =
    self.deleteBgCon.hidden = [self.groupDetailInfo.role isEqualToString:@"1"];
    self.muteSwitchBtn.on = self.groupDetailInfo.allShutUp;
    self.visibleSwitchBtn.on = self.groupDetailInfo.showUserInfo;
    self.inviteSwitchBtn.on = self.groupDetailInfo.joinGroupReview;
    self.muteUserLbl.text = @"Manage restricted users".icanlocalized;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self fetchGroupMemberInfo];
}
- (IBAction)transferAction {
    OwnerTransferViewController * vc = [OwnerTransferViewController new];
    vc.groupDetailInfo = self.groupDetailInfo;
    vc.allMemberItems = self.allMemberItems;
    vc.sucessSettingOwnerBlock = ^{
        if (self.sucessSettingOwnerBlock) {
            self.sucessSettingOwnerBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)settingManagerAction {
    SettingGroupManagerViewController * vc = [SettingGroupManagerViewController new];
    vc.groupDetailInfo = self.groupDetailInfo;
    vc.allMemberItems = self.allMemberItems;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)deleteAction {
    [UIAlertController alertControllerWithTitle:nil message:@"Are you sure to delete all messages".icanlocalized target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.cancel.title".icanlocalized,@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
        if (index==1) {
            RemoveGroupAllMessageRequest*request=[RemoveGroupAllMessageRequest request];
            request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/message/remove/group/%@",self.groupDetailInfo.groupId];
            [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
                ChatModel*config = [[ChatModel alloc]init];;
                config.chatID = self.groupDetailInfo.groupId;
                config.chatType = GroupChat;
                config.authorityType = AuthorityType_friend;
                [[WCDBManager sharedManager]deleteResourceWihtChatId:self.groupDetailInfo.groupId];
                [[WCDBManager sharedManager]deleteAllChatModelWith:config];
                [[WCDBManager sharedManager]updateChatListModelLastMessageWithChatModel:config];
               
                if (self.deleteSuccessBlock) {
                    self.deleteSuccessBlock();
                }
                [WebSocketManager sharedManager].currentChatID=@"";
                [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"Clean up",清理完成) inView:self.view];
            } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                
            }];
        }
    }];
}
- (IBAction)muteSwitchAction:(id)sender {
    [self settingAllShutUpRequest];
}
- (IBAction)visibleSwitchAction:(id)sender {
    [self settingShowUserInfoRequest];
}
- (IBAction)inviteSwitchAction:(id)sender {
    [self settingJoinGroupReviewRequest];
}

- (IBAction)muteUserView:(id)sender {
    SettingGroupManagerViewController * vc = [SettingGroupManagerViewController new];
    vc.groupDetailInfo = self.groupDetailInfo;
    vc.allMemberItems = self.allMemberItems;
    vc.isMuteUserView = true;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)settingShowUserInfoRequest{
    ChangeGroupShowUserInfoRequest*request=[ChangeGroupShowUserInfoRequest request];
    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/group/%@/showUserInfo",self.groupDetailInfo.groupId];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}
-(void)settingAllShutUpRequest{
    ChangeGroupallShutUpRequest*request=[ChangeGroupallShutUpRequest request];
    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/group/%@/allShutUp",self.groupDetailInfo.groupId];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
    
}


-(void)fetchGroupMemberInfo{
    GetGroupUserListRequest*request=[GetGroupUserListRequest request];
    request.groupId=self.groupDetailInfo.groupId;
    request.parameters=[request mj_JSONString];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[GroupMemberInfo class] success:^(NSArray<GroupMemberInfo*>* response) {
        self.allMemberItems=response;
        [[WCDBManager sharedManager]insertOrReplaceGroupMemberInfoWithArray:response];
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
    
    
}
-(void)settingJoinGroupReviewRequest{
    ///group/joinGroupReview/{id}/{open}
    SettingJoinGroupReviewRequest * request = [SettingJoinGroupReviewRequest request];
    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/group/joinGroupReview/%@/%@",self.groupDetailInfo.groupId,self.inviteSwitchBtn.on?@"true":@"false"];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
            
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            
        }];
    
}
@end
