//
//  CreateOrganizationVC.m
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-06-21.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "CreateOrganizationVC.h"
#import "SelectMobileCodeViewController.h"
#import "QDNavigationController.h"
#import "PrivacyPermissionsTool.h"
#import "UIImagePickerHelper.h"
#import "SaveViewManager.h"
#import "OSSWrapper.h"
#import "MainPageVC.h"

@interface CreateOrganizationVC ()

@property (weak, nonatomic) IBOutlet UILabel *orgDetailsLbl;
@property (weak, nonatomic) IBOutlet UILabel *orgIconLbl;
@property (weak, nonatomic) IBOutlet UIView *iconBgView;
@property (weak, nonatomic) IBOutlet DZIconImageView *iconImg;
@property (weak, nonatomic) IBOutlet UIButton *imgeditBtn;
@property (weak, nonatomic) IBOutlet UIView *editImgBgView;
@property (weak, nonatomic) IBOutlet UILabel *orgNameLbl;
@property (weak, nonatomic) IBOutlet UITextField *orgNameTxt;
@property (weak, nonatomic) IBOutlet UIControl *createBtnControl;
@property (weak, nonatomic) IBOutlet UILabel *createBtnLbl;
@end

@implementation CreateOrganizationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self addLocalizations];
    self.orgNameTxt.delegate = self;
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
    self.orgDetailsLbl.text = @"Organization Details".icanlocalized;
    self.orgIconLbl.text = @"Organization Icon".icanlocalized;
    self.orgNameLbl.text = @"Organization Name".icanlocalized;
    self.orgNameTxt.placeholder = @"Type Organization Name".icanlocalized;
    self.createBtnLbl.text = @"Create".icanlocalized;
}

-(void)setupUI{
    [self.createBtnControl layerWithCornerRadius:5 borderWidth:1 borderColor:UIColor.clearColor];
    self.editImgBgView.layer.cornerRadius = self.editImgBgView.frame.size.height/2;
    self.editImgBgView.clipsToBounds = YES;
    self.iconImg.layer.cornerRadius = self.iconImg.frame.size.height/2;
    self.iconImg.clipsToBounds = YES;
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

-(void)setHeadPicWithImage:(UIImage *)image{
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
    [self.iconImg setDZIconImageViewWithUrl:self.headImgUrl gender:@""];
    [QMUITipsTool showSuccessWithMessage:NSLocalizedString(@"Set up successfully", 设置成功) inView:self.view];
}

- (IBAction)editImgAction:(id)sender {
    [self showAlert];
}

- (IBAction)createOrganizationAction:(id)sender {
    if(![self.orgNameTxt.text  isEqual: @""] && self.orgNameTxt.text != nil ){
        [self submitDataRequest];
    }else{
        [QMUITipsTool showErrorWihtMessage:@"ContentRemind".icanlocalized inView:self.view];
    }
}

-(void)submitDataRequest{
    AddOrganizationRequest *request = [AddOrganizationRequest request];
    request.name = self.orgNameTxt.text;
    request.organizationImageUrl = self.headImgUrl;
    request.parameters = [request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[OrganizationDetailsInfo class] contentClass:[OrganizationDetailsInfo class] success:^(OrganizationDetailsInfo *response)  {
        self.organizationInfoModel = response;
        MainPageVC *homeVc = [[MainPageVC alloc]init];
        homeVc.organizationInfoModel = self.organizationInfoModel;
        homeVc.hidesBottomBarWhenPushed = YES;
        homeVc.needBack = YES;
        [self.navigationController pushViewController:homeVc animated:YES];
        [QMUITipsTool showOnlyTextWithMessage:@"AddSuccess".icanlocalized inView:nil];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        DDLogInfo(@"error=%@",error);
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:nil];
    }];
}

@end
