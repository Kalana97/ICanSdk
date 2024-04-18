//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 9/5/2020
 - File name:  ICanHelpSettingViewController.m
 - Description:
 - Function List:
 */


#import "ICanHelpSettingViewController.h"
#import "HJCActionSheet.h"
#import "WCDBManager+ChatModel.h"
#import "WCDBManager+ChatList.h"
#import "WCDBManager+ChatSetting.h"
#import "ChatSetting.h"

@interface ICanHelpSettingViewController ()<HJCActionSheetDelegate>
@property (nonatomic,strong) HJCActionSheet * hjcActionSheet;
@property (nonatomic,strong) ChatSetting * chatSetting;
@property (weak, nonatomic) IBOutlet UILabel *topChatLab;
@property (weak, nonatomic) IBOutlet UISwitch *topChatSwitchBtn;

@property (weak, nonatomic) IBOutlet UILabel *muteLab;
@property (weak, nonatomic) IBOutlet UISwitch *muteSwitchBtn;
@property (weak, nonatomic) IBOutlet UILabel *deleteLab;
@property (weak, nonatomic) IBOutlet UIView *line10pxBgView;
@property (weak, nonatomic) IBOutlet UIControl *itemBgView;
@property (weak, nonatomic) IBOutlet UIControl *itemBgView1;
@property (weak, nonatomic) IBOutlet UIControl *itemBgView2;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation ICanHelpSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorBg243Color;
    self.lineView.backgroundColor = UIColorSeparatorColor;
    self.title=@"mine.listView.cell.setting".icanlocalized;
    ChatModel * config = [[ChatModel alloc]init];
    config.authorityType = AuthorityType_friend;
    config.chatType = UserChat;
    switch (self.type) {
        case ICanHelpSettingTypeSystem:
            config.chatID = SystemHelperMessageType;
            self.chatSetting=[[WCDBManager sharedManager]fetchChatSettingWith:config];
            break;
        case ICanHelpSettingTypePay:
            config.chatID = PayHelperMessageType;
            self.chatSetting=[[WCDBManager sharedManager]fetchChatSettingWith:config];
            break;
        case ICanHelpSettingTypeAnnouncement:
            config.chatID = AnnouncementHelperMessageType;
            self.chatSetting=[[WCDBManager sharedManager]fetchChatSettingWith:config];
            break;
        case ICanHelpSettingTypeC2C:
            config.chatID = C2CHelperMessageType;
            config.chatType = C2CHelperMessageType;
            self.chatSetting=[[WCDBManager sharedManager]fetchChatSettingWith:config];
            break;
        case ICanHelpSettingTypeNoticeOTP:
            config.chatID = NoticeOTPMessageType;
            config.chatType = NoticeOTPMessageType;
            self.chatSetting = [[WCDBManager sharedManager]fetchChatSettingWith:config];
            break;
        default:
            break;
    }
    self.muteLab.text = NSLocalizedString(@"Mute Notifications", 消息免打扰);
    self.muteLab.textColor = UIColorThemeMainTitleColor;
    self.muteSwitchBtn.on = self.chatSetting.isNoDisturbing;
    
    self.topChatLab.text = NSLocalizedString(@"Sticky on Top", 置顶聊天);
    self.topChatLab.textColor = UIColorThemeMainTitleColor;

    self.topChatSwitchBtn.on = self.chatSetting.isStick;
    
    self.deleteLab.text = NSLocalizedString(@"Clear Chat History", 清空聊天记录);
    self.deleteLab.textColor = UIColorThemeMainTitleColor;

}
- (IBAction)muteAction {
    switch (self.type) {
        case ICanHelpSettingTypePay:{
            [[WCDBManager sharedManager]updateIsNoDisturbing:self.muteSwitchBtn.isOn chatId:PayHelperMessageType chatType:UserChat];
            [[WCDBManager sharedManager]updateChatSettingIsNoDisturbing:self.muteSwitchBtn.isOn chatId:PayHelperMessageType chatType:UserChat authorityType:AuthorityType_friend];
            [self settingHelp:self.muteSwitchBtn.isOn];
        }
            break;
        case ICanHelpSettingTypeSystem:{
            [[WCDBManager sharedManager]updateIsNoDisturbing:self.muteSwitchBtn.isOn chatId:SystemHelperMessageType chatType:UserChat];
            [[WCDBManager sharedManager]updateChatSettingIsNoDisturbing:self.muteSwitchBtn.isOn chatId:SystemHelperMessageType chatType:UserChat authorityType:AuthorityType_friend];
            [self settingHelp:self.muteSwitchBtn.isOn];
        }
            break;
        case ICanHelpSettingTypeAnnouncement:{
            [[WCDBManager sharedManager]updateIsNoDisturbing:self.muteSwitchBtn.isOn chatId:AnnouncementHelperMessageType chatType:UserChat];
            [[WCDBManager sharedManager]updateChatSettingIsNoDisturbing:self.muteSwitchBtn.isOn chatId:AnnouncementHelperMessageType chatType:UserChat authorityType:AuthorityType_friend];
            [self settingHelp:self.muteSwitchBtn.isOn];
        }

            break;
        case ICanHelpSettingTypeC2C:{
            [[WCDBManager sharedManager]updateIsNoDisturbing:self.muteSwitchBtn.isOn chatId:C2CHelperMessageType chatType:C2CHelperMessageType];
            [[WCDBManager sharedManager]updateChatSettingIsNoDisturbing:self.muteSwitchBtn.isOn chatId:C2CHelperMessageType chatType:C2CHelperMessageType authorityType:AuthorityType_friend];
        }
            break;
        case ICanHelpSettingTypeNoticeOTP:{
            [[WCDBManager sharedManager]updateIsNoDisturbing:self.muteSwitchBtn.isOn chatId:NoticeOTPMessageType chatType:NoticeOTPMessageType];
            [[WCDBManager sharedManager]updateChatSettingIsNoDisturbing:self.muteSwitchBtn.isOn chatId:NoticeOTPMessageType chatType:NoticeOTPMessageType authorityType:AuthorityType_friend];
        }
            break;
        default:
            break;
    }
    
}
- (IBAction)topAction:(id)sender {
    switch (self.type) {
        case ICanHelpSettingTypePay:{
            [[WCDBManager sharedManager]updateChatSettingIsStick:self.topChatSwitchBtn.isOn chatId:PayHelperMessageType chatType:UserChat authorityType:AuthorityType_friend];
            [[WCDBManager sharedManager]updateIsStick:self.topChatSwitchBtn.isOn chatId:PayHelperMessageType chatType:UserChat];
        }
            break;
        case ICanHelpSettingTypeSystem:{
            [[WCDBManager sharedManager]updateChatSettingIsStick:self.topChatSwitchBtn.isOn chatId:SystemHelperMessageType chatType:UserChat authorityType:AuthorityType_friend];
            [[WCDBManager sharedManager]updateIsStick:self.topChatSwitchBtn.isOn chatId:SystemHelperMessageType chatType:UserChat];
        }
            break;

        case ICanHelpSettingTypeAnnouncement:{
            [[WCDBManager sharedManager]updateChatSettingIsStick:self.topChatSwitchBtn.isOn chatId:AnnouncementHelperMessageType chatType:UserChat authorityType:AuthorityType_friend];
            [[WCDBManager sharedManager]updateIsStick:self.topChatSwitchBtn.isOn chatId:AnnouncementHelperMessageType chatType:UserChat];

        }
            break;
            
        case ICanHelpSettingTypeC2C:{
            [[WCDBManager sharedManager]updateChatSettingIsStick:self.topChatSwitchBtn.isOn chatId:C2CHelperMessageType chatType:C2CHelperMessageType authorityType:AuthorityType_friend];
            [[WCDBManager sharedManager]updateIsStick:self.topChatSwitchBtn.isOn chatId:C2CHelperMessageType chatType:C2CHelperMessageType];
        }
            
            break;
        case ICanHelpSettingTypeNoticeOTP:{
            [[WCDBManager sharedManager]updateChatSettingIsStick:self.topChatSwitchBtn.isOn chatId:NoticeOTPMessageType chatType:NoticeOTPMessageType authorityType:AuthorityType_friend];
            [[WCDBManager sharedManager]updateIsStick:self.topChatSwitchBtn.isOn chatId:NoticeOTPMessageType chatType:NoticeOTPMessageType];
        }
            break;
        default:
            break;
    }
    
   
}
- (IBAction)deleteAction {
    self.hjcActionSheet = [[HJCActionSheet alloc] initWithDelegate:self CancelTitle:NSLocalizedString(@"Cancel", nil) OtherTitles:NSLocalizedString(@"Whether Clear chat", 是否清除聊天记录), @"UIAlertController.sure.title".icanlocalized, nil];
    self.hjcActionSheet.tag = 100;
    [self.hjcActionSheet setBtnTag:1 TextColor:UIColor102Color textFont:14.0f enable:NO];
    [self.hjcActionSheet setBtnTag:2 TextColor:UIColor244RedColor textFont:0 enable:YES];
    [self.hjcActionSheet show];
}

- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 2) {
        switch (self.type) {
            case ICanHelpSettingTypePay:{
                [self deleteMessageFromBackend:PayHelperMessageType completion:^(BOOL isSuccess) {
                    if (isSuccess) {
                        [[WCDBManager sharedManager]deleteResourceWihtChatId:PayHelperMessageType];
                        ChatModel *config = [[ChatModel alloc]init];;
                        config.chatID = PayHelperMessageType;
                        config.chatType = UserChat;
                        config.authorityType = AuthorityType_friend;
                        [[WCDBManager sharedManager]deleteAllChatModelWith:config];
                        [[WCDBManager sharedManager]updateChatListModelLastMessageWithChatModel:config];
                        if (self.deleteMessageBlock) {
                            self.deleteMessageBlock();
                        }
                        WebSocketManager.sharedManager.currentChatID = @"";
                        [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"Clean up",清理完成) inView:self.view];
                    } else {
                        // Handle failure
                    }
                }];
            }
                break;
            case ICanHelpSettingTypeSystem:{
                [self deleteMessageFromBackend:SystemHelperMessageType completion:^(BOOL isSuccess) {
                    if (isSuccess) {
                        ChatModel *config = [[ChatModel alloc]init];;
                        config.chatID = SystemHelperMessageType;
                        config.chatType = UserChat;
                        config.authorityType = AuthorityType_friend;
                        [[WCDBManager sharedManager]deleteAllChatModelWith:config];
                        [[WCDBManager sharedManager]deleteResourceWihtChatId:SystemHelperMessageType];
                        [[WCDBManager sharedManager]updateChatListModelLastMessageWithChatModel:config];
                        if (self.deleteMessageBlock) {
                            self.deleteMessageBlock();
                        }
                        WebSocketManager.sharedManager.currentChatID = @"";
                        [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"Clean up",清理完成) inView:self.view];
                    } else {
                        // Handle failure
                    }
                }];
            }
                break;
            case ICanHelpSettingTypeC2C:{
                [self deleteMessageFromBackend:C2CHelperMessageType completion:^(BOOL isSuccess) {
                    if (isSuccess) {
                        ChatModel *config = [[ChatModel alloc]init];;
                        config.chatID = C2CHelperMessageType;
                        config.chatType = C2CHelperMessageType;
                        config.authorityType = AuthorityType_friend;
                        [[WCDBManager sharedManager]deleteAllChatModelWith:config];
                        [[WCDBManager sharedManager]deleteResourceWihtChatId:C2CHelperMessageType];
                        [[WCDBManager sharedManager]updateChatListModelLastMessageWithChatModel:config];
                        if (self.deleteMessageBlock) {
                            self.deleteMessageBlock();
                        }
                        WebSocketManager.sharedManager.currentChatID = @"";
                        [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"Clean up",清理完成) inView:self.view];
                    } else {
                        // Handle failure
                    }
                }];
            }
                break;
            case ICanHelpSettingTypeNoticeOTP:{
                [self deleteMessageFromBackend:NoticeOTPMessageType completion:^(BOOL isSuccess) {
                    if (isSuccess) {
                        ChatModel *config = [[ChatModel alloc]init];;
                        config.chatID = NoticeOTPMessageType;
                        config.chatType = NoticeOTPMessageType;
                        config.authorityType = AuthorityType_friend;
                        [[WCDBManager sharedManager]deleteAllChatModelWith:config];
                        [[WCDBManager sharedManager]deleteResourceWihtChatId:NoticeOTPMessageType];
                        [[WCDBManager sharedManager]updateChatListModelLastMessageWithChatModel:config];
                        if (self.deleteMessageBlock) {
                            self.deleteMessageBlock();
                        }
                        WebSocketManager.sharedManager.currentChatID = @"";
                        [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"Clean up",清理完成) inView:self.view];
                    } else {
                        // Handle failure
                    }
                }];
            }
                break;
            default:
                break;
        }
    }
}

