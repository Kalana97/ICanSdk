//
/**
 - Copyright © 2019 EasyPay. All rights reserved.
 - AUthor: Created  by DZL on 2019/9/22
 - System_Version_MACOS: 10.14
 - EasyPay
 - File name:  UIImagePickerHelper.m
 - Description:
 - Function List:
 - History:
 */


#import "UIImagePickerHelper.h"
#import "ChatAlbumModel.h"

static void(^ _success)(void);
static void(^ _failed)(void);
@interface UIImagePickerHelper()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,LFAssetExportSessionDelegate>
@property (nonatomic,strong) UIImagePickerController *picker;
@property (nonatomic,assign) BOOL isAllowEditing;
@property (nonatomic,copy) DidFinishPhotographPhotosHandle didFinishPhotographPhotosHandle;
@property(nonatomic, strong) NSTimer *exportProgressBarTimer;
@property(nonatomic, copy) void (^progress)(float progress);
@property(nonatomic, assign) float lfaexportSessionProgress;
@end
@implementation UIImagePickerHelper
+ (instancetype)sharedManager {
    static UIImagePickerHelper *api;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        api = [[UIImagePickerHelper alloc] init];
        
    });
    return api;
}
+(void)selectMorePicturInChatView:(PhotoPickerImagesCallback)imagesCallback pickingGifImageHandle:(DidFinishPickingGifImageHandle)didFinishPickingGifImageHandle didFinishPickingVideoHandle:(DidFinishPickingVideoHandle)didFinishPickingVideoHandle target:(id)target{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:4 delegate:target pushPhotoPickerVc:YES];
    
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = NO;
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    imagePickerVc.allowTakeVideo = NO;   // 在内部显示拍视频按
    imagePickerVc.videoMaximumDuration = 10; // 视频最大拍摄时间
    [imagePickerVc setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    }];
    imagePickerVc.iconThemeColor = [UIColor colorWithRed:31 / 255.0 green:185 / 255.0 blue:34 / 255.0 alpha:1.0];
    imagePickerVc.showPhotoCannotSelectLayer = YES;
    imagePickerVc.cannotSelectLayerColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    [imagePickerVc setPhotoPickerPageUIConfigBlock:^(UICollectionView *collectionView, UIView *bottomToolBar, UIButton *previewButton, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel, UIView *divideLine) {
        [doneButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }];
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = YES;
    //        imagePickerVc.allowPickingImage =YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.allowPickingGif = YES;
    imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    if (@available(iOS 13.0, *)) {
        imagePickerVc.statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        imagePickerVc.statusBarStyle = UIStatusBarStyleDefault;
    }
    
    // 设置是否显示图片序号
    imagePickerVc.showSelectedIndex = YES;
    
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosWithInfosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto, NSArray<NSDictionary *> *infos) {
        __block int index = 0;
        NSMutableArray *imagesArray = [NSMutableArray array];
        [assets enumerateObjectsUsingBlock:^(PHAsset  *_Nonnull asset, NSUInteger idx, BOOL * _Nonnull stop) {
            ChatAlbumModel *imageModel = [[ChatAlbumModel alloc]init];
            imageModel.isOrignal = isSelectOriginalPhoto;
            [imagesArray addObject:imageModel];
            if (isSelectOriginalPhoto) {
                [[TZImageManager manager]getOriginalPhotoDataWithAsset:asset completion:^(NSData *data, NSDictionary *info, BOOL isDegraded) {
                    imageModel.picSize = [UIImage imageWithData:data].size;
                    NSString *name = info[PHImageResultRequestIDKey];
                    imageModel.name = [NSString stringWithFormat:@"%@%@",[NSString getCFUUID],name];
                    UIImage*newImage=[UIImage imageWithData:data];
                    NSData*originalData=UIImageJPEGRepresentation(newImage, 1.0f);
                    DDLogInfo(@" [NSString getHasNameData:originalData]=%@",  [NSString getHasNameData:originalData]);
                    if (originalData.length>1024*1024*20) {
                        //原图只是压 不缩大小
                        imageModel.orignalImageData =[UIImage compressImageSize:newImage toByte:1024*1024*16];
                        //这个是压缩之后的图片
                        imageModel.compressImageData= [newImage thumbImageToByte:1024*12];
                    }else{
                        imageModel.orignalImageData =originalData;
                        //这个是压缩之后的用来显示在图片
                        imageModel.compressImageData= [newImage thumbImageToByte:1024*12];
                    }
                    
                    imageModel.isGif=NO;
                    if (index == assets.count - 1) {
                        imagesCallback(imagesArray);
                    }
                    index ++;
                }];
            }else{
                [[TZImageManager manager]getOriginalPhotoDataWithAsset:asset completion:^(NSData *data, NSDictionary *info, BOOL isDegraded) {
                    UIImage*newImage=[UIImage imageWithData:data];
                    imageModel.picSize = newImage.size;
                    NSString *name = info[PHImageResultRequestIDKey];
                    imageModel.name = [NSString stringWithFormat:@"%@%@",[NSString getCFUUID],name];
                    CGFloat compressScale = 1;
                    if (data.length/1024.0/1024.0 < 3) {
                        compressScale = 0.1;  //压缩10倍
                    }else{  //大于3M
                        compressScale = 0.05; //压缩20倍
                    }
                    imageModel.orignalImageData =  [newImage imageWithThumbtoByte:1024*1024];
                    imageModel.compressImageData=[newImage thumbImageToByte:1024*12] ;
                    DDLogInfo(@" imageModel.orignalImageData=%@",  [NSString getHasNameData:imageModel.orignalImageData]);
                    DDLogInfo(@" imageModel.compressImageData=%@",  [NSString getHasNameData:imageModel.compressImageData]);
                    imageModel.isGif=NO;
                    if (index == assets.count - 1) {
                        imagesCallback(imagesArray);
                    }
                    index ++;
                }];
            }
            
            
        }];
        
    }];
    [imagePickerVc setDidFinishPickingGifImageHandle:^(UIImage *animatedImage, id sourceAssets) {
        !didFinishPickingGifImageHandle?: didFinishPickingGifImageHandle(animatedImage,sourceAssets);
    }];
    
    [imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *coverImage, PHAsset *asset) {
        !didFinishPickingVideoHandle?:didFinishPickingVideoHandle(coverImage,asset);
    }];
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [target presentViewController:imagePickerVc animated:YES completion:nil];
}
+(void)selectMorePictureWithTarget:(id)target maxCount:(NSInteger)max minCount:(NSInteger)min isAllowEditing:(BOOL)isAllowEditing pickingPhotosHandle:( DidFinishPickingPhotosHandle)didFinishPickingPhotosHandle didFinishPickingPhotosWithInfosHandle:(DidFinishPickingPhotosWithInfosHandle)didFinishPickingPhotosWithInfosHandle cancelHandle:(ImagePickerControllerDidCancelHandle)imagePickerControllerDidCancelHandle pickingVideoHandle:(DidFinishPickingVideoHandle)didFinishPickingVideoHandle pickingGifImageHandle:(DidFinishPickingGifImageHandle)didFinishPickingGifImageHandle{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:max columnNumber:4 delegate:target pushPhotoPickerVc:YES];
    
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = YES;
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    imagePickerVc.allowTakeVideo = NO;   // 在内部显示拍视频按
    imagePickerVc.videoMaximumDuration = 10; // 视频最大拍摄时间
    [imagePickerVc setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    }];
    
    // imagePickerVc.photoWidth = 1600;
    // imagePickerVc.photoPreviewMaxWidth = 1600;
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    // imagePickerVc.navigationBar.translucent = NO;
    imagePickerVc.iconThemeColor = [UIColor colorWithRed:31 / 255.0 green:185 / 255.0 blue:34 / 255.0 alpha:1.0];
    imagePickerVc.showPhotoCannotSelectLayer = YES;
    imagePickerVc.cannotSelectLayerColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    [imagePickerVc setPhotoPickerPageUIConfigBlock:^(UICollectionView *collectionView, UIView *bottomToolBar, UIButton *previewButton, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel, UIView *divideLine) {
        [doneButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }];
    
    /*
     [imagePickerVc setAssetCellDidSetModelBlock:^(TZAssetCell *cell, UIImageView *imageView, UIImageView *selectImageView, UILabel *indexLabel, UIView *bottomView, UILabel *timeLength, UIImageView *videoImgView) {
     cell.contentView.clipsToBounds = YES;
     cell.contentView.layer.cornerRadius = cell.contentView.tz_width * 0.5;
     }];
     */
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage =YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.allowPickingGif = YES;
    imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    
    // imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = isAllowEditing;
    imagePickerVc.needCircleCrop = isAllowEditing;
    // 设置竖屏下的裁剪尺寸
    NSInteger left = 0;
    NSInteger widthHeight = ScreenWidth - 2 * left;
    NSInteger top = (ScreenHeight - widthHeight) / 2;
    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    imagePickerVc.scaleAspectFillCrop = isAllowEditing;
    // 设置横屏下的裁剪尺寸
    // imagePickerVc.cropRectLandscape = CGRectMake((self.view.tz_height - widthHeight) / 2, left, widthHeight, widthHeight);
    /*
     [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
     cropView.layer.borderColor = [UIColor redColor].CGColor;
     cropView.layer.borderWidth = 2.0;
     }];*/
    
    //imagePickerVc.allowPreview = NO;
    // 自定义导航栏上的返回按钮
    /*
     [imagePickerVc setNavLeftBarButtonSettingBlock:^(UIButton *leftButton){
     [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
     [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 20)];
     }];
     imagePickerVc.delegate = self;
     */
    
    // Deprecated, Use statusBarStyle
    // imagePickerVc.isStatusBarDefault = NO;
    // 设置是否显示图片序号
    imagePickerVc.showSelectedIndex = YES;
    
    // 设置首选语言 / Set preferred language
    // imagePickerVc.preferredLanguage = @"zh-Hans";
    
    // 设置languageBundle以使用其它语言 / Set languageBundle to use other language
    // imagePickerVc.languageBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"tz-ru" ofType:@"lproj"]];
    
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosWithInfosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto, NSArray<NSDictionary *> *infos) {
        
    }];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        !didFinishPickingPhotosHandle?: didFinishPickingPhotosHandle(photos,assets,isSelectOriginalPhoto);
    }];
    [imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *coverImage, PHAsset *asset) {
        !didFinishPickingVideoHandle?: didFinishPickingVideoHandle(coverImage,asset);
    }];
    [imagePickerVc setDidFinishPickingGifImageHandle:^(UIImage *animatedImage, id sourceAssets) {
        !didFinishPickingGifImageHandle?: didFinishPickingGifImageHandle(animatedImage,sourceAssets);
    }];
    [imagePickerVc setImagePickerControllerDidCancelHandle:^{
        !imagePickerControllerDidCancelHandle?: imagePickerControllerDidCancelHandle();
    }];
    
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [target presentViewController:imagePickerVc animated:YES completion:nil];
}


