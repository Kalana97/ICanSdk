//
//  ShowHeadPicVC.m
//  EasyPay
//
//  Created by 刘志峰 on 2019/8/20.
//  Copyright © 2019 EasyPay. All rights reserved.
//

#import "ShowHeadPicVC.h"
#import "QMUIAlertControllerTool.h"
#import "UIImagePickerHelper.h"
#import "OSSWrapper.h"
#import "PrivacyPermissionsTool.h"
#import "UIImage+colorImage.h"
#import "SaveViewManager.h"
@interface ShowHeadPicVC ()
@property(nonatomic, strong) DZIconImageView *iconImageView;
@end

@implementation ShowHeadPicVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title=NSLocalizedString(@"Profile Photos", 个人头像);
//    Change Profile Photo
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem qmui_itemWithTitle:@"Set Avatar".icanlocalized target:self action:@selector(showAlert)];
    [self.view addSubview:self.iconImageView];
    
    [self.iconImageView layerWithCornerRadius:ScreenWidth/2 borderWidth:0 borderColor:nil];
    [self.iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(ScreenWidth));
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
}


-(DZIconImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView=[[DZIconImageView alloc]init];
        
        [_iconImageView  setDZIconImageViewWithUrl:[UserInfoManager sharedManager].headImgUrl gender:[UserInfoManager sharedManager].gender];
        
    }
    return _iconImageView;
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
    QMUIAlertAction *action4 = [QMUIAlertAction actionWithTitle:NSLocalizedString(@"Save", 保存) style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
    }];
    
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:nil message:nil preferredStyle:QMUIAlertControllerStyleActionSheet];
    [alertController addAction:action1];
    [alertController addAction:action3];
    [alertController addAction:action2];
    [alertController addAction:action4];
    [alertController showWithAnimated:YES];
    
}
//从相册选择
-(void)selectPickFromeTZImagePicker{
    [PrivacyPermissionsTool judgeAlbumAuthorizationSuccess:^{
        [UIImagePickerHelper selectMorePictureWithTarget:self maxCount:1 minCount:1 isAllowEditing:YES pickingPhotosHandle:^(NSArray<UIImage *> * _Nonnull photos, NSArray * _Nonnull assets, BOOL isSelectOriginalPhoto) {
            [self setHeadPicWithImage:photos.firstObject];
        } didFinishPickingPhotosWithInfosHandle:nil cancelHandle:nil pickingVideoHandle:nil pickingGifImageHandle:nil];
        
    } failure:^{
        
    }];
    
    
}
//拍照
-(void)photographToSetHeaderPic{
    
    [PrivacyPermissionsTool judgeCameraAuthorizationSuccess:^{
        [[UIImagePickerHelper sharedManager]photographFromImagePickerController:self isAllowEditing:YES didFinishPhotographPhotosHandle:^(UIImage * _Nonnull image, NSDictionary * _Nonnull info) {
            
            [self setHeadPicWithImage:image];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [PrivacyPermissionsTool judgeAlbumAuthorizationSuccess:^{
                    [SaveViewManager saveImageToPhotos:image success:^{
                        
                    } failed:^{
                        
                    }];
                    
                } failure:^{
                    
                }];
                
            });
            
            
            
            
        }];
        
    } failure:^{
        
    }];
    
    
    
}

-(void)setHeadPicWithImage:(UIImage*)image{
    [QMUITipsTool showLoadingWihtMessage: NSLocalizedString(@"Setup...", 设置中...) inView:self.view isAutoHidden:NO];
    NSData*smallAlbumData=[UIImage compressImageSize:image toByte:1024*50];
    [[[OSSWrapper alloc]init] setUserHeadImageWithImage:smallAlbumData type:@"1" success:^(NSString * _Nonnull url) {
        [self setHeadPortraitWihtUrl:url];
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
}

-(void)setHeadPortraitWihtUrl:(NSString*)path{
    EditUserMessageRequest*request=[EditUserMessageRequest request];
    request.headImgUrl=path;
    request.parameters=[request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        [QMUITipsTool showSuccessWithMessage:NSLocalizedString(@"Set up successfully", 设置成功) inView:self.view];
        [UserInfoManager sharedManager].headImgUrl=path;
        [[NSNotificationCenter defaultCenter]postNotificationName:KUpdateUserMessageNotification object:nil];
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[UserInfoManager sharedManager].headImgUrl]];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}
@end
