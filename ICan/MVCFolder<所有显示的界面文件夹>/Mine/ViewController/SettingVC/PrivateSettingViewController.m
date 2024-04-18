//
//  PrivateSettingViewController.m
//  ICan
//
//  Created by Limaohuyu666 on 2019/12/31.
//  Copyright © 2019 dzl. All rights reserved.
//  设置---隐私设置

#import "PrivateSettingViewController.h"
#import "PrivacyPermissionsTool.h"
#import <CoreLocation/CoreLocation.h>
#import "BlockUsersListViewController.h"
@interface PrivateSettingViewController ()<CLLocationManagerDelegate>
//定位管理者
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (weak, nonatomic) IBOutlet UIControl *nearByBgCon;
@property (weak, nonatomic) IBOutlet UILabel *nearByLab;
@property (weak, nonatomic) IBOutlet UISwitch *nearBySwitchBtn;

@property (weak, nonatomic) IBOutlet UIControl *recommendBgCon;
@property (weak, nonatomic) IBOutlet UILabel *recommondLab;
@property (weak, nonatomic) IBOutlet UISwitch *recommondSwitchBtn;
@property (weak, nonatomic) IBOutlet UIView *jiangeView;

@property (weak, nonatomic) IBOutlet UILabel *requireLab;
@property (weak, nonatomic) IBOutlet UISwitch *requireSwitchBtn;


@property (weak, nonatomic) IBOutlet UILabel *blockListLab;

@property (weak, nonatomic) IBOutlet UILabel *readLab;
@property (weak, nonatomic) IBOutlet UISwitch *readSwitchBtn;


@end

@implementation PrivateSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorBg243Color;
    self.title =[@"mine.setting.cell.title.privacy" icanlocalized:@"隐私设置"];
    
    self.nearByLab.text = NSLocalizedString(@"Visible nearby", 附近人可见);
    self.recommondLab.text  = NSLocalizedString(@"Recommend to others", 推荐给其他人);
    self.requireLab.text = @"Require Friend Request".icanlocalized;
    self.blockListLab.text = @"Block list".icanlocalized;
    self.readLab.text =  @"ReadReceipts".icanlocalized;
    
    self.nearBySwitchBtn.on = [UserInfoManager sharedManager].nearbyVisible;
    self.recommondSwitchBtn.on = [UserInfoManager sharedManager].beFound;
    self.requireSwitchBtn.on = [UserInfoManager sharedManager].quickFriend;
    self.readSwitchBtn.on = [UserInfoManager sharedManager].readReceipt;
    self.nearByBgCon.hidden = ![UserInfoManager sharedManager].openNearbyPeople;
    self.recommendBgCon.hidden = ![UserInfoManager sharedManager].openRecommend;
    if (![UserInfoManager sharedManager].openNearbyPeople && ![UserInfoManager sharedManager].openRecommend){
        self.jiangeView.hidden = YES;
    }
    [self getCurrentLocation];
}
- (IBAction)nearByAction {
    if([UserInfoManager sharedManager].nearbyVisible == false){
        [self settingPersonIsNearbyVisibleWithSelected:self.nearBySwitchBtn.isOn];
    }else{
        [self settingPersonIsNearbyVisibleWithSelected:false];
    }
}

- (IBAction)recommendAction {
    [self settingPersonIsCanBeFoundWithSelected:self.recommondSwitchBtn.isOn];
}
- (IBAction)requireAction {
    [self settingQuickFriend:self.requireSwitchBtn.isOn];
}
- (IBAction)readAction {
    //已读回执
    [UserInfoManager sharedManager].readReceipt= self.readSwitchBtn.isOn;
    PutReadReceiptRequest*request = [PutReadReceiptRequest request];
    request.readReceipt = self.readSwitchBtn.isOn;
    request.parameters=[request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}
- (IBAction)blockAction {
    BlockUsersListViewController*vc=[[BlockUsersListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

//设置用户是否能被发现
-(void)settingPersonIsCanBeFoundWithSelected:(BOOL)selected{
    SetUserBeFoundRequest * request = [SetUserBeFoundRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        [UserInfoManager sharedManager].beFound = selected;
        
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}
-(void)settingQuickFriend:(BOOL)select{
    AutoAgreeFriendRequest * request = [AutoAgreeFriendRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        [UserInfoManager sharedManager].quickFriend = select;
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}

//设置用户附近的人是否可见
-(void)settingPersonIsNearbyVisibleWithSelected:(BOOL)selected{
    UserNearbyVisibleRequest * request = [UserNearbyVisibleRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        [UserInfoManager sharedManager].nearbyVisible = selected;
        [self fetchCurretnLoacationAndJudeIsNeedUpdateLocation];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
    
}

- (void)getCurrentLocation {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter=kCLDistanceFilterNone;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startMonitoringSignificantLocationChanges];
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if ([locations firstObject]) {
        [self.locationManager stopUpdatingLocation];
        self.currentLocation = [locations firstObject];
    }
}

// Obtain the current location and report the user's current location
- (void)fetchCurretnLoacationAndJudeIsNeedUpdateLocation {
    if (![UserInfoManager sharedManager].nearbyVisible) {
        return;
    }
    [PrivacyPermissionsTool judgeLocationAuthorizationSuccess:^{
        UploadUserLocationRequest *request = [UploadUserLocationRequest request];
        request.longitude = [NSString stringWithFormat:@"%f",self.currentLocation.coordinate.longitude];
        request.latitude = [NSString stringWithFormat:@"%f",self.currentLocation.coordinate.latitude];
        request.parameters = [request mj_JSONString];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        }];
    } failure:^{
        
    }];
}

@end
