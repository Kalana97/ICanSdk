//
//  BusinessEditViewController.m
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-12-21.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "BusinessEditViewController.h"
#import "CircleEditMydDataViewController.h"
#import <TZImagePickerController.h>
#import "CircleOssWrapper.h"
#import "YBImageBrowerTool.h"
#import "PrivacyPermissionsTool.h"
#import "UIImagePickerHelper.h"
#import "CircleUserDetailImgeCollectionViewCell.h"
#import "CircleHobbyCollectionViewCell.h"
#import "CircleSelectHobbyViewController.h"
#import "HJCActionSheet.h"
#import <BRPickerView.h>
#import "showBusinessSelectAddressView.h"
#import "SelectBusinessTypeView.h"
#import <ReactiveObjC.h>
#import "UploadImgModel.h"
#import "BusinessUserResponse.h"
#import "BusinessUserRequest.h"
#import "BusinessNetworkReqManager.h"

@interface BusinessEditViewController ()<TZImagePickerControllerDelegate,QMUITextViewDelegate,HJCActionSheetDelegate,UIScrollViewDelegate,QMUITextFieldDelegate,QMUITextViewDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet DZIconImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UIView *checkIconImgView;
@property (weak, nonatomic) IBOutlet UILabel *checkIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *decsTipLabel;
@property (weak, nonatomic) IBOutlet QMUITextView *descTextField;
@property (weak, nonatomic) IBOutlet UILabel *countryTipLabel;
@property (weak, nonatomic) IBOutlet QMUITextField *countryLabel;
@property (nonatomic, strong) UploadImgModel *addImgModel;
@property (nonatomic, strong) UploadImgModel *userIconImgModel;
@property (nonatomic, strong) showBusinessSelectAddressView *selectAddressView;
@property (nonatomic, strong) BusinessCurrentUserInfo *businessUserInfo;
@property (weak, nonatomic) IBOutlet QMUITextField *nameTextField;
@property (nonatomic, assign) BOOL selectUserIconImg;
@property (nonatomic, assign) BOOL isItemShake;
@property (nonatomic, strong) UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIControl *areaControl;
@property (weak, nonatomic) IBOutlet UIControl *typeControl;
@property (weak, nonatomic) IBOutlet UILabel *businessTypeTipLbl;
@property (weak, nonatomic) IBOutlet QMUITextField *businessTypeTextField;
@property(nonatomic, strong) SelectBusinessTypeView *selectBusinessTypeView;
@end

@implementation BusinessEditViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"CircleEditMydDataViewController.title".icanlocalized;
    [IQKeyboardManager sharedManager].enable = NO;
    self.addImgModel = [[UploadImgModel alloc]init];
    self.addImgModel.image = UIImageMake(@"icon_photograph_w");
    self.addImgModel.isAdd = YES;
    self.userIconImgModel = [[UploadImgModel alloc]init];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    self.checkIconLabel.text = @"CircleMineShowUserImgTableViewCell.checkIconLabel".icanlocalized;
    [self getUserRequest];
    self.countryTipLabel.text = @"CircleHomeListViewController.topHeadView.area".icanlocalized;
    self.countryLabel.placeholder = @"CircleEditMydDataDetialInfoTableViewCell.areaLaTextField".icanlocalized;
    self.businessTypeTextField.placeholder = @"Select business type".icanlocalized;
    self.decsTipLabel.text = @"Description".icanlocalized;
    self.businessTypeTipLbl.text = @"Business Type".icanlocalized;
    self.descTextField.placeholder =  @"CircleEditMydDataDetialInfoTableViewCell.signatureTextView".icanlocalized;
    self.nameTextField.placeholder = @"Enter bussiness name".icanlocalized;
    self.descTextField.layer.cornerRadius = 5;
    self.descTextField.delegate = self;
    self.countryLabel.delegate = self;
    [self.iconImgView layerWithCornerRadius:45 borderWidth:0 borderColor:nil];
    [self.checkIconImgView layerWithCornerRadius:45 borderWidth:0 borderColor:nil];
    [self.iconImgView addTap];
    self.iconImgView.tapBlock = ^{
        [self showAlert];
    };
    self.nameTextField.delegate = self;
    self.countryLabel.delegate = self;
    self.businessTypeTextField.delegate = self;
    [self.nameTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        self.businessUserInfo.businessName = x.trimmingwhitespaceAndNewline;
    }];
    [self getTypeList];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    UITapGestureRecognizer *checkBgGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showAlert)];
    checkBgGesture.delegate = self;
    [self.checkIconImgView addGestureRecognizer:checkBgGesture];
    UITapGestureRecognizer *areaControl = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(countryAction)];
    areaControl.delegate = self;
    [self.areaControl addGestureRecognizer:areaControl];
    UITapGestureRecognizer *typeGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(typeAction)];
    typeGesture.delegate = self;
    [self.typeControl addGestureRecognizer:typeGesture];
}

