//
//  OSSManager.h
//  AliyunOSSSDK-iOS-Example
//
//  Created by huaixu on 2018/10/23.
//  Copyright © 2018 aliyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AliyunOSSiOS/AliyunOSSiOS.h>

NS_ASSUME_NONNULL_BEGIN

@interface OSSManager : NSObject
/** 这个是上传我行的clint */
@property (nonatomic, strong) OSSClient *defaultClient;

@property (nonatomic, strong) OSSClient *imageClient;


/** 这个是上传商城的clinet */
@property (nonatomic, strong) OSSClient *shopDefaultClient;
+ (instancetype)sharedManager;

@end

NS_ASSUME_NONNULL_END
