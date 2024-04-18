/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 2019/9/22
- File name:  UIImagePickerHelper.h
- Description: 专门用来封装tzimagepick的类
- Function List: 
- History:
*/
        

#import <Foundation/Foundation.h>
#import "TZImagePickerController.h"
#import "LFAssetExportSession.h"
@class ChatAlbumModel;
typedef void (^DidFinishPickingPhotosHandle)(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto);
typedef void (^DidFinishPickingPhotosWithInfosHandle)(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto,NSArray<NSDictionary *> *infos);
typedef void (^ImagePickerControllerDidCancelHandle)(void);
typedef void (^DidFinishPickingVideoHandle)(UIImage *coverImage,PHAsset *asset);
typedef void (^DidFinishPickingGifImageHandle)(UIImage *animatedImage,id sourceAssets);

typedef void (^DidFinishPhotographPhotosHandle)(UIImage *image,NSDictionary *info);
//返回选中的所有图片 , 原图或者压缩图
typedef void(^PhotoPickerImagesCallback)(NSArray<ChatAlbumModel *> *images);
@interface UIImagePickerHelper : NSObject

@property(nonatomic, strong) AVAssetExportSession *exportSession;

@property(nonatomic, strong) LFAssetExportSession *lfaexportSession;

@property(nonatomic, strong) dispatch_source_t timer;

+ (instancetype)sharedManager;
+(void)selectMorePictureWithTarget:(id)target maxCount:(NSInteger)max minCount:(NSInteger)min isAllowEditing:(BOOL)isAllowEditing pickingPhotosHandle:(DidFinishPickingPhotosHandle)didFinishPickingPhotosHandle didFinishPickingPhotosWithInfosHandle:(DidFinishPickingPhotosWithInfosHandle)didFinishPickingPhotosWithInfosHandle cancelHandle:(ImagePickerControllerDidCancelHandle)imagePickerControllerDidCancelHandle pickingVideoHandle:(DidFinishPickingVideoHandle)didFinishPickingVideoHandle pickingGifImageHandle:(DidFinishPickingGifImageHandle)didFinishPickingGifImageHandle;
-(void)photographFromImagePickerController:(UIViewController*)currentViewController isAllowEditing:(BOOL)isAllowEditing didFinishPhotographPhotosHandle:(DidFinishPhotographPhotosHandle)didFinishPhotographPhotosHandle;

// 保存图片
+ (void)saveImageToPhotosAlbum:(UIImage*)savedImage success:(void(^)(void))success failed:(void(^)(void))failed;

+(void)selectMorePicturInChatView:(PhotoPickerImagesCallback)imagesCallback pickingGifImageHandle:(DidFinishPickingGifImageHandle)didFinishPickingGifImageHandle didFinishPickingVideoHandle:(DidFinishPickingVideoHandle)didFinishPickingVideoHandle target:(id)target;



+(void)selectMorePictureOrVideoInTimeLinesWithTarget:(id)target maxCount:(NSInteger)max minCount:(NSInteger)min canSelectVide:(BOOL)canSelectVideo canSelectPhoto:(BOOL)canSelectPhoto pickingPhotosHandle:(DidFinishPickingPhotosHandle)didFinishPickingPhotosHandle didFinishPickingPhotosWithInfosHandle:(DidFinishPickingPhotosWithInfosHandle)didFinishPickingPhotosWithInfosHandle cancelHandle:(ImagePickerControllerDidCancelHandle)imagePickerControllerDidCancelHandle pickingVideoHandle:(DidFinishPickingVideoHandle)didFinishPickingVideoHandle pickingGifImageHandle:(DidFinishPickingGifImageHandle)didFinishPickingGifImageHandle;

+(void)selectEvalueteWithTarget:(id)target maxCount:(NSInteger)max minCount:(NSInteger)min canSelectVide:(BOOL)canSelectVideo canSelectPhoto:(BOOL)canSelectPhoto  pickingPhotosHandle:(DidFinishPickingPhotosHandle)didFinishPickingPhotosHandle didFinishPickingPhotosWithInfosHandle:(DidFinishPickingPhotosWithInfosHandle)didFinishPickingPhotosWithInfosHandle cancelHandle:(ImagePickerControllerDidCancelHandle)imagePickerControllerDidCancelHandle pickingVideoHandle:(DidFinishPickingVideoHandle)didFinishPickingVideoHandle pickingGifImageHandle:(DidFinishPickingGifImageHandle)didFinishPickingGifImageHandle;

- (void)startExportVideoWithVideoAsset:(AVURLAsset *)videoAsset presetName:(NSString *)presetName exportProgress:(void (^)(float progress))progress success:(void (^)(NSString *  outputPath))success failure:(void (^)(NSString *  errorMessage, NSError *  error))failure;

-(void)startExportVideoWithVideoAsset:(AVURLAsset *   )videoAsset preset:(NSInteger)preset outputPath:(NSString* )outputPath  exportProgress:(void (^ )(float progress))progress success:(void (^ )(NSString *   outputPath))success failure:(void (^   )(NSString *    errorMessage, NSError *     error))failure;
@end


