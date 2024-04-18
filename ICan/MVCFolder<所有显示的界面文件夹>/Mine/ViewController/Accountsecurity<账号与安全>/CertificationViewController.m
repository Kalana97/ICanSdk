//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 9/11/2021
- File name:  CertificationViewController.m
- Description:
- Function List:
*/
        

#import "CertificationViewController.h"
#import "HJCActionSheet.h"
#import <TZImagePickerController.h>
#import "OSSWrapper.h"
#import "PrivacyPermissionsTool.h"
#import "UIImagePickerHelper.h"
#import "SelectMobileCodeViewController.h"
#import "QDNavigationController.h"
typedef NS_ENUM(NSInteger,CertificationUploadType){
    CertificationUploadType_uploadIdPhoto1,
    CertificationUploadType_uploadIdPhoto2,
    CertificationUploadType_selfie
};
@interface CertificationViewController ()<HJCActionSheetDelegate,TZImagePickerControllerDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *warningLbl;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet QMUITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UILabel *lastnameLab;
@property (weak, nonatomic) IBOutlet QMUITextField *lastnameTextField;

@property (weak, nonatomic) IBOutlet UILabel *genderLab;
@property (weak, nonatomic) IBOutlet UIButton *manBtn;
@property (weak, nonatomic) IBOutlet UIButton *womanBtn;
///国家
@property (weak, nonatomic) IBOutlet UILabel *countryLab;
@property (weak, nonatomic) IBOutlet QMUITextField *countryTextField;
///证件类型
@property (weak, nonatomic) IBOutlet UILabel *idTypeLab;
@property (weak, nonatomic) IBOutlet QMUITextField *idTypeTextField;

@property (weak, nonatomic) IBOutlet UILabel *idNumberTypeLab;
@property (weak, nonatomic) IBOutlet QMUITextField *idNumberTextField;

@property (weak, nonatomic) IBOutlet UILabel *uploadIdPhotoLab;
@property (weak, nonatomic) IBOutlet UIImageView *uploadIdPhoto1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *uploadIdPhoto2ImageView;
//自拍照
@property (weak, nonatomic) IBOutlet UILabel *selfieLab;
@property (weak, nonatomic) IBOutlet UIImageView *selfieImageView;


@property (weak, nonatomic) IBOutlet UILabel *attentionLab;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property(nonatomic, strong) NSArray *otherTitlesItems;

@property(nonatomic, assign) CertificationUploadType type;
@property(nonatomic, copy) NSString *imageUrl1;
@property(nonatomic, copy) NSString *imageUrl2;
///自拍照
@property(nonatomic, copy) NSString *selfieimageUrl;
@property(nonatomic, copy) NSString *idType;

@property(nonatomic, strong) AllCountryInfo *countryInfo;
@end

@implementation CertificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorBg243Color;
    self.idType = @"IDCard";
    self.idTypeTextField.text = @"IDcard".icanlocalized;
    self.nameLab.text = @"CertificationViewControllerNameLab".icanlocalized;
    self.nameTextField.placeholder = @"CertificationViewControllerNameTextField".icanlocalized;
    self.lastnameLab.text = @"CertificationViewControllerLastnameLab".icanlocalized;
    self.lastnameTextField.placeholder = @"CertificationViewControllerLastnameTextField".icanlocalized;
    self.genderLab.text = @"CertificationViewControllerGenderLab".icanlocalized;
    self.idTypeLab.text = @"CertificationViewControlleridTypeLab".icanlocalized;
    self.idTypeTextField.placeholder = @"CertificationViewControlleridTypeTextField".icanlocalized;
    self.idNumberTypeLab.text = @"CertificationViewControlleridNumberTypeLab".icanlocalized;
    self.idNumberTextField.placeholder = @"CertificationViewControllerIdNumberTextField".icanlocalized;
    self.uploadIdPhotoLab.text = @"CertificationViewControlleruploadIdPhotoLab".icanlocalized;
    self.selfieLab.text = @"CertificationViewControllerSelfieLab".icanlocalized;
    self.attentionLab.text = @"CertificationViewControllerAttentionLab".icanlocalized;
    self.countryLab.text = @"Country".icanlocalized;
    self.countryTextField.placeholder = @"Pleaseselectacountry".icanlocalized;
    [self.sureBtn setTitle:@"CertificationViewControllerSureBtn".icanlocalized forState:UIControlStateNormal];
    [self.womanBtn setTitle:@"Female".icanlocalized forState:UIControlStateNormal];
    [self.manBtn setTitle:@"Male".icanlocalized forState:UIControlStateNormal];
    [self.womanBtn setImage:UIImageMake(@"icon_selectperson_nor") forState:UIControlStateNormal];
    [self.womanBtn setImage:UIImageMake(@"icon_selectperson_sel") forState:UIControlStateSelected];
    [self.manBtn setImage:UIImageMake(@"icon_selectperson_nor") forState:UIControlStateNormal];
    [self.manBtn setImage:UIImageMake(@"icon_selectperson_sel") forState:UIControlStateSelected];
    [self.sureBtn layerWithCornerRadius:22 borderWidth:0 borderColor:nil];
    self.title = @"CertificationViewControllerTitle".icanlocalized;
    UITapGestureRecognizer * uploadIdPhoto1Tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uploadIdPhoto1Action)];
    [self.uploadIdPhoto1ImageView addGestureRecognizer:uploadIdPhoto1Tap];
    UITapGestureRecognizer * uploadIdPhoto2Tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uploadIdPhoto2Action)];
    [self.uploadIdPhoto2ImageView addGestureRecognizer:uploadIdPhoto2Tap];
    UITapGestureRecognizer * selfieTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selfieAction)];
    [self.selfieImageView addGestureRecognizer:selfieTap];
    [self getOneCountryRequest];
    self.warningLbl.text = @"Authentication page tip".icanlocalized;
}

