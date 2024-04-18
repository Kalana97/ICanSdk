//
//  OSSWrapper.h
//  AliyunOSSSDK-iOS-Example
//
//  Created by huaixu on 2018/10/23.
//  Copyright © 2018 aliyun. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UploadImgModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^OSSWrapperSuccessHandler)(ChatModel*chatModel);
typedef void(^OSSWrapperFailureHandler)(NSError *error,NSInteger statusCode);

typedef void(^OSSWrapperSuccessHandlerInTimelines)(NSString *imageimageUrl);
@interface OSSWrapper : NSObject
@property(nonatomic, strong) NSMutableArray *requestArray;
/**
 在聊天页面上传图片的回调
 
 @param images images description
 @param progress progress description
 @param success success description
 @param failure failure description
 */
-(void)uploadImageWithImages:(NSArray<ChatModel*>*)images  uploadProgress:(void (^)(NSString *progress,ChatModel*chatModel))progress success:(OSSWrapperSuccessHandler)success failure:(OSSWrapperFailureHandler)failure;
-(void)uploadVoiceWithChatModel:(ChatModel*)chatModel uploadProgress:(void (^)(NSString *progress,ChatModel*chatModel))progress success:(OSSWrapperSuccessHandler)success failure:(OSSWrapperFailureHandler)failure;

/// 上传文件
/// @param chatModel chatModel description
/// @param progress progress description
/// @param success success description
/// @param failure failure description
-(void)uploadFileWithChatModel:(ChatModel*)chatModel uploadProgress:(void (^)(ChatModel*chatModel))progress success:(OSSWrapperSuccessHandler)success failure:(OSSWrapperFailureHandler)failure;

/// 设置群头像 用户头像 发送定位图片
/// @param imageData imageData description
/// @param type 0 1 2
/// @param success success description
/// @param failure failure description
-(void)setUserHeadImageWithImage:(NSData*)imageData type:(NSString*)type  success:(void (^_Nullable)(NSString*url))success
             failure:(void (^_Nullable)(NSError*))failure;



-(void)uploadVideoWithChatModel:(ChatModel*)chatModel imageUploadProgress:(void (^)( ChatModel * _Nonnull model))imageUploadProgress imageUploadSuccess:(OSSWrapperSuccessHandler)imageUploadSuccess imagefailure:(OSSWrapperFailureHandler)imagefailure videoUploadProgress:(void (^)( ChatModel * _Nonnull model))videoUploadProgress videoUploadSuccess:(OSSWrapperSuccessHandler)videoUploadSuccess videofailure:(OSSWrapperFailureHandler)videofailure;

-(void)startUploadTimelinesVideoWith:(UIImage *)image imageFailure:(void (^_Nullable)(NSError*))imageFailure videoFailure:(void (^_Nullable)(NSError*))videoFailure videoUrl:(NSURL *)videoUrl videoUploadProgress:(void (^_Nullable)(float progress))videoUploadProgress  success:(void (^_Nullable)(NSString*imageUrl ,NSString*videoUrl,NSString*videoOssPath))success;

-(void)uploadImageWithChatModel:(ChatModel*)chatModel uploadProgress:(void (^)(NSString * _Nonnull, ChatModel * _Nonnull))progress success:(OSSWrapperSuccessHandler)success failure:(OSSWrapperFailureHandler)failure;


-(void)uploadTimelineImagesWithModels:(NSArray<UploadImgModel*>*)imgs successHandler:(void (^)(NSArray*imgModels))successHandler;
-(void)uploadImagesWithImage:(UIImage *)image successHandler:(OSSWrapperSuccessHandlerInTimelines)successHandler failureHandler:(OSSWrapperFailureHandler)failureHandler;

-(void)uploadCertificationImagesWith:(UIImage*)img type:(NSInteger)type successHandler:(void (^)(NSString*url))successHandler;
/**
 upload image asynchronously

 @param objectKey object's key
 @param filePath local file's path
 @param success success block
 @param failure failure block
 */
- (void)asyncPutImage:(NSString *)objectKey
        localFilePath:(NSString *)filePath
              success:(void (^_Nullable)(id))success
              failure:(void (^_Nullable)(NSError*))failure;
/**
 cancel normal upload/download request.
 */
- (void)normalRequestCancel;


/**
 trigger callback to business server.

 @param objectKey object's key
 @param success success block
 @param failure failure block
 */
- (void)triggerCallbackWithObjectKey:(NSString *)objectKey success:(void (^_Nullable)(id))success failure:(void (^_Nullable)(NSError*))failure;


/**
 use API which named multipartUpload to upload big file.

 @param success success block
 @param failure failure block
 */
- (void)multipartUploadWithSuccess:(void (^_Nullable)(id))success failure:(void (^_Nullable)(NSError*))failure;

// ==========================image process===============================//
/**
 *    @brief    watermark
 *
 *    @param     object  object's key
 *    @param     text     text
 *    @param     size     font size
 */
- (void)textWaterMark:(NSString *)object
            waterText:(NSString *)text
           objectSize:(int)size
              success:(void (^_Nullable)(id))success
              failure:(void (^_Nullable)(NSError*))failure;

/**
 *    @brief    zoom process
 *
 *    @param     object    object's key
 *    @param     width     width
 *    @param     height    height
 */
- (void)reSize:(NSString *) object
      picWidth:(int) width
     picHeight:(int) height
       success:(void (^_Nullable)(id))success
       failure:(void (^_Nullable)(NSError*))failure;

@end

NS_ASSUME_NONNULL_END
