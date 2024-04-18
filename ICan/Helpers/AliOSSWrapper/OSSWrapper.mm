//
//  OSSWrapper.m
//  AliyunOSSSDK-iOS-Example
//
//  Created by huaixu on 2018/10/23.
//  Copyright © 2018 aliyun. All rights reserved.
//  https://help.aliyun.com/document_detail/32066.html

#import <Foundation/Foundation.h>
#import "OSSWrapper.h"
#import "OSSManager.h"
#import "WCDBManager+ChatModel.h"
#import "NSData+ImageContentType.h"
#import "UploadImgModel.h"
@interface OSSWrapper ()

@property (nonatomic, strong) OSSPutObjectRequest *normalUploadRequest;

@property (nonatomic, strong) OSSGetObjectRequest *normalDloadRequest;

@end

// 字体，默认文泉驿正黑
NSString * const font = @"d3F5LXplbmhlaQ==";

@implementation OSSWrapper
-(void)check:(void (^)(void))block{
    if ([UserInfoManager.sharedManager validateWithExpireTime:BaseSettingManager.sharedManager.expiration]) {
        block();
    }else{
        [UserInfoManager.sharedManager getAliyunOSSSecurityToken:^{
            block();
        }];
    }
}
-(void)uploadImageWithImages:(NSArray<ChatModel *> *)images   uploadProgress:(void (^)(NSString * _Nonnull, ChatModel * _Nonnull))progress success:(OSSWrapperSuccessHandler)success failure:(OSSWrapperFailureHandler)failure{
    [self check:^{
        for (ChatModel*model in images) {
            [self uploadImageWithChatModel:model uploadProgress:progress   success:success failure:failure];
        }
    }];
    
    
    
}

/// 上传聊天界面的图片
/// @param chatModel 数据源
/// @param progress 进度条
/// @param success 成功回调
/// @param failure 失败回调
-(void)uploadImageWithChatModel:(ChatModel*)chatModel uploadProgress:(void (^)(NSString * _Nonnull, ChatModel * _Nonnull))progress success:(OSSWrapperSuccessHandler)success failure:(OSSWrapperFailureHandler)failure{
    [self check:^{
        [self startUploadImageWithChatModel:chatModel uploadProgress:progress success:success failure:failure];
    }];
    
    
}
-(void)startUploadImageWithChatModel:(ChatModel*)chatModel uploadProgress:(void (^)(NSString * _Nonnull, ChatModel * _Nonnull))progress success:(OSSWrapperSuccessHandler)success failure:(OSSWrapperFailureHandler)failure{
    OSSPutObjectRequest*  request = [OSSPutObjectRequest new];
    request.bucketName = [BaseSettingManager sharedManager].bucket;
    SDImageFormat format = [NSData sd_imageFormatForImageData:chatModel.orignalImageData];
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
    request.objectKey = [NSString stringWithFormat:@"chat/%@/%@.%@",[self getTimeNow],chatModel.fileCacheName,mimeType];
    request.uploadingData=chatModel.orignalImageData;
    request.isAuthenticationRequired = YES;
    request.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        float progressLoad = 1.f * totalBytesSent / totalBytesExpectedToSend;
        chatModel.uploadProgress=[NSString stringWithFormat:@"%.f%%",progressLoad*100];
        dispatch_async(dispatch_get_main_queue(), ^{
            progress([NSString stringWithFormat:@"%.f%%",progressLoad*100],chatModel);
        });
        
    };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OSSTask * task = [[OSSManager sharedManager].defaultClient putObject:request];
        [task continueWithBlock:^id(OSSTask *task) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (task.error) {
                    failure(task.error,task.error.code);
                } else {
                    NSString*urlStr=[NSString stringWithFormat:@"%@/%@",[BaseSettingManager sharedManager].urlBegin,request.objectKey];
                    chatModel.fileServiceUrl=urlStr;
                    chatModel.uploadProgress=@"100%";
                    chatModel.uploadState=1;
                    chatModel.sendState=2;
                    chatModel.imageUrl=urlStr;
                    UIImage*image=[UIImage imageWithData:chatModel.orignalImageData];
                    ImageMessageInfo*imageInfo=[[ImageMessageInfo alloc]init];
                    imageInfo.imageUrl = chatModel.imageUrl;
                    imageInfo.height=image.size.height ;
                    imageInfo.width=image.size.width;
                    imageInfo.isFull=!chatModel.isOrignal;
                    chatModel.thumbnails=request.objectKey;
                    chatModel.messageContent=[imageInfo mj_JSONString];
                    [[WCDBManager sharedManager]insertChatModel:chatModel];
                    success(chatModel);
                    
                }
            });
            
            return nil;
        }];
    });
}
-(void)uploadTimelineImagesWithModels:(NSArray<UploadImgModel*>*)imgs successHandler:(void (^)(NSArray*imgModels))successHandler{
    [self check:^{
        for (UploadImgModel*imgModel in imgs) {
            UIImage*image=imgModel.image;
            OSSPutObjectRequest*  request = [OSSPutObjectRequest new];
            request.bucketName = [BaseSettingManager sharedManager].bucket;
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
            request.objectKey = [NSString stringWithFormat:@"circle/%@/%@.%@",[self getTimeNow],[NSString getArc4random5:0],mimeType];
            request.uploadingData=imageData;
            request.isAuthenticationRequired = YES;
            imgModel.request=request;
        }
        dispatch_group_t group = dispatch_group_create();
        for (UploadImgModel*requestModel in imgs) {
            dispatch_group_enter(group);
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                OSSTask * task = [[OSSManager sharedManager].defaultClient putObject:requestModel.request];
                [task continueWithBlock:^id(OSSTask *task) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (task.error) {
                            //                        failureHandler(task.error,task.error.code);
                        } else {
                            NSString*urlStr=[NSString stringWithFormat:@"%@/%@",[BaseSettingManager sharedManager].urlBegin,requestModel.request.objectKey];
                            requestModel.ossImgUrl=urlStr;
                            dispatch_group_leave(group);
                        }
                        
                    });
                    
                    return nil;
                }];
                
            });
        }
        dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
            successHandler(imgs);
        });
    }];
    
    
}

