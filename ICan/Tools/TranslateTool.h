//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 26/3/2020
- File name:  TranslateTool.h
- Description: 翻译相关的工具类
- Function List:
*/
        

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TranslateTool : NSObject


/// 语言识别
/// https://firebase.google.com/docs/ml-kit/ios/identify-languages
/// @param text 需要识别的字符串
/// @param identifyBlock identifyBlock description
+ (void)identifyLanguageForText:(NSString*)text block:(void (^)(NSString * _Nonnull))identifyBlock;

/// 翻译
/// @param text 需要翻译的文字
/// @param translateFailBlock translateFailBlock description
/// @param translateSuccessBlock translateSuccessBlock description
+(void)translateLanguageForText:(NSString*)text translateFailBlock:(void (^)(void))translateFailBlock  translateSuccessBlock:(void (^)(NSString * _Nonnull))translateSuccessBlock;

+(void)getDownloadedTranslateModels;
@end

NS_ASSUME_NONNULL_END
