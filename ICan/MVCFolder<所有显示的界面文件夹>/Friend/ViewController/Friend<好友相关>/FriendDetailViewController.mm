//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - AUthor: Created  by DZL on 2019/10/16
 - ICan
 - File name:  FriendDetailViewController.m
 - Description:
 - Function List:
 */


#import "FriendDetailViewController.h"
#import "CTMediator+CTMediatorModuleChatActions.h"
#import "ChatUtil.h"
#import "AESEncryptor.h"


#import "WCDBManager+ChatSetting.h"
#import "ChatSetting.h"
#import "WCDBManager+UserMessageInfo.h"
#import "WCDBManager+ChatList.h"
#import "WCDBManager+ChatList.h"
#import "WCDBManager+ChatModel.h"
#import "WCDBManager+UserMessageInfo.h"
#import "WCDBManager+GroupMemberInfo.h"
#import "WCDBManager+FriendSubscriptionInfo.h"
#import "FriendSubscriptionInfo.h"

#import "TimelineSettingViewController.h"
#import "EditGroupNameViewController.h"
#import "FriendDataSettingViewController.h"
#import "TypeTimelinesViewController.h"
#import "ShowFriendHeadImageView.h"
#import "UIViewController+Extension.h"

@interface FriendDetailViewController ()<WebSocketManagerDelegate,QMUITextViewDelegate>
/// 是否可以点击同意添加好友按钮 是为了避免重复点击
@property(nonatomic, assign) BOOL isCanClikAgreeButton;
@property(nonatomic, strong) UIButton *rightButton;

@property (weak, nonatomic) IBOutlet DZIconImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *remarkNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *IDLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;

@property (weak, nonatomic) IBOutlet UIControl *setRemarkBgView;
@property (weak, nonatomic) IBOutlet UILabel *setRemarkLabel;

@property (weak, nonatomic) IBOutlet UIControl *permissionSettingsBgView;
@property (weak, nonatomic) IBOutlet UILabel *permissionSettingsLabel;
@property (weak, nonatomic) IBOutlet UILabel *momentsLabel;
@property (weak, nonatomic) IBOutlet UIView *monentLineView;

@property (weak, nonatomic) IBOutlet UIControl *invitedByView;
@property (weak, nonatomic) IBOutlet UILabel *invitedByLabel;
@property (weak, nonatomic) IBOutlet UILabel *viaLabel;
@property (weak, nonatomic) IBOutlet UIButton *inviterNameBtn;

@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *signatureContentLabel;
@property (weak, nonatomic) IBOutlet UIView *signatureLineView;

@property (weak, nonatomic) IBOutlet UIView *textViewBgView;
@property (weak, nonatomic) IBOutlet QMUITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *textViewCountLabel;
@property (weak, nonatomic) IBOutlet UIView *textViewLineView;

/** 钻石会员的加好友的背景 */
@property (weak, nonatomic) IBOutlet UIView *diamondBgView;
@property (weak, nonatomic) IBOutlet UIButton *diamondAddFriendBtn;
@property (weak, nonatomic) IBOutlet UIView *diamondLineView;

@property (weak, nonatomic) IBOutlet UIView *sendButtonBgView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *refuseButton;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (weak, nonatomic) IBOutlet UILabel *refuseTipsLabel;
@property (weak, nonatomic) IBOutlet UIView *sendSecretLineView;
@property (weak, nonatomic) IBOutlet UIButton *sendSecretButton;
@property (weak, nonatomic) IBOutlet UIView *sendSecretBgView;

@property (weak, nonatomic) IBOutlet UIStackView *blockBgView;
@property (weak, nonatomic) IBOutlet UILabel *blockTipsLabel;
@property (weak, nonatomic) IBOutlet UIView *blockLineView;
@property (nonatomic, assign) GroupMemberInfo *currentMember;

@end