-(void)uploadImagesWithImage:(UIImage *)image successHandler:(OSSWrapperSuccessHandlerInTimelines)successHandler failureHandler:(OSSWrapperFailureHandler)failureHandler{
    [self check:^{
        [self startUploadImageWithImage:image successHandler:successHandler failureHandler:failureHandler];
    }];
    
}
-(void)startUploadImageWithImage:(UIImage *)image successHandler:(OSSWrapperSuccessHandlerInTimelines)successHandler failureHandler:(OSSWrapperFailureHandler)failureHandler{
    OSSPutObjectRequest*  request = [OSSPutObjectRequest new];
    request.bucketName = [BaseSettingManager sharedManager].bucket;
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
    request.objectKey = [NSString stringWithFormat:@"circle/%@/%@.%@",[self getTimeNow],[NSString getArc4random5:0],mimeType];
    request.uploadingData=imageData;
    request.isAuthenticationRequired = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OSSTask * task = [[OSSManager sharedManager].defaultClient putObject:request];
        [task continueWithBlock:^id(OSSTask *task) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (task.error) {
                    failureHandler(task.error,task.error.code);
                } else {
                    NSString*urlStr=[NSString stringWithFormat:@"%@/%@",[BaseSettingManager sharedManager].urlBegin,request.objectKey];
                    successHandler(urlStr);
                }
            });
            
            return nil;
        }];
    });
    
}

//上传的是用户头像
- (NSString *)getUserObjectKeyInTimelines{
    NSString* date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYYMMddhhmmssSSS"];
    date = [formatter stringFromDate:[NSDate date]];
    //取出个随机数
    int last = arc4random() % 1000000;
    NSString *timeNow = [[NSString alloc] initWithFormat:@"system/timeLines/user/%@%i",date,last];
    return timeNow;
}


