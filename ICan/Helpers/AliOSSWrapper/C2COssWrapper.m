//
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 21/5/2021
 - File name:  CircleOssWrapper.m
 - Description:
 - Function List:
 */


#import "C2COssWrapper.h"
#import "UploadImgModel.h"
#import "NSData+ImageContentType.h"
@implementation C2COssWrapper
+ (instancetype)shared {
    static C2COssWrapper *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[C2COssWrapper alloc] init];//
    });
    
    return _manager;
}
-(void)check:(void (^)(void))block{
    
    if ([self validateWithExpireTime:C2CUserManager.shared.expiration]) {
        block();
    }else{
        [C2CUserManager.shared getC2COssTokenRequest:^{
            block();
        }];
    }
}
- (BOOL)validateWithExpireTime:(NSString *)expireTime {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *expire = [dateFormat dateFromString:expireTime];
    NSInteger expiretimet = [expire timeIntervalSince1970];
    NSInteger nowTimet = [[NSDate date] timeIntervalSince1970];
    return  expiretimet > nowTimet;
    
}
-(void)uploadImage:(UIImage*)image  successHandler:(void (^)(NSString*imgModels))successHandler{
    [self check:^{
        //    OSS路径目录：
        //    投诉图片目录：C2C/年/月/日/
        OSSPutObjectRequest*  request = [OSSPutObjectRequest new];
        request.bucketName = self.bucket;
        NSData*imageData=[image imageWithThumbtoByte:1024*1024];
        SDImageFormat format = [NSData sd_imageFormatForImageData:imageData];
        NSString*mimeType;
        //判断图片类型
        switch (format) {
            case SDImageFormatGIF:{
                mimeType=@"gif";
            }
                break;
            case SDImageFormatPNG:
                mimeType=@"png";
                break;
            case SDImageFormatHEIC:
                mimeType=@"heic";
                break;
            case SDImageFormatJPEG:
                mimeType=@"jpeg";
                break;
            case SDImageFormatTIFF:
                break;
            case SDImageFormatWebP:
                break;
            case SDImageFormatUndefined:
                break;
            default:
                break;
        }
        request.objectKey = [NSString stringWithFormat:@"c2c/%@/%@.%@",[self getTimeNow],[NSString getArc4random5:0],mimeType];
        request.uploadingData=imageData;
        request.isAuthenticationRequired = YES;
        
        OSSTask * task = [self.defaultClient putObject:request];
        [task continueWithBlock:^id(OSSTask *task) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (task.error) {
//                    NSDictionary * userInfo = task.error.userInfo;
//                    ///token失效
//                    if ([[userInfo objectForKey:@"Code"]isEqualToString:@"InvalidSecurityToken"]) {
//                        [[C2CUserManager shared]getC2COssTokenRequest:^{
//                            [self uploadImage:image successHandler:successHandler];
//                        }];
//                    }
                } else {
                    NSString*urlStr=[NSString stringWithFormat:@"%@/%@",self.urlBegin,request.objectKey];
                    successHandler(urlStr);   
                }
            });
            return nil;
        }];
    }];
    
    
}
-(void)uploadC2CComplaintImagesWithModels:(NSArray<UploadImgModel*>*)imgs successHandler:(void (^)(NSArray*imgModels))successHandler{
    [self check:^{
        //    C2C申述文件路径：appeal
            NSMutableArray*needUploadArray=[NSMutableArray array];
            for (UploadImgModel*imgModel in imgs) {
                if (imgModel.image&&!imgModel.isAdd) {
                    UIImage*image=imgModel.image;
                    OSSPutObjectRequest*  request = [OSSPutObjectRequest new];
                    request.bucketName = self.bucket;
                    NSData*imageData=[image imageWithThumbtoByte:1024*1024];
                    SDImageFormat format = [NSData sd_imageFormatForImageData:imageData];
                    NSString*mimeType;
                    //判断图片类型
                    switch (format) {
                        case SDImageFormatGIF:{
                            mimeType=@"gif";
                        }
                            break;
                        case SDImageFormatPNG:
                            mimeType=@"png";
                            break;
                        case SDImageFormatHEIC:
                            mimeType=@"heic";
                            break;
                        case SDImageFormatJPEG:
                            mimeType=@"jpeg";
                            break;
                        case SDImageFormatTIFF:
                            break;
                        case SDImageFormatWebP:
                            break;
                        case SDImageFormatUndefined:
                            break;
                        default:
                            break;
                    }
                    request.objectKey = [NSString stringWithFormat:@"appeal/%@/%@.%@",[self getTimeNow],[NSString getArc4random5:0],mimeType];
                    request.uploadingData=imageData;
                    request.isAuthenticationRequired = YES;
                    imgModel.request=request;
                    [needUploadArray addObject:imgModel];
                }
            }
            if (needUploadArray.count>0) {
                dispatch_group_t group = dispatch_group_create();
                for (UploadImgModel*requestModel in needUploadArray) {
                    dispatch_group_enter(group);
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        
                        OSSTask * task = [self.defaultClient putObject:requestModel.request];
                        [task continueWithBlock:^id(OSSTask *task) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (task.error) {
            //                        failureHandler(task.error,task.error.code);
                                } else {
                                    NSString*urlStr=[NSString stringWithFormat:@"%@/%@",self.urlBegin,requestModel.request.objectKey];
                                    requestModel.ossImgUrl=urlStr;
                                    
                                }
                                dispatch_group_leave(group);
                            });
                            return nil;
                        }];
                        
                    });
                }
                dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        successHandler(needUploadArray);
                    });
                    
                });
            }else{
                successHandler(needUploadArray);
            }
    }];
}
-(void)startUploadC2CCComplaintVideoWith:(UIImage *)image imageFailure:(void (^_Nullable)(NSError*))imageFailure videoFailure:(void (^_Nullable)(NSError*))videoFailure videoUrl:(NSURL *)videoUrl videoUploadProgress:(void (^_Nullable)(float progress))videoUploadProgress  success:(void (^_Nullable)(NSString*imageUrl ,NSString*videoUrl,NSString*videoOssPath))success{
    [self check:^{
        __block NSString*videoOssUrl;
        __block NSString*imgOssUrl;
        __block NSString*videoOssPath;
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_enter(group);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            OSSPutObjectRequest*  imageRequest = [OSSPutObjectRequest new];
            imageRequest.bucketName = self.bucket;
            NSString*mimeType=@"jpeg";
            NSString*objectKey=[NSString stringWithFormat:@"appeal/%@/%@.%@",[self getTimeNow],[NSString getArc4random5:0],mimeType];
            imageRequest.objectKey = objectKey;
            NSData * imageData = [UIImage compressImageSize:image toByte:1024*50];
            imageRequest.uploadingData=imageData;
            imageRequest.isAuthenticationRequired = YES;
            OSSTask * imagetask = [self.defaultClient putObject:imageRequest];
            
            [imagetask continueWithBlock:^id(OSSTask *task) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (imagetask.error) {
                        if (imagetask.error.code!=5) {//如果不是手动取消的
                            imageFailure(task.error);
                        }
                    } else {
                        
                        imgOssUrl=[NSString stringWithFormat:@"%@/%@",self.urlBegin,imageRequest.objectKey];
                        dispatch_group_leave(group);
                    }
                    
                });
                
                return nil;
            }];
            
        });
        dispatch_group_enter(group);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            OSSPutObjectRequest*  videoRequest = [OSSPutObjectRequest new];
            videoRequest.bucketName = self.bucket;
            videoRequest.objectKey = [NSString stringWithFormat:@"appeal/%@/%@.mp4",[self getTimeNow],[NSString getArc4random5:1]];
            videoRequest.uploadingFileURL=videoUrl;
            videoRequest.isAuthenticationRequired = YES;
            videoRequest.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
                float progressLoad = 1.f * totalBytesSent / totalBytesExpectedToSend;
                videoUploadProgress(progressLoad);
                
            };
            
            OSSTask * task = [self.defaultClient putObject:videoRequest];
            [task continueWithBlock:^id(OSSTask *task) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (task.error) {
                        if (task.error.code!=5) {
                            videoFailure(task.error);
                        }
                    } else {
                        videoOssUrl=[NSString stringWithFormat:@"%@/%@",self.urlBegin,videoRequest.objectKey];
                        videoOssPath=videoRequest.objectKey;
                        dispatch_group_leave(group);
                    }
                    
                });
                
                return nil;
            }];
        });
        dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                success(imgOssUrl,videoOssUrl,videoOssPath);
            });
            
        });
    }];
    
}
- (NSString *)getTimeNow{
    //取出个随机数
    NSDateFormatter * yearformatter = [[NSDateFormatter alloc ] init];
    [yearformatter setDateFormat:@"yyyy/M/d"];
    NSString*  year = [yearformatter stringFromDate:[NSDate date]];
    NSString *timeNow = [[NSString alloc] initWithFormat:@"%@",year];
    return timeNow;
}
@end
