//
//  BusinessMineViewController.m
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-12-20.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "BusinessMineViewController.h"
#import <TZImagePickerController.h>
#import "CircleOssWrapper.h"
#import "YBImageBrowerTool.h"
#import "PrivacyPermissionsTool.h"
#import "UIImagePickerHelper.h"
#import "PayManager.h"
#import "CircleMineSecondTableViewCell.h"
#import "UploadImgModel.h"
#import "BusinessMyImgViewController.h"
#import "CircleMineHeadView.h"
#import "SurePushPostView.h"
#import "BusinessAddPhotoViewController.h"
#import "BusinessUserRequest.h"
#import "BusinessUserResponse.h"
#import "BusinessNetworkReqManager.h"
#import "BusinessMineHeadView.h"
#import "BusinessEditViewController.h"

@interface BusinessMineViewController ()<TZImagePickerControllerDelegate>
@property(nonatomic, strong) UIView *navBarView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *leftArrowButton;
@property(nonatomic, strong) CircleUserInfo *circleUserInfo;
@property(nonatomic, strong) BusinessCurrentUserInfo *businessUserInfo;
@property(nonatomic, strong) LikeMeOrMeLikeCountInfo *likeMeOrMeLikeCountInfo;
@property(nonatomic, strong) PayManager *mange;
@property(nonatomic, strong) BusinessMineHeadView *headView;
@property(nonatomic, strong) UserGoodInfo *userGoodInfo;
@property(nonatomic, strong) UploadImgModel *userIconImgModel;
@property(nonatomic, strong) UploadImgModel *bgImgModel;
@property(nonatomic, strong) UIButton *pushButton;
@property(nonatomic, strong) NSMutableArray<UploadImgModel *> *selectPhotos;
@property(nonatomic, assign) BOOL isSingleUpload;
@end

@implementation BusinessMineViewController
-(BOOL)forceEnableInteractivePopGestureRecognizer{
    return YES;;
}

-(BOOL)preferredNavigationBarHidden{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userIconImgModel = [[UploadImgModel alloc]init];
    self.bgImgModel = [[UploadImgModel alloc]init];
    [self getUserRequest];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getUserRequest) name:kUpdateCircleUserMessageNotificatiaon object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getUserRequest) name:kCirclePhotoWallChangeNotification object:nil];
    [self.view addSubview:self.navBarView];
    [self.navBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@(NavBarHeight));
    }];
    [self.navBarView addSubview:self.leftArrowButton];
    [self.leftArrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@27);
        make.height.equalTo(@27);
        make.left.equalTo(@10);
        make.bottom.equalTo(@-13.5);
    }];
}

-(void)updateView{
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(-StatusBarHeight));
        make.left.right.equalTo(@0);
        make.bottom.equalTo(@(0));
    }];
}

-(void)initTableView{
    [super initTableView];
    [self updateView];
    self.tableView.backgroundColor = UIColor.clearColor;
    self.view.backgroundColor = UIColor.clearColor;
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessMineHeadView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"BusinessMineHeadView"];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat contenty = scrollView.contentOffset.y;
    CGFloat marightY = NavBarHeight;
    if (contenty > marightY) {
        self.navBarView.backgroundColor = UIColor.whiteColor;
        [self.leftArrowButton setBackgroundImage:UIImageMake(@"icon_nav_back_black") forState:UIControlStateNormal];
    }else{
        [self.leftArrowButton setBackgroundImage:UIImageMake(@"icon_nav_white_withblack_border") forState:UIControlStateNormal];
        self.navBarView.backgroundColor = UIColorMakeWithRGBA(255, 255, 255, contenty/marightY);
    }
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 400;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return UITableViewAutomaticDimension;

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    self.headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"BusinessMineHeadView"];
    self.headView.userInfo = self.businessUserInfo;
    @weakify(self);
    self.headView.editIconBlock = ^{
        @strongify(self);
        self.isSingleUpload = YES;
        [self showIconAlert];
    };
    self.headView.editBgImgBlock = ^{
        @strongify(self);
        self.isSingleUpload = YES;
        [self showBgImageViewAlert];
    };
    self.headView.clickEditBlock = ^{
        @strongify(self);
        BusinessEditViewController *vc = [BusinessEditViewController new];
        vc.editSuccessBlock = ^{
            [self getUserRequest];
        };
        [[AppDelegate shared]pushViewController:vc animated:YES];
    };
    self.headView.showAllBlock = ^{
        @strongify(self);
        BusinessMyImgViewController *vc = [[BusinessMyImgViewController alloc]init];
        vc.businessUserInfo = self.businessUserInfo;
        [self.navigationController pushViewController:vc animated:YES];
    };
    self.headView.addImageBlock = ^{
        @strongify(self);
        self.isSingleUpload = NO;
        [self pushTZImagePickerController];
    };
    return self.headView;
}

