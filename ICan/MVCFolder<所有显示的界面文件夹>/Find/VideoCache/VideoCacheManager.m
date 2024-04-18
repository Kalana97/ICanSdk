//
//  VideoCacheManager.m
//  ICan
//
//  Created by limaohuyu on 2021/5/19.
//  Copyright © 2021 dzl. All rights reserved.
//

#import "VideoCacheManager.h"

@interface VideoCacheManager ()
@property (nonatomic, strong) NSFileManager *fileManager;      //文件管理类
@property (nonatomic, strong) NSURL *diskCacheDirectoryURL;    //本地磁盘文件夹路径
@property (nonatomic, strong) dispatch_queue_t ioQueue;        //查询缓存任务队列
@property(nonatomic, strong) NSMutableArray *downUrlArrays;   //生命周期中 已经添加到任务队列中的URL

@end

@implementation VideoCacheManager
+ (instancetype)sharedCacheManager{
    static VideoCacheManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[VideoCacheManager alloc]init];
    });
    return manager;
}

-(instancetype)init {
    self = [super init];
    if(self) {
        _fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES);
        NSString *path = [paths lastObject];
        NSString *diskCachePath = [NSString stringWithFormat:@"%@%@",path,@"/videoCache"];
        //判断是否创建本地磁盘缓存文件夹
        BOOL isDirectory = NO;
        BOOL isExisted = [_fileManager fileExistsAtPath:diskCachePath isDirectory:&isDirectory];
        if (!isDirectory || !isExisted){
            NSError *error;
            [_fileManager createDirectoryAtPath:diskCachePath withIntermediateDirectories:YES attributes:nil error:&error];
        }
        //本地磁盘缓存文件夹URL
        _diskCacheDirectoryURL = [NSURL fileURLWithPath:diskCachePath];
        //初始化查询缓存任务队列
        _ioQueue = dispatch_queue_create("ican.start.videocache", DISPATCH_QUEUE_SERIAL);
        
        //初始化并行下载队列
        _downloadConcurrentQueue = [NSOperationQueue new];
        _downloadConcurrentQueue.name = @"ican.concurrent.downloader";
        _downloadConcurrentQueue.maxConcurrentOperationCount = 6;
        
    }
    return self;
}



- (void)downloadVideoWithURL:(NSString  *)videoUrl progressBlock:(DownloaderProgressBlock)progressBlock
         completedBlock:(DownloaderCompletedBlock)completedBlock{
    if (![self.downUrlArrays containsObject:videoUrl]) {
        [self.downUrlArrays addObject:videoUrl];
        [_downloadConcurrentQueue addOperationWithBlock:^{
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            NSURLRequest *requset = [NSURLRequest requestWithURL:[NSURL URLWithString:videoUrl]];
            //返回一个下载任务对象
            NSURLSessionDownloadTask *loadTask = [manager downloadTaskWithRequest:requset progress:^(NSProgress * _Nonnull downloadProgress) {
                DDLogInfo(@"下载URL = %@ 下载的大小 === %lld=== 文件的总大小=====%lld",videoUrl,downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
                if (progressBlock) {
                    progressBlock(downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
                }
            } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                NSString *path = [self diskCachePathForKey:videoUrl];
                return  [NSURL fileURLWithPath:path];
            } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                NSLog(@"下载完成地址:%@",filePath);
                if (completedBlock) {
                    completedBlock(filePath,error);
                }
                }];
            [loadTask resume];
        }];
    }
   
    
}