-(void)uploadIdPhoto1Action{
    self.type = CertificationUploadType_uploadIdPhoto1;
    [self pushTZImagePickerController];
}
-(void)uploadIdPhoto2Action{
    self.type = CertificationUploadType_uploadIdPhoto2;
    [self pushTZImagePickerController];
}
///上传自拍照
-(void)selfieAction{
    self.type = CertificationUploadType_selfie;
    [self photographToSetHeaderPic];
}
//拍照
-(void)photographToSetHeaderPic{
    [PrivacyPermissionsTool judgeCameraAuthorizationSuccess:^{
        [[UIImagePickerHelper sharedManager]photographFromImagePickerController:self isAllowEditing:YES didFinishPhotographPhotosHandle:^(UIImage * _Nonnull image, NSDictionary * _Nonnull info) {
            self.selfieImageView.image = image;
            [[[OSSWrapper alloc]init]uploadCertificationImagesWith:image type:0 successHandler:^(NSString * _Nonnull url) {
                self.selfieimageUrl = url;
            }];
            
            
        }];
        
    } failure:^{
        
    }];
}
-(IBAction)countryAction{
    [self.view endEditing:YES];
    SelectMobileCodeViewController*vc=[[SelectMobileCodeViewController alloc]init];
    QDNavigationController*nav=[[QDNavigationController alloc]initWithRootViewController:vc];
    nav.modalPresentationStyle=UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:^{
        
    }];
    vc.selectAreaBlock = ^(AllCountryInfo * _Nonnull info) {
        if (BaseSettingManager.isChinaLanguages) {
            self.countryTextField.text = info.nameCn;
        }else{
            self.countryTextField.text = info.nameEn;
        }
        self.countryInfo = info;
    };
    
}
-(IBAction)selectIdTypeAction{
    [self.view endEditing:YES];
    self.otherTitlesItems = @[@"IDcard".icanlocalized,@"Passport".icanlocalized,@"Driver'sLicense".icanlocalized];
    HJCActionSheet*hjcActionSheet=[[HJCActionSheet alloc]initWithArrayDelegate:self cancelTitle:NSLocalizedString(@"Cancel", nil) otherTitles:self.otherTitlesItems];
    [hjcActionSheet show];
    
}
- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        self.uploadIdPhoto2ImageView.hidden = NO;
        self.idType = @"IDCard";
    }else if (buttonIndex == 2){
        self.idType = @"Passport";
        self.uploadIdPhoto2ImageView.hidden = YES;
    }else if (buttonIndex == 3){
        self.idType = @"DriverLicense";
        self.uploadIdPhoto2ImageView.hidden = YES;
    }
    NSString*title=[self.otherTitlesItems objectAtIndex:buttonIndex-1];
    self.idTypeTextField.text = title;
    
}

