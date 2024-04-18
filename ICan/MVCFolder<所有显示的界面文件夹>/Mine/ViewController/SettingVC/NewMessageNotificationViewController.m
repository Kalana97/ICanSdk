
#import "NewMessageNotificationViewController.h"
@interface NewMessageNotificationViewController ()
@property(nonatomic, strong) UserConfigurationInfo *userConfigurationInfo;
@property (weak, nonatomic) IBOutlet UILabel *closeLab;

@property (weak, nonatomic) IBOutlet UILabel *receivedNewMessageLab;
@property (weak, nonatomic) IBOutlet UISwitch *receivedNewMessageSwitch;


@property (weak, nonatomic) IBOutlet UILabel *messageDetailLab;
@property (weak, nonatomic) IBOutlet UISwitch *messageDetailSwitch;


@property (weak, nonatomic) IBOutlet UILabel *openLab;
@property (weak, nonatomic) IBOutlet UILabel *soudLab;
@property (weak, nonatomic) IBOutlet UISwitch *soudSwitch;


@property (weak, nonatomic) IBOutlet UILabel *shakeLab;
@property (weak, nonatomic) IBOutlet UISwitch *shakeSwitch;




@end

@implementation NewMessageNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=NSLocalizedString(@"mine.setting.cell.title.messageNotifications", 新消息通知);
    self.view.backgroundColor = UIColorBg243Color;
    self.userConfigurationInfo=[BaseSettingManager sharedManager].userConfigurationInfo;
    self.closeLab.text = [NSString stringWithFormat:NSLocalizedString(@"NewMessageNotificationViewController.AppNotActivated", 应用未打开时)];
    self.openLab.text = NSLocalizedString(@"NewMessageNotificationViewController.AppIsOpen", 应用打开时);
    self.receivedNewMessageLab.text = NSLocalizedString(@"Notifications", 接收新消息通知);
    self.receivedNewMessageSwitch.on=self.userConfigurationInfo.isAcceptMessageNotice;
    self.messageDetailLab.text = NSLocalizedString(@"Show Preview Text", 通知显示消息详情);
    self.messageDetailSwitch.on = self.userConfigurationInfo.isShowMessageNoticeDetail;
    self.soudLab.text = NSLocalizedString(@"Sound", 声音);
    self.soudSwitch.on = self.userConfigurationInfo.isOpenSound;
    self.shakeLab.text = NSLocalizedString(@"In-App Vibrate", 震动);
    self.shakeSwitch.on = self.userConfigurationInfo.isOpenShake;
}
- (IBAction)receivedNewMessageAction {
    self.userConfigurationInfo.isAcceptMessageNotice=self.receivedNewMessageSwitch.isOn;
    [BaseSettingManager sharedManager].userConfigurationInfo=self.userConfigurationInfo;
}
- (IBAction)showDetailAction {
    self.userConfigurationInfo.isShowMessageNoticeDetail=self.messageDetailSwitch.isOn;
    [BaseSettingManager sharedManager].userConfigurationInfo=self.userConfigurationInfo;
}
- (IBAction)soudAction {
    self.userConfigurationInfo.isOpenSound=self.soudSwitch.isOn;
    [BaseSettingManager sharedManager].userConfigurationInfo=self.userConfigurationInfo;
}
- (IBAction)shakeAction {
    self.userConfigurationInfo.isOpenShake=self.shakeSwitch.isOn;
    [BaseSettingManager sharedManager].userConfigurationInfo=self.userConfigurationInfo;
}
@end