- (void)pushTZImagePickerController {
    NSInteger count = 9-self.selectPhotos.count;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:count columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.isSelectOriginalPhoto = NO;
    imagePickerVc.allowTakePicture = YES;
    imagePickerVc.allowTakeVideo = NO;
    imagePickerVc.videoMaximumDuration = 10;
    [imagePickerVc setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    }];
    imagePickerVc.photoWidth = 1600;
    imagePickerVc.photoPreviewMaxWidth = 1600;
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = NO;
    imagePickerVc.sortAscendingByModificationDate = YES;
    imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
    imagePickerVc.showSelectedIndex = YES;
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - TZImagePickerControllerDelegate
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    [self.selectPhotos removeAllObjects];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    [self.selectPhotos removeAllObjects];
    for (UIImage *image in photos) {
        UploadImgModel *model = [[UploadImgModel alloc]init];
        model.image = image;
        [self.selectPhotos addObject:model];
    }
    BusinessAddPhotoViewController *vc = [[BusinessAddPhotoViewController alloc]init];
    vc.isSinglePhoto = self.isSingleUpload;
    vc.selectPhotos = [NSMutableArray arrayWithArray:self.selectPhotos];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)isAlbumCanSelect:(NSString *)albumName result:(PHFetchResult *)result {
    return YES;
}

- (BOOL)isAssetCanSelect:(PHAsset *)asset {
    return YES;
}

-(UIView *)navBarView{
    if (!_navBarView){
        _navBarView = [[UIView alloc]init];
        _navBarView.backgroundColor = UIColorMakeWithRGBA(255, 255, 255, 0.1);;
    }
    return _navBarView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel centerLabelWithTitle:@"CircleHomeListViewController.title".icanlocalized font:17 color:UIColor252730Color];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    }
    return _titleLabel;
}

-(UIButton *)leftArrowButton{
    if (!_leftArrowButton) {
        _leftArrowButton = [UIButton dzButtonWithTitle:nil image:nil backgroundColor:UIColor.clearColor titleFont:0 titleColor:UIColor.clearColor target:self action:@selector(buttonAction)];
        [_leftArrowButton setBackgroundImage:UIImageMake(@"icon_circle_back_white") forState:UIControlStateNormal];
    }
    return _leftArrowButton;
}

-(NSMutableArray<UploadImgModel *> *)selectPhotos{
    if (!_selectPhotos) {
        _selectPhotos = [NSMutableArray array];
    }
    return _selectPhotos;
}

-(void)buttonAction{
    [[AppDelegate shared].curNav popViewControllerAnimated:YES];
}

-(UIButton *)pushButton{
    if (!_pushButton) {
        _pushButton = [UIButton dzButtonWithTitle:@"CircleMineViewController.topTips".icanlocalized image:nil backgroundColor:UIColorThemeMainColor titleFont:16 titleColor:UIColor.whiteColor target:self action:@selector(buy)];
        [_pushButton layerWithCornerRadius:22 borderWidth:0 borderColor:UIColorThemeMainColor];
    }
    return _pushButton;
}

