//
//  UserProfileVC.m
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-06-26.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "UserProfileVC.h"
#import "ViewPermissionsVC.h"
#import "ViewTransactionsVC.h"
#import "PayManager.h"
#import "SettingPaymentPasswordViewController.h"
#import "EmailBindingViewController.h"

@interface UserProfileVC ()
@property (weak, nonatomic) IBOutlet UIView *userDataBgView;
@property (weak, nonatomic) IBOutlet DZIconImageView *userImgIcon;
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *userIdLbl;
@property (weak, nonatomic) IBOutlet UIView *userTypeBgView;
@property (nonatomic,weak) UIViewController * showViewController;
@property (weak, nonatomic) IBOutlet UILabel *userTypeLbl;
@property (weak, nonatomic) IBOutlet UILabel *transLbl;
@property (weak, nonatomic) IBOutlet UILabel *permissionLbl;
@property (weak, nonatomic) IBOutlet UILabel *removeUserLbl;
@property (weak, nonatomic) IBOutlet UIStackView *transactionStack;
@property (weak, nonatomic) IBOutlet UIStackView *permissionStack;
@property (weak, nonatomic) IBOutlet UIStackView *removeUserStack;

@end

@implementation UserProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.userDataBgView layerWithCornerRadius:10 borderWidth:1 borderColor:UIColor.clearColor];
    self.userImgIcon.layer.cornerRadius = self.userImgIcon.frame.size.height/2;
    self.userImgIcon.clipsToBounds = YES;
    [self.userTypeBgView layerWithCornerRadius:15 borderWidth:1 borderColor:UIColor.clearColor];
    [self addLocalize];
}

-(void)addLocalize{
    self.transLbl.text = @"Transactions".icanlocalized;
    self.permissionLbl.text = @"Permissions".icanlocalized;
    self.removeUserLbl.text = @"Remove user".icanlocalized;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self getUserDetailsNetowrkRequest];
    [self checkOrgStatus];
    [self setupStack];
}

-(void)getUserDetailsNetowrkRequest{
    GetOrgUserInfoRequest *request = [GetOrgUserInfoRequest request];
    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/organization/userInfo?userId=%ld",(long)self.memberInfo.userId];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[MemebersResponseInfo class] contentClass:[MemebersResponseInfo class] success:^(MemebersResponseInfo* response) {
        self.memberInfo = response;
        [self setData];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        DDLogInfo(@"error=%@",error);
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:nil];
    }];
}

-(void)setData{
    [self.userImgIcon setDZIconImageViewWithUrl:self.memberInfo.headImgUrl gender:@""];
    self.userNameLbl.text = [NSString stringWithFormat:@"%@", self.memberInfo.nickname];
    self.userIdLbl.text = [NSString stringWithFormat:@"%@ : %ld",@"ICan ID".icanlocalized,(long)self.memberInfo.numberId];
    if(self.memberInfo.userType == 1){
        self.userTypeLbl.text = @"Owner".icanlocalized;
        self.userTypeLbl.textColor = UIColorMakeHEXCOLOR(0X2F80ED);
        self.userTypeBgView.backgroundColor = UIColorMakeHEXCOLOR(0XF3FAFF);
    }else if (self.memberInfo.userType == 2){
        self.userTypeLbl.text = @"Manager".icanlocalized;
        self.userTypeLbl.textColor = UIColorMakeHEXCOLOR(0X27AE60);
        self.userTypeBgView.backgroundColor = UIColorMakeHEXCOLOR(0XF3FFF6) ;
    }else{
        self.userTypeLbl.text = @"User".icanlocalized;
        self.userTypeLbl.textColor = UIColorMakeHEXCOLOR(0X9B51E0);
        self.userTypeBgView.backgroundColor = UIColorMakeHEXCOLOR(0XF8F3FF);
    }
}


-(void)checkOrgStatus{
    GetOrganizationInfoForUserRequest *request = [GetOrganizationInfoForUserRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[OrganizationDetailsInfo class] contentClass:[OrganizationDetailsInfo class] success:^(OrganizationDetailsInfo* response){
        self.organizationInfoModel = response;
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        DDLogInfo(@"error=%@",error);
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:nil];
    }];
}

