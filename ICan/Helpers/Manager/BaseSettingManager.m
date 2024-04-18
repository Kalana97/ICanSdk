//
/**
 - Copyright © 2019 EasyPay. All rights reserved.
 - AUthor: Created  by DZL on 2019/9/11
 - System_Version_MACOS: 10.14
 - EasyPay
 - File name:  BaseSettingManager.m
 - Description:
 - Function List:
 - History:
 */
#import "CheckVersionTool.h"
#import "LoginViewController.h"
#import "BaseViewController.h"
#import "BaseSettingManager.h"
#import "QDTabBarViewController.h"
#import "QDNavigationController.h"
#import "C2CTabBarViewController.h"
#import "IcanWalletPageViewController.h"
#import "UIDevice+Orientation.h"
#import "CustomScreenSplash.h"
#import "HandleOpenUrlManager.h"

#define KdeviceUuid        @"deviceUuid"

#define Kbucket            @"bucket"
#define KossEndpoint       @"ossEndpoint"
#define KaccessKeyId       @"accessKeyId"
#define KaccessKeySecret   @"accessKeySecret"
#define KsecurityToken     @"securityToken"
#define Kexpiration     @"expiration"


#define Kshopbucket            @"shopbucket"
#define KshopossEndpoint       @"shopossEndpoint"
#define KshopaccessKeyId      @"shopaccessKeyId"
#define KshopaccessKeySecret   @"shopaccessKeySecret"
#define KshopsecurityToken     @"shopsecurityToken"
#define Kshopexpiration     @"shopexpiration"
#define Kspeaker     @"speaker"

static NSString* const KmallTelephoeCode=@"mallTelephoeCode";
static NSString* const KmallCountryName =@"mallCountryName";
@interface BaseSettingManager ()<UITabBarControllerDelegate,UITabBarDelegate>
@end
@implementation BaseSettingManager
+ (instancetype)sharedManager {
    static BaseSettingManager *api;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        api = [[BaseSettingManager alloc] init];
    });
    return api;
}
-(void)setDeviceUuid:(NSString *)deviceUuid{
    [self setUserDefaultsWithObject:deviceUuid key:KdeviceUuid];
}
-(NSString *)deviceUuid{
    NSString*deviceUuid=[self gainObjectWithKey:KdeviceUuid];
    
    return deviceUuid;
}
-(void)setBucket:(NSString *)bucket{
    [self setUserDefaultsWithObject:bucket key:Kbucket];
}
-(NSString *)bucket{
    return [self gainObjectWithKey:Kbucket];
}
-(void)setUrlBegin:(NSString *)urlBegin{
    [self setUserDefaultsWithObject:urlBegin key:@"urlBegin"];
}
-(NSString *)urlBegin{
    return  [self gainObjectWithKey:@"urlBegin"];
}
-(void)setOssEndpoint:(NSString *)ossEndpoint{
    [self setUserDefaultsWithObject:ossEndpoint key:KossEndpoint];
}
-(NSString *)ossEndpoint{
    return [self gainObjectWithKey:KossEndpoint];
}

-(void)setAccessKeyId:(NSString *)accessKeyId{
    [self setUserDefaultsWithObject:accessKeyId key:KaccessKeyId];
}
-(NSString *)accessKeyId{
    return [self gainObjectWithKey:KaccessKeyId];
}

-(void)setAccessKeySecret:(NSString *)accessKeySecret{
    [self setUserDefaultsWithObject:accessKeySecret key:KaccessKeySecret];
}

-(NSString *)accessKeySecret{
    return [self gainObjectWithKey:KaccessKeySecret];
}

-(void)setSecurityToken:(NSString *)securityToken{
    [self setUserDefaultsWithObject:securityToken key:KsecurityToken];
}

-(NSString *)securityToken{
    return [self gainObjectWithKey:KsecurityToken];
}

