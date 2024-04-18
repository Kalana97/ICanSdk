//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 21/5/2021
- File name:  CircleOssWrapper.m
- Description:
- Function List:
*/
        

#import "CircleOssWrapper.h"
#import "UploadImgModel.h"
#import "NSData+ImageContentType.h"
@implementation CircleOssWrapper
+ (instancetype)shared {
    static CircleOssWrapper *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[CircleOssWrapper alloc] init];//
    });
    
    return _manager;
}
-(void)uploadImagesWithModels:(NSArray<UploadImgModel*>*)imgs uploadType:(UploadType)uploadType successHandler:(void (^)(NSArray*imgModels))successHandler{
    NSMutableArray*needUploadArray=[NSMutableArray array];
//    OSS路径目录：
//    投诉图片目录：circle/complaints/
//    用户上传图片目录：circle/user/photos/
//    背景图片 circle/user/bg_img/
    for (UploadImgModel*imgModel in imgs) {
        if (imgModel.image) {
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
            NSString*pathString;
            switch (uploadType) {
                case UploadType_Complaints:{
                    pathString=@"circle/complaints";
                }
                    break;
                case UploadType_CircleUser:{
                    pathString=@"circle/user/photos";
                }
                    break;
                case UploadTypeCircleBgImgView:{
                    pathString=@"circle/user/bg_img";
                }
                    break;
                default:
                    break;
            }
            request.objectKey = [NSString stringWithFormat:@"%@/%@/%@.%@",pathString,[self getTimeNow],[NSString getArc4random5:0],mimeType];
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
                successHandler(imgs);
            });
            
        });
    }else{
        successHandler(imgs);
    }
    
    
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
