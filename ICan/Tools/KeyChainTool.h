//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 22/10/2019
- File name:  KeyChainTool.h
- Description: 钥匙串工具类
- Function List:
*/
        

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
NSString * const KEY_USERNAME_PASSWORD = @"com.company.app.usernamepassword";
static NSString* const kSYDictionaryKey = @"123";
static NSString* const kSYKeyChainKey = @"2345";
//当前设备唯一ID的key 存在则不在缓存
static NSString* const KDeviceUDIDKEY = @"KDeviceUDIDKEY";
@interface KeyChainTool : NSObject

/// 通过keychain保存唯一的设备ID
/// @param devieString devieString description
+(void)saveDeviceUDIDWithString:(NSString*)devieString;

/// 根据key获取某个值
/// @param key key description
+(id)loadKeyChainForKey:(NSString*)key;

/// 根据key删除某个值
/// @param key key description
+(void)deleteObjectForKey:(NSString*)key;
@end

NS_ASSUME_NONNULL_END