//上传的是用户头像
- (NSString *)getUserObjectKey{
    NSString* date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYYMMddhhmmssSSS"];
    date = [formatter stringFromDate:[NSDate date]];
    //取出个随机数
    int last = arc4random() % 1000000;
    NSString *timeNow = [[NSString alloc] initWithFormat:@"system/head_img/user/%@%i",date,last];
    return timeNow;
}
//上传的是群头群像
- (NSString *)getGroupObjectKey{
    NSString* date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYYMMddhhmmssSSS"];
    date = [formatter stringFromDate:[NSDate date]];
    //取出个随机数
    int last = arc4random() % 1000000;
    NSString *timeNow = [[NSString alloc] initWithFormat:@"system/head_img/group/%@%i",date,last];
    return timeNow;
}


/// 上传聊天界面的语音文件
/// @param chatModel chatModel description
/// @param progress progress description
/// @param success success description
/// @param failure failure description
-(void)uploadVoiceWithChatModel:(ChatModel *)chatModel uploadProgress:(void (^)(NSString * _Nonnull, ChatModel * _Nonnull))progress success:(OSSWrapperSuccessHandler)success failure:(OSSWrapperFailureHandler)failure{
    [self check:^{
        [self startUploadVoiceWithChatModel:chatModel uploadProgress:progress success:success failure:failure];
    }];
    
    
    
}
-(void)startUploadVoiceWithChatModel:(ChatModel *)chatModel uploadProgress:(void (^)(NSString * _Nonnull, ChatModel * _Nonnull))progress success:(OSSWrapperSuccessHandler)success failure:(OSSWrapperFailureHandler)failure{
    OSSPutObjectRequest*request = [OSSPutObjectRequest new];
    request.bucketName = [BaseSettingManager sharedManager].bucket;
    request.objectKey = [NSString stringWithFormat:@"chat/%@/%@.mp3",[self getTimeNow],[NSString getArc4random5:2]];
    request.uploadingData=chatModel.orignalImageData;
    request.isAuthenticationRequired = YES;
    request.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        float progressStr = 1.f * totalByteSent / totalBytesExpectedToSend;
        NSString *pecentStr = [NSString stringWithFormat:@"%.0f%%", progressStr];
        chatModel.uploadProgress=pecentStr;
        progress(pecentStr,chatModel);
    };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OSSTask * task = [[OSSManager sharedManager].defaultClient putObject:request];
        [task continueWithBlock:^id(OSSTask *task) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (task.error) {
                    failure(task.error,task.error.code);
                } else {
                    NSString*urlStr=[NSString stringWithFormat:@"%@/%@",[BaseSettingManager sharedManager].urlBegin,request.objectKey];
                    chatModel.fileServiceUrl=urlStr;
                    chatModel.uploadProgress=@"100%";
                    chatModel.uploadState=1;
                    chatModel.sendState=2;
                    [[WCDBManager sharedManager]insertChatModel:chatModel];
                    success(chatModel);
                    
                }
            });
            
            return nil;
        }];
    });
}


