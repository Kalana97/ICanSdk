//
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 19/5/2021
 - File name:  CircleMineViewController.m
 - Description:
 - Function List:
 */


#import "CircleMineViewController.h"
#import <TZImagePickerController.h>
#import "CircleOssWrapper.h"
#import "YBImageBrowerTool.h"
#import "PrivacyPermissionsTool.h"
#import "UIImagePickerHelper.h"
#import "CircleEditMydDataViewController.h"
#import "PayManager.h"
#import "CircleMineSecondTableViewCell.h"
#import "UploadImgModel.h"
#import "CircleMyImgViewController.h"
#import "CircleMineHeadView.h"
#import "SurePushPostView.h"
#import "CircleAddPhotoViewController.h"
@interface CircleMineViewController ()<TZImagePickerControllerDelegate>
@property(nonatomic, strong) UIView *navBarView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *leftArrowButton;
@property(nonatomic, strong) CircleUserInfo *circleUserInfo;
@property(nonatomic, strong) LikeMeOrMeLikeCountInfo *likeMeOrMeLikeCountInfo;
@property(nonatomic, strong) PayManager*mange;
@property(nonatomic, strong) CircleMineHeadView *headView;
@property(nonatomic, strong) UserGoodInfo *userGoodInfo;
//上传用户头像
@property(nonatomic, strong) UploadImgModel *userIconImgModel;
//上传背景头像
@property(nonatomic, strong) UploadImgModel *bgImgModel;
@property(nonatomic, strong) UIButton *pushButton;
/** 当前从相册选择的照片数组 */
@property(nonatomic, strong) NSMutableArray<UploadImgModel*> *selectPhotos;
@end

