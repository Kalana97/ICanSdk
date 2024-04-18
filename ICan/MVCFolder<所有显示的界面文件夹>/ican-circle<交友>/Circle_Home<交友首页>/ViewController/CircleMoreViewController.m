//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 19/5/2021
- File name:  CircleMoreViewController.m
- Description:
- Function List:
*/
        

#import "CircleMoreViewController.h"
#import "CircleComplaintViewController.h"

@interface CircleMoreViewController ()
@property (nonatomic,strong) NSArray *titleMap;
@property (weak, nonatomic) IBOutlet UILabel *complaintLab;
@property (weak, nonatomic) IBOutlet UILabel *noSeeLab;
@property (weak, nonatomic) IBOutlet UISwitch *noSeeSwitchBtn;

@end

@implementation CircleMoreViewController
- (IBAction)noSeeAction {
    [self postDiskLikeRequest:self.noSeeSwitchBtn.isOn];
}
- (IBAction)complaintAction {
    CircleComplaintViewController*vc=[CircleComplaintViewController new];
    vc.targetUserId=self.userInfo.userId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"CircleMoreViewController.title".icanlocalized;
    self.view.backgroundColor=UIColorBg243Color;
    self.complaintLab.text = @"CircleMoreViewController.complaint".icanlocalized;
    self.noSeeLab.text = @"CircleMoreViewController.nosee".icanlocalized;
    self.noSeeSwitchBtn.on = self.userInfo.isDislike;
}

-(void)postDiskLikeRequest:(BOOL)select{
    if (select) {
        PostDislikeUsersRequest*request=[PostDislikeUsersRequest request];
        request.dislikeUserId=self.userInfo.userId;
        request.parameters=[request mj_JSONObject];
        [[CircleNetRequestManager shareManager]startRequest:request responseClass:[CircleBaseResponse class] contentClass:[CircleBaseResponse class] success:^(id  _Nonnull response) {
            self.userInfo.isDislike=select;
        } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
            [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
        }];
    }else{
        PUTDislikeUsersRequest*request=[PUTDislikeUsersRequest request];
        request.dislikeUserId=self.userInfo.userId;
        request.parameters=[request mj_JSONObject];
        [[CircleNetRequestManager shareManager]startRequest:request responseClass:[CircleBaseResponse class] contentClass:[CircleBaseResponse class] success:^(id  _Nonnull response) {
            self.userInfo.isDislike=select;
        } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
            [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
        }];
    }
}
@end