-(IBAction)womanBtnAction{
    self.womanBtn.selected = YES;
    self.manBtn.selected = NO;
    
}
-(IBAction)manBtnAction{
    self.womanBtn.selected = NO;
    self.manBtn.selected = YES;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
- (void)pushTZImagePickerController {
    NSInteger count = 1;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:count columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.isSelectOriginalPhoto = NO;
    // 1.设置目前已经选中的图片数组
    //    imagePickerVc.selectedAssets = self.selectedAssets; // 目前已经选中的图片数组
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    imagePickerVc.allowTakeVideo = NO;   // 在内部显示拍视频按
    imagePickerVc.videoMaximumDuration = 10; // 视频最大拍摄时间
    [imagePickerVc setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    }];
    imagePickerVc.photoWidth = 1600;
    imagePickerVc.photoPreviewMaxWidth = 1600;
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
    
    // 设置是否显示图片序号
    imagePickerVc.showSelectedIndex = YES;
    
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    switch (self.type) {
        case CertificationUploadType_selfie:{
            self.selfieImageView.image = photos.firstObject;
            [[[OSSWrapper alloc]init]uploadCertificationImagesWith:photos.firstObject type:0 successHandler:^(NSString * _Nonnull url) {
                self.selfieimageUrl = url;
            }];
        }
            
            break;
        case CertificationUploadType_uploadIdPhoto1:{
            self.uploadIdPhoto1ImageView.image = photos.firstObject;
            [[[OSSWrapper alloc]init]uploadCertificationImagesWith:photos.firstObject type:0 successHandler:^(NSString * _Nonnull url) {
                
                self.imageUrl1 = url;
            }];
        }
            
            break;
        case CertificationUploadType_uploadIdPhoto2:{
            self.uploadIdPhoto2ImageView.image = photos.firstObject;
            [[[OSSWrapper alloc]init]uploadCertificationImagesWith:photos.firstObject type:1 successHandler:^(NSString * _Nonnull url) {
                self.imageUrl2 = url;
            }];
        }
            
            break;
        default:
            break;
    }
    
}

// Decide album show or not't
// 决定相册显示与否
- (BOOL)isAlbumCanSelect:(NSString *)albumName result:(PHFetchResult *)result {
    return YES;
}

-(IBAction)sureBtnAction{
    UserAuthRequest * request  = [UserAuthRequest request];
    if (self.nameTextField.text.length == 0) {
        [QMUITipsTool showOnlyTextWithMessage:@"CertificationViewControllerNameTextField".icanlocalized inView:self.view];
        return;
    }
    if (self.lastnameTextField.text.length == 0) {
        [QMUITipsTool showOnlyTextWithMessage:@"CertificationViewControllerLastnameTextField".icanlocalized inView:self.view];
        return;
    }
    if (self.idNumberTextField.text.length == 0) {
        [QMUITipsTool showOnlyTextWithMessage:@"CertificationViewControllerIdNumberTextField".icanlocalized inView:self.view];
        return;
    }
    if ([self.idType isEqualToString: @"IDCard"]) {
        if (!self.imageUrl2||!self.imageUrl1) {
            [QMUITipsTool showOnlyTextWithMessage:@"PleaseuploadyourIDphoto".icanlocalized inView:self.view];
            return;
        }
    }else{
        if (!self.imageUrl1) {
            [QMUITipsTool showOnlyTextWithMessage:@"PleaseuploadyourIDphoto".icanlocalized inView:self.view];
            return;
        }
    }
    
    if (!self.selfieimageUrl) {
        [QMUITipsTool showOnlyTextWithMessage:@"Pleaseuploadaselfie".icanlocalized inView:self.view];
        return;
    }
    request.firstName = self.nameTextField.text;
    request.lastName = self.lastnameTextField.text;
    if (self.manBtn.selected) {
        request.gender = @"Male";
    }else{
        request.gender = @"Female";
    }
    if (self.countryInfo) {
        request.countriesCode = self.countryInfo.code;
    }
    request.idType = self.idType;
    request.cardId = self.idNumberTextField.text;
    if ([self.idType isEqualToString: @"IDCard"]) {
        request.idImgs = @[self.imageUrl1,self.imageUrl2];
    }else{
        request.idImgs = @[self.imageUrl1];
    }
   
    request.selfieImg = self.selfieimageUrl;
    request.parameters = [request mj_JSONObject];
    [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:NO];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        [[UserInfoManager sharedManager]getMineMessageRequest:^(UserMessageInfo * _Nonnull info) {
            [QMUITips hideAllTips];
            [QMUITipsTool showOnlyTextWithMessage:@"Authentication page toast".icanlocalized inView:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:KUpdateUserMessageNotification object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITips hideAllTips];
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}
-(void)getOneCountryRequest{
    GetOneCountriesRequest * request = [GetOneCountriesRequest request];
    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/public/countries/%@",UserInfoManager.sharedManager.countriesCode];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[AllCountryInfo class] contentClass:[AllCountryInfo class] success:^(AllCountryInfo *response) {
        if (BaseSettingManager.isChinaLanguages) {
            self.countryTextField.text = response.nameCn;
        }else{
            self.countryTextField.text = response.nameEn;
        }
        self.countryInfo = response;
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}

@end