@implementation FriendDetailViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorBg243Color;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateUI) name:kGetPriviSuccessNotification object:nil];
    self.title=NSLocalizedString(@"Friend Detail", 个人详情);
    self.isCanClikAgreeButton = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.invitedByView.layer.hidden = YES;
    
    [self checkGroupOwnerOrAdmin];
    
    if (![self.userId isEqualToString:[UserInfoManager sharedManager].userId]) {
        //如果不是自己 添加右上角的更多按钮
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    }
    
    [self getFriendDetail];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateFriendNotification:) name:kDeleteFriendNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateFriendNotification:) name:kAgreeFriendNotification object:nil];
    
    [self.iconImageView layerWithCornerRadius:30 borderWidth:0 borderColor:nil];
    self.IDLabel.textColor=UIColorThemeMainSubTitleColor;
    self.sexLabel.textColor=UIColorThemeMainSubTitleColor;
    self.remarkNameLabel.textColor=UIColorNavBarTitleColor;
    self.nickNameLabel.textColor=UIColorThemeMainTitleColor;
    
    self.iconImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.iconImageView addGestureRecognizer:tap];
    
    self.setRemarkLabel.text=NSLocalizedString(@"friend.detail.listCell.editContact",@"设置备注") ;
    self.permissionSettingsLabel.text=@"friend.detail.listCell.permissionSettings".icanlocalized;
    self.momentsLabel.text=@"friend.detail.listCell.Moments".icanlocalized;
    self.signatureLabel.text=NSLocalizedString(@"friend.detail.listCell.Signature", 个性签名);
    
    [self.refuseButton layerWithCornerRadius:22 borderWidth:0.8 borderColor:UIColorMake(240, 33, 77)];
    [self.agreeButton layerWithCornerRadius:22 borderWidth:0 borderColor:nil];
    self.refuseButton.backgroundColor=[UIColor whiteColor];
    [self.refuseButton setTitleColor:UIColorMake(240, 33, 77) forState:UIControlStateNormal];
    
    [self.agreeButton setBackgroundColor:UIColorThemeMainColor];
    [self.sendButton layerWithCornerRadius:22 borderWidth:0 borderColor:nil];
    [self.agreeButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    
    self.refuseTipsLabel.textColor=UIColorMake(240, 33, 77);
    [self.sendSecretButton setBackgroundColor:UIColor.whiteColor];
    [self.sendSecretButton layerWithCornerRadius:22 borderWidth:1 borderColor:UIColorThemeMainColor];
    [self.sendSecretButton setTitleColor:UIColorThemeMainColor forState:UIControlStateNormal];
    self.sendSecretButton.hidden = self.sendSecretLineView.hidden = ![UserInfoManager sharedManager].isSecret;
    //私聊
    [self.sendSecretButton setTitle:@"friend.detail.privateChat".icanlocalized forState:UIControlStateNormal];
    //接受
    [self.agreeButton setTitle:@"Accept".icanlocalized forState:UIControlStateNormal];
    [self.refuseButton setTitle:NSLocalizedString(@"Reject", 拒绝) forState:UIControlStateNormal];
    self.refuseTipsLabel.text=@"Rejected".icanlocalized;
    self.blockTipsLabel.text=@"Added to block list， You will not receive message from this user".icanlocalized;
    [self.sendButton setTitle:@"chatlist.menu.list.addfriend".icanlocalized forState:UIControlStateNormal];
    [self.diamondAddFriendBtn setTitle:@"chatlist.menu.list.addfriend".icanlocalized forState:UIControlStateNormal];
    [self.diamondAddFriendBtn layerWithCornerRadius:22 borderWidth:0 borderColor:nil];
    
    [self updateUI];
}

-(void)checkGroupOwnerOrAdmin{
    if (self.isGroupOwnerOrAdmin == YES) {
        for (GroupMemberInfo *groupMember in self.sortGroupMemberInfoItems) {
            if(groupMember.userId == self.userId){
                self.currentMember = groupMember;
                break;
            }
        }
        if ([self.currentMember.role isEqualToString:@"2"]) {
            [self showInvitedBy];
            self.userId = self.currentMember.userId;
        }
        
    }else{
        self.invitedByView.layer.hidden = YES;
        if (!self.userMessageInfo) {
            self.userMessageInfo= [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:self.userId];
        }else{
            self.userId=self.userMessageInfo.userId;
        }
    }
}

-(IBAction)inviterNameBtnAction:(id)sender {
    NSString *role = [self getUserRole:[self.currentMember.invitedBy valueForKey:@"id"]];
    if ([role isEqualToString:@"2"]) {
        self.userId = [NSString stringWithFormat:@"%@", [self.currentMember.invitedBy valueForKey:@"id"]];
        [self checkGroupOwnerOrAdmin];
        [self getFriendDetail];
    }
}