-(void)setExpiration:(NSString *)expiration{
    [self setUserDefaultsWithObject:expiration key:Kexpiration];
}
-(NSString *)expiration{
    return [self gainObjectWithKey:Kexpiration];
}


-(void)setShopBucket:(NSString *)shopBucket{
    [self setUserDefaultsWithObject:shopBucket key:Kshopbucket];
}
-(NSString *)shopBucket{
    return [self gainObjectWithKey:Kshopbucket];
}

-(void)setShopOssEndpoint:(NSString *)shopOssEndpoint{
    [self setUserDefaultsWithObject:shopOssEndpoint key:KshopossEndpoint];
}
-(NSString *)shopOssEndpoint{
    return [self gainObjectWithKey:KshopossEndpoint];
}
-(void)setShopAccessKeyId:(NSString *)shopAccessKeyId{
    [self setUserDefaultsWithObject:shopAccessKeyId key:KshopaccessKeyId];
}
-(NSString *)shopAccessKeyId{
    return [self gainObjectWithKey:KshopaccessKeyId];
}
-(void)setShopAccessKeySecret:(NSString *)shopAccessKeySecret{
    [self setUserDefaultsWithObject:shopAccessKeySecret key:KshopaccessKeySecret];
}
-(NSString *)shopAccessKeySecret{
    return [self gainObjectWithKey:KshopaccessKeySecret];
}

-(void)setShopSecurityToken:(NSString *)shopSecurityToken{
    [self setUserDefaultsWithObject:shopSecurityToken key:KshopsecurityToken];
}
-(NSString *)shopSecurityToken{
    return [self gainObjectWithKey:KshopsecurityToken];
}

-(void)setShopExpiration:(NSString *)shopExpiration{
    [self setUserDefaultsWithObject:shopExpiration key:Kshopexpiration];
}
-(NSString *)shopExpiration{
    return [self gainObjectWithKey:Kshopexpiration];
}

-(void)setMallTelephoeCode:(NSString *)mallTelephoeCode{
    [self setUserDefaultsWithObject:mallTelephoeCode key:KmallTelephoeCode];
}

-(void)setSpeaker:(BOOL)speaker{
    [self setUserDefaultsWithObject:@(speaker) key:Kspeaker];
}
-(BOOL)speaker{
    return [[self gainObjectWithKey:Kspeaker] boolValue];
}

-(NSString *)mallTelephoeCode{
    NSString*string=[self gainObjectWithKey:KmallTelephoeCode];
    if (string) {
        return string;
    }
    return @"86";
}


-(void)setMallCountryName:(NSString *)mallCountryName{
    [self setUserDefaultsWithObject:mallCountryName key:KmallCountryName];
}

-(NSString *)mallCountryName{
    NSString*string=[self gainObjectWithKey:KmallCountryName];
    if (string) {
        return string;
    }
    return @"中国";
}

-(void)setUserDefaultsWithObject:(id)object key:(NSString*)key{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:object forKey:key];
    [userDefaults synchronize];
}
- (id)gainObjectWithKey:(NSString *)key {
    id object = [[NSUserDefaults standardUserDefaults] valueForKey:key];
    return object;
}

