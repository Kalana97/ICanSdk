//
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 19/5/2021
 - File name:  CircleSettingViewController.m
 - Description:
 - Function List:
 */


#import "CircleSettingViewController.h"
#import "CircleLikeOrDislikeListViewController.h"
#import "WCDBManager+ChatModel.h"
#import "WCDBManager+ChatList.h"
@interface CircleSettingViewController ()
@property (nonatomic,strong) NSArray *titleMap;
@property (weak, nonatomic) IBOutlet UILabel *noLikeLabel;
@property (weak, nonatomic) IBOutlet UILabel *clearLabel;
@property (weak, nonatomic) IBOutlet UILabel *wantToYueHui;
@property (weak, nonatomic) IBOutlet UILabel *cancelLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;

@end

@implementation CircleSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    "CircleSettingViewController.setting"="设置";
    //    "CircleSettingViewController.nolike"="不感兴趣";
    //    "CircleSettingViewController.clear"="清除缓存";
    //    "CircleSettingViewController.userProtcol"="用户协议";
    self.noLikeLabel.text=@"CircleSettingViewController.nolike".icanlocalized;
    self.clearLabel.text=@"CircleSettingViewController.clear".icanlocalized;
    self.wantToYueHui.text=@"Willingtodate".icanlocalized;
    self.cancelLabel.text=@"CircleSettingCancelTableViewCell.deleteUser".icanlocalized;
    self.switchBtn.on=CircleUserInfoManager.shared.yue;
    self.title=@"CircleSettingViewController.setting".icanlocalized;
    self.view.backgroundColor=UIColorBg243Color;
}
- (IBAction)noLikeAction:(id)sender {
    CircleLikeOrDislikeListViewController*vc=[CircleLikeOrDislikeListViewController new];
    vc.circleListType=CircleListType_Dislike;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)clearAction:(id)sender {
    [[WCDBManager sharedManager]deleteAllCircleMessage];
    //        "CircleSettingViewController.cleanup"="清理完成";
    [QMUITipsTool showOnlyTextWithMessage:@"CircleSettingViewController.cleanup".icanlocalized inView:self.view];
    [[NSNotificationCenter defaultCenter]postNotificationName:kCleanCircleMessageNotificatiaon object:nil];
}
- (IBAction)cancelAction:(id)sender {
    [self alertUserdestroy];
}

- (IBAction)switchAction:(id)sender {
    PutCircleUserInfoRequest*request=[PutCircleUserInfoRequest request];
    request.yue=@(self.switchBtn.isOn);
    request.parameters=[request mj_JSONObject];
    [[CircleNetRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        CircleUserInfoManager.shared.yue=self.switchBtn.isOn;
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}



- (void)alertUserdestroy {
    UIAlertController*alertVC=[UIAlertController alertControllerWithTitle: @"CircleSettingViewController.sureDeleteAccountTips".icanlocalized message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction*action1=[UIAlertAction actionWithTitle:@"UIAlertController.cancel.title".icanlocalized style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction*action2=[UIAlertAction actionWithTitle:@"UIAlertController.sure.title".icanlocalized style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:@"AccountSecurityViewController.sureDeleteAccount".icanlocalized message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction*action1=[UIAlertAction actionWithTitle:@"UIAlertController.cancel.title".icanlocalized style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction*action2=[UIAlertAction actionWithTitle:@"UIAlertController.sure.title".icanlocalized style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            DeleteCircleUserRequest*request=[DeleteCircleUserRequest request];
            [[CircleNetRequestManager shareManager]startRequest:request responseClass:[CircleBaseResponse class] contentClass:[CircleBaseResponse class] success:^(id  _Nonnull response) {
                [[WCDBManager sharedManager]deleteAllCircleMessage];
                [[WCDBManager sharedManager]deleteChatListModelWithAuthorityType:AuthorityType_circle];
                [[NSNotificationCenter defaultCenter]postNotificationName:kCleanCircleMessageNotificatiaon object:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:kCancelCircleUserNotificatiaon object:nil];
                [CircleUserInfoManager.shared removeObjectWithKey:@"circleuserId"];
                [CircleUserInfoManager.shared removeObjectWithKey:@"circletoken"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
                
            }];
        }];
        [alertVC addAction:action1];
        [alertVC addAction:action2];
        [self presentViewController:alertVC animated:YES completion:^{
            
        }];
    }];
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    [self presentViewController:alertVC animated:YES completion:^{
        
    }];
}

@end