- (void)countryAction{
    [self.view endEditing:YES];
    [self.selectAddressView didShowSelectAddressView];
}

- (void)typeAction{
    [self.view endEditing:YES];
    [self.selectBusinessTypeView didShowSelectAddressView];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *checkStr = [textField.text stringByReplacingCharactersInRange:range withString:string].trimmingwhitespaceAndNewline;
    int lenth = [checkStr getLenth];
    if (lenth > 30) {
        [QMUITipsTool showErrorWihtMessage:@"circle.nameTextFieldlength".icanlocalized inView:self.view];
        return NO;
    }
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *checkStr = [textView.text stringByReplacingCharactersInRange:range withString:text].trimmingwhitespaceAndNewline;
    int lenth = [checkStr getLenth];
    if (lenth > 500) {
        [QMUITipsTool showErrorWihtMessage:@"circle.singturelength".icanlocalized inView:self.view];
        return NO;
    }
    return YES;
}

-(void)tapAction{
    [self.view endEditing:YES];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

-(void)getTypeList{
    GetBusinessTypeId *request = [GetBusinessTypeId request];
    request.pid = [NSNumber numberWithInteger:0];
    request.parameters = [request mj_JSONObject];
    [[BusinessNetworkReqManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[BusinessTypeInfo class] success:^(NSArray<BusinessTypeInfo *> *response) {
        [self.selectBusinessTypeView.numberItems addObject:response];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
    }];
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
        self.selectUserIconImg = YES;
        [UIImagePickerHelper selectMorePictureWithTarget:self maxCount:1 minCount:1 isAllowEditing:YES  pickingPhotosHandle:^(NSArray<UIImage *> * _Nonnull photos, NSArray * _Nonnull assets, BOOL isSelectOriginalPhoto) {
            self.userIconImgModel.image = photos.firstObject;
            self.selectUserIconImg = NO;
            self.iconImgView.image = photos.firstObject;
            [[CircleOssWrapper shared]uploadImagesWithModels:@[self.userIconImgModel] uploadType:UploadType_CircleUser successHandler:^(NSArray<UploadImgModel*> * _Nonnull imgModels) {
                [QMUITips hideAllTips];
                self.businessUserInfo.avatar = imgModels.firstObject.ossImgUrl;
                self.userIconImgModel.ossImgUrl = imgModels.firstObject.ossImgUrl;
            }];
        } didFinishPickingPhotosWithInfosHandle:nil cancelHandle:nil pickingVideoHandle:nil pickingGifImageHandle:nil];
    } failure:^{
    }];
}

-(void)photographToSetHeaderPic{
    [PrivacyPermissionsTool judgeCameraAuthorizationSuccess:^{
        self.selectUserIconImg = YES;
        [[UIImagePickerHelper sharedManager]photographFromImagePickerController:self isAllowEditing:YES didFinishPhotographPhotosHandle:^(UIImage * _Nonnull image, NSDictionary * _Nonnull info) {
            [QMUITips hideAllTips];
            self.userIconImgModel.image = image;
            self.selectUserIconImg = NO;
            self.iconImgView.image = image;
            [[CircleOssWrapper shared]uploadImagesWithModels:@[self.userIconImgModel] uploadType:UploadType_CircleUser successHandler:^(NSArray<UploadImgModel *> * _Nonnull imgModels) {
                self.businessUserInfo.avatar = imgModels.firstObject.ossImgUrl;
                self.userIconImgModel.ossImgUrl = imgModels.firstObject.ossImgUrl;
            }];
        }];
    } failure:^{
    }];
}

- (UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [UIButton dzButtonWithTitle:@"CircleEditMydDataViewController.rightButton".icanlocalized image:nil backgroundColor:UIColor.clearColor titleFont:14 titleColor:UIColorThemeMainColor target:self action:@selector(rightBarButtonItemAction)];
    }
    return _rightButton;
}