+(void)selectMorePictureOrVideoInTimeLinesWithTarget:(id)target maxCount:(NSInteger)max minCount:(NSInteger)min  canSelectVide:(BOOL)canSelectVideo canSelectPhoto:(BOOL)canSelectPhoto pickingPhotosHandle:(DidFinishPickingPhotosHandle)didFinishPickingPhotosHandle didFinishPickingPhotosWithInfosHandle:(DidFinishPickingPhotosWithInfosHandle)didFinishPickingPhotosWithInfosHandle cancelHandle:(ImagePickerControllerDidCancelHandle)imagePickerControllerDidCancelHandle pickingVideoHandle:(DidFinishPickingVideoHandle)didFinishPickingVideoHandle pickingGifImageHandle:(DidFinishPickingGifImageHandle)didFinishPickingGifImageHandle{
    
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:max columnNumber:4 delegate:target pushPhotoPickerVc:YES];
    imagePickerVc.photoWidth=1242;
    imagePickerVc.photoPreviewMaxWidth=1242;
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = YES;
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    imagePickerVc.allowTakeVideo = NO;   // 在内部显示拍视频按
    imagePickerVc.videoMaximumDuration = 10; // 视频最大拍摄时间
    [imagePickerVc setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    }];
    
    // imagePickerVc.photoWidth = 1600;
    // imagePickerVc.photoPreviewMaxWidth = 1600;
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    // imagePickerVc.navigationBar.translucent = NO;
    imagePickerVc.iconThemeColor = [UIColor colorWithRed:31 / 255.0 green:185 / 255.0 blue:34 / 255.0 alpha:1.0];
    imagePickerVc.showPhotoCannotSelectLayer = YES;
    imagePickerVc.cannotSelectLayerColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    [imagePickerVc setPhotoPickerPageUIConfigBlock:^(UICollectionView *collectionView, UIView *bottomToolBar, UIButton *previewButton, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel, UIView *divideLine) {
        [doneButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }];
    
    /*
     [imagePickerVc setAssetCellDidSetModelBlock:^(TZAssetCell *cell, UIImageView *imageView, UIImageView *selectImageView, UILabel *indexLabel, UIView *bottomView, UILabel *timeLength, UIImageView *videoImgView) {
     cell.contentView.clipsToBounds = YES;
     cell.contentView.layer.cornerRadius = cell.contentView.tz_width * 0.5;
     }];
     */
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = canSelectVideo;
    imagePickerVc.allowPickingImage =canSelectPhoto;
    imagePickerVc.allowPickingOriginalPhoto = canSelectPhoto;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    
    // imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    
    // 设置横屏下的裁剪尺寸
    // imagePickerVc.cropRectLandscape = CGRectMake((self.view.tz_height - widthHeight) / 2, left, widthHeight, widthHeight);
    /*
     [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
     cropView.layer.borderColor = [UIColor redColor].CGColor;
     cropView.layer.borderWidth = 2.0;
     }];*/
    
    //imagePickerVc.allowPreview = NO;
    // 自定义导航栏上的返回按钮
    /*
     [imagePickerVc setNavLeftBarButtonSettingBlock:^(UIButton *leftButton){
     [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
     [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 20)];
     }];
     imagePickerVc.delegate = self;
     */
    
    // Deprecated, Use statusBarStyle
    // imagePickerVc.isStatusBarDefault = NO;
    if (@available(iOS 13.0, *)) {
        imagePickerVc.statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        imagePickerVc.statusBarStyle = UIStatusBarStyleDefault;
        // Fallback on earlier versions
    }
    
    // 设置是否显示图片序号
    imagePickerVc.showSelectedIndex = YES;
    
    // 设置首选语言 / Set preferred language
    // imagePickerVc.preferredLanguage = @"zh-Hans";
    
    // 设置languageBundle以使用其它语言 / Set languageBundle to use other language
    // imagePickerVc.languageBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"tz-ru" ofType:@"lproj"]];
    
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosWithInfosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto, NSArray<NSDictionary *> *infos) {
        
    }];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        !didFinishPickingPhotosHandle?: didFinishPickingPhotosHandle(photos,assets,isSelectOriginalPhoto);
    }];
    [imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *coverImage, PHAsset *asset) {
        
        
        !didFinishPickingVideoHandle?: didFinishPickingVideoHandle(coverImage,asset);
    }];
    [imagePickerVc setDidFinishPickingGifImageHandle:^(UIImage *animatedImage, id sourceAssets) {
        !didFinishPickingGifImageHandle?: didFinishPickingGifImageHandle(animatedImage,sourceAssets);
    }];
    [imagePickerVc setImagePickerControllerDidCancelHandle:^{
        !imagePickerControllerDidCancelHandle?: imagePickerControllerDidCancelHandle();
    }];
    
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [target presentViewController:imagePickerVc animated:YES completion:nil];
    
    
    
}

