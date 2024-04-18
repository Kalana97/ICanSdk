//
//  UIImage+photoPicker.m
//  JYHomeCloud
//
//  Created by 孟遥 on 16/12/19.
//  Copyright © 2016年 All rights reserved.
//

#import "UIImage+photoPicker.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import "ChatAlbumModel.h"

typedef void(^albumAuthorizationCallBack)(void);

@implementation UIImage (photoPicker)


#pragma mark - 获取相册视频
+ (void)openPhotoPickerGetVideo:(videoBaseInfoCallback)callback target:(UIViewController *)target
{
    //每次只能选取一个视频
    TZImagePickerController *picker = [self initPickerWithtaget:target maxCount:1];
    picker.allowPickingImage = NO;
    picker.allowPickingVideo = YES;
    picker.didFinishPickingVideoHandle = ^(UIImage *coverImage,id asset){

        //缓存视频到本地
        [self getVideoPathFromPHAsset:asset complete:callback cover:coverImage];
    };
}


/**
 缓存视频到本地

 @param asset            <#asset description#>
 @param cover <#coverCallbackNow description#>
 */
+ (void)getVideoPathFromPHAsset:(PHAsset *)asset complete:(videoBaseInfoCallback)callback cover:(UIImage *)cover {
    NSArray *assetResources = [PHAssetResource assetResourcesForAsset:asset];
    PHAssetResource *resource;

    for (PHAssetResource *assetRes in assetResources) {
        if (@available(iOS 9.1, *)) {
            if (assetRes.type == PHAssetResourceTypePairedVideo ||
                assetRes.type == PHAssetResourceTypeVideo) {
                resource = assetRes;
            }
        } else {
            // Fallback on earlier versions
        }
    }
    NSString *fileName = @"tempAssetVideo.mov";
    if (resource.originalFilename) {
        //命名规范可以自行定义 ， 但是要保证不要重复
        fileName = [NSString stringWithFormat:@"chatVideo_%@%@",getCurrentTime(),resource.originalFilename];
    }
    //创建视频模型
    ChatAlbumModel *videoModel = [[ChatAlbumModel alloc]init];
    //缩略图
    videoModel.videoCoverImg = cover;
    //视频时长
    videoModel.duration = [@(asset.duration)stringValue];
    //视频名称
    videoModel.name = fileName;
    //回调含有基本信息的视频模型
    if (callback) {
        callback(videoModel);
    }
}


#pragma mark - 初始化
+ (TZImagePickerController *)initPickerWithtaget:(UIViewController *)target maxCount:(NSInteger)maxCount{

    __block UIViewController *targetVc = target;
    TZImagePickerController *picker = [[TZImagePickerController alloc]initWithMaxImagesCount:maxCount delegate:nil];
    picker.allowPickingGif=YES;
    picker.modalPresentationStyle=UIModalPresentationFullScreen;
    //判断权限
    [self photoAlbumAuthorizationJudge:^{

        if (!target &&![UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController) return;

        if (!target &&[UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController) {
            targetVc = [UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController;
        }

        [targetVc presentViewController:picker animated:YES completion:nil];

    } target:target];
    return picker;
}





+ (void)photoAlbumAuthorizationJudge:(albumAuthorizationCallBack)callback target:(UIViewController *)target
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
            //未决定
        case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {

                if (status == PHAuthorizationStatusRestricted ||
                    status == PHAuthorizationStatusDenied) {
                }else{
                    callback();
                }
            }];
        }
            break;

            //拒绝
        case AVAuthorizationStatusRestricted:
        {
            //引导用户打开权限
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notice" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Sure", UIAlertController.sure.title) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

                //打开用户设置
                [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:sureAction];
            [alert addAction:cancelAction];
            [target presentViewController:alert animated:YES completion:nil];
        }
            break;

            //已经授权过
        case AVAuthorizationStatusAuthorized:
        {
            callback();
        }
            break;
        case PHAuthorizationStatusDenied:{

            //引导用户打开权限
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notice" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Sure", UIAlertController.sure.title) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

                //打开用户设置
                [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:sureAction];
            [alert addAction:cancelAction];
            [target presentViewController:alert animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}



NS_INLINE NSString *getCurrentTime() {
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    return [NSString stringWithFormat:@"%llu",recordTime];
}

@end
