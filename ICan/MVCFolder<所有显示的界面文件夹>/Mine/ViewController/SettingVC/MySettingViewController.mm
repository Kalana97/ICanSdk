//
//  MySettingViewController.m
//  EasyPay
//
//  Created by 刘志峰 on 2019/5/6.
//  Copyright © 2019 EasyPay. All rights reserved.
//

#import "MySettingViewController.h"
#import "VideoCacheManager.h"
#import "JKPickerView.h"
#import "WCDBManager+ChatModel.h"

#import "AccountSecurityViewController.h"
#import "AboutWeViewController.h"
#import "PrivateSettingViewController.h"
#import "NewMessageNotificationViewController.h"
#import "MemberSettingViewController.h"
#import "AppearenceViewController.h"
@interface MySettingViewController ()
/** 账号与安全 */
@property (weak, nonatomic) IBOutlet UIControl *accountSecurityBgCon;
@property (weak, nonatomic) IBOutlet UILabel *accountSecurityLabel;
/** 新消息通知 */
@property (weak, nonatomic) IBOutlet UIControl *messageNotifiBgCon;
@property (weak, nonatomic) IBOutlet UILabel *messageNotifiLabel;
/** 隐私设置 */
@property (weak, nonatomic) IBOutlet UIControl *privateSettingBgCon;
@property (weak, nonatomic) IBOutlet UILabel *privateSettingLabel;
/** 会员设置 */
@property (weak, nonatomic) IBOutlet UIControl *memberSettingBgCon;
@property (weak, nonatomic) IBOutlet UILabel *memberSettingLabel;
@property (weak, nonatomic) IBOutlet UIView *memberSettingLineView;
/** 清除所有缓存与聊天记录 */
@property (weak, nonatomic) IBOutlet UIControl *clearMessageBgCon;
@property (weak, nonatomic) IBOutlet UILabel *clearMessageLabel;
/** 聊天记录清除时间 */
@property (weak, nonatomic) IBOutlet UIControl *saveMessageBgCon;
@property (weak, nonatomic) IBOutlet UILabel *saveMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *saveMessageDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *saveMessageDesLabel;
/** 关于我们 */
@property (weak, nonatomic) IBOutlet UIControl *aboutBgCon;
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *appearenceTitlleLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@end

@implementation MySettingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = UIColorBg243Color;
    self.accountSecurityLabel.text = @"mine.setting.cell.title.accountSecurity".icanlocalized;
    self.messageNotifiLabel.text   = @"mine.setting.cell.title.messageNotifications".icanlocalized;
    self.privateSettingLabel.text  = @"mine.setting.cell.title.privacy".icanlocalized;
    self.memberSettingLabel.text   = @"Member settings".icanlocalized;
    self.clearMessageLabel.text    = @"mine.setting.cell.title.allMessage".icanlocalized;
    self.saveMessageLabel.text     = @"mine.setting.cell.title.records".icanlocalized;
    self.aboutLabel.text           = @"mine.setting.cell.title.about".icanlocalized;
    self.appearenceTitlleLabel.text = @"Appearance".icanlocalized;
    
    self.titleView.title = [@"mine.listView.cell.setting" icanlocalized:@"设置"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 当前应用软件版本  比如：1.0.1
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.aboutDesLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Version",版本),appCurVersion];
    if (UserInfoManager.sharedManager.seniorValid||UserInfoManager.sharedManager.diamondValid) {
        self.memberSettingBgCon.hidden = self.memberSettingLineView.hidden = NO;
    }else{
        self.memberSettingBgCon.hidden = self.memberSettingLineView.hidden = YES;
    }
    [self setDetailInfomation];
    [self.logoutBtn setTitle:@"mine.setting.logOutButton.title".icanlocalized forState:UIControlStateNormal];
    [self.logoutBtn layerWithCornerRadius:22 borderWidth:0 borderColor:nil];
}