-(void)startUploadTimelinesVideoWith:(UIImage *)image imageFailure:(void (^_Nullable)(NSError*))imageFailure videoFailure:(void (^_Nullable)(NSError*))videoFailure videoUrl:(NSURL *)videoUrl videoUploadProgress:(void (^_Nullable)(float progress))videoUploadProgress  success:(void (^_Nullable)(NSString*imageUrl ,NSString*videoUrl,NSString*videoOssPath))success{
    [self check:^{
        __block NSString*videoOssUrl;
        __block NSString*imgOssUrl;
        __block NSString*videoOssPath;
        self.requestArray=[NSMutableArray array];
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_enter(group);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            OSSPutObjectRequest*  imageRequest = [OSSPutObjectRequest new];
            imageRequest.bucketName = [BaseSettingManager sharedManager].bucket;
            NSString*mimeType=@"jpeg";
            NSString*objectKey=[NSString stringWithFormat:@"circle/%@/%@.%@",[self getTimeNow],[NSString getArc4random5:0],mimeType];
            imageRequest.objectKey = objectKey;
            NSData * imageData = [UIImage compressImageSize:image toByte:1024*50];
            imageRequest.uploadingData=imageData;
            imageRequest.isAuthenticationRequired = YES;
            OSSTask * imagetask = [[OSSManager sharedManager].defaultClient putObject:imageRequest];
            [self.requestArray addObject:imageRequest];
            [imagetask continueWithBlock:^id(OSSTask *task) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (imagetask.error) {
                        if (imagetask.error.code!=5) {//如果不是手动取消的
                            imageFailure(task.error);
                        }
                    } else {
                        [self.requestArray removeObject:imageRequest];
                        imgOssUrl=[NSString stringWithFormat:@"%@/%@",[BaseSettingManager sharedManager].urlBegin,imageRequest.objectKey];
                        dispatch_group_leave(group);
                    }
                    
                });
                
                return nil;
            }];
            
        });
        dispatch_group_enter(group);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            OSSPutObjectRequest*  videoRequest = [OSSPutObjectRequest new];
            videoRequest.bucketName = [BaseSettingManager sharedManager].bucket;
            videoRequest.objectKey = [NSString stringWithFormat:@"circle/%@/%@.mp4",[self getTimeNow],[NSString getArc4random5:1]];
            videoRequest.uploadingFileURL=videoUrl;
            videoRequest.isAuthenticationRequired = YES;
            videoRequest.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
                float progressLoad = 1.f * totalBytesSent / totalBytesExpectedToSend;
                videoUploadProgress(progressLoad);
                
            };
            [self.requestArray addObject:videoRequest];
            OSSTask * task = [[OSSManager sharedManager].defaultClient putObject:videoRequest];
            [task continueWithBlock:^id(OSSTask *task) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (task.error) {
                        if (task.error.code!=5) {
                            videoFailure(task.error);
                        }
                        
                    } else {
                        [self.requestArray removeObject:videoRequest];
                        videoOssUrl=[NSString stringWithFormat:@"%@/%@",[BaseSettingManager sharedManager].urlBegin,videoRequest.objectKey];
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


/// 上传聊天视频
/// @param chatModel 消息模型
/// @param imageUploadProgress 图片上传精度
/// @param imageUploadSuccess imageUploadSuccess description
/// @param imagefailure imagefailure description
/// @param videoUploadProgress videoUploadProgress description
/// @param videoUploadSuccess videoUploadSuccess description
/// @param videofailure videofailure description
-(void)uploadVideoWithChatModel:(ChatModel*)chatModel imageUploadProgress:(void (^)( ChatModel * _Nonnull model))imageUploadProgress imageUploadSuccess:(OSSWrapperSuccessHandler)imageUploadSuccess imagefailure:(OSSWrapperFailureHandler)imagefailure videoUploadProgress:(void (^)( ChatModel * _Nonnull model))videoUploadProgress videoUploadSuccess:(OSSWrapperSuccessHandler)videoUploadSuccess videofailure:(OSSWrapperFailureHandler)videofailure{
    [self check:^{
        OSSPutObjectRequest*  imageRequest = [OSSPutObjectRequest new];
        imageRequest.bucketName = [BaseSettingManager sharedManager].bucket;
        NSString*mimeType=@"jpeg";
        NSString*objectKey=[NSString stringWithFormat:@"chat/%@/%@.%@",[self getTimeNow],[NSString getArc4random5:0],mimeType];
        imageRequest.objectKey = objectKey;
        imageRequest.uploadingData=chatModel.orignalImageData;
        imageRequest.isAuthenticationRequired = YES;
        imageRequest.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            float progressLoad = 1.f * totalBytesSent / totalBytesExpectedToSend;
            chatModel.videFirstUploadProgress=[NSString stringWithFormat:@"%.f%%",progressLoad*100];
            dispatch_async(dispatch_get_main_queue(), ^{
                imageUploadProgress(chatModel);
            });
            
        };
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            OSSTask * imagetask = [[OSSManager sharedManager].defaultClient putObject:imageRequest];
            [imagetask continueWithBlock:^id(OSSTask *task) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (imagetask.error) {
                        imagefailure(task.error,task.error.code);
                    } else {
                        NSString*urlStr=[NSString stringWithFormat:@"%@/%@",[BaseSettingManager sharedManager].urlBegin,imageRequest.objectKey];
                        //                        chatModel.uploadState=1;
                        chatModel.sendState=2;
                        chatModel.imageUrl=urlStr;
                        chatModel.thumbnails=imageRequest.objectKey;
                        imageUploadSuccess(chatModel);
                        
                    }
                });
                
                return nil;
            }];
        });
        OSSPutObjectRequest*  videoRequest = [OSSPutObjectRequest new];
        videoRequest.bucketName = [BaseSettingManager sharedManager].bucket;
        videoRequest.objectKey =[NSString stringWithFormat:@"chat/%@/%@",[self getTimeNow],chatModel.fileCacheName];
        videoRequest.uploadingFileURL=[NSURL URLWithString:chatModel.showFileName];
        videoRequest.isAuthenticationRequired = YES;
        videoRequest.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            float progressLoad = 1.f * totalBytesSent / totalBytesExpectedToSend;
            chatModel.uploadProgress=[NSString stringWithFormat:@"%.f%%",progressLoad*100];
            chatModel.totalUnitCount=totalBytesExpectedToSend;
            chatModel.completedUnitCount=totalBytesSent;
            dispatch_async(dispatch_get_main_queue(), ^{
                videoUploadProgress(chatModel);
            });
            
        };
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            OSSTask * task = [[OSSManager sharedManager].defaultClient putObject:videoRequest];
            [task continueWithBlock:^id(OSSTask *task) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (task.error) {
                        videofailure(task.error,task.error.code);
                    } else {
                        NSString*urlStr=[NSString stringWithFormat:@"%@/%@",[BaseSettingManager sharedManager].urlBegin,videoRequest.objectKey];
                        chatModel.uploadState=1;
                        chatModel.sendState=2;
                        chatModel.fileServiceUrl=urlStr;
                        chatModel.thumbnails=videoRequest.objectKey;
                        videoUploadSuccess(chatModel);
                        
                    }
                });
                
                return nil;
            }];
        });
    }];
    
    
}
-(void)uploadCertificationImagesWith:(UIImage*)img type:(NSInteger)type successHandler:(void (^)(NSString*url))successHandler{
    [self check:^{
        OSSPutObjectRequest*  request = [OSSPutObjectRequest new];
        request.bucketName = [BaseSettingManager sharedManager].bucket;
        NSData*imageData=[img imageWithThumbtoByte:1024*1024];
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
    //    证件照  /system/authentication/certificate/
    //    自拍   /system/authentication/selfie/
        if (type==0) {
            request.objectKey = [NSString stringWithFormat:@"system/authentication/certificate/%@/%@.%@",[self getTimeNow],[NSString getArc4random5:0],mimeType];
        }else{
            request.objectKey = [NSString stringWithFormat:@"system/authentication/selfie/%@/%@.%@",[self getTimeNow],[NSString getArc4random5:0],mimeType];
        }
        request.uploadingData=imageData;
        request.isAuthenticationRequired = YES;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            OSSTask * task = [[OSSManager sharedManager].defaultClient putObject:request];
            [task continueWithBlock:^id(OSSTask *task) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (task.error) {
    //                    failureHandler(task.error,task.error.code);
                    } else {
                        NSString*urlStr=[NSString stringWithFormat:@"%@/%@",[BaseSettingManager sharedManager].urlBegin,request.objectKey];
                        
                        successHandler(urlStr);
                    }
                    
                });
                
                return nil;
            }];
            
        });
    }];
    
    
}
-(void)uploadFileWithChatModel:(ChatModel *)chatModel uploadProgress:(void (^)(ChatModel * _Nonnull))progress success:(OSSWrapperSuccessHandler)success failure:(OSSWrapperFailureHandler)failure{
    [self check:^{
        self.normalUploadRequest = [OSSPutObjectRequest new];
        self.normalUploadRequest.bucketName = [BaseSettingManager sharedManager].bucket;
        self.normalUploadRequest.objectKey = [NSString stringWithFormat:@"chat/%@/%@",[self getTimeNow],chatModel.fileCacheName];
        self.normalUploadRequest.uploadingData=chatModel.fileData;
        self.normalUploadRequest.isAuthenticationRequired = YES;
        self.normalUploadRequest.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
            dispatch_async(dispatch_get_main_queue(), ^{
                chatModel.completedUnitCount=totalByteSent;
                progress(chatModel);
            });
        };
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            OSSTask * task = [[OSSManager sharedManager].defaultClient putObject:self.normalUploadRequest];
            [task continueWithBlock:^id(OSSTask *task) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (task.error) {
                        failure(task.error,task.error.code);
                    } else {
                        NSString*urlStr=[NSString stringWithFormat:@"%@/%@",[BaseSettingManager sharedManager].urlBegin,self.normalUploadRequest.objectKey];
                        chatModel.fileServiceUrl=urlStr;
                        chatModel.uploadProgress=@"100%";
                        chatModel.uploadState=1;
                        chatModel.sendState=2;
                        chatModel.thumbnails=self.normalUploadRequest.objectKey;
                        [[WCDBManager sharedManager]insertChatModel:chatModel];
                        success(chatModel);
                        
                    }
                });
                
                return nil;
            }];
        });
    }];
    
    
}