-(void)updateUI{
    [self.iconImageView setDZIconImageViewWithUrl:self.userMessageInfo.headImgUrl gender:self.userMessageInfo.gender];
    if ([self.userMessageInfo.remarkName isEqual:@""] || self.userMessageInfo.remarkName == nil) {
        self.remarkNameLabel.hidden=YES;
        self.nickNameLabel.textColor=UIColorNavBarTitleColor;
        self.nickNameLabel.text=[NSString stringWithFormat:@"%@",self.userMessageInfo.nickname];
    }else{
        self.remarkNameLabel.hidden = NO;
        self.remarkNameLabel.textColor=UIColorNavBarTitleColor;
           self.nickNameLabel.textColor=UIColorThemeMainTitleColor;
        self.remarkNameLabel.text=self.userMessageInfo.remarkName;
        self.nickNameLabel.text=[NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"nickname", 昵称),self.userMessageInfo.nickname];
    }
    
    self.IDLabel.text=[NSString stringWithFormat:@"ID：%@",self.userMessageInfo.numberId];
    if ([self.userMessageInfo.gender isEqualToString:@"1"]) {
        self.sexLabel.text=[NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"mine.profile.title.more.gender", 性别),NSLocalizedString(@"Male", 男)];
    }else if ([self.userMessageInfo.gender isEqualToString:@"2"]){
        self.sexLabel.text=[NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"mine.profile.title.more.gender", 性别),NSLocalizedString(@"Female", 女)];
    }else{
        self.sexLabel.text=[NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"mine.profile.title.more.gender", 性别),[@"tip.notSet" icanlocalized:@"未设置"]];
    }
    self.signatureContentLabel.text=self.userMessageInfo.signature;
    //如果是自己的用户详情
    if ([self.userMessageInfo.userId isEqualToString:[UserInfoManager sharedManager].userId]) {
        self.setRemarkBgView.hidden = self.permissionSettingsBgView.hidden = self.invitedByView.hidden = self.monentLineView.hidden = self.signatureLineView.hidden = self.blockBgView.hidden = self.blockLineView.hidden = self.sendSecretLineView.hidden = self.sendButtonBgView.hidden = self.sendSecretBgView.hidden = self.textViewBgView.hidden = self.textViewLineView.hidden = YES;
        self.diamondBgView.hidden = self.diamondLineView.hidden = YES;
    }else{
        if (self.userMessageInfo.isFriend) {
            if (self.userMessageInfo.block) {
                self.blockLineView.hidden=self.blockBgView.hidden = NO;
                
            }else{
                self.blockLineView.hidden=self.blockBgView.hidden = YES;
            }
            self.refuseButton.hidden = YES;
            self.agreeButton.hidden = YES;
            self.sendButton.hidden = NO;
            self.refuseTipsLabel.hidden = YES;
            self.textViewBgView.hidden = self.textViewLineView.hidden = YES;
            self.diamondBgView.hidden = self.diamondLineView.hidden = YES;
            //聊天
            [self.sendButton setTitle:@"friend.detail.chat".icanlocalized forState:UIControlStateNormal];
            self.setRemarkBgView.hidden = self.permissionSettingsBgView.hidden = self.monentLineView.hidden = self.sendSecretBgView.hidden = self.sendSecretLineView.hidden = NO;
        }else{
            self.blockLineView.hidden = self.blockBgView.hidden = YES;
            self.setRemarkBgView.hidden = self.permissionSettingsBgView.hidden = self.monentLineView.hidden = self.sendSecretBgView.hidden = self.sendSecretLineView.hidden = YES;
            switch (self.friendDetailType) {
                case FriendDetailType_fromNewFriend:{
                    self.textView.editable=NO;
                    self.textView.text=self.friendSubscriptionInfo.message;
                    self.textViewCountLabel.hidden=YES;
                    self.diamondBgView.hidden = YES;
                    switch (self.friendSubscriptionInfo.subscriptionType) {
                        case 0:{//拒绝
                            self.refuseButton.hidden=YES;
                            self.agreeButton.hidden=YES;
                            self.sendButton.hidden=YES;
                            self.refuseTipsLabel.hidden=NO;
                        }
                            
                            break;
                        case 1:{//同意
                            self.refuseButton.hidden=NO;
                            self.agreeButton.hidden=NO;
                            self.sendButton.hidden=YES;
                            self.refuseTipsLabel.hidden=YES;
                        }
                            break;
                        case 2:{//未处理
                            self.refuseButton.hidden=NO;
                            self.agreeButton.hidden=NO;
                            self.sendButton.hidden=YES;
                            self.refuseTipsLabel.hidden=YES;
                        }
                            break;
                    }
                }
                    
                    break;
                default:{
                    if (UserInfoManager.sharedManager.diamondValid) {
                        self.refuseButton.hidden = YES;
                        self.agreeButton.hidden = YES;
                        self.sendButton.hidden = NO;
                        self.diamondLineView.hidden = self.diamondBgView.hidden = NO;
                        self.refuseTipsLabel.hidden = YES;
                        self.textViewCountLabel.hidden = NO;
                        self.textView.editable = YES;
                        self.textView.placeholder = NSLocalizedString(@"Request to add you as a friend", 请求添加你为好友);
                        [self.sendButton setTitle:@"friend.detail.chat".icanlocalized forState:UIControlStateNormal];
                    }else{
                        self.refuseButton.hidden = YES;
                        self.agreeButton.hidden = YES;
                        self.diamondLineView.hidden = self.diamondBgView.hidden = YES;
                        self.sendButton.hidden = NO;
                        self.refuseTipsLabel.hidden = YES;
                        self.textViewCountLabel.hidden = NO;
                        self.textView.editable = YES;
                        self.textView.placeholder = NSLocalizedString(@"Request to add you as a friend", 请求添加你为好友);
                        [self.sendButton setTitle:@"friend.detail.chat".icanlocalized forState:UIControlStateNormal];
                        [self.sendButton setTitle:@"chatlist.menu.list.addfriend".icanlocalized forState:UIControlStateNormal];
                    }
                }
                    break;
            }
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self removeVcWithArray:@[@"QRCodeController"]];
}

