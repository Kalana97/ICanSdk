//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 17/5/2021
- File name:  UploadImgModel.h
- Description:
- Function List:
*/
        

#import <Foundation/Foundation.h>
#import <AliyunOSSiOS/AliyunOSSiOS.h>
NS_ASSUME_NONNULL_BEGIN

@interface UploadImgModel : NSObject
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, assign) NSInteger index;
@property(nonatomic, strong) OSSPutObjectRequest *request;
@property(nonatomic, copy)   NSString *ossImgUrl;
@property(nonatomic, assign) BOOL isAdd;
@end

NS_ASSUME_NONNULL_END