-(void)rightBarButtonItemAction{
    if(!self.businessUserInfo.countryId && !self.businessUserInfo.areaId&&!self.businessUserInfo.provinceId) {
        [QMUITipsTool showOnlyTextWithMessage:@"CircleEditMydDataViewController.areaTips".icanlocalized inView:self.view];
        return;
    }
    if (!self.userIconImgModel.ossImgUrl && !self.userIconImgModel.image) {
        [QMUITipsTool showOnlyTextWithMessage:@"CircleEditMydDataViewController.pleseSelectIconImg".icanlocalized inView:self.view];
        return;
    }
    if (self.businessUserInfo.businessName.length <= 0) {
        [QMUITipsTool showOnlyTextWithMessage:@"CircleEditMydDataViewController.pleseInputNickname".icanlocalized inView:self.view];
        return;
    }
    if(!self.businessUserInfo.businessType && !self.businessUserInfo.businessSubType) {
        [QMUITipsTool showOnlyTextWithMessage:@"Select business type".icanlocalized inView:self.view];
        return;
    }
    [self setUserInfoFirst];
}

-(void)setUserInfoFirst{
    PutBusinessUserInfo *request = [PutBusinessUserInfo request];
    request.countryId =  [NSNumber numberWithInteger:self.businessUserInfo.countryId];
    request.provinceId = [NSNumber numberWithInteger:self.businessUserInfo.provinceId];
    request.cityId = [NSNumber numberWithInteger:self.businessUserInfo.cityId];
    request.areaId = [NSNumber numberWithInteger:self.businessUserInfo.areaId];
    request.businessType = [NSNumber numberWithInteger:self.businessUserInfo.businessType];
    request.businessSubType = [NSNumber numberWithInteger:self.businessUserInfo.businessSubType];
    request.businessName = self.businessUserInfo.businessName;
    if (self.descTextField.text.trimmingwhitespaceAndNewline.length > 0) {
        request.Description = self.descTextField.text.trimmingwhitespaceAndNewline;
    }
    request.avatar = self.userIconImgModel.ossImgUrl;
    request.parameters = [request mj_JSONObject];
    [[BusinessNetworkReqManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id  _Nonnull response) {
        BussinessInfoManager.shared.avatar = self.businessUserInfo.avatar;
        [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateCircleUserMessageNotificatiaon object:nil];
        !self.editSuccessBlock?:self.editSuccessBlock();
        [self.navigationController popViewControllerAnimated:YES];
        [QMUITipsTool showOnlyTextWithMessage:@"CircleEditMydDataViewController.changeSuccess".icanlocalized inView:nil];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}

-(void)getUserRequest{
    GetBusinessCurrentUserInfoRequest *request = [GetBusinessCurrentUserInfoRequest request];
    [[BusinessNetworkReqManager shareManager]startRequest:request responseClass:[BusinessCurrentUserInfo class] contentClass:[BusinessCurrentUserInfo class] success:^(BusinessCurrentUserInfo* response) {
        self.businessUserInfo = response;
        BussinessInfoManager.shared.businessId = [NSString stringWithFormat:@"%zd",response.businessId];
        BussinessInfoManager.shared.businessName = response.businessName;
        BussinessInfoManager.shared.avatar = response.avatar;
        BussinessInfoManager.shared.icanId = response.icanId;
        BussinessInfoManager.shared.checkAvatar = response.checkAvatar;
        BussinessInfoManager.shared.deleted = response.deleted;
        BussinessInfoManager.shared.enable = response.enable;
        self.userIconImgModel = [[UploadImgModel alloc]init];
        self.userIconImgModel.ossImgUrl = response.avatar;
        [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateCircleUserMessageNotificatiaon object:nil];
        [self updateView];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}

-(void)updateView{
    self.nameTextField.text = self.businessUserInfo.businessName;
    if (self.businessUserInfo.checkBusinessDescription.length > 0) {
        self.descTextField.text = self.businessUserInfo.checkBusinessDescription;
    }else{
        if(self.businessUserInfo.businessDescription.length > 0) {
            self.descTextField.text = self.businessUserInfo.businessDescription;
        }
    }
    if(self.businessUserInfo.businessTypeUpdated){
        NSMutableString *typeName = [[NSMutableString alloc]init];;
        if(self.businessUserInfo.businessType){
            [typeName appendString:BaseSettingManager.isChinaLanguages? self.businessUserInfo.businessTypeName:self.businessUserInfo.businessTypeNameEn];
        }
        if(self.businessUserInfo.businessSubType){
            [typeName appendString:@" "];
            [typeName appendString:BaseSettingManager.isChinaLanguages?self.businessUserInfo.businessSubTypeName:self.businessUserInfo.businessSubTypeNameEn];
        }
        self.businessTypeTextField.text = typeName;
    }
    if (self.businessUserInfo.countryId) {
        self.countryLabel.text = self.businessUserInfo.showArea;
    }
    if (self.businessUserInfo.checkAvatar) {
        self.checkIconImgView.hidden = NO;
        [self.iconImgView setImageWithString:self.businessUserInfo.checkAvatar placeholder:BoyDefault];
    }else{
        self.checkIconImgView.hidden = YES;
        [self.iconImgView setImageWithString:self.businessUserInfo.avatar placeholder:BoyDefault];
    }
}

-(showBusinessSelectAddressView *)selectAddressView{
    if (!_selectAddressView) {
        _selectAddressView = [[showBusinessSelectAddressView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _selectAddressView.userInfo = self.businessUserInfo;
        if (self.isEidt) {
            _selectAddressView.addressViewType = AddressViewType_SetUserMessage;
        }else{
            _selectAddressView.addressViewType = AddressViewType_FirstSetUserMessage;
        }
        @weakify(self);
        _selectAddressView.successBlock = ^(NSArray<AreaInfo *> * _Nonnull selectAreaItems) {
            @strongify(self);
            self.businessUserInfo.currentSelectItems = selectAreaItems;
            NSMutableString *area = [[NSMutableString alloc]init];
            for (int i = 0; i < selectAreaItems.count; i++) {
                if (i != 0) {
                    [area appendString:@" "];
                }
                AreaInfo *info = [selectAreaItems objectAtIndex:i];
                [area appendString:info.areaName];
            }
            self.countryLabel.text = area;
            switch (selectAreaItems.count) {
                case 0:
                    break;
                case 1:{
                    self.businessUserInfo.countryId = selectAreaItems[0].areaId;
                }
                    break;
                case 2:{
                    self.businessUserInfo.countryId = selectAreaItems[0].areaId;
                    self.businessUserInfo.provinceId = selectAreaItems[1].areaId;
                }
                    break;
                case 3:{
                    self.businessUserInfo.countryId = selectAreaItems[0].areaId;
                    self.businessUserInfo.provinceId = selectAreaItems[1].areaId;
                    self.businessUserInfo.cityId = selectAreaItems[2].areaId;
                }
                    break;
                case 4:{
                    self.businessUserInfo.countryId = selectAreaItems[0].areaId;
                    self.businessUserInfo.provinceId = selectAreaItems[1].areaId;
                    self.businessUserInfo.cityId = selectAreaItems[2].areaId;
                    self.businessUserInfo.areaId = selectAreaItems[3].areaId;
                }
                    break;
                default:
                    break;
            }
        };
    }
    return _selectAddressView;
}

-(SelectBusinessTypeView *)selectBusinessTypeView{
    if (!_selectBusinessTypeView) {
        _selectBusinessTypeView = [[SelectBusinessTypeView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _selectBusinessTypeView.userInfo = self.businessUserInfo;
        @weakify(self);
        _selectBusinessTypeView.successBlock = ^(NSArray<BusinessTypeInfo *> * _Nonnull selectTypeItems) {
            @strongify(self);
            self.businessUserInfo.currentSelectTypes = selectTypeItems;
            NSMutableString *type = [[NSMutableString alloc]init];
            for (int i = 0; i < selectTypeItems.count; i++) {
                if(i != 0) {
                    [type appendString:@" "];
                }
                BusinessTypeInfo *info = [selectTypeItems objectAtIndex:i];
                [type appendString:BaseSettingManager.isChinaLanguages ? info.businessType : info.businessTypeEn];
            }
            self.businessTypeTextField.text = type;
            self.businessUserInfo.businessTypeUpdated = YES;
            switch (selectTypeItems.count) {
                case 0:
                    break;
                case 1:{
                    self.businessUserInfo.businessType = selectTypeItems[0].businessTypeId;
                }
                    break;
                case 2:{
                    self.businessUserInfo.businessType = selectTypeItems[0].businessTypeId;
                    self.businessUserInfo.businessSubType = selectTypeItems[1].businessTypeId;
                }
                    break;
                default:
                    break;
            }
        };
    }
    return _selectBusinessTypeView;
}
@end