- (void)showIconAlert {
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"UIAlertController.cancel.title".icanlocalized style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
    }];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:NSLocalizedString(@"ChooseFromAlbum", 从相册选择)  style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        [self selectIconPickFromeTZImagePicker];
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

-(void)selectIconPickFromeTZImagePicker{
    [PrivacyPermissionsTool judgeAlbumAuthorizationSuccess:^{
        [UIImagePickerHelper selectMorePictureWithTarget:self maxCount:1 minCount:1 isAllowEditing:YES pickingPhotosHandle:^(NSArray<UIImage *> * _Nonnull photos, NSArray * _Nonnull assets, BOOL isSelectOriginalPhoto) {
            self.userIconImgModel.image = photos.firstObject;
            [[CircleOssWrapper shared]uploadImagesWithModels:@[self.userIconImgModel] uploadType:UploadType_CircleUser successHandler:^(NSArray<UploadImgModel *> * _Nonnull imgModels) {
                [QMUITips hideAllTips];
                self.userIconImgModel.ossImgUrl = imgModels.firstObject.ossImgUrl;
                PutBusinessUserInfo *request = [PutBusinessUserInfo request];
                request.avatar = self.userIconImgModel.ossImgUrl;
                request.parameters = [request mj_JSONObject];
                [[BusinessNetworkReqManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id  _Nonnull response) {
                    BussinessInfoManager.shared.avatar = self.businessUserInfo.avatar;
                    [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateCircleUserMessageNotificatiaon object:nil];
                    [QMUITipsTool showOnlyTextWithMessage:@"CircleEditMydDataViewController.changeSuccess".icanlocalized inView:nil];
                } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
                    [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
                }];
            }];
        } didFinishPickingPhotosWithInfosHandle:nil cancelHandle:nil pickingVideoHandle:nil pickingGifImageHandle:nil];
    } failure:^{
        //handle faliure
    }];
}

-(void)photographToSetHeaderPic{
    [PrivacyPermissionsTool judgeCameraAuthorizationSuccess:^{
        [[UIImagePickerHelper sharedManager]photographFromImagePickerController:self isAllowEditing:YES didFinishPhotographPhotosHandle:^(UIImage * _Nonnull image, NSDictionary * _Nonnull info) {
            [QMUITips hideAllTips];
            self.userIconImgModel.image = image;
            [[CircleOssWrapper shared]uploadImagesWithModels:@[self.userIconImgModel] uploadType:UploadType_CircleUser successHandler:^(NSArray<UploadImgModel *> * _Nonnull imgModels) {
                self.userIconImgModel.ossImgUrl = imgModels.firstObject.ossImgUrl;
                PutBusinessUserInfo *request = [PutBusinessUserInfo request];
                request.avatar = self.userIconImgModel.ossImgUrl;
                request.parameters = [request mj_JSONObject];
                [[BusinessNetworkReqManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id  _Nonnull response) {
                    BussinessInfoManager.shared.avatar = self.circleUserInfo.avatar;
                    [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateCircleUserMessageNotificatiaon object:nil];
                    [QMUITipsTool showOnlyTextWithMessage:@"CircleEditMydDataViewController.changeSuccess".icanlocalized inView:nil];
                } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
                    [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
                }];
            }];
        }];
    } failure:^{
    }];
}

- (void)showBgImageViewAlert {
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"UIAlertController.cancel.title".icanlocalized style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
    }];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:NSLocalizedString(@"ChooseFromAlbum", 从相册选择)  style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action){
        [self selectBgImageViewPickFromeTZImagePicker];
    }];
    QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:@"chatView.function.camera".icanlocalized style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action){
        [self photographToSetBgImageViewPic];
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:nil message:nil preferredStyle:QMUIAlertControllerStyleActionSheet];
    [alertController addAction:action1];
    [alertController addAction:action3];
    [alertController addAction:action2];
    [alertController showWithAnimated:YES];
}

