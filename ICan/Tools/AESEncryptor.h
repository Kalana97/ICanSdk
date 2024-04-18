//
//  AESEncryptor.h
//  EasyPay
//
//  Created by 刘志峰 on 2019/6/6.
//  Copyright © 2019 EasyPay. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AESEncryptor : NSObject
#pragma mark -- 加密方法
+ (NSString*)encryptAESWithString:(NSString *)string;
#pragma mark -- 解密方法
+ (NSString*)decryptAESWithString:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