#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    
}

// The picker should dismiss itself; when it dismissed these handle will be called.
// You can also set autoDismiss to NO, then the picker don't dismiss itself.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 你也可以设置autoDismiss属性为NO，选择器就不会自己dismis了
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    
}

// If user picking a video and allowPickingMultipleVideo is NO, this callback will be called.
// If allowPickingMultipleVideo is YES, will call imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:
// 如果用户选择了一个视频且allowPickingMultipleVideo是NO，下面的代理方法会被执行
// 如果allowPickingMultipleVideo是YES，将会调用imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset {
    
}

// If user picking a gif image and allowPickingMultipleVideo is NO, this callback will be called.
// If allowPickingMultipleVideo is YES, will call imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:
// 如果用户选择了一个gif图片且allowPickingMultipleVideo是NO，下面的代理方法会被执行
// 如果allowPickingMultipleVideo是YES，将会调用imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(PHAsset *)asset {
    
}

#pragma mark  弹出系统的图片拍照
-(void)photographFromImagePickerController:(UIViewController*)currentViewController isAllowEditing:(BOOL)isAllowEditing didFinishPhotographPhotosHandle:(DidFinishPhotographPhotosHandle)didFinishPhotographPhotosHandle{
    self.didFinishPhotographPhotosHandle=[didFinishPhotographPhotosHandle copy];
    self.isAllowEditing=isAllowEditing;
    //这里会导致提前释放而无法回调吗？
    UIImagePickerController*picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    //设置拍照后的图片可被编辑
    picker.allowsEditing = self.isAllowEditing;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [currentViewController.navigationController presentViewController:picker animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info{
    
    UIImage *image;
    if (self.isAllowEditing) {
        image= [info objectForKey:UIImagePickerControllerEditedImage];
    }else{
        image=[info objectForKey:UIImagePickerControllerOriginalImage];
    }
    !self.didFinishPhotographPhotosHandle?:self.didFinishPhotographPhotosHandle(image, info);
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
+(void)saveImageToPhotosAlbum:(UIImage *)savedImage success:(void (^)(void))success failed:(void (^)(void))failed{
    _success = [success copy];
    _failed = [failed copy];
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
#pragma mark -- <保存到相册>
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        _failed();
    }else{
        _success();
    }
}
- (NSString *)tmpVideo
{
    NSString *videoPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"video"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:videoPath]) {
        [fileManager createDirectoryAtPath:videoPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return videoPath;
}
-(void)startExportVideoWithVideoAsset:(AVURLAsset *)videoAsset preset:(NSInteger)preset outputPath:(NSString*)outputPath  exportProgress:(void (^)(float progress))progress success:(void (^)(NSString *outputPath))success failure:(void (^)(NSString *errorMessage, NSError *error))failure{
    
    if(!outputPath){
        outputPath = [DZFileManager getTempPath];
        outputPath = [outputPath stringByAppendingPathComponent:@"compression"];
        if (![DZFileManager fileIsExistOfPath:outputPath]) {
            [DZFileManager creatDirectoryWithPath:outputPath];
        }
        outputPath = [outputPath stringByAppendingPathComponent:@"compression.mp4"];
        if ([DZFileManager fileIsExistOfPath:outputPath]) {
            [DZFileManager removeFileOfPath:outputPath];
        }
    }
    NSString*tempStr = [DZFileManager getTempPath];
    NSString * tempSavePath = [tempStr stringByAppendingPathComponent:@"comp/100234.mp4"];
    [DZFileManager removeFileOfPath:tempSavePath];
    [DZFileManager saveFile:tempSavePath withData:[NSData dataWithContentsOfURL:videoAsset.URL]];
    AVURLAsset *assetVideo = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:tempSavePath]];
    self.progress=progress;
    LFAssetExportSession *encoder = [LFAssetExportSession exportSessionWithAsset:assetVideo preset:(LFAssetExportSessionPreset)preset];
    self.lfaexportSession = encoder;
    encoder.delegate = self;
    encoder.outputFileType = AVFileTypeMPEG4;
    encoder.outputURL = [NSURL fileURLWithPath:outputPath];
    //    CMTime time = [asset duration];
    //    encoder.timeRange = CMTimeRangeMake(CMTimeMake(0, time.timescale), CMTimeMake(1, time.timescale));
    NSLog(@"The compressed file size is about %.2fMB", encoder.estimatedExportSize/1000.0);
    [encoder exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (encoder.status == AVAssetExportSessionStatusCompleted){
                if (success) {
                    success(outputPath);
                }
                DDLogInfo(@"Video export succeeded. video path:%@", encoder.outputURL);
                DDLogInfo(@"video size:%.2fMB", [encoder.outputURL.relativePath lf_fileSize]/1024.0/1024.0);
            }
            else if (encoder.status == AVAssetExportSessionStatusCancelled){
                DDLogInfo(@"Video export cancelled");
            }else if (encoder.status == AVAssetExportSessionStatusUnknown){
                if (success&&self.lfaexportSessionProgress==1.00&&!encoder.error) {
                    success(outputPath);
                    DDLogInfo(@"AVAssetExportSessionStatusUnknown Video export succeeded. video path:%@", encoder.outputURL);
                    DDLogInfo(@"video size:%.2fMB", [encoder.outputURL.relativePath lf_fileSize]/1024.0/1024.0);
                }else{
                    DDLogInfo(@"AVAssetExportSessionStatusUnknown Video export failed with error: %@ (%ld)", encoder.error.localizedDescription, (long)encoder.error.code);
                    if (failure) {
                        failure(@"Failed", encoder.error);
                    }
                }
               
            }else if (encoder.status == AVAssetExportSessionStatusFailed){
                DDLogInfo(@"Video export failed with error: %@ (%ld)", encoder.error.localizedDescription, (long)encoder.error.code);
                if (failure) {
                    failure(@"Failed", encoder.error);
                }
            }
        });
    }];
    
    
}
#pragma mark - LFAssetExportSessionDelegate
- (void)assetExportSessionDidProgress:(LFAssetExportSession *)assetExportSession{
    if(self.progress){
        self.lfaexportSessionProgress = assetExportSession.progress;
        self.progress(assetExportSession.progress);
    }
    DDLogDebug(@"%f", assetExportSession.progress);
}
- (void)startExportVideoWithVideoAsset:(AVURLAsset *)videoAsset presetName:(NSString *)presetName exportProgress:(void (^)(float progress))progress success:(void (^)(NSString *outputPath))success failure:(void (^)(NSString *errorMessage, NSError *error))failure {
    // Find compatible presets by video asset.
    NSArray *presets = [AVAssetExportSession exportPresetsCompatibleWithAsset:videoAsset];
    
    // Begin to compress video
    // Now we just compress to low resolution if it supports
    // If you need to upload to the server, but server does't support to upload by streaming,
    // You can compress the resolution to lower. Or you can support more higher resolution.
    if ([presets containsObject:presetName]) {
        self.exportSession=[[AVAssetExportSession alloc] initWithAsset:videoAsset presetName:presetName];
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss-SSS"];
        NSString *outputPath = [NSHomeDirectory() stringByAppendingFormat:@"/tmp/video-%@.mp4", [formater stringFromDate:[NSDate date]]];
        
        // Optimize for network use.
        self.exportSession.shouldOptimizeForNetworkUse = true;
        
        NSArray *supportedTypeArray = self.exportSession.supportedFileTypes;
        if ([supportedTypeArray containsObject:AVFileTypeMPEG4]) {
            self.exportSession.outputFileType = AVFileTypeMPEG4;
        } else if (supportedTypeArray.count == 0) {
            if (failure) {
                failure(@"该视频类型暂不支持导出", nil);
            }
            NSLog(@"No supported file types 视频类型暂不支持导出");
            return;
        } else {
            self.exportSession.outputFileType = [supportedTypeArray objectAtIndex:0];
            if (videoAsset.URL && videoAsset.URL.lastPathComponent) {
                outputPath = [outputPath stringByReplacingOccurrencesOfString:@".mp4" withString:[NSString stringWithFormat:@"-%@", videoAsset.URL.lastPathComponent]];
            }
        }
        // NSLog(@"video outputPath = %@",outputPath);
        if (![[NSFileManager defaultManager] fileExistsAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/tmp"]]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/tmp"] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        self.exportSession.outputURL = [NSURL fileURLWithPath:outputPath];
        
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
        dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(self.timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.exportSession.progress>0.99) {
                    dispatch_source_cancel(self.timer);
                }
                
            });
            progress(self.exportSession.progress);
            
        });
        dispatch_resume(self.timer);
        [self.exportSession exportAsynchronouslyWithCompletionHandler:^(void) {
            dispatch_async(dispatch_get_main_queue(), ^{
                switch (self.exportSession.status) {
                    case AVAssetExportSessionStatusUnknown: {
                        DDLogInfo(@"AVAssetExportSessionStatusUnknown");
                    }  break;
                    case AVAssetExportSessionStatusWaiting: {
                        DDLogInfo(@"AVAssetExportSessionStatusWaiting");
                    }  break;
                    case AVAssetExportSessionStatusExporting: {
                        DDLogInfo(@"AVAssetExportSessionStatusExporting");
                    }  break;
                    case AVAssetExportSessionStatusCompleted: {
                        DDLogInfo(@"AVAssetExportSessionStatusCompleted");
                        if (success) {
                            success(outputPath);
                        }
                    }  break;
                    case AVAssetExportSessionStatusFailed: {
                        DDLogInfo(@"AVAssetExportSessionStatusFailed");
                        if (failure) {
                            failure(@"Failed", self.exportSession.error);
                        }
                    }  break;
                    case AVAssetExportSessionStatusCancelled: {
                        DDLogInfo(@"AVAssetExportSessionStatusCancelled");
                        if (failure) {
                            failure(@"Cancelled", nil);
                        }
                    }  break;
                    default: break;
                }
            });
        }];
    } else {
        if (failure) {
            NSString *errorMessage = [NSString stringWithFormat:@"当前设备不支持该预设:%@", presetName];
            failure(errorMessage, nil);
        }
    }
}
- (void)updateExportDisplay {
    [self.exportProgressBarTimer invalidate];
    
}
@end