-(void)showInvitedBy{
    self.invitedByView.hidden = NO;
    self.invitedByLabel.text = [NSString stringWithFormat:@"%@:", @"InvitedBy".icanlocalized];
    self.inviterNameBtn.tintColor = [UIColor systemBlueColor];
    NSString *title = [self.currentMember.invitedBy valueForKey:@"nickname"];
    [self.inviterNameBtn setTitle:title forState:UIControlStateNormal];
    NSString *role = [self getUserRole:[self.currentMember.invitedBy valueForKey:@"id"]];
    
    if ([role isEqualToString: @"2"]) {
        [self.inviterNameBtn setTitleColor:UIColor.systemBlueColor forState:UIControlStateNormal];
        self.inviterNameBtn.enabled = YES;
    }else{
        [self.inviterNameBtn setTitleColor:UIColorMakeWithAlpha(25, 27, 30, 0.6) forState:UIControlStateNormal];
        self.inviterNameBtn.enabled = NO;
    }
    
    if(self.currentMember.joinType != nil){
        
        NSString *joinType = @"";
        
        if([self.currentMember.joinType isEqualToString:@"Invite"]){
            joinType = @"InvitedByInvite".icanlocalized;
        }else if([self.currentMember.joinType isEqualToString:@"Create"]){
            joinType = @"InvitedByCreate".icanlocalized;
        }else if([self.currentMember.joinType isEqualToString:@"QRCode"]){
            joinType = @"InvitedByQRCode".icanlocalized;
        }else if([self.currentMember.joinType isEqualToString:@"Manager"]){
            joinType = @"InvitedByManager".icanlocalized;
        }else if([self.currentMember.joinType isEqualToString:@"Search"]){
            joinType = @"InvitedBySearch".icanlocalized;
        }else{
            joinType = @"InvitedByOther".icanlocalized;
        }
        
        if (BaseSettingManager.isChinaLanguages) {
            self.viaLabel.text = [joinType stringByAppendingString: @" 进群"];
        }else{
            self.viaLabel.text = [@"via ".icanlocalized stringByAppendingString:joinType];
        }
    }else{
        self.viaLabel.hidden = YES;
    }
}

