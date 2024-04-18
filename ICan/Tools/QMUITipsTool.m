//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 25/9/2019
- File name:  QMUITipsTool.m
- Description:
- Function List: 
- History:/Users/dzl/Desktop/test/test/IDETemplateMacros.plist
*/
        

#import "QMUITipsTool.h"

@implementation QMUITipsTool
+ (void)showSuccessWithMessage:(NSString *)message inView:(UIView *)parentView{
    [QMUITips hideAllTips];
    [QMUITips showSucceed:message inView:parentView?:[UIApplication sharedApplication].delegate.window hideAfterDelay:1.5];
}
+ (void)showLoadingWihtMessage:(NSString *)message inView:(UIView *)parentView{
    [QMUITips hideAllTips];
    [QMUITips showLoading:message?:NSLocalizedString(@"Loading", 加载中) inView:parentView?:[UIApplication sharedApplication].delegate.window hideAfterDelay:1.5];
}
+ (void)showErrorWihtMessage:(NSString *)message inView:(UIView *)parentView{
       [QMUITips hideAllTips];
    if (message.length>0) {
        [QMUITips showError:message inView:parentView?:[UIApplication sharedApplication].delegate.window hideAfterDelay:2];
    }
  
}
+(void)showOnlyTextWithMessage:(NSString*)message inView:(UIView*)parentView isAutoHidden:(BOOL)isAutoHidden{
    [QMUITips hideAllTips];
    if (isAutoHidden) {
        [QMUITips showWithText:message inView:parentView?:[UIApplication sharedApplication].delegate.window hideAfterDelay:1.5];
    }else{
        [QMUITips showWithText:message inView:parentView?:[UIApplication sharedApplication].delegate.window];
//        [QMUITips showLoadingInView:parentView?:[UIApplication sharedApplication].delegate.window hideAfterDelay:1.5];
    }
}
+(void)showOnlyTextWithMessage:(NSString *)message inView:(UIView *)parentView{
    [QMUITips hideAllTips];
    [QMUITips showWithText:message inView:parentView?:[UIApplication sharedApplication].delegate.window hideAfterDelay:1.5];
}
+(void)showOnlyLodinginView:(UIView *)parentView isAutoHidden:(BOOL)isAutoHidden;{
    [QMUITips hideAllTips];
    if (isAutoHidden) {
        [QMUITips showLoadingInView:parentView?:[UIApplication sharedApplication].delegate.window hideAfterDelay:1.5];
    }else{
        [QMUITips showLoadingInView:parentView?:[UIApplication sharedApplication].delegate.window];
//        [QMUITips showLoadingInView:parentView?:[UIApplication sharedApplication].delegate.window hideAfterDelay:1.5];
    }
    
}
+ (void)showLoadingWihtMessage:(NSString *)message inView:(UIView *)parentView isAutoHidden:(BOOL)isAutoHidden{
    [QMUITips hideAllTips];
    if (isAutoHidden) {
        [QMUITips showLoading:message?:NSLocalizedString(@"Loading", 加载中) inView:parentView?:[UIApplication sharedApplication].delegate.window hideAfterDelay:1.5];
    }else{
        [QMUITips showLoading:message?:NSLocalizedString(@"Loading", 加载中) inView:parentView?:[UIApplication sharedApplication].delegate.window];
    }
    
}
/*
- (void)didSelectCellWithTitle:(NSString *)title {
    UIView *parentView = self.view;
    
    if ([title isEqualToString:@"Loading"]) {
        // 如果不需要修改contentView的样式，可以直接使用下面这个工具方法
//         QMUITips *tips = [QMUITips showLoadingInView:parentView hideAfterDelay:2];
        
        // 展示如何修改自定义的样式
        QMUITips *tips = [QMUITips createTipsToView:parentView];
        QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
        contentView.minimumSize = CGSizeMake(0, 0);
        tips.willShowBlock = ^(UIView *showInView, BOOL animated) {
            NSLog(@"tips calling willShowBlock");
        };
        tips.didShowBlock = ^(UIView *showInView, BOOL animated) {
            NSLog(@"tips calling didShowBlock");
        };
        tips.willHideBlock = ^(UIView *hideInView, BOOL animated) {
            NSLog(@"tips calling willHideBlock");
        };
        tips.didHideBlock = ^(UIView *hideInView, BOOL animated) {
            NSLog(@"tips calling didHideBlock");
        };
        [tips showLoadingHideAfterDelay:2];
        
    } else if ([title isEqualToString:@"Loading With Text"]) {
        [QMUITips showLoading:@"加载中..." inView:parentView hideAfterDelay:2];
        
    } else if ([title isEqualToString:@"Tips For Succeed"]) {
        [QMUITips showSucceed:@"加载成功" inView:parentView hideAfterDelay:2];
        
    } else if ([title isEqualToString:@"Tips For Error"]) {
        [QMUITips showError:@"加载失败，请检查网络情况" inView:parentView hideAfterDelay:2];
        
    } else if ([title isEqualToString:@"Tips For Info"]) {
        [QMUITips showInfo:@"活动已经结束" detailText:@"本次活动时间为2月1号-2月15号" inView:parentView hideAfterDelay:2];
        
    } else if ([title isEqualToString:@"Custom TintColor"]) {
        QMUITips *tips = [QMUITips showInfo:@"活动已经结束" detailText:@"本次活动时间为2月1号-2月15号" inView:parentView hideAfterDelay:2];
        tips.tintColor = UIColorBlue;
        
    } else if ([title isEqualToString:@"Custom BackgroundView Style"]) {
        QMUITips *tips = [QMUITips showInfo:@"活动已经结束" detailText:@"本次活动时间为2月1号-2月15号" inView:parentView hideAfterDelay:2];
        QMUIToastBackgroundView *backgroundView = (QMUIToastBackgroundView *)tips.backgroundView;
        backgroundView.shouldBlurBackgroundView = YES;
        backgroundView.styleColor = UIColorMakeWithRGBA(232, 232, 232, 0.8);
        tips.tintColor = UIColorBlack;
        
    } else if ([title isEqualToString:@"Custom Content View"]) {
        QMUITips *tips = [QMUITips createTipsToView:parentView];
        tips.toastPosition = QMUIToastViewPositionBottom;
        QDCustomToastAnimator *customAnimator = [[QDCustomToastAnimator alloc] initWithToastView:tips];
        tips.toastAnimator = customAnimator;
        QDCustomToastContentView *customContentView = [[QDCustomToastContentView alloc] init];
        [customContentView renderWithImage:UIImageMake(@"image0") text:@"什么是QMUIToastView" detailText:@"QMUIToastView用于临时显示某些信息，并且会在数秒后自动消失。这些信息通常是轻量级操作的成功信息。"];
        tips.contentView = customContentView;
        [tips showAnimated:YES];
        [tips hideAnimated:YES afterDelay:4];
        
    } else if ([title isEqualToString:@"Custom Animator"]) {
        QMUITips *tips = [QMUITips createTipsToView:parentView];
        QDCustomToastAnimator *customAnimator = [[QDCustomToastAnimator alloc] initWithToastView:tips];
        tips.toastAnimator = customAnimator;
        [tips showInfo:@"活动已经结束" detailText:@"本次活动时间为2月1号-2月15号" hideAfterDelay:2];
        
    }
    
    [self.tableView qmui_clearsSelection];
}
 */
@end
