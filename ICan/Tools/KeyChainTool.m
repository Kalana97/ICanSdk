//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 22/10/2019
- File name:  KeyChainTool.m
- Description:
- Function List:
*/
        

#import "KeyChainTool.h"
#import <Security/Security.h>

@implementation KeyChainTool

+(void)saveDeviceUDIDWithString:(NSString*)devieString;{
    [self setSaveObject:devieString forKey:KDeviceUDIDKEY];
}
+ (void)keyChainSave:(NSString *)string {
  NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
  [tempDic setObject:string forKey:kSYDictionaryKey];
//    [self save:kSYKeyChainKey data:tempDic];
  
}
+ (id)loadKeyChainForKey:(NSString *)key{
    return  [self objectForKey:key];
}
+(void)deleteObjectForKey:(NSString*)key{
    [self removeObjectForKey:key];
}

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
  return [NSMutableDictionary dictionaryWithObjectsAndKeys:
          (id)kSecClassGenericPassword,(id)kSecClass,
          service, (id)kSecAttrService,
          service, (id)kSecAttrAccount,
          (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
          nil];
}

+ (void)setSaveObject:(id )value forKey:(NSString *)forKey{
  
  //Get search dictionary
  NSMutableDictionary *keychainQuery = [self getKeychainQuery:forKey];
  //Delete old item before add new item
  SecItemDelete((CFDictionaryRef)keychainQuery);
  //Add new object to search dictionary(Attention:the data format)
  [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:value] forKey:(id)kSecValueData];
  //Add item to keychain with the search dictionary
  SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

+ (id)objectForKey:(NSString *)service {
  id ret = nil;
  NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
  //Configure the search setting
  //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
  [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
  [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
  CFDataRef keyData = NULL;
  if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
      @try {
          ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
      } @catch (NSException *e) {
          NSLog(@"Unarchive of %@ failed: %@", service, e);
      } @finally {
      }
  }
  if (keyData)
      CFRelease(keyData);
  return ret;
}

+ (void)removeObjectForKey:(NSString *)service {
  NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
  SecItemDelete((CFDictionaryRef)keychainQuery);
}
@end
