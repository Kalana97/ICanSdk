//
//  SettingsPageVC.m
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-06-22.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "SettingsPageVC.h"
#import "QDNavigationController.h"
#import "PrivacyPermissionsTool.h"
#import "UIImagePickerHelper.h"
#import "SaveViewManager.h"
#import "OSSWrapper.h"
#import "EditLevelCell.h"
#import "PayManager.h"
#import "SettingPaymentPasswordViewController.h"
#import "AssignUsersVC.h"
#import "ConfirmPopUp.h"
#import "EmailBindingViewController.h"

@interface SettingsPageVC ()

@property (weak, nonatomic) IBOutlet UILabel *settingsLbl;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UILabel *orgIconLbl;
@property (weak, nonatomic) IBOutlet DZIconImageView *orgLogoImg;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UILabel *orgNameLbl;
@property (weak, nonatomic) IBOutlet UIView *editImgBgView;
@property (weak, nonatomic) IBOutlet UITextField *orgNameTxt;
@property (weak, nonatomic) IBOutlet UIView *mainBgView;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIControl *closeOrgBtn;
@property (weak, nonatomic) IBOutlet UILabel *transactionAppLvlLbl;
@property (weak, nonatomic) IBOutlet UILabel *addLvlLbl;
@property (weak, nonatomic) IBOutlet UILabel *closeOrgLbl;
@property (nonatomic,weak) UIViewController * showViewController;
@end

@implementation SettingsPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mainBgView layerWithCornerRadius:10 borderWidth:1 borderColor:UIColor.clearColor];
    [self.closeOrgBtn layerWithCornerRadius:5 borderWidth:1 borderColor:UIColor.clearColor];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.myTableView registNibWithNibName:@"EditLevelCell"];
    [self getOrgInfo];
    [self addLocalizations];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)hideKeyboard {
    [self.orgNameTxt resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)addLocalizations{
    self.settingsLbl.text = @"mine.listView.cell.setting".icanlocalized;
    self.orgIconLbl.text = @"Organization Icon".icanlocalized;
    [self.saveBtn setTitle:@"Save".icanlocalized forState:UIControlStateNormal];
    self.orgNameLbl.text = @"Organization Name".icanlocalized;
    self.transactionAppLvlLbl.text = @"Approval flow".icanlocalized;
    self.addLvlLbl.text = @"Add level".icanlocalized;
    self.closeOrgLbl.text = @"Disband Organization".icanlocalized;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    self.headImgUrl = self.organizationInfoModel.organizationImageUrl;
}

-(void)getOrgInfo{
    GetOrganizationInfoForUserRequest *request = [GetOrganizationInfoForUserRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[OrganizationDetailsInfo class] contentClass:[OrganizationDetailsInfo class] success:^(OrganizationDetailsInfo* response){
        self.organizationInfoModel = response;
        [self setData];
        [self.myTableView reloadData];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        DDLogInfo(@"error=%@",error);
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:nil];
    }];
}

-(void)setData{
    [self.orgLogoImg setDZIconImageViewWithUrl:self.organizationInfoModel.organizationImageUrl gender:@""];
    self.orgLogoImg.layer.cornerRadius = self.orgLogoImg.frame.size.height/2;
    self.orgLogoImg.clipsToBounds = YES;
    [self.saveBtn layerWithCornerRadius:5 borderWidth:1 borderColor:UIColor.clearColor];
    self.editImgBgView.layer.cornerRadius = self.editImgBgView.frame.size.height/2;
    self.editImgBgView.clipsToBounds = YES;
    self.orgNameTxt.text = self.organizationInfoModel.name;
}

- (void)showAlert {
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"UIAlertController.cancel.title".icanlocalized style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
    }];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:NSLocalizedString(@"ChooseFromAlbum", 从相册选择)  style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        [self selectPickFromeTZImagePicker];
    }];
    QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:@"chatView.function.camera".icanlocalized style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        [self photographToSetHeaderPic];
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:nil message:nil preferredStyle:QMUIAlertControllerStyleActionSheet];
    [alertController addAction:action1];
    [alertController addAction:action3];
    [alertController addAction:action2];
    [alertController showWithAnimated:YES];
}

-(void)selectPickFromeTZImagePicker{
    [PrivacyPermissionsTool judgeAlbumAuthorizationSuccess:^{
        [UIImagePickerHelper selectMorePictureWithTarget:self maxCount:1 minCount:1 isAllowEditing:YES pickingPhotosHandle:^(NSArray<UIImage *> * _Nonnull photos, NSArray * _Nonnull assets, BOOL isSelectOriginalPhoto) {
            [self setHeadPicWithImage:photos.firstObject];
        } didFinishPickingPhotosWithInfosHandle:nil cancelHandle:nil pickingVideoHandle:nil pickingGifImageHandle:nil];
    } failure:^{
        NSLog(@"fail");
    }];
}

-(void)photographToSetHeaderPic{
    [PrivacyPermissionsTool judgeCameraAuthorizationSuccess:^{
        [[UIImagePickerHelper sharedManager]photographFromImagePickerController:self isAllowEditing:YES didFinishPhotographPhotosHandle:^(UIImage * _Nonnull image, NSDictionary * _Nonnull info) {
            [self setHeadPicWithImage:image];
            dispatch_async(dispatch_get_main_queue(), ^{
                [PrivacyPermissionsTool judgeAlbumAuthorizationSuccess:^{
                    [SaveViewManager saveImageToPhotos:image success:^{
                    } failed:^{
                        NSLog(@"fail");
                    }];
                } failure:^{
                    NSLog(@"fail");
                }];
            });
        }];
    } failure:^{
        NSLog(@"fail");
    }];
}

