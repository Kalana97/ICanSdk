//
//  VideoCacheManager.h
//  ICan
//
//  Created by limaohuyu on 2021/5/19.
//  Copyright © 2021 dzl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//查询
typedef void(^CacheQueryCompletedBlock)(id data, BOOL hasCache);

//下载进度的回调
typedef void(^DownloaderProgressBlock)(NSInteger completedUnitCount, NSInteger totalUnitCount);
//下载完毕后的回调
typedef void(^DownloaderCompletedBlock)(NSURL * filePath,NSError *error);


@interface VideoCacheManager : NSObject
//创建单例
+ (instancetype)sharedCacheManager;

//下载队列
@property (strong, nonatomic) NSOperationQueue *downloadConcurrentQueue;

//计算缓存数据
- (CGFloat )calculationDiskCache;

//根据key值从本地磁盘中查询缓存数据
- (void)queryURLFromDiskMemory:(NSString *)videoUrl cacheQueryCompletedBlock:(CacheQueryCompletedBlock)cacheQueryCompletedBlock;

//获取videoUrl值对应的磁盘缓存文件路径
- (NSString *)diskCachePathForKey:(NSString *)videoUrl;

//清除本地磁盘缓存数据 diskCache：需要保留到多少M
- (void )clearDiskCacheWihtRetain:(NSInteger )diskCache;


@end

NS_ASSUME_NONNULL_END
