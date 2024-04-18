//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 25/9/2019
- File name:  QMUITipsTool.h
- Description: 用来展示一些提示数据
- Function List: 
- History:/Users/dzl/Desktop/test/test/IDETemplateMacros.plist
*/
        

#import <Foundation/Foundation.h>



@interface QMUITipsTool : NSObject
+(void)showSuccessWithMessage:(NSString*)message inView:(UIView*)parentView;
+(void)showLoadingWihtMessage:(NSString*)message inView:(UIView*)parentView;
+ (void)showErrorWihtMessage:(NSString *)message inView:(UIView *)parentView;
+(void)showOnlyTextWithMessage:(NSString*)message inView:(UIView*)parentView;
+(void)showOnlyTextWithMessage:(NSString*)message inView:(UIView*)parentView isAutoHidden:(BOOL)isAutoHidden;
+(void)showOnlyLodinginView:(UIView*)parentView isAutoHidden:(BOOL)isAutoHidden;;
//设置loading页面是否自动隐藏 适用于登录注册等避免重复点击的界面
+ (void)showLoadingWihtMessage:(NSString *)message inView:(UIView *)parentView isAutoHidden:(BOOL)isAutoHidden;
@end