-(NSString*)getUserRole:(NSString*)userId{
    NSString *role = @"";
    for (GroupMemberInfo *groupMember in self.sortGroupMemberInfoItems) {
        if([groupMember.userId intValue] == [userId intValue]){
            role = groupMember.role;
            break;
        }
    }
    return role;
}

-(void)textViewDidChange:(UITextView *)textView{
    self.textViewCountLabel.text=[NSString stringWithFormat:@"%lu/30",(unsigned long)textView.text.length];
}

-(void)tapAction{
    ShowFriendHeadImageView * view = [[ShowFriendHeadImageView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth , ScreenHeight)];
    [view.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.userMessageInfo.headImgUrl] placeholderImage:[self.userMessageInfo.gender isEqualToString:@"2"]?[UIImage imageNamed:GirlDefault]:[UIImage imageNamed:BoyDefault]];
    [view showView];
    
}

-(void)updateSecretShow{
    [self updateUI];
}

-(IBAction)setRemarkAction {
    EditGroupNameViewController*vc=[[EditGroupNameViewController alloc]init];
    vc.editNameType=EditNameType_UserRemark;
    vc.userMessageInfo=self.userMessageInfo;
    vc.editSuccessBlock = ^(NSString * _Nonnull name) {
        self.userMessageInfo.remarkName=name;
        [self updateUI];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)setPerfimissionAction {
    TimelineSettingViewController*vc=[[TimelineSettingViewController alloc]init];
    vc.userMessageInfo=self.userMessageInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)momentAction:(id)sender {
    TypeTimelinesViewController * vc = [[TypeTimelinesViewController alloc]initWithStyle:UITableViewStyleGrouped];
    vc.userId = self.userId;
    vc.timelineType=TimelineType_UserAll;
    vc.usermessageInfo=self.userMessageInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)diamonAddFriendAction {
    [self applyForAddFriend];
}

-(IBAction)sendButtonAction:(id)sender {
    ChatModel *chatModel   = [[ChatModel alloc]init];
    chatModel.showName = self.userMessageInfo.nickname;
    chatModel.chatID = self.userMessageInfo.userId;
    chatModel.chatType = UserChat;
    if (self.userMessageInfo.isFriend) {
        switch (self.friendDetailType) {
            case FriendDetailType_popChatView:{
                for (UIViewController * vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:NSClassFromString(@"ChatViewController")]) {
                        [self.navigationController popToViewController:vc animated:NO];
                        break;
                    }
                }
            }
                break;
            case  FriendDetailType_pushChatViewNotification:{
                [self.navigationController popToRootViewControllerAnimated:NO];
                [[NSNotificationCenter defaultCenter]postNotificationName:kChatWithFriendNotification object:chatModel];
            }
                break;
            case FriendDetailType_fromNewFriend:{
                UIViewController*vc= [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:chatModel.chatID,kchatType:UserChat,kauthorityType:AuthorityType_friend}];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case FriendDetailType_push:{
                UIViewController*vc= [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:chatModel.chatID,kchatType:UserChat,kauthorityType:AuthorityType_friend}];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
        
    }else{
        //如果自己是VIP会员或者是钻石会员
        if (UserInfoManager.sharedManager.diamondValid) {
            UIViewController*vc= [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:chatModel.chatID,kchatType:UserChat,kauthorityType:AuthorityType_friend}];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [self applyForAddFriend];
        }
    }
}

-(IBAction)refuseAction:(id)sender {
    self.friendSubscriptionInfo.subscriptionType=0;
    [[WCDBManager sharedManager]updateFriendSubscriptionIsHasReadWithSender:self.friendSubscriptionInfo.sender SubscriptionType:0];
    [self updateUI];
    if (self.refuseButtonBlock) {
        self.refuseButtonBlock();
    }
}

-(IBAction)acceptAction:(id)sender {
    [self agreeFriendRequest:self.userId];
}

-(IBAction)sendScretAction:(id)sender {
    UIViewController*vc= [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:self.userMessageInfo.userId,kchatType:UserChat,kauthorityType:AuthorityType_secret}];
    [self.navigationController pushViewController:vc animated:YES];
}