@implementation CircleMineViewController
-(BOOL)forceEnableInteractivePopGestureRecognizer{
    return YES;;
}
-(BOOL)preferredNavigationBarHidden{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.userIconImgModel=[[UploadImgModel alloc]init];
    self.bgImgModel=[[UploadImgModel alloc]init];
    [self getUserRequest];
    [self getLikeUnLikeRequest];
    [self getGoodCountRequest];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getUserRequest) name:kUpdateCircleUserMessageNotificatiaon object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getUserRequest) name:kCirclePhotoWallChangeNotification object:nil];
    self.mange=[[PayManager alloc]initWithShowViewController:self fetchBalanceSuccessBlock:^(UserBalanceInfo * _Nonnull balance) {
    }];
    [self.view addSubview:self.navBarView];
    [self.navBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@(NavBarHeight));
    }];
    [self.navBarView addSubview:self.leftArrowButton];
    [self.leftArrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@17);
        make.height.equalTo(@17);
        make.left.equalTo(@10);
        make.bottom.equalTo(@-13.5);
    }];
    
    
}
-(void)updateView{
    if (self.circleUserInfo.dateOfBirth) {
        if (self.circleUserInfo.publish) {
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@(-StatusBarHeight));
                make.left.right.equalTo(@0);
                make.bottom.equalTo(@(0));
            }];
            self.pushButton.hidden=YES;
        }else{
            CGFloat bottomMargin= isIPhoneX?34:0;
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@(-StatusBarHeight));
                make.left.right.equalTo(@0);
                make.bottom.equalTo(@(-(bottomMargin+44+20+20)));
            }];
            [self.view addSubview:self.pushButton];
            [self.pushButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@10);
                make.height.equalTo(@44);
                make.right.equalTo(@-10);
                make.bottom.equalTo(@(-(bottomMargin+20)));
            }];
        }
    }else{
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(-StatusBarHeight));
            make.left.right.equalTo(@0);
            make.bottom.equalTo(@(0));
        }];
        
    }
}
-(void)initTableView{
    [super initTableView];
    [self updateView];
    self.tableView.backgroundColor=UIColor.clearColor;
    self.view.backgroundColor=UIColor.clearColor;
    
    [self.tableView registNibWithNibName:kCircleMineSecondTableViewCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"CircleMineHeadView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"CircleMineHeadView"];
    
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat contenty=scrollView.contentOffset.y;
    CGFloat marightY=NavBarHeight;
    if (contenty>marightY) {
        self.navBarView.backgroundColor=UIColor.whiteColor;
        [self.leftArrowButton setBackgroundImage:UIImageMake(@"icon_nav_back_black") forState:UIControlStateNormal];
        
    }else{
        [self.leftArrowButton setBackgroundImage:UIImageMake(@"icon_nav_white_withblack_border") forState:UIControlStateNormal];
        self.navBarView.backgroundColor=UIColorMakeWithRGBA(255, 255, 255, contenty/marightY);
    }
}
-(void)layoutTableView{
    
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 400;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return UITableViewAutomaticDimension;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    self.headView=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CircleMineHeadView"];
    self.headView.userInfo=self.circleUserInfo;
    self.headView.userGoodInfo=self.userGoodInfo;
    self.headView.likeMeOrMeLikeCountInfo=self.likeMeOrMeLikeCountInfo;
    @weakify(self);
    self.headView.editIconBlock = ^{
        @strongify(self);
        [self showIconAlert];
    };
    self.headView.editBgImgBlock = ^{
        @strongify(self);
        [self showBgImageViewAlert];
    };
    self.headView.clickEditBlock = ^{
        @strongify(self);
        CircleEditMydDataViewController*vc=[CircleEditMydDataViewController new];
        vc.editSuccessBlock = ^{
            [self getUserRequest];
        };
        
        [[AppDelegate shared]pushViewController:vc animated:YES];
    };
    self.headView.showAllBlock = ^{
        @strongify(self);
        CircleMyImgViewController*vc=[[CircleMyImgViewController alloc]init];
        vc.circleUserInfo=self.circleUserInfo;
        [self.navigationController pushViewController:vc animated:YES];
    };
    self.headView.addImageBlock = ^{
        @strongify(self);
        [self pushTZImagePickerController];
    };
    return self.headView;
}
- (void)pushTZImagePickerController {
    NSInteger count = 9-self.selectPhotos.count;
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
    [self.selectPhotos removeAllObjects];
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    [self.selectPhotos removeAllObjects];
    for (UIImage*image in photos) {
        UploadImgModel*model=[[UploadImgModel alloc]init];
        model.image=image;
        [self.selectPhotos addObject:model];
    }
    CircleAddPhotoViewController * vc = [[CircleAddPhotoViewController alloc]init];
    vc.selectPhotos = [NSMutableArray arrayWithArray:self.selectPhotos];
    [self.navigationController pushViewController:vc animated:YES];
    
}
// Decide album show or not't
// 决定相册显示与否
- (BOOL)isAlbumCanSelect:(NSString *)albumName result:(PHFetchResult *)result {
    return YES;
}

// Decide asset show or not't
// 决定asset显示与否
- (BOOL)isAssetCanSelect:(PHAsset *)asset {
    return YES;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CircleMineSecondTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:kCircleMineSecondTableViewCell];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(UIView *)navBarView{
    if (!_navBarView) {
        _navBarView=[[UIView alloc]init];
        _navBarView.backgroundColor=UIColor.clearColor;
    }
    return _navBarView;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel=[UILabel centerLabelWithTitle:@"CircleHomeListViewController.title".icanlocalized font:17 color:UIColor252730Color];
        _titleLabel.font=[UIFont boldSystemFontOfSize:17];
    }
    return _titleLabel;
}
-(UIButton *)leftArrowButton{
    if (!_leftArrowButton) {
        _leftArrowButton=[UIButton dzButtonWithTitle:nil image:nil backgroundColor:UIColor.clearColor titleFont:0 titleColor:UIColor.clearColor target:self action:@selector(buttonAction)];
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
//"CircleMineViewController.topTips"="个人信息已完善，点击发布到大厅";
-(UIButton *)pushButton{
    if (!_pushButton) {
        _pushButton=[UIButton dzButtonWithTitle:@"CircleMineViewController.topTips".icanlocalized image:nil backgroundColor:UIColorThemeMainColor titleFont:16 titleColor:UIColor.whiteColor target:self action:@selector(buy)];
        [_pushButton layerWithCornerRadius:22 borderWidth:0 borderColor:UIColorThemeMainColor];
    }
    return _pushButton;
}
-(void)buy{
    if (self.circleUserInfo.checkAvatar.length>0||self.circleUserInfo.checkSignature.length>0||self.circleUserInfo.checkBackground.length>0||self.circleUserInfo.checkPhotos.count>0) {
        [UIAlertController alertControllerWithTitle:nil message:@"circlePushErrorTips".icanlocalized target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
                    
        }];
        return;
    }
//    if (self.circleUserInfo.photos.count<6) {
//        [QMUITipsTool showErrorWihtMessage:@"CircleImageLessThanSix".icanlocalized inView:self.view];
//        return;
//    }
    PostReleaseMoneyRequest*doRequest=[PostReleaseMoneyRequest request];
    [[CircleNetRequestManager shareManager]startRequest:doRequest responseClass:[PostReleaseMoneyInfo class] contentClass:[PostReleaseMoneyInfo class] success:^(PostReleaseMoneyInfo* mresponse) {
        if (mresponse.money!=0.00) {
            SurePushPostView*postView=[[NSBundle mainBundle]loadNibNamed:@"SurePushPostView" owner:self options:nil].firstObject;
            postView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            [postView showPostView];
            postView.contentLabel.text=[NSString stringWithFormat:@"%@ ￥%.2f，%@",@"CircleMineViewController.buytips".icanlocalized,mresponse.money,@"CircleMineViewController.surebuytips".icanlocalized];
            postView.sureBlock = ^{
                PostCircleReleaseBuyRequest*request=[PostCircleReleaseBuyRequest request];
                [[CircleNetRequestManager shareManager]startRequest:request responseClass:[PostCircleReleaseBuyInfo class] contentClass:[PostCircleReleaseBuyInfo class] success:^(PostCircleReleaseBuyInfo* response) {
                    [self.mange showPayViewWithAmount:[NSString stringWithFormat:@"%.2f",response.money.doubleValue] typeTitleStr:@"CircleMineViewController.typeStr".icanlocalized SurePaymentViewType:SurePaymentView_Normal successBlock:^(NSString * _Nonnull password) {
                        [UserInfoManager sharedManager].attemptCount = nil;
                        [UserInfoManager sharedManager].isPayBlocked = NO;
                        PayPreparePayOrderRequest*request=[PayPreparePayOrderRequest request];
                        request.pathUrlString=[NSString stringWithFormat:@"%@/preparePayOrder/%@",request.baseUrlString,response.transactionId];
                        request.password=password;
                        request.parameters=[request mj_JSONString];
                        [QMUITipsTool showLoadingWihtMessage:@"Paying".icanlocalized inView:nil isAutoHidden:NO];
                        [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id cresponse) {
                            //"BuyPackageViewController.successTips"="购买成功";
                            [QMUITipsTool showSuccessWithMessage:@"BuyPackageViewController.successTips".icanlocalized inView:nil];
                            self.circleUserInfo.publish=YES;
                            [self.tableView reloadData];
                            [self updateView];
                        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                            if ([info.code isEqual:@"pay.password.error"]) {
                                if (info.extra.isBlocked) {
                                    [UserInfoManager sharedManager].isPayBlocked = YES;
                                    [UserInfoManager sharedManager].unblockTime = [NSString getUnblockTime:info.extra.blockedTimeMillis];
                                    [self buy];
                                } else if (info.extra.remainingCount != 0) {
                                    [UserInfoManager sharedManager].attemptCount = [NSString stringWithFormat:@"%ld", (long)info.extra.remainingCount];
                                    [self buy];
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
                    }];
                } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
                    
                }];
            };
        }else{
            self.circleUserInfo.publish=YES;
            [QMUITipsTool showSuccessWithMessage:@"SuccessfullyPosted".icanlocalized inView:nil];
            [self updateView];
            [self.tableView reloadData];
        }
        
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        
    }];
    
    
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
//从相册选择
-(void)selectIconPickFromeTZImagePicker{
    [PrivacyPermissionsTool judgeAlbumAuthorizationSuccess:^{
        [UIImagePickerHelper selectMorePictureWithTarget:self maxCount:1 minCount:1 isAllowEditing:YES pickingPhotosHandle:^(NSArray<UIImage *> * _Nonnull photos, NSArray * _Nonnull assets, BOOL isSelectOriginalPhoto) {
            self.userIconImgModel.image=photos.firstObject;
            [[CircleOssWrapper shared]uploadImagesWithModels:@[self.userIconImgModel] uploadType:UploadType_CircleUser successHandler:^(NSArray<UploadImgModel*> * _Nonnull imgModels) {
                [QMUITips hideAllTips];
                self.userIconImgModel.ossImgUrl=imgModels.firstObject.ossImgUrl;
                PutCircleUserInfoRequest*request=[PutCircleUserInfoRequest request];
                request.avatar=self.userIconImgModel.ossImgUrl;
                request.parameters=[request mj_JSONObject];
                [[CircleNetRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id  _Nonnull response) {
                    CircleUserInfoManager.shared.avatar=self.circleUserInfo.avatar;
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
//拍照
-(void)photographToSetHeaderPic{
    [PrivacyPermissionsTool judgeCameraAuthorizationSuccess:^{
        [[UIImagePickerHelper sharedManager]photographFromImagePickerController:self isAllowEditing:YES didFinishPhotographPhotosHandle:^(UIImage * _Nonnull image, NSDictionary * _Nonnull info) {
            [QMUITips hideAllTips];
            self.userIconImgModel.image=image;
            [[CircleOssWrapper shared]uploadImagesWithModels:@[self.userIconImgModel] uploadType:UploadType_CircleUser successHandler:^(NSArray<UploadImgModel*> * _Nonnull imgModels) {
                self.userIconImgModel.ossImgUrl=imgModels.firstObject.ossImgUrl;
                PutCircleUserInfoRequest*request=[PutCircleUserInfoRequest request];
                request.avatar=self.userIconImgModel.ossImgUrl;
                request.parameters=[request mj_JSONObject];
                [[CircleNetRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id  _Nonnull response) {
                    CircleUserInfoManager.shared.avatar=self.circleUserInfo.avatar;
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
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:NSLocalizedString(@"ChooseFromAlbum", 从相册选择)  style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        [self selectBgImageViewPickFromeTZImagePicker];
    }];
    QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:@"chatView.function.camera".icanlocalized style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
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
            self.bgImgModel.image=photos.firstObject;
            [[CircleOssWrapper shared]uploadImagesWithModels:@[self.bgImgModel] uploadType:UploadTypeCircleBgImgView successHandler:^(NSArray<UploadImgModel*> * _Nonnull imgModels) {
                [QMUITips hideAllTips];
                self.bgImgModel.ossImgUrl=imgModels.firstObject.ossImgUrl;
                PutCircleUserInfoRequest*request=[PutCircleUserInfoRequest request];
                request.background=self.bgImgModel.ossImgUrl;
                request.parameters=[request mj_JSONObject];
                [[CircleNetRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id  _Nonnull response) {
                    CircleUserInfoManager.shared.avatar=self.circleUserInfo.avatar;
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
            self.bgImgModel.image=image;
            [[CircleOssWrapper shared]uploadImagesWithModels:@[self.bgImgModel] uploadType:UploadTypeCircleBgImgView successHandler:^(NSArray<UploadImgModel*> * _Nonnull imgModels) {
                self.bgImgModel.ossImgUrl=imgModels.firstObject.ossImgUrl;
                PutCircleUserInfoRequest*request=[PutCircleUserInfoRequest request];
                request.background=self.bgImgModel.ossImgUrl;
                request.parameters=[request mj_JSONObject];
                [[CircleNetRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id  _Nonnull response) {
                    CircleUserInfoManager.shared.avatar=self.circleUserInfo.avatar;
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
    GetCircleCurrenUserInfoRequest*request=[GetCircleCurrenUserInfoRequest request];
    [[CircleNetRequestManager shareManager]startRequest:request responseClass:[CircleUserInfo class] contentClass:[CircleUserInfo class] success:^(CircleUserInfo* response) {
        self.circleUserInfo=response;
        CircleUserInfoManager.shared.yue=response.yue;
        CircleUserInfoManager.shared.age=response.age;
        CircleUserInfoManager.shared.icanId=[NSString stringWithFormat:@"%zd",response.icanId];
        CircleUserInfoManager.shared.gender=response.gender;
        CircleUserInfoManager.shared.dateOfBirth=response.dateOfBirth;
        CircleUserInfoManager.shared.avatar=response.avatar;
        CircleUserInfoManager.shared.nickname=response.nickname;
        CircleUserInfoManager.shared.checkAvatar=response.checkAvatar;
        CircleUserInfoManager.shared.enable=response.enable;
        if (!response.enable) {
            [UIAlertController alertControllerWithTitle:@"CircleUserEnable".icanlocalized message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
        }
        [self.tableView reloadData];
        [self updateView];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        
    }];
}
-(void)getGoodCountRequest{
    GetUserGoodRequest*request=[GetUserGoodRequest request];
    request.pathUrlString=[request.baseUrlString stringByAppendingString:[NSString stringWithFormat:@"/api/users/good/%@",CircleUserInfoManager.shared.userId]];
    [[CircleNetRequestManager shareManager]startRequest:request responseClass:[UserGoodInfo class] contentClass:[UserGoodInfo class] success:^(UserGoodInfo* response) {
        self.userGoodInfo=response;
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}
-(void)getLikeUnLikeRequest{
    GetLikeMeOrMeLikeCountRequest*request=[GetLikeMeOrMeLikeCountRequest request];
    [[CircleNetRequestManager shareManager]startRequest:request responseClass:[LikeMeOrMeLikeCountInfo class] contentClass:[LikeMeOrMeLikeCountInfo class] success:^(LikeMeOrMeLikeCountInfo * response) {
        self.likeMeOrMeLikeCountInfo=response;
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}
@end
