//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 1/11/2019
- File name:  PrivacyPermissionsTool.h
- Description:
- Function List:
*/
        

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PrivacyPermissionsTool : NSObject
/**
 判断当前的相机权限状态

 @param success success description
 @param failure failure description
 */
+(void)judgeCameraAuthorizationSuccess:(void(^)(void))success failure:(void(^)(void))failure;


/**
 获取当前相册的权限状态

 @param success success descriptio
 @param failure failure description
 */
+(void)judgeAlbumAuthorizationSuccess:(void(^)(void))success failure:(void(^)(void))failure;
/**
 判断是否允许面部ID或者是指纹

 @param support
 */
+ (void)judgeSupporFaceIDOrTouchID:(void(^)(NSString*str))support;

/**
 获取当前的麦克风权限

 @param success success description
 @param failure failure description
 */
+(void)judgeMicrophoneAuthorizationSuccess:(void(^)(void))success notDetermined:(void(^)(void))notDetermined failure:(void(^)(void))failure;
/**
 判断是否开启定位

 @param allow allow description
 */
+(void)judgeLocationAuthorizationSuccess:(void(^)(void))success failure:(void(^)(void))failure;

/**
 判断是否拥有通讯录权限

 @param success success description
 @param failure failure description
 */
+(void)judgeContactAuthorizationSuccess:(void(^)(void))success failure:(void(^)(void))failure;

+ (void)goToAppSystemSetting ;
@end

NS_ASSUME_NONNULL_END
