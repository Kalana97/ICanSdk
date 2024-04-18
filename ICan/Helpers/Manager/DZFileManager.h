//
//  DZFileManager.h
//  FileManager
//
//  Created by lidazhi on 2018/12/20.
//  Copyright © 2018 LIMAOHUYU. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^cleanCacheBlock)(void);
@interface DZFileManager : NSObject

+(instancetype )sharedManager;


/**
 获取某个用户的聊天消息的本地缓存路径

 @param imName 用户im名
 @return return value description
 */
+(NSString*)messageCacheWithImName:(NSString*)imName;

/**
 根据当前的聊天好友创建图片缓存路径

 @param imName 当前好友的imName
 @return return value description
 */
+(NSString *)imageCachePathWithImName:(NSString*)imName;


+(NSString *)audioCachePathWithImName:(NSString*)imName;
+(NSString *)fileCachePathWithImName:(NSString*)imName;
+(NSString *)videoCachePathWithImName:(NSString*)imName;


+ (NSString *)getDocumentPath;
//获取Library路径
+ (NSString *)getLibraryPath;
//获取应用程序路径
+ (NSString *)getApplicationPath;
//获取Cache路径
+ (NSString *)getCachePath;
//获取Temp路径
+ (NSString *)getTempPath;
+ (BOOL)fileIsExistOfPath:(NSString *)filePath;
//从某个路径中移除文件
+ (BOOL)removeFileOfPath:(NSString *)filePath;
//从URL路径中移除文件
- (BOOL)removeFileOfURL:(NSURL *)fileURL;
//创建文件路径
+(BOOL)creatDirectoryWithPath:(NSString *)dirPath;
//创建文件
+ (BOOL)creatFileWithPath:(NSString *)filePath;
//保存文件
+ (BOOL)saveFile:(NSString *)filePath withData:(NSData *)data;
+ (BOOL)appendData:(NSData *)data withPath:(NSString *)path;
//获取文件
+ (NSData *)getFileData:(NSString *)filePath;
//读取文件
+ (NSData *)getFileData:(NSString *)filePath startIndex:(long long)startIndex length:(NSInteger)length;
//移动文件
+ (BOOL)moveFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath;
//拷贝文件
+(BOOL)copyFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath;
//获取文件夹下文件列表
+ (NSArray *)getFileListInFolderWithPath:(NSString *)path;
//获取文件大小
+ (long long)getFileSizeWithPath:(NSString *)path;
//获取文件创建时间
+ (NSString *)getFileCreatDateWithPath:(NSString *)path;
//获取文件所有者
+ (NSString *)getFileOwnerWithPath:(NSString *)path;
//获取文件更改日期
+ (NSString *)getFileChangeDateWithPath:(NSString *)path;
/**
 *  清理缓存
 */
+(void)cleanCache:(cleanCacheBlock)block;

/**
 *  整个缓存目录的大小
 */
+(float)folderSizeAtPath;

@end