- (void)deleteMessageFromBackend:(NSString *)messageType completion:(void (^)(BOOL isSuccess))completion {
    NSArray<NSString *> *messageIds = [[WCDBManager sharedManager] getMessageIdsByMessageType:messageType];
    MessageRemove *request = [MessageRemove request];
    request.messageIds = messageIds;
    request.parameters = [request mj_JSONObject];
    [[NetworkRequestManager shareManager] startRequest:request responseClass:[NSArray class] contentClass:nil success:^(NSArray *response) {
        if (completion) {
            completion(YES);
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        if (completion) {
            completion(NO);
        }
    }];
}


-(void)settingHelp:(BOOL)select{
    switch (self.type) {
        case ICanHelpSettingTypePay:{
            SettingPayHelperDisturbRequest*request=[SettingPayHelperDisturbRequest request];
            request.payHelper=select;
            request.parameters=[request mj_JSONString];
            [[NetworkRequestManager shareManager]startRequest:request responseClass:[GetPayHelperDisturbInfo class] contentClass:[GetPayHelperDisturbInfo class] success:^(GetPayHelperDisturbInfo* response) {
                
            } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                
            }];
        }
            break;
        case ICanHelpSettingTypeSystem:{
            SettingPayHelperDisturbRequest*request = [SettingPayHelperDisturbRequest request];
            request.systemHelper = select;
            request.parameters = [request mj_JSONString];
            [[NetworkRequestManager shareManager]startRequest:request responseClass:[GetPayHelperDisturbInfo class] contentClass:[GetPayHelperDisturbInfo class] success:^(GetPayHelperDisturbInfo* response) {
                
            } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                
            }];
        }
            break;
        case ICanHelpSettingTypeC2C:{
            SettingPayHelperDisturbRequest*request = [SettingPayHelperDisturbRequest request];
            request.C2CHelper = select;
            request.parameters = [request mj_JSONString];
            [[NetworkRequestManager shareManager]startRequest:request responseClass:[GetPayHelperDisturbInfo class] contentClass:[GetPayHelperDisturbInfo class] success:^(GetPayHelperDisturbInfo* response) {
                
            } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                
            }];
        }
            break;
        default:
            break;
    }
    
    
}
@end