-(void)setUserHeadImageWithImage:(NSData *)imageData type:(NSString*)type success:(void (^)(NSString * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure{
    [self check:^{
        self.normalUploadRequest = [OSSPutObjectRequest new];
        self.normalUploadRequest.bucketName = [BaseSettingManager sharedManager].bucket;
        if ([type isEqualToString:@"0"]) {//群
            self.normalUploadRequest.objectKey = [NSString stringWithFormat:@"%@.png",[self getGroupObjectKey]];
        }else if ([type isEqualToString:@"1"]){//用户
            self.normalUploadRequest.objectKey = [NSString stringWithFormat:@"%@.png",[self getUserObjectKey]];
        }else{
            self.normalUploadRequest.objectKey = [NSString stringWithFormat:@"%@.png",[self getTimeNow]];
        }
        self.normalUploadRequest.uploadingData=imageData;
        self.normalUploadRequest.isAuthenticationRequired = YES;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            OSSTask * task = [[OSSManager sharedManager].defaultClient putObject:self.normalUploadRequest];
            [task continueWithBlock:^id(OSSTask *task) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (task.error) {
                        failure(task.error);
                    } else {
                        NSString*urlStr=[NSString stringWithFormat:@"%@/%@",[BaseSettingManager sharedManager].urlBegin,self.normalUploadRequest.objectKey];
                        success(urlStr);
                        
                    }
                });
                
                return nil;
            }];
        });
    }];
    
    
    
    
}