-(void)deleteUserFromOrganization:(NSString *)password{
    OrganizationRemoveUserRequest *request = [OrganizationRemoveUserRequest request];
    request.payPassword = password;
    request.userID = self.memberInfo.userId;
    request.parameters = [request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(BaseResponse *response)  {
        [UserInfoManager sharedManager].attemptCount = nil;
        [UserInfoManager sharedManager].isPayBlocked = NO;
        [QMUITipsTool showOnlyTextWithMessage:@"Remove Success".icanlocalized inView:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        if ([info.code isEqual:@"pay.password.error"]) {
            if (info.extra.isBlocked) {
                [UserInfoManager sharedManager].isPayBlocked = YES;
                [UserInfoManager sharedManager].unblockTime = [NSString getUnblockTime:info.extra.blockedTimeMillis];
                [self showSurePayView];
            } else if (info.extra.remainingCount != 0) {
                [UserInfoManager sharedManager].attemptCount = [NSString stringWithFormat:@"%ld", (long)info.extra.remainingCount];
                [self showSurePayView];
            } else {
                [UserInfoManager sharedManager].attemptCount = nil;
            }
        } else {
            DDLogInfo(@"error=%@",error);
            [QMUITipsTool showOnlyTextWithMessage:info.desc inView:nil];
        }
    }];
}

- (IBAction)goToTransactionsAction:(id)sender {
    ViewTransactionsVC *profileVC = [[ViewTransactionsVC alloc]init];
    profileVC.memberInfo = self.memberInfo;
    [self.navigationController pushViewController:profileVC animated:YES];
}

- (IBAction)gotToPermissionsAction:(id)sender {
    ViewPermissionsVC *profileVC = [[ViewPermissionsVC alloc]init];
    profileVC.memberInfo = self.memberInfo;
    profileVC.organizationInfoModel = self.organizationInfoModel;
    [self.navigationController pushViewController:profileVC animated:YES];
}

- (IBAction)removeUserAction:(id)sender {
    [self showSurePayView];
}

-(void)showSurePayView{
    if ([UserInfoManager sharedManager].tradePswdSet) {
        [[PayManager sharedManager]checkPaymentPasswordWithOther: @"Password".icanlocalized needSub: @"Enter the payment password".icanlocalized successBlock:^(NSString * _Nonnull password){
            [self deleteUserFromOrganization:password];
        }];
    }else {
        [UIAlertController alertControllerWithTitle:@"Proceed to set up payment password".icanlocalized message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.sure.title".icanlocalized,@"UIAlertController.cancel.title".icanlocalized] handler:^(int index) {
            if (index == 0) {
                if(![UserInfoManager sharedManager].isEmailBinded && [UserInfoManager sharedManager].mustBindEmailPayPswd){
                    EmailBindingViewController *vc = [[EmailBindingViewController alloc]init];
                    if (self.showViewController) {
                        [self.showViewController.navigationController pushViewController:vc animated:YES];
                    }else{
                        [[AppDelegate shared]pushViewController:vc animated:YES];
                    }
                }else{
                    SettingPaymentPasswordViewController *vc = [[SettingPaymentPasswordViewController alloc]init];
                    if (self.showViewController) {
                        [self.showViewController.navigationController pushViewController:vc animated:YES];
                    }else{
                        [[AppDelegate shared]pushViewController:vc animated:YES];
                    }
                }
            }
        }];
    }
}

-(void)setupStack{
    NSArray *userPermissionList = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserPermissions"];
    for (NSString *action in userPermissionList) {
        if([action isEqualToString:REMOVE_USERS]){
            self.removeUserStack.hidden = FALSE;
        }else if([action isEqualToString:INVITE_USERS]){
    
        }else if([action isEqualToString:CONFIRM_USERS]){

        }else if([action isEqualToString:VIEW_TRANSACTION_ORG]){
            self.transactionStack.hidden = FALSE;
        }else if([action isEqualToString:APR_TRANSACTION]){
            
        }else if([action isEqualToString:CHANGE_PERMISSION]){
            self.permissionStack.hidden = FALSE;
        }else if([action isEqualToString:OWNER]){
            self.permissionStack.hidden = FALSE;
            self.transactionStack.hidden = FALSE;
            self.removeUserStack.hidden = FALSE;
        }
    }
    
    if(self.memberInfo.userId == [UserInfoManager.sharedManager.userId integerValue]){
        self.transactionStack.hidden = FALSE;
        self.removeUserStack.hidden = TRUE;
    }else{
        if(self.memberInfo.userType == 1){
            self.removeUserStack.hidden = YES;
        }
    }
}

@end