-(void)selectBgImageViewPickFromeTZImagePicker{
    [PrivacyPermissionsTool judgeAlbumAuthorizationSuccess:^{
        [UIImagePickerHelper selectMorePictureWithTarget:self maxCount:1 minCount:1 isAllowEditing:NO  pickingPhotosHandle:^(NSArray<UIImage *> * _Nonnull photos, NSArray * _Nonnull assets, BOOL isSelectOriginalPhoto) {
            self.bgImgModel.image = photos.firstObject;
            [[CircleOssWrapper shared]uploadImagesWithModels:@[self.bgImgModel] uploadType:UploadTypeCircleBgImgView successHandler:^(NSArray<UploadImgModel*> * _Nonnull imgModels) {
                [QMUITips hideAllTips];
                self.bgImgModel.ossImgUrl = imgModels.firstObject.ossImgUrl;
                PutBusinessUserInfo *request = [PutBusinessUserInfo request];
                request.background = self.bgImgModel.ossImgUrl;
                request.parameters = [request mj_JSONObject];
                [[BusinessNetworkReqManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id  _Nonnull response) {
                    BussinessInfoManager.shared.avatar = self.businessUserInfo.avatar;
                    [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateCircleUserMessageNotificatiaon object:nil];
                    [QMUITipsTool showOnlyTextWithMessage:@"CircleEditMydDataViewController.changeSuccess".icanlocalized inView:nil];
                } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
                    [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
                }];
            }];
        } didFinishPickingPhotosWithInfosHandle:nil cancelHandle:nil pickingVideoHandle:nil pickingGifImageHandle:nil];
    } failure:^{
    }];
}

-(void)photographToSetBgImageViewPic{
    [PrivacyPermissionsTool judgeCameraAuthorizationSuccess:^{
        [[UIImagePickerHelper sharedManager]photographFromImagePickerController:self isAllowEditing:NO didFinishPhotographPhotosHandle:^(UIImage * _Nonnull image, NSDictionary * _Nonnull info) {
            [QMUITips hideAllTips];
            self.bgImgModel.image = image;
            [[CircleOssWrapper shared]uploadImagesWithModels:@[self.bgImgModel] uploadType:UploadTypeCircleBgImgView successHandler:^(NSArray<UploadImgModel*> * _Nonnull imgModels) {
                self.bgImgModel.ossImgUrl = imgModels.firstObject.ossImgUrl;
                PutBusinessUserInfo *request = [PutBusinessUserInfo request];
                request.background = self.bgImgModel.ossImgUrl;
                request.parameters = [request mj_JSONObject];
                [[BusinessNetworkReqManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id  _Nonnull response) {
                    BussinessInfoManager.shared.avatar = self.businessUserInfo.avatar;
                    [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateCircleUserMessageNotificatiaon object:nil];
                    [QMUITipsTool showOnlyTextWithMessage:@"CircleEditMydDataViewController.changeSuccess".icanlocalized inView:nil];
                } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
                    [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
                }];
            }];
        }];
    } failure:^{
    }];
}

-(void)getUserRequest{
    GetBusinessCurrentUserInfoRequest *request = [GetBusinessCurrentUserInfoRequest request];
    [[BusinessNetworkReqManager shareManager]startRequest:request responseClass:[BusinessCurrentUserInfo class] contentClass:[BusinessCurrentUserInfo class] success:^(BusinessCurrentUserInfo* response) {
        self.businessUserInfo = response;
        BussinessInfoManager.shared.businessId = [NSString stringWithFormat:@"%zd",response.businessId];
        BussinessInfoManager.shared.businessName = response.businessName;
        BussinessInfoManager.shared.avatar = response.avatar;
        BussinessInfoManager.shared.checkAvatar = response.checkAvatar;
        BussinessInfoManager.shared.deleted = response.deleted;
        BussinessInfoManager.shared.enable = response.enable;
        if (!response.enable) {
            [UIAlertController alertControllerWithTitle:@"CircleUserEnable".icanlocalized message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
        [self.tableView reloadData];
        [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateBusinessIconNotificatiaon object:nil];
        [self updateView];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
    }];
}
@end