- (IBAction)accountSecurityAction {
    AccountSecurityViewController*accountSecurity=[AccountSecurityViewController new];
    [self.navigationController pushViewController:accountSecurity animated:YES];
}
- (IBAction)messageNotifiAction {
    [self.navigationController pushViewController:[NewMessageNotificationViewController new] animated:YES];
}
- (IBAction)privateSettingAction {
    [self.navigationController pushViewController:[PrivateSettingViewController new] animated:YES];
}
- (IBAction)memberSettingAction {
    [self.navigationController pushViewController:[MemberSettingViewController new] animated:YES];
}
- (IBAction)clearMessgeAction {
    [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ClearTips",是否清除所有缓存与聊天记录) message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.cancel.title".icanlocalized,@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
        if (index==1) {
            [self deleteAllMessage];
            
        }
    }];
}
- (IBAction)saveMessgeAction {
    [self clearMessage];
}
- (IBAction)aboutAction {
    [self.navigationController pushViewController:[AboutWeViewController new] animated:YES];
}
- (IBAction)appearenceAction {
    [self.navigationController pushViewController:[AppearenceViewController new] animated:YES];
}
- (IBAction)logoutAction {
    [UIAlertController alertControllerWithTitle:@"Notice".icanlocalized message:@"Confirm to log out".icanlocalized target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.cancel.title".icanlocalized,@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
        if (index==1) {
            [self logoutBtnCick];
        }
    }];
}
-(void)clearMessage{
    //5分钟，60分钟，24小时，3天，7天，二周，一个月，三个月，永久保留
    @weakify(self);
    NSString*titleText;
    UserConfigurationInfo*configuration=[BaseSettingManager sharedManager].userConfigurationInfo;
    if ([configuration.deleteMessageWholeTime isEqualToString:[NSString stringWithFormat:@"%d",7*60*60*24]]) {
        titleText =NSLocalizedString(@"Seven Day", 7天);
    }else if ([configuration.deleteMessageWholeTime isEqualToString:[NSString stringWithFormat:@"%d",14*60*60*24]]){
        titleText =NSLocalizedString(@"TwoWeeks", 两周);
    }else if ([configuration.deleteMessageWholeTime isEqualToString:[NSString stringWithFormat:@"%d",30*60*60*24]]){
        titleText =NSLocalizedString(@"One Month", 1个月);
    }else if ([configuration.deleteMessageWholeTime isEqualToString:[NSString stringWithFormat:@"%d",60*5]]){
        titleText =NSLocalizedString(@"FiveMinutes",5分钟);
    }else if ([configuration.deleteMessageWholeTime isEqualToString:[NSString stringWithFormat:@"%d",60*60]]){
        titleText =NSLocalizedString(@"SixtyMinutes",60分钟);
    }else if ([configuration.deleteMessageWholeTime isEqualToString:[NSString stringWithFormat:@"%d",60*60*24]]){
        titleText =NSLocalizedString(@"TwentyFourHour",24小时);
    }else if ([configuration.deleteMessageWholeTime isEqualToString:[NSString stringWithFormat:@"%d",3*60*60*24]]){
        titleText =NSLocalizedString(@"Three Day",3天);
    }else if ([configuration.deleteMessageWholeTime isEqualToString:[NSString stringWithFormat:@"%d",3*30*60*60*24]]){
        titleText =NSLocalizedString(@"Three Month",三个月);
    }else{
        titleText =NSLocalizedString(@"Permanent", 永久);
    }
    NSArray*dataArray=@[NSLocalizedString(@"FiveMinutes",5分钟),NSLocalizedString(@"SixtyMinutes",60分钟),NSLocalizedString(@"TwentyFourHour",24小时),NSLocalizedString(@"Three Day",3天),NSLocalizedString(@"Seven Day", 7天),NSLocalizedString(@"TwoWeeks", 两周),NSLocalizedString(@"One Month", 1个月),NSLocalizedString(@"Three Month",三个月),NSLocalizedString(@"Permanent", 永久)];
    NSInteger row=[dataArray indexOfObject:titleText];
    [[JKPickerView sharedJKPickerView] setPickViewWithTarget:self title:NSLocalizedString(@"Record Retention Time", 选择保留聊天记录时间) leftItemTitle:@"UIAlertController.cancel.title".icanlocalized rightItemTitle:@"UIAlertController.sure.title".icanlocalized leftAction:@selector(removePick) rightAction:@selector(sureAction) dataArray:dataArray dataBlock:^(NSString *title) {
        @strongify(self);
        [self setDeleteMessageWholeTimeWithTitle:title];
    }];
    [[JKPickerView sharedJKPickerView]selectRow:row inComponent:0 animated:YES];
}

