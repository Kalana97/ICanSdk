//
//  QrScanResultAddRoomController.m
//  ICan
//
//  Created by Limaohuyu666 on 2019/10/23.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "QrScanResultAddRoomController.h"
#import "UIButton+HYQUIButton.h"
#import "ChatUtil.h"
#import "WCDBManager.h"
#import "CTMediator+CTMediatorModuleChatActions.h"
#import "UIViewController+Extension.h"

@interface QrScanResultAddRoomController ()
@property (nonatomic,weak) IBOutlet UILabel * roomNameLabel;
@property (nonatomic,weak) IBOutlet UILabel * roomAmountLabel;
@property (nonatomic,weak) IBOutlet UIImageView * roomIconImageView;
@property (nonatomic,weak) IBOutlet UIButton * sureAddButton;

@property (nonatomic,assign) BOOL isInTheRoom;
@property (nonatomic,copy)  NSString *shareUserId;

@end

@implementation QrScanResultAddRoomController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self removeVcWithArray:@[@"QRCodeController"]];
}
-(void)setupView{
    self.title = self.groupDetailInfo.name;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.roomIconImageView];
    [self.sureAddButton setTitle:NSLocalizedString(@"Join the group chat", 加入群聊) forState:UIControlStateNormal];
    [self.roomIconImageView layerWithCornerRadius:ScreenWidth/3/2 borderWidth:0 borderColor:nil];
    
    self.roomNameLabel.text = self.groupDetailInfo.name;
    if (BaseSettingManager.isChinaLanguages) {
        self.roomAmountLabel.text = [NSString stringWithFormat:@"ID:%@ (%@人)",self.groupDetailInfo.groupNumberId,self.groupDetailInfo.userCount];
    }else{
        self.roomAmountLabel.text = [NSString stringWithFormat:@"ID:%@ (%@ Participants)",self.groupDetailInfo.groupNumberId,self.groupDetailInfo.userCount];
    }
    
    [self.roomIconImageView setImageWithString:self.groupDetailInfo.headImgUrl placeholder:GroupDefault];
    
    
}

-(IBAction)addButtonAction{
    InviteGroupRequest * request = [InviteGroupRequest request];
    request.groupId = @([self.groupDetailInfo.groupId integerValue]);
    if (!self.fromAddFriend) {
        request.inviterId = @([self.inviterId integerValue]);
        request.joinType =@"QRCode";
    }else{
        request.joinType =@"Search";
    }
    NSNumber * userId = @([[UserInfoManager sharedManager].userId integerValue]);
    request.userIds = @[userId];
    request.parameters= [request mj_JSONString];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        if (!self.groupDetailInfo.joinGroupReview) {
            [self gotoGroupChatController];
        }else{
            [QMUITipsTool showSuccessWithMessage:@"Thereviewsubmitted".icanlocalized inView:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
    
}

-(void)gotoGroupChatController{
    GetGroupDetailRequest * request =[GetGroupDetailRequest request];
    request.pathUrlString = [NSString stringWithFormat:@"%@/group/%@",request.baseUrlString,self.groupDetailInfo.groupId];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[GroupDetailInfo class] contentClass:[GroupDetailInfo class] success:^(GroupDetailInfo * response) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [QMUITips hideAllTips];
        });
        //订阅群消息
        [[WebSocketManager sharedManager]subscriptionGroupWihtGroupId:response.groupId];
        UIViewController*vc= [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:response.groupId,kchatType:GroupChat,kauthorityType:AuthorityType_friend}];
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
    
}


@end