//根据key值从本地磁盘中查询缓存数据
- (void)queryURLFromDiskMemory:(NSString *)videoUrl cacheQueryCompletedBlock:(CacheQueryCompletedBlock)cacheQueryCompletedBlock{
    dispatch_async(_ioQueue, ^{
        NSString *path = [self diskCachePathForKey:videoUrl];
        if([self.fileManager fileExistsAtPath:path]) {
            if (self.downloadConcurrentQueue.isSuspended) {
                [self.downloadConcurrentQueue setSuspended:NO];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                cacheQueryCompletedBlock(path, YES);
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                cacheQueryCompletedBlock(path, NO);
            });
//            isSuspended 如果这个值设置为 NO，那说明这个队列已经准备好了可以执行了。如果这个值设置为 YES，那么已经添加到队列中的操作还是可以执行了，而后面继续添加进队列中的操作才处于暂停状态，直到你再次将这个值设置为 NO 时，后面加入的操作才会继续执行。这个属性的默认值是 NO。

            if (!self.downloadConcurrentQueue.isSuspended) {
                [self.downloadConcurrentQueue setSuspended:YES];
            }
            [self downloadVideoWithURL:videoUrl progressBlock:nil completedBlock:nil];
        }
    });
}

//计算缓存数据
- (CGFloat )calculationDiskCache {
    NSArray *contents = [_fileManager contentsOfDirectoryAtPath:_diskCacheDirectoryURL.path error:nil];
    NSEnumerator *enumerator = [contents objectEnumerator];
    NSString *fileName;
    CGFloat folderSize = 0.0f;
    while((fileName = [enumerator nextObject])) {
        NSString *filePath = [_diskCacheDirectoryURL.path stringByAppendingPathComponent:fileName];
        folderSize += [_fileManager attributesOfItemAtPath:filePath error:nil].fileSize;
    }
    return folderSize/1024.0f/1024.0f;
}

//获取key值对应的磁盘缓存文件路径
- (NSString *)diskCachePathForKey:(NSString *)videoUrl {
    NSString *fileName = [self md5:videoUrl];
    NSString *cachePathForKey = [_diskCacheDirectoryURL URLByAppendingPathComponent:fileName].path;
    cachePathForKey = [cachePathForKey stringByAppendingFormat:@".mp4"];
    return cachePathForKey;
}

//清除本地磁盘缓存数据
- (void )clearDiskCacheWihtRetain:(NSInteger )diskCache {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *contents = [self->_fileManager contentsOfDirectoryAtPath:self->_diskCacheDirectoryURL.path error:nil];
        NSEnumerator *enumerator = [contents objectEnumerator];
        NSString *fileName;
        CGFloat folderAllSize = 0.0f;
        while((fileName = [enumerator nextObject])) {
            NSString *filePath = [self->_diskCacheDirectoryURL.path stringByAppendingPathComponent:fileName];
            folderAllSize += [self->_fileManager attributesOfItemAtPath:filePath error:nil].fileSize;
            if (diskCache ==0){
                [self->_fileManager removeItemAtPath:filePath error:NULL];
            }
        }
        if (diskCache >0) {
            NSArray *sortedPaths = [contents sortedArrayUsingComparator:^(NSString * firstPath, NSString* secondPath) {
                NSDate *firstData =  [[self->_fileManager attributesOfItemAtPath:firstPath error:nil] fileModificationDate];
                NSDate *secondData =  [[self->_fileManager attributesOfItemAtPath:secondPath error:nil] fileModificationDate];
                 return [firstData compare:secondData];//升序
             }];
            for (NSString *tempFileName in sortedPaths) {
                NSString *filePath = [self->_diskCacheDirectoryURL.path stringByAppendingPathComponent:tempFileName];
                CGFloat folderSize = [self->_fileManager attributesOfItemAtPath:filePath error:nil].fileSize;
                folderAllSize = folderAllSize-folderSize;
                if (folderAllSize<= diskCache*1024.0f*1024.0f) {
                    break;
                }else{
                    [self->_fileManager removeItemAtPath:filePath error:NULL];
                }
            }

        }
    });
}


//key值进行md5签名
- (NSString *)md5:(NSString *)key {
    if(!key) {
        return @"temp";
    }
    return key.MD5String;
}
-(NSMutableArray *)downUrlArrays{
    if (!_downUrlArrays) {
        _downUrlArrays=[NSMutableArray array];
    }
    return _downUrlArrays;
}
@end