- (void)asyncPutImage:(NSString *)objectKey localFilePath:(NSString *)filePath success:(void (^)(id _Nullable))success failure:(void (^)(NSError * _Nonnull))failure {
    if (![objectKey oss_isNotEmpty]) {
        NSError *error = [NSError errorWithDomain:NSInvalidArgumentException code:0 userInfo:@{NSLocalizedDescriptionKey: @"objectKey should not be nil"}];
        failure(error);
        return;
    }
    
    _normalUploadRequest = [OSSPutObjectRequest new];
    //    _normalUploadRequest.bucketName = OSS_BUCKET_PRIVATE;
    _normalUploadRequest.objectKey = objectKey;
    _normalUploadRequest.uploadingFileURL = [NSURL fileURLWithPath:filePath];
    _normalUploadRequest.isAuthenticationRequired = YES;
    _normalUploadRequest.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        float progress = 1.f * totalByteSent / totalBytesExpectedToSend;
        OSSLogDebug(@"上传文件进度: %f", progress);
    };
    //    _normalUploadRequest.callbackParam = @{
    //                                           @"callbackUrl": OSS_CALLBACK_URL,
    //                                           // callbackBody可自定义传入的信息
    //                                           @"callbackBody": @"filename=${object}"
    //                                           };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OSSTask * task = [[OSSManager sharedManager].defaultClient putObject:_normalUploadRequest];
        [task continueWithBlock:^id(OSSTask *task) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (task.error) {
                    failure(task.error);
                } else {
                    success(nil);
                }
            });
            
            return nil;
        }];
    });
}

- (void)normalRequestCancel
{
    if (_normalDloadRequest) {
        [_normalDloadRequest cancel];
    }
    
    if (_normalUploadRequest) {
        [_normalUploadRequest cancel];
    }
}

