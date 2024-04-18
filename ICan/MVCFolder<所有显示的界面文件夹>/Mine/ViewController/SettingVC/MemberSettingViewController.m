
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 9/9/2021
- File name:  MemberSettingViewController.m
- Description:
- Function List:
*/
        

#import "MemberSettingViewController.h"

@interface MemberSettingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *openRemoveMessageLab;
@property (weak, nonatomic) IBOutlet UISwitch *openStopDeleteMessageSwitch;

@end

@implementation MemberSettingViewController
#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
//    "MemberSettingRemoveMessageTitle"="阻止其他人删除消息";
//    "MemberSettingRemoveMessageDetailTitle"="其他人无法在单人/群聊中删除自己的客户端消息";
    self.title = @"Member settings".icanlocalized;
    NSString*bigText = @"MemberSettingRemoveMessageTitle".icanlocalized;
    NSString*detailText = @"MemberSettingRemoveMessageDetailTitle".icanlocalized;
    NSMutableAttributedString*string = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n%@",bigText,detailText]];
    [string addAttribute:NSForegroundColorAttributeName value:UIColor252730Color range:NSMakeRange(0, bigText.length)];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, bigText.length)];
    
    [string addAttribute:NSForegroundColorAttributeName value:UIColor153Color range:NSMakeRange(bigText.length+1, detailText.length)];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(bigText.length+1, detailText.length)];
    self.openRemoveMessageLab.attributedText = string;
    self.openStopDeleteMessageSwitch.on = UserInfoManager.sharedManager.preventDeleteMessage;
}
- (IBAction)switchAction:(id)sender {
    SettingPreventDeleteMessageRequest*request = [SettingPreventDeleteMessageRequest request];
    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/user/preventDeleteMessage/%d",self.openStopDeleteMessageSwitch.isOn];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        UserInfoManager.sharedManager.preventDeleteMessage = self.openStopDeleteMessageSwitch.isOn;
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
    
}
#pragma mark - Getter
#pragma mark - Setter
#pragma mark - Public
#pragma mark - Private
#pragma mark - Lazy
#pragma mark - Event
#pragma mark - Networking

@end