-(UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton=[UIButton dzButtonWithTitle:nil image:nil backgroundColor:UIColor.clearColor titleFont:0 titleColor:nil target:self action:@selector(rightBarButtonItemAction)];
        _rightButton.frame=CGRectMake(0, 0, 20, 20);
        [_rightButton setBackgroundImage:[UIImage imageNamed:@"icon_nav_more_black"] forState:UIControlStateNormal];
        
    }
    return _rightButton;
}

-(void)updateFriendNotification:(NSNotification*)notifi{
    NSString*friendId=notifi.object;
    if ([friendId isEqualToString:self.userId]) {
        [self getFriendDetail];
    }
}

-(void)rightBarButtonItemAction{
    FriendDataSettingViewController*vc=[[FriendDataSettingViewController alloc]init];
    vc.userId=self.userId;
    vc.messageInfo=self.userMessageInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)deleteFriend{
    DeleteFriendRequest*request=[DeleteFriendRequest request];
    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/userFriend/%@",self.userId];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        [QMUITipsTool showSuccessWithMessage:@"DeleteSuccess".icanlocalized inView:self.view];
        ChatModel * config = [[ChatModel alloc]init];
        config.authorityType = AuthorityType_friend;
        config.chatID = self.userMessageInfo.userId;
        config.chatType = UserChat;
        [[WCDBManager sharedManager]deleteOneChatListWithChatModel:config];
       
        [[WCDBManager sharedManager]deleteAllChatModelWith:config];
        [[WCDBManager sharedManager]deleteOneChatSettingWithChatId:self.userMessageInfo.userId chatType:UserChat authorityType:AuthorityType_friend];
        [[WCDBManager sharedManager]deleteFriendSubscriptionInfoWithSender:self.userMessageInfo.userId];
        [[WCDBManager sharedManager]updateFriendRelationWithUserId:self.userMessageInfo.userId isFriend:0];
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

#pragma mark -- 发送添加好友消息
-(void)applyForAddFriend {
    ApplyFriendRequest*request=[ApplyFriendRequest request];
    request.userId=@([self.userMessageInfo.userId integerValue]);
    if([self.textView.text isEqualToString:@""]){
        request.message = NSLocalizedString(@"Request to add you as a friend", 请求添加你为好友);
    }else{
        request.message = self.textView.text;
    }
    request.parameters=[request mj_JSONObject];
    [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:NO];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        [QMUITipsTool showSuccessWithMessage:@"FriendRequestSentSuccess".icanlocalized inView:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
    
}

//获取好友详情
-(void)getFriendDetail{
    GetUserMessageRequest*request=[GetUserMessageRequest request];
    request.userId=self.userId;
    request.parameters=[request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[UserMessageInfo class] contentClass:[UserMessageInfo class] success:^(UserMessageInfo* response) {
        self.userMessageInfo = response;
        [[WCDBManager sharedManager]updateIsService:response.cs userId:response.userId];
        //更新群头像
        if (response.headImgUrl) {
            [[WCDBManager sharedManager]updateGroupMemberHeadImageUrlWithUserId:response.userId headImg:response.headImgUrl];
        }
        [[WCDBManager sharedManager]insertUserMessageInfo:response];
        //发送通知更新tableView
        [[NSNotificationCenter defaultCenter]postNotificationName:kUserMessageChangeNotificatiaon object:nil];
        [self updateUI];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

//同意添加好友
-(void)agreeFriendRequest:(NSString*)userId{
    if (!self.isCanClikAgreeButton) {
        return;
    }
    AgreeFriendRequest*request=[AgreeFriendRequest request];
    request.userId=@(userId.integerValue);
    request.parameters=[request mj_JSONObject];
    self.isCanClikAgreeButton=NO;
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        [[WCDBManager sharedManager]updateFriendSubscriptionIsHasReadWithSender:userId SubscriptionType:1];
        [self getFriendDetail];
        [[NSNotificationCenter defaultCenter]postNotificationName:kAgreeFriendNotification object:userId];
        [QMUITipsTool showSuccessWithMessage:NSLocalizedString(@"Friend added successfully", 成功添加好友) inView:self.view];
        ChatModel*model=[ChatUtil initAddFriendWithChatId:userId authorityType:AuthorityType_friend];
        [[WCDBManager sharedManager]cacheMessageWithChatModel:model isNeedSend:YES];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        self.isCanClikAgreeButton=YES;
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}
@end