- (void)triggerCallbackWithObjectKey:(NSString *)objectKey success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OSSCallBackRequest *request = [OSSCallBackRequest new];
        //        request.bucketName = OSS_BUCKET_PRIVATE;
        request.objectName = objectKey;
        //        request.callbackParam = @{@"callbackUrl": OSS_CALLBACK_URL,
        //                                  @"callbackBody": @"test"};
        //        request.callbackVar = @{@"var1": @"value1",
        //                                @"var2": @"value2"};
        
        OSSTask *triggerCBTask = [[OSSManager sharedManager].defaultClient triggerCallBack:request];
        [triggerCBTask waitUntilFinished];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (triggerCBTask.result) {
                success(triggerCBTask.result);
            } else {
                failure(triggerCBTask.error);
            }
        });
    });
}

- (void)multipartUploadWithSuccess:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 获取沙盒的cache路径
        NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        
        // 获取本地大文件url
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"wangwang" withExtension:@"zip"];
        
        OSSResumableUploadRequest * resumableUpload = [OSSResumableUploadRequest new];
        //        resumableUpload.bucketName = OSS_BUCKET_PRIVATE;            // 设置bucket名称
        resumableUpload.objectKey = @"oss-ios-demo-big-file";       // 设置object key
        resumableUpload.uploadingFileURL = fileURL;                 // 设置要上传的文件url
        resumableUpload.contentType = @"application/octet-stream";  // 设置content-type
        resumableUpload.partSize = 102400;                          // 设置分片大小
        resumableUpload.recordDirectoryPath = cachesDir;            // 设置分片信息的本地存储路径
        
        // 设置metadata
        resumableUpload.completeMetaHeader = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value1", @"x-oss-meta-name1", nil];
        
        // 设置上传进度回调
        resumableUpload.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
            NSLog(@"progress: %lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
        };
        
        //
        OSSTask * resumeTask = [[OSSManager sharedManager].defaultClient resumableUpload:resumableUpload];
        [resumeTask waitUntilFinished];                             // 阻塞当前线程直到上传任务完成
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (resumeTask.result) {
                success(resumeTask.result);
            } else {
                failure(resumeTask.error);
            }
        });
    });
}

- (void)textWaterMark:(NSString *)object waterText:(NSString *)text objectSize:(int)size success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    NSString * base64Text = [OSSUtil calBase64WithData:(UTF8Char*)[text cStringUsingEncoding:NSASCIIStringEncoding]];
    NSString * queryString = [NSString stringWithFormat:@"@watermark=2&type=%@&text=%@&size=%d",
                              font, base64Text, size];
    NSLog(@"TextWatermark: %@", object);
    NSLog(@"Text: %@", text);
    NSLog(@"QueryString: %@", queryString);
    NSLog(@"%@%@", object, queryString);
    //    [self asyncGetImage:[NSString stringWithFormat:@"%@%@", object, queryString] success:success failure:failure];
}

- (void)reSize:(NSString *)object picWidth:(int)width picHeight:(int)height success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    NSString * queryString = [NSString stringWithFormat:@"@%dw_%dh_1e_1c", width, height];
    NSLog(@"ResizeImage: %@", object);
    NSLog(@"Width: %d", width);
    NSLog(@"Height: %d", height);
    NSLog(@"QueryString: %@", queryString);
    //    [self asyncGetImage:[NSString stringWithFormat:@"%@%@", object, queryString] success:success failure:failure];
}
//判断是否需要重新获取阿里云token
-(BOOL)jugdeIfNeedToGetNewOSSTokenWithExpireTime:(NSString *)expireTime{
    //    2020-01-15T08:56:59Z
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // 时间格式,此处遇到过坑,建议时间HH大写,手机24小时进制和12小时禁止都可以完美格式化
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *expire = [dateFormat dateFromString:expireTime];
    NSInteger expiretimet=[expire timeIntervalSince1970];
    NSInteger nowTimet=[[NSDate date] timeIntervalSince1970];
    return expiretimet-nowTimet>300;
    
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
