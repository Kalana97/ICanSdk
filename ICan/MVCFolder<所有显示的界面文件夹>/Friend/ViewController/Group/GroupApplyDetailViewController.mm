//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/10/2021
- File name:  GroupApplyDetailViewController.m
- Description:
- Function List:
*/
        

#import "GroupApplyDetailViewController.h"
#import "WCDBManager+GroupListInfo.h"
#import "WCDBManager+UserMessageInfo.h"
#import "GroupApplyInfo.h"
#import "WCDBManager+GroupApplyInfo.h"
@interface GroupApplyDetailViewController ()
@property (weak, nonatomic) IBOutlet DZIconImageView *inviteIconImgView;
@property (weak, nonatomic) IBOutlet UILabel *inviteNicknameLab;
@property (weak, nonatomic) IBOutlet UILabel *tipsLab;
@property (weak, nonatomic) IBOutlet UILabel *groupnameLab;

@property (weak, nonatomic) IBOutlet DZIconImageView *beInviteIconImgView;
@property (weak, nonatomic) IBOutlet UILabel *beInviteNicknameLab;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;


@end

@implementation GroupApplyDetailViewController
- (IBAction)sureBtnAction:(id)sender {
    if (!self.info.isAgree) {
        InviteGroupRequest*request=[InviteGroupRequest request];
        request.groupId = @(self.info.groupId.integerValue);
        request.joinType = self.info.joinType;
        request.inviterId = @(self.info.inviterId.integerValue);
        request.userIds = @[self.info.userId];
        request.operater = @(UserInfoManager.sharedManager.userId.intValue);
        request.parameters=[request mj_JSONString];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
            
            self.info.isAgree = YES;
            [[WCDBManager sharedManager]updateGroupApplyInfoAgreeWithMessageId:self.info.messageId];
            if (self.agreeBlock) {
                self.agreeBlock(self.info);
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            
        }];
    }
    
}
-(void)setBtnUI{
    if (self.info.isAgree) {
        [self.sureBtn setTitle:@"Confirminvitation".icanlocalized forState:UIControlStateNormal];
        [self.sureBtn setBackgroundColor:UIColorBg243Color];
        [self.sureBtn setTitleColor:UIColor153Color forState:UIControlStateNormal];
    }else{
        [self.sureBtn setTitle:@"Confirminvitation".icanlocalized forState:UIControlStateNormal];
        [self.sureBtn setBackgroundColor:UIColorThemeMainColor];
        [self.sureBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBtnUI];
    [self.sureBtn layerWithCornerRadius:22 borderWidth:0 borderColor:nil];
    self.title =@"InvitationDetails".icanlocalized;
    [self.inviteIconImgView layerWithCornerRadius:40 borderWidth:0 borderColor:nil];
    [self.beInviteIconImgView layerWithCornerRadius:40 borderWidth:0 borderColor:nil];
    self.tipsLab.text = @"InviteAfriendJoingroup".icanlocalized;
    [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:self.info.inviterId successBlock:^(UserMessageInfo * _Nonnull uinfo) {
        [self.inviteIconImgView setDZIconImageViewWithUrl:uinfo.headImgUrl gender:uinfo.gender];
        self.inviteNicknameLab.text = uinfo.nickname;
        
    }];
   
    [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:self.info.userId successBlock:^(UserMessageInfo * _Nonnull uinfo) {
        [self.beInviteIconImgView setDZIconImageViewWithUrl:uinfo.headImgUrl gender:uinfo.gender];
        self.beInviteNicknameLab.text = uinfo.nickname;
        
    }];
    [[WCDBManager sharedManager]fetchOneGroupListInfoWithGroupId:self.info.groupId successBlock:^(GroupListInfo * _Nonnull listInfo) {
        self.groupnameLab.text = [NSString stringWithFormat:@"%@",listInfo.name];;
    }];
    
}


@end