- (void)removePick {
    [[JKPickerView sharedJKPickerView] removePickView];
}

- (void)sureAction {
    [[JKPickerView sharedJKPickerView] sureAction];
    
}
-(void)setDeleteMessageWholeTimeWithTitle:(NSString*)timeTitle{
    UserConfigurationInfo * userConfigurationInfo = [BaseSettingManager sharedManager].userConfigurationInfo;
    NSInteger time = 0;
    if ([timeTitle isEqualToString:NSLocalizedString(@"Seven Day", 7天)]) {
        time = 7*60*60*24;
        userConfigurationInfo.deleteMessageWholeTime = [NSString stringWithFormat:@"%ld",(long)time];
        
    }else if ([timeTitle isEqualToString:NSLocalizedString(@"One Month", 1个月)]){
        time = 30*60*60*24;
        userConfigurationInfo.deleteMessageWholeTime = [NSString stringWithFormat:@"%ld",(long)time];
        
    }else if ([timeTitle isEqualToString:NSLocalizedString(@"FiveMinutes",5分钟)]){
        time = 60*5;
        userConfigurationInfo.deleteMessageWholeTime = [NSString stringWithFormat:@"%ld",(long)time];
        
    }else if ([timeTitle isEqualToString:NSLocalizedString(@"SixtyMinutes",60分钟)]){
        time = 60*60;
        userConfigurationInfo.deleteMessageWholeTime = [NSString stringWithFormat:@"%ld",(long)time];
        
    }else if ([timeTitle isEqualToString:NSLocalizedString(@"TwentyFourHour",24小时)]){
        time = 24*60*60;
        userConfigurationInfo.deleteMessageWholeTime = [NSString stringWithFormat:@"%ld",(long)time];
        
    }else if ([timeTitle isEqualToString:NSLocalizedString(@"Three Day",3天)]){
        time = 3*24*60*60;
        userConfigurationInfo.deleteMessageWholeTime = [NSString stringWithFormat:@"%ld",(long)time];
        
    }else if ([timeTitle isEqualToString:NSLocalizedString(@"TwoWeeks", 两周)]){
        time = 14*24*60*60;
        userConfigurationInfo.deleteMessageWholeTime = [NSString stringWithFormat:@"%ld",(long)time];
        
    }else if ([timeTitle isEqualToString:NSLocalizedString(@"Three Month",三个月)]){
        time = 90*24*60*60;
        userConfigurationInfo.deleteMessageWholeTime = [NSString stringWithFormat:@"%ld",(long)time];
        
    }else{
        time = 0;
        userConfigurationInfo.deleteMessageWholeTime = [NSString stringWithFormat:@"%ld",(long)time];
    }
    [BaseSettingManager sharedManager].userConfigurationInfo = userConfigurationInfo;
    [[WCDBManager sharedManager]deleteMessageWihtTime:time];
    [self setDetailInfomation];
    
}
-(void)setDetailInfomation{
    UserConfigurationInfo*configuration=[BaseSettingManager sharedManager].userConfigurationInfo;
    if ([configuration.deleteMessageWholeTime isEqualToString:[NSString stringWithFormat:@"%d",7*60*60*24]]) {
           self.saveMessageDetailLabel.text = NSLocalizedString(@"Keep chat records for seven days", 保留七天内的聊天记录);
           self.saveMessageDesLabel.text =NSLocalizedString(@"Seven Day", 7天);
        }else if ([configuration.deleteMessageWholeTime isEqualToString:[NSString stringWithFormat:@"%d",14*60*60*24]]){
            self.saveMessageDetailLabel.text = NSLocalizedString(@"Keep chat records for two weeks", 保留两周内的聊天记录);
            self.saveMessageDesLabel.text =NSLocalizedString(@"TwoWeeks", 两周);
        }else if ([configuration.deleteMessageWholeTime isEqualToString:[NSString stringWithFormat:@"%d",30*60*60*24]]){
            self.saveMessageDetailLabel.text = NSLocalizedString(@"Keep chat records for one month", 保留一个月内的聊天记录);
            self.saveMessageDesLabel.text =NSLocalizedString(@"One Month", 1个月);
        }else if ([configuration.deleteMessageWholeTime isEqualToString:[NSString stringWithFormat:@"%d",60*5]]){
            self.saveMessageDetailLabel.text = @"Keep chat history within 5 minutes".icanlocalized;
            self.saveMessageDesLabel.text =NSLocalizedString(@"FiveMinutes",5分钟);
        }else if ([configuration.deleteMessageWholeTime isEqualToString:[NSString stringWithFormat:@"%d",60*60]]){
            self.saveMessageDetailLabel.text = @"Keep chat history within 1 hour".icanlocalized;
            self.saveMessageDesLabel.text =NSLocalizedString(@"SixtyMinutes",60分钟);
        }else if ([configuration.deleteMessageWholeTime isEqualToString:[NSString stringWithFormat:@"%d",60*60*24]]){
            self.saveMessageDetailLabel.text = @"Keep chat history within 1 day".icanlocalized;
            self.saveMessageDesLabel.text =NSLocalizedString(@"TwentyFourHour",24小时);
        }else if ([configuration.deleteMessageWholeTime isEqualToString:[NSString stringWithFormat:@"%d",3*60*60*24]]){
            self.saveMessageDetailLabel.text = @"Keep chat history for 3 days".icanlocalized;
            self.saveMessageDesLabel.text =NSLocalizedString(@"Three Day",3天);
        }else if ([configuration.deleteMessageWholeTime isEqualToString:[NSString stringWithFormat:@"%d",3*30*60*60*24]]){
            self.saveMessageDetailLabel.text = @"Keep chat history within 3 months".icanlocalized;
            self.saveMessageDesLabel.text =NSLocalizedString(@"Three Month",三个月);
        }else{
            self.saveMessageDetailLabel.text =NSLocalizedString(@"KeepChatLogsPermanently", 永久保存聊天记录);
            self.saveMessageDesLabel.text =NSLocalizedString(@"Permanent", 永久);
        }
    
 
}
#pragma mark -- 退出登录
-(void)logoutBtnCick {
    ReportUserLogoutRequest*request=[ReportUserLogoutRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        [[WebSocketManager sharedManager]userManualLogout];
        [BaseSettingManager resetAppToLoginViewControllershowOtherLoginTipsLogout:NO tips:@""];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
    
    
    
}
-(void)deleteAllMessage{
    //娃哈哈说这里就是删除全部消息这个是不发送消息 只删除自己的
    UserRemoveMessageRequest*request=[UserRemoveMessageRequest request];
    request.type=@"All";
    request.parameters=[request mj_JSONString];
    [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:NO];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        [[WCDBManager sharedManager]deleteAllResource];
        [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"Clean up",清理完成) inView:self.view];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
    //清除所有的视频数据
    [[VideoCacheManager sharedCacheManager] clearDiskCacheWihtRetain:0];
}
@end
