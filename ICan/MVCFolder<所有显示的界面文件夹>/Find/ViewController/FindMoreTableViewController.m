//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - Author: Created  by DZL on 12/10/2019
 - File name:  FindTableViewController.m
 - Description:
 - Function List:
 */


#import "FindMoreTableViewController.h"
#import "PrivacyPermissionsTool.h"
#import "UITabBar+Extension.h"
#import "CircleOssWrapper.h"
#import "QRCodeController.h"
#import "FindNearbyPersonsViewController.h"
#import "TypeTimelinesViewController.h"
#import "UtilityPaymentsViewController.h"
#import "CircleHomeListViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "CommonWebViewController.h"
#import "C2CTabBarViewController.h"
#import "C2COssWrapper.h"
#import "TelecomListViewController.h"

@interface FindMoreTableViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *shopLab;
@property (weak, nonatomic) IBOutlet UILabel *huafeiLab;
@property (weak, nonatomic) IBOutlet UILabel *jiaofeiLab;
@property (weak, nonatomic) IBOutlet UILabel *circleLab;
///物流
@property (weak, nonatomic) IBOutlet UILabel *logisticsLab;
@property (weak, nonatomic) IBOutlet UILabel *estateLab;
@property (weak, nonatomic) IBOutlet UILabel *stockLab;
///夺宝
@property (weak, nonatomic) IBOutlet UILabel *snatchLab;
///体育比分
@property (weak, nonatomic) IBOutlet UILabel *sportLab;
///大神
@property (weak, nonatomic) IBOutlet UILabel *ookamiLab;
///小游戏
@property (weak, nonatomic) IBOutlet UILabel *gameLab;
///酒店
@property (weak, nonatomic) IBOutlet UILabel *hotelLab;
///机票
@property (weak, nonatomic) IBOutlet UILabel *airLab;
@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, strong) CLLocation *currentLocation;
@end

@implementation FindMoreTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getCicleToken) name:kCancelCircleUserNotificatiaon object:nil];
    self.view.backgroundColor=UIColorBg243Color;
    if ([CircleUserInfoManager.shared.icanId isEqualToString:UserInfoManager.sharedManager.userId]&&CircleUserInfoManager.shared.token) {
        [self getCircleOssTokenRequest];
        [self getAllprofessionRequest];
        [self fetchCircleCurretnLoacationAndJudeIsNeedUpdateLocation];
    }
    self.title = @"mine.profile.title.more".icanlocalized;
    self.shopLab.text = @"Mall".icanlocalized;
    self.huafeiLab.text = @"CallFee".icanlocalized;
    self.jiaofeiLab.text = @"Payment".icanlocalized;
    self.circleLab.text = @"Friendship".icanlocalized;
    self.logisticsLab.text = @"Logistics".icanlocalized;
    self.estateLab.text = @"RealEstate".icanlocalized;
    self.stockLab.text = @"Stock".icanlocalized;
    self.snatchLab.text = @"Treasure".icanlocalized;
    self.sportLab.text = @"SportsScore".icanlocalized;
    self.ookamiLab.text = @"GreatGod".icanlocalized;
    self.gameLab.text = @"MiniGame".icanlocalized;
    self.hotelLab.text = @"Hotel".icanlocalized;
    self.airLab.text = @"Ticket".icanlocalized;
    [self getCurrentLocation];
}

- (IBAction)hangqingAction{
    [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"ThisFunctionNotAvailable", 该功能暂未在线上开放) inView:nil];
}
- (IBAction)jioayiAction{
    [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"ThisFunctionNotAvailable", 该功能暂未在线上开放) inView:nil];
}
- (IBAction)nftAction{
    [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"ThisFunctionNotAvailable", 该功能暂未在线上开放) inView:nil];
}
- (IBAction)licaiAction{
    [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"ThisFunctionNotAvailable", 该功能暂未在线上开放) inView:nil];
}
- (IBAction)shopAction{
    NSString*blockStr=[NSString stringWithFormat:@"icanStore://type=openMall"];
    NSURL*url=[NSURL URLWithString:blockStr.netUrlEncoded];
    if ([[UIApplication sharedApplication]canOpenURL:url]) {
        [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:^(BOOL success) {
            
        }];
    }else{
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",UserInfoManager.sharedManager.mallH5Url]] options:@{} completionHandler:^(BOOL success) {
            
        }];
    }
}