-(void)setHeadPicWithImage:(UIImage*)image{
    [QMUITipsTool showLoadingWihtMessage: NSLocalizedString(@"Setup...", 设置中...) inView:self.view isAutoHidden:NO];
    NSData *smallAlbumData = [UIImage compressImageSize:image toByte:1024*50];
    [[[OSSWrapper alloc]init] setUserHeadImageWithImage:smallAlbumData type:@"1" success:^(NSString * _Nonnull url) {
        [self setHeadPortraitWihtUrl:url];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"fail");
    }];
    
}

-(void)setHeadPortraitWihtUrl:(NSString*)path{
    self.headImgUrl = path;
    [self.orgLogoImg setDZIconImageViewWithUrl:self.headImgUrl gender:@""];
    [QMUITipsTool showSuccessWithMessage:NSLocalizedString(@"Set up successfully", 设置成功) inView:self.view];
}

-(void)submitData{
    PutOrganizationRequest *request = [PutOrganizationRequest request];
    request.orgId = self.organizationInfoModel.orgId;
    request.name = self.orgNameTxt.text;
    request.organizationImageUrl = self.headImgUrl;
    request.parameters = [request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[OrganizationDetailsInfo class] contentClass:[OrganizationDetailsInfo class] success:^(OrganizationDetailsInfo *response)  {
        self.organizationInfoModel = response;
        if (self.goBackData) {
            self.goBackData(self.organizationInfoModel);
        }
        [QMUITipsTool showOnlyTextWithMessage:@"Success".icanlocalized inView:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        DDLogInfo(@"error=%@",error);
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:nil];
    }];
}

-(void)deleteOrganization:(NSString *)password{
    DeleteOrganizationRequest *request = [DeleteOrganizationRequest request];
    request.payPassword = password;
    request.parameters = [request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(BaseResponse *response)  {
        [UserInfoManager sharedManager].attemptCount = nil;
        [UserInfoManager sharedManager].isPayBlocked = NO;
        [QMUITipsTool showOnlyTextWithMessage:@"AddSuccess".icanlocalized inView:nil];
        [[AppDelegate shared].curNav popToRootViewControllerAnimated:NO];
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
                DDLogInfo(@"error=%@",error);
                [QMUITipsTool showOnlyTextWithMessage:info.desc inView:nil];
            }
        } else {
            DDLogInfo(@"error=%@",error);
            [QMUITipsTool showOnlyTextWithMessage:info.desc inView:nil];
        }
    }];
}

- (IBAction)editBtnAction:(id)sender {
    [self showAlert];
}

- (IBAction)saveDataAction:(id)sender {
    if(![self.orgNameTxt.text isEqualToString:self.organizationInfoModel.name] || ![self.organizationInfoModel.organizationImageUrl isEqualToString:self.headImgUrl]){
        [self submitData];
    }else{
        [QMUITipsTool showSuccessWithMessage:@"No changes made".icanlocalized inView:self.view];
    }
}

- (IBAction)didDeleteOrgAction:(id)sender {
    [self showSurePayView];
}

-(void)showSurePayView{
    if ([UserInfoManager sharedManager].tradePswdSet) {
        [[PayManager sharedManager]checkPaymentPasswordWithOther: @"Password".icanlocalized needSub: @"Enter the payment password".icanlocalized successBlock:^(NSString * _Nonnull password)  {
            [self deleteOrganization:password];
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

- (IBAction)editTransactionLevels:(id)sender {
    AssignUsersVC *homeVc = [[AssignUsersVC alloc]init];
    homeVc.goBackData = ^(NSArray<MemebersResponseInfo *> * _Nonnull selectedUsers) {
        if(selectedUsers.count > 0){
            [self addLevel:selectedUsers];
        }else{
            [QMUITipsTool showOnlyTextWithMessage:@"Even one user should be selected" inView:nil];
        }
    };
    homeVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:homeVc animated:YES];
}

- (void)addLevel:(NSArray<MemebersResponseInfo *> *)levelInfo{
    AddEditLevelRequest *request = [AddEditLevelRequest request];
    request.level = self.organizationInfoModel.transactionApprovalLevels + 1;
    request.isAdd = true;
    NSMutableArray<NSNumber *> *convertedArray = [NSMutableArray arrayWithCapacity:levelInfo.count];
    for (MemebersResponseInfo *memberInfo in levelInfo) {
        NSNumber *number = @(memberInfo.userId);
        [convertedArray addObject:number];
    }
    request.usersAssigned = convertedArray;
    request.parameters = [request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(BaseResponse *response) {
        [QMUITips hideAllTips];
        [self getOrgInfo];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
    }];
}

- (void)deleteLevel:(NSInteger)level{
    ConfirmPopUp *vc = [[ConfirmPopUp alloc] init];
    vc.type = 2;
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5]; // Adjust alpha as needed
    vc.noBlock = ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    vc.sureBlock = ^{
        AddEditLevelRequest *request = [AddEditLevelRequest request];
        request.level = level;
        request.isAdd = false;
        request.parameters = [request mj_JSONObject];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(BaseResponse *response) {
            [QMUITips hideAllTips];
            [self dismissViewControllerAnimated:YES completion:nil];
            [self getOrgInfo];
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    };
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.organizationInfoModel.transactionApprovalLevels;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EditLevelCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:@"EditLevelCell"];
    [cell setData:indexPath.row + 1];
    cell.deleteBlock = ^{
        [self deleteLevel:indexPath.row + 1];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Clicked");
}

@end
