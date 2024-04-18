//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 21/5/2021
- File name:  CircleOssWrapper.h
- Description:
- Function List:
*/
        

#import <Foundation/Foundation.h>
#import <AliyunOSSiOS/AliyunOSSiOS.h>
NS_ASSUME_NONNULL_BEGIN

@interface C2COssWrapper : NSObject
+(instancetype)shared;
@property(nonatomic, copy) NSString *urlBegin;
@property(nonatomic, strong) NSString *bucket;
@property (nonatomic, strong) OSSClient *defaultClient;
-(void)uploadImage:(UIImage*)image  successHandler:(void (^)(NSString*imgModels))successHandler;
-(void)uploadC2CComplaintImagesWithModels:(NSArray<UploadImgModel*>*)imgs successHandler:(void (^)(NSArray*imgModels))successHandler;
-(void)startUploadC2CCComplaintVideoWith:(UIImage *)image imageFailure:(void (^_Nullable)(NSError*))imageFailure videoFailure:(void (^_Nullable)(NSError*))videoFailure videoUrl:(NSURL *)videoUrl videoUploadProgress:(void (^_Nullable)(float progress))videoUploadProgress  success:(void (^_Nullable)(NSString*imageUrl ,NSString*videoUrl,NSString*videoOssPath))success;
@end

NS_ASSUME_NONNULL_END
