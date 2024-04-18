//
/**
- Copyright © 2019 dzl. All rights reserved.
- AUthor: Created  by DZL on 2019/11/3
- ICan
- File name:  UIAlertController+DZExtension.h
- Description:
- Function List:
*/
        

typedef void(^ActionBlock)(int index);


#import <UIKit/UIKit.h>



@interface UIAlertController (DZExtension)
/**
 *  设置提示控制器
 *
 *  @param title          提示器标题
 *  @param message        提示信息
 *  @param preferredStyle 提示器样式
 *  @param actionTitles   所有action title 的数组
 *  @param handler        block回调（index 是action标题的数组下标）
 *
 *  @return
 */
+ (UIAlertController *)alertCTWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle actionTitles:(NSArray *)titles handler:(ActionBlock)handler ;


/**
 *  设置提示控制器
 *
 *  @param title          提示器标题
 *  @param message        提示信息
 *  @param preferredStyle 提示器样式
 *  @param actionTitles   所有action title 的数组
 *  @param handler        block回调（index 是action标题的数组下标）
 *
 *  @return
 */
+ (void)alertControllerWithTitle:(NSString *)title message:(NSString *)message target:(id)target preferredStyle:(UIAlertControllerStyle)preferredStyle actionTitles:(NSArray *)titles handler:(ActionBlock)handler;
@end


