/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 2019/9/4
- System_Version_MACOS: 10.14
- EasyPay
- File name:  HandleOpenUrlManager.h
- Description:用于处理第三方返回结果
- Function List: 
- History:
*/
        

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import <AlipaySDK/AFServiceCenter.h>
NS_ASSUME_NONNULL_BEGIN
@protocol HandleOpenUrlManagerDelegate <NSObject>
@optional

/**
 微信授权登录结果

 @param response SendAuthResp
 */
- (void)managerDidRecvWeiXinAuthResponse:(SendAuthResp *)response;

/**
 支付宝授权登录结果

 @param response AFServiceResponse
 */
- (void)managerDidRecvAlipayAuthResponse:(AFServiceResponse *)response;

@end

@interface HandleOpenUrlManager : NSObject<WXApiDelegate>
DECLARE_SINGLETON(HandleOpenUrlManager, shareManager);
@property (nonatomic, assign) id<HandleOpenUrlManagerDelegate> delegate;

@property(nonatomic, copy,nullable) NSURL *openUrl;
/**
 支付宝授权登录结果
 
 @param response AFServiceResponse
 */
- (void)managerDidRecvAlipayAuthResponse:(AFServiceResponse *)response;

-(BOOL)handleOpenUrl;
-(void)handleShortcutItem:(UIApplicationShortcutItem*)shortcutItem;
@end

NS_ASSUME_NONNULL_END
