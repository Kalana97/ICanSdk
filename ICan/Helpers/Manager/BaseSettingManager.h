//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 2019/9/11
- System_Version_MACOS: 10.14
- EasyPay
- File name:  BaseSettingManager.h
- Description:
- Function List: 
- History:
*/
        

#import <Foundation/Foundation.h>
@class UserConfigurationInfo;
NS_ASSUME_NONNULL_BEGIN

@interface BaseSettingManager : NSObject

/**设备安装APP的唯一ID*/
@property (nonatomic,copy)  NSString * deviceUuid;
/**用户的信息 放在请求头*/
@property (nonatomic,copy) NSString * userAgent;

/** 上传的是我行资源的osstoken */
@property (nonatomic,copy) NSString * bucket;
@property (nonatomic,copy) NSString * ossEndpoint;
@property (nonatomic,copy) NSString * accessKeyId;
@property (nonatomic,copy) NSString * accessKeySecret;
@property (nonatomic,copy) NSString * securityToken;
@property(nonatomic, copy) NSString * urlBegin;
@property (nonatomic,copy) NSString * expiration;

/** 上传的是商城资源的osstoken */
@property (nonatomic,copy) NSString * shopBucket;
@property (nonatomic,copy) NSString * shopOssEndpoint;
@property (nonatomic,copy) NSString * shopAccessKeyId;
@property (nonatomic,copy) NSString * shopAccessKeySecret;
@property (nonatomic,copy) NSString * shopSecurityToken;
@property (nonatomic,copy) NSString * shopExpiration;
/** 是否是扬声器 */
@property(nonatomic, assign) BOOL speaker;

/** 商城TelephoeCode，默认86*/
@property(nonatomic, copy) NSString *mallTelephoeCode;
/** 商城跟首页右上角国家名字，默认中国大陆*/
@property(nonatomic, copy) NSString *mallCountryName;
/** 当前用户的配置 */
@property(nonatomic, retain) UserConfigurationInfo *userConfigurationInfo;

/**
@{@"numberid":nsarray}
 */
@property(nonatomic, strong) NSDictionary *historyDict;



+(instancetype)sharedManager;
+(BOOL)isChinaLanguages;
+(NSString*)getCurrentLanguages;
-(void)resetAppToTabbarViewController;
-(void)resetAppToTabbarViewControllerDuplicate;
+(void)resetAppToLoginViewControllershowOtherLoginTips:(BOOL)showOtherLoginTips tips:(NSString*)tips;
+(void)resetAppToLoginViewControllershowOtherLoginTipsLogout:(BOOL)showOtherLoginTips tips:(NSString*)tips;
+(NSDictionary*)getCurrentAgreementWithTitle:(NSString*)title;

/// 获取当前系统的语言环境
+(NSDictionary*)getPreferredLanguages;
+(NSDictionary*)getSelectedLanguage:(NSString*)sentLanguage;
+(NSString*)uploadLanguages;
@end

NS_ASSUME_NONNULL_END
