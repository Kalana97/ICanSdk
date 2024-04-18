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
typedef NS_ENUM(NSInteger,UploadType){
    UploadType_Complaints,
    UploadType_CircleUser,
    UploadTypeCircleBgImgView,
};
@class UploadImgModel;
NS_ASSUME_NONNULL_BEGIN

@interface CircleOssWrapper : NSObject
+(instancetype)shared;
@property(nonatomic, copy) NSString *urlBegin;
@property(nonatomic, strong) NSString *bucket;
@property (nonatomic, strong) OSSClient *defaultClient;
-(void)uploadImagesWithModels:(NSArray<UploadImgModel*>*)imgs uploadType:(UploadType)uploadType successHandler:(void (^)(NSArray*imgModels))successHandler;
@end

NS_ASSUME_NONNULL_END
