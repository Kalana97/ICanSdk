//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 16/6/2020
- File name:  TimelineSettingViewController.m
- Description:
- Function List:
*/
        

#import "TimelineSettingViewController.h"
@interface TimelineSettingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *noseeLab;
@property (weak, nonatomic) IBOutlet UISwitch *noSeeSwitchBtn;
@property (weak, nonatomic) IBOutlet UIControl *itemBgView;

@end

@implementation TimelineSettingViewController
- (void)viewDidLoad {
    [super viewDidLoad];
//    权限设置
    self.title=@"friend.detail.listCell.permissionSettings".icanlocalized;
    self.view.backgroundColor = UIColorBg243Color;
    self.noseeLab.text = @"Hide Posts".icanlocalized;
    self.noseeLab.textColor = UIColorThemeMainTitleColor;
    self.noSeeSwitchBtn.on = self.userMessageInfo.shieldTimeLine;
}
- (IBAction)noSeeSwitchBtnAction {
    ShieldTimelineRequest*request=[ShieldTimelineRequest request];
    request.userId=self.userMessageInfo.userId;
    request.unShield=!self.noSeeSwitchBtn.isOn;
    request.parameters=[request mj_JSONObject];
    if (self.noSeeSwitchBtn.isOn) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kShieldTimeLineNotification object:self.userMessageInfo];
    }
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        self.userMessageInfo.shieldTimeLine = self.noSeeSwitchBtn.isOn;
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}
@end