- (IBAction)huafeiAction{
    TelecomListViewController*vc=[TelecomListViewController new];
    vc.dialogClass=@"Telecom";
    vc.titleName=@"Telecom".icanlocalized;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)jiaofeiAction{
    TelecomListViewController*vc=[TelecomListViewController new];
    vc.dialogClass=@"OtherUtility";
    vc.titleName=@"Other utility".icanlocalized;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)circleAction{
    //如果聊天登录用户的ID等于交友的icanId 那么判断本地是否存在token 如果存在token 那么不再获取token
    if ([CircleUserInfoManager.shared.icanId isEqualToString:UserInfoManager.sharedManager.userId]&&CircleUserInfoManager.shared.token) {
        CircleHomeListViewController * vc = [CircleHomeListViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self getCicleToken];
    }
}
- (IBAction)wuliuAction{
    [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"ThisFunctionNotAvailable", 该功能暂未在线上开放) inView:nil];
}
- (IBAction)fangdichangAction{
    [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"ThisFunctionNotAvailable", 该功能暂未在线上开放) inView:nil];
}
- (IBAction)gupiaoAction{
    [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"ThisFunctionNotAvailable", 该功能暂未在线上开放) inView:nil];
}
- (IBAction)snatchAction{
    [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"ThisFunctionNotAvailable", 该功能暂未在线上开放) inView:nil];
}
- (IBAction)sportAction{
    [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"ThisFunctionNotAvailable", 该功能暂未在线上开放) inView:nil];
}
- (IBAction)ookamiAction{
    [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"ThisFunctionNotAvailable", 该功能暂未在线上开放) inView:nil];
}
- (IBAction)gameAction{
    [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"ThisFunctionNotAvailable", 该功能暂未在线上开放) inView:nil];
}
- (IBAction)hotelAction{
    [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"ThisFunctionNotAvailable", 该功能暂未在线上开放) inView:nil];
}
- (IBAction)airAction{
    [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"ThisFunctionNotAvailable", 该功能暂未在线上开放) inView:nil];
}
/** 上传用户位置 */
- (void)fetchCurretnLoacationAndJudeIsNeedUpdateLocation {
    [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:YES];
    [PrivacyPermissionsTool judgeLocationAuthorizationSuccess:^{
        [self uploadChatPoiRequest:self.currentLocation];
    } failure:^{
        [QMUITips hideAllTips];
    }];
}

- (void)fetchCircleCurretnLoacationAndJudeIsNeedUpdateLocation {
    [PrivacyPermissionsTool judgeLocationAuthorizationSuccess:^{
        [self uploadCirclePoiRequest:self.currentLocation];
    } failure:^{
        [QMUITips hideAllTips];
    }];
}

- (void)uploadChatPoiRequest:(CLLocation*)location {
    UploadUserLocationRequest *request = [UploadUserLocationRequest request];
    request.longitude = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    request.latitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    request.parameters = [request mj_JSONString];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        [QMUITips hideAllTips];
        FindNearbyPersonsViewController *vc = [[FindNearbyPersonsViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}

- (void)uploadCirclePoiRequest:(CLLocation*)location {
    PutCircleUserPOIRequest *crequest = [PutCircleUserPOIRequest request];
    crequest.longitude = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    crequest.latitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    crequest.parameters = [crequest mj_JSONString];
    [[CircleNetRequestManager shareManager]startRequest:crequest responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}

- (void)getCurrentLocation {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
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
   
-(void)getCicleToken{
    GetCircleTokenRequest*request=[GetCircleTokenRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[GetCircleToeknInfo class] contentClass:[GetCircleToeknInfo class] success:^(GetCircleToeknInfo* response) {
        [CircleUserInfoManager shared].token=response.token;
        [self getCircleOssTokenRequest];
        [self getAllprofessionRequest];
        [self fetchCircleCurretnLoacationAndJudeIsNeedUpdateLocation];
        CircleHomeListViewController * vc = [CircleHomeListViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}
-(void)getCircleOssTokenRequest{
    GetCircleOssRequest*request=[GetCircleOssRequest request];
    [[CircleNetRequestManager shareManager]startRequest:request responseClass:[OSSSecurityTokenInfo class] contentClass:[OSSSecurityTokenInfo class] success:^(OSSSecurityTokenInfo* response) {
        [CircleOssWrapper shared].bucket=response.bucket;
        [CircleOssWrapper shared].urlBegin=response.urlBegin;
        OSSClientConfiguration *cfg = [[OSSClientConfiguration alloc] init];
        cfg.maxRetryCount = 10;
        cfg.timeoutIntervalForRequest = 15;
        cfg.isHttpdnsEnable = NO;
        cfg.crc64Verifiable = YES;
        OSSFederationToken*token = [OSSFederationToken new];
        token.tAccessKey = response.credentials.accessKeyId;
        token.tSecretKey = response.credentials.accessKeySecret;
        token.tToken = response.credentials.securityToken;
        token.expirationTimeInGMTFormat = response.credentials.expiration;
        OSSStsTokenCredentialProvider *provider = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:token.tAccessKey secretKeyId:token.tSecretKey securityToken:token.tToken];
        OSSClient *defaultClient = [[OSSClient alloc] initWithEndpoint:response.ossEndpoint credentialProvider:provider clientConfiguration:cfg];
        [CircleOssWrapper shared].defaultClient = defaultClient;
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        
    }];
}
//获取职业
-(void)getAllprofessionRequest{
    GetProfessionsRequest *request = [GetProfessionsRequest request];
    [[CircleNetRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[ProfessionInfo class] success:^(NSArray<ProfessionInfo*> *response) {
        CircleUserInfoManager.shared.professionArray = response;
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        
    }];
}
@end