-(void)setHistoryDict:(NSDictionary *)historyDict{
    [self setUserDefaultsWithObject:historyDict key:@"historyDict"];
}
-(NSDictionary *)historyDict{
    return [self gainObjectWithKey:@"historyDict"];
}
#pragma mark -- 重置到tabbarViewController
-(void)resetAppToTabbarViewController {
     if ([HandleOpenUrlManager shareManager].openUrl) {
        [[HandleOpenUrlManager shareManager]handleOpenUrl];
        [HandleOpenUrlManager shareManager].openUrl=nil;
    }else {
//        CustomScreenSplash *splash = [[CustomScreenSplash alloc] init];
//        [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
//        [UIApplication sharedApplication].delegate.window.rootViewController=splash;
//        NSTimeInterval delayInSeconds = 0.5;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [UIDevice interfaceOrientation:UIInterfaceOrientationPortrait];
            QDTabBarViewController *tabBVC = [[QDTabBarViewController alloc] init];
            tabBVC.delegate=self;
            [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
            [UIApplication sharedApplication].delegate.window.rootViewController=tabBVC;
            [CheckVersionTool checkVersioForceUpdate];
//        });
    }
}

-(void)resetAppToTabbarViewControllerDuplicate {
            [UIDevice interfaceOrientation:UIInterfaceOrientationPortrait];
            QDTabBarViewController *tabBVC = [[QDTabBarViewController alloc] init];
            tabBVC.delegate=self;
            [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
            [UIApplication sharedApplication].delegate.window.rootViewController=tabBVC;
}

+(void)resetAppToLoginViewControllershowOtherLoginTips:(BOOL)showOtherLoginTips tips:(NSString*)tips{
//    CustomScreenSplash *splash = [[CustomScreenSplash alloc] init];
//    [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
//    [UIApplication sharedApplication].delegate.window.rootViewController=splash;
//    NSTimeInterval delayInSeconds = 2.0;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            LoginViewController*vc=[[LoginViewController alloc]init];
            vc.showOtherLoginTips=showOtherLoginTips;
            vc.tips=tips;
            QDNavigationController*loginVc=[[QDNavigationController alloc]initWithRootViewController:vc];
            [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
            [UIApplication sharedApplication].delegate.window.rootViewController=loginVc;
            [CheckVersionTool checkVersioForceUpdate];
//        });
}

+(void)resetAppToLoginViewControllershowOtherLoginTipsLogout:(BOOL)showOtherLoginTips tips:(NSString*)tips{
    LoginViewController*vc=[[LoginViewController alloc]init];
    vc.showOtherLoginTips=showOtherLoginTips;
    vc.tips=tips;
    QDNavigationController*loginVc=[[QDNavigationController alloc]initWithRootViewController:vc];
    [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
    [UIApplication sharedApplication].delegate.window.rootViewController=loginVc;
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    QDNavigationController * nav = (QDNavigationController*)viewController;
    UIViewController* visibleVc = nav.visibleViewController;
    if ([visibleVc isKindOfClass:NSClassFromString(@"C2CTabBarViewController")]) {
        C2CTabBarViewController * vc = [[C2CTabBarViewController alloc]init];
        vc.shoulPopToRoot = NO;
        [[AppDelegate shared] pushViewController:vc animated:YES];
        return NO;
    }else if ([visibleVc isKindOfClass:NSClassFromString(@"IcanWalletPageViewController")]) {
        IcanWalletPageViewController*walletVc = [[IcanWalletPageViewController alloc]init];
        walletVc.hidesBottomBarWhenPushed = YES;
        if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
            walletVc.fromFind = YES;
        }else{
            ///ican chat 国外版本点击的时候 直接显示余额页面
            walletVc.fromFind = NO;
        }
       
        [[AppDelegate shared] pushViewController:walletVc animated:YES];
        return NO;
    }
    
    return YES;
}

- (void)removeObjectWithKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(UserConfigurationInfo *)userConfigurationInfo{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"UserConfiguration.plist"];
    NSMutableDictionary *usersDic = [[NSMutableDictionary alloc ] initWithContentsOfFile:plistPath];
    NSMutableDictionary*dict=[usersDic objectForKey:[UserInfoManager sharedManager].userId];
    if (dict) {
        return [UserConfigurationInfo mj_objectWithKeyValues:dict];
    }
    UserConfigurationInfo*info= [[UserConfigurationInfo alloc]init];
    info.isShowMessageNoticeDetail=YES;
    info.isAcceptMessageNotice=YES;
    info.isOpenShake=YES;
    info.isOpenSound=YES;
    //默认是7天
    info.deleteMessageWholeTime =[NSString stringWithFormat:@"%d",0];
    info.mallTelephoeCode=@"86";
    info.mallCountryName=@"中国";
    return info;
    
    
}
-(void)setUserConfigurationInfo:(UserConfigurationInfo *)userConfigurationInfo{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"UserConfiguration.plist"];
    NSMutableDictionary *usersDic = [[NSMutableDictionary alloc ] initWithContentsOfFile:plistPath];
    if (!usersDic) {
        usersDic =[[NSMutableDictionary alloc]init];
    }
    [usersDic setObject:[userConfigurationInfo mj_JSONObject] forKey:[UserInfoManager sharedManager].userId];
    [usersDic writeToFile:plistPath atomically:YES];
}
+(BOOL)isChinaLanguages{
//    zh-Hans-CN,中文简体
//    en-CN,
//    ja-JP,
//    en-US
    
//    zh-Hant-HK,
//    en-US,
//    zh-Hans-US,
//    en
    NSArray *appleLanguages = [NSLocale preferredLanguages];
    if (appleLanguages && appleLanguages.count > 0) {
        NSString *languages = appleLanguages[0];
        if ([languages hasPrefix:@"zh-Hans"]||[languages hasPrefix:@"zh-Hant"]||[languages hasPrefix:@"zh"]) {
            return YES;
        }
    }
    return NO;
}
+(NSString*)getCurrentLanguages{
    NSArray *appleLanguages = [NSLocale preferredLanguages];
    if (appleLanguages && appleLanguages.count > 0) {
        NSString *languages = appleLanguages[0];
        if ([languages hasPrefix:@"zh-Hans"]) {
            return @"zh_cn";
        }else if ([languages hasPrefix:@"zh-Hant"]){
            return @"zh_tw";
        }else if([languages hasPrefix:@"en"]){
            return @"en";
        }
    }
    return @"zh_cn";
}
+(NSString*)uploadLanguages{
    //获取当前系统语言
    NSString *strLang = [[[NSBundle mainBundle] preferredLocalizations] firstObject];
    if ([strLang hasPrefix:@"zh"]) {
        return @"zh-cn";
    }
    return strLang;
}
/// 获取当前系统的语言环境
+(NSDictionary*)getPreferredLanguages{
//    yue-Hans-CN 粤语 简体 （增加）
//    yue-Hant-CN 粤语 繁体 （增加）
//    NSArray * ISOLanguageCodesarray = [NSLocale ISOLanguageCodes];
//    NSArray * ISOCurrencyCodesarray = [NSLocale ISOCurrencyCodes];
//    NSArray * ISOCountryCodesarray = [NSLocale ISOCountryCodes];
//    NSLog(@"ISOLanguageCodesarray=%@ISOCurrencyCodesarray=%@ISOCountryCodesarray=%@",ISOLanguageCodesarray,ISOCurrencyCodesarray,ISOCountryCodesarray);
    NSArray *appleLanguages = [NSLocale preferredLanguages];
    if (appleLanguages && appleLanguages.count > 0) {
        NSString *languages = appleLanguages[0];
        if ([languages hasPrefix:@"zh-Hans"]) {
            return @{@"google":@"zh",@"baidu":@"zh"};
        }else if ([languages hasPrefix:@"zh-Hant"]){
            return @{@"google":@"zh-TW",@"baidu":@"cht"};
        }else if([languages hasPrefix:@"en"]){
            return @{@"google":@"en",@"baidu":@"en"};
        }else if ([languages hasPrefix:@"ko"]){///韩语
            return @{@"google":@"ko",@"baidu":@"kor"};
        }else if ([languages hasPrefix:@"yue-Hans"]){
            return @{@"google":@"zh",@"baidu":@"zh"};
        }else if ([languages hasPrefix:@"yue-Hant"]){
            return @{@"google":@"zh-TW",@"baidu":@"zh"};
        }else if ([languages hasPrefix:@"fr"]){
            return @{@"google":@"fr",@"baidu":@"fra"};
        }else if ([languages hasPrefix:@"tr"]){
            return @{@"google":@"tr",@"baidu":@"en"};
        }else{
            return @{@"google":@"en",@"baidu":@"en"};
        }
    }
    return @{@"google":@"en",@"baidu":@"en"};
}

+(NSDictionary *)getSelectedLanguage:(NSString*)sentLanguage {
        NSString *languages = sentLanguage;
        if ([languages hasPrefix:@"en-us"]) {
            return @{@"google":@"en-us",@"baidu":@"en-us"};
        }else if ([languages hasPrefix:@"tr"]){
            return @{@"google":@"tr",@"baidu":@"tr"};
        }else if([languages hasPrefix:@"zh-cn"]){
            return @{@"google":@"zh-cn",@"baidu":@"zh-cn"};
        }else if ([languages hasPrefix:@"vi"]){///韩语
            return @{@"google":@"vi",@"baidu":@"vi"};
        }else if ([languages hasPrefix:@"km"]){
            return @{@"google":@"km",@"baidu":@"km"};
        }else if ([languages hasPrefix:@"th"]){
            return @{@"google":@"th",@"baidu":@"th"};
        }else if ([languages hasPrefix:@"si"]){
            return @{@"google":@"si",@"baidu":@"si"};
        }else if ([languages hasPrefix:@"ta"]){
            return @{@"google":@"ta",@"baidu":@"ta"};
        }else{
            return @{@"google":@"en",@"baidu":@"en"};
        }
}

+(NSDictionary*)getCurrentAgreementWithTitle:(NSString*)title{
    NSString*webtitle = [title substringWithRange:NSMakeRange(1, title.length-2)];
    NSString*urlString;
    NSString*lange = BaseSettingManager.getCurrentLanguages;
    
        if ([title isEqualToString:NSLocalizedString(@"ServiceAgreement", 服务协议)]) {
            if ([lange isEqualToString:@"en"]) {
                urlString = @"https://icanlk.com/static/agreement/html/ican_chat_service_agreement.html?language=en-us";
            }else{
                urlString = @"https://icanlk.com/static/agreement/html/ican_chat_service_agreement.html?language=zh-cn";
            }
        }else if ([title isEqualToString:@"PrivacyAgreement".icanlocalized]){//隐私协议
            if ([lange isEqualToString:@"en"]) {
                urlString = @"https://icanlk.com/static/agreement/html/ican_chat_privacy_agreement.html?language=en-us";
            }else{
                urlString = @"https://icanlk.com/static/agreement/html/ican_chat_privacy_agreement.html?language=zh-cn";
            }
        }else if ([title isEqualToString:NSLocalizedString(@"WithdrawalAgreement", 提现协议)]){
            if ([lange isEqualToString:@"en"]) {
                urlString = @"https://icanlk.com/static/agreement/html/ican_chat_withdrawal_agreement.html?language=en-us";
            }else{
                urlString = @"https://icanlk.com/static/agreement/html/ican_chat_withdrawal_agreement.html?language=zh-cn";
            }
        }else if ([title isEqualToString:NSLocalizedString(@"MemberServiceAgreement", 会员协议)]){
            if ([lange isEqualToString:@"en"]) {
                urlString = @"https://icanlk.com/static/agreement/html/value_added_service_agreement.html?language=en-us";
            }else{
                urlString = @"https://icanlk.com/static/agreement/html/value_added_service_agreement.html?language=zh-cn";
            }
        }else if ([title isEqualToString:NSLocalizedString(@"PurchaseAgreement", 购买协议)]){
            if ([lange isEqualToString:@"en"]) {
                urlString = @"https://icanlk.com/static/agreement/html/account_purchase_agreement.html?language=en-us";
            }else{
                urlString = @"https://icanlk.com/static/agreement/html/account_purchase_agreement.html?language=zh-cn";
            }
        }
        return @{@"title":webtitle,@"url":urlString};
    
    
    

}
@end
