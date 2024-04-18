// 主要作用是用来对快速设置button
//  UIButton+HYQUIButton.h
//  HaoYuanQu
//
//  Created by  on 16/1/28.
//  Copyright © 2016年 HaoYuanQu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (HYQUIButton)

/**


 @param title buttonn的文字（没有就传nil）
 @param image buttonn的图片名字（没有就传nil）
 @param backgroundColor buttonn的背景颜色（没有就传nil）
 @param titleFont buttonn的文字大小
 @param target 动作执行者
 @param action 动作执行者的方法
 @return return value description
 */
+(UIButton*)dzNavButtonWithTitle:(NSString*)title image:(NSString*)image backgroundColor:(UIColor*)backgroundColor titleFont:(CGFloat)titleFont titleColor:(UIColor*)titleColor target:(id)target action:(SEL)action;


/**
 主要用于设置功能性的按钮 一般用于view上面

 @param title title description
 @param image image description
 @param backgroundColor backgroundColor description
 @param titleFont titleFont description
 @param target target description
 @param action action description
 @return return value description
 */
+(UIButton*)functionButtonWithTitle:(NSString*)title image:(NSString*)image backgroundColor:(UIColor*)backgroundColor titleFont:(CGFloat)titleFont target:(id)target action:(SEL)action;


+(UIButton*)dzButtonWithTitle:(NSString *)title image:(NSString *)image backgroundColor:(UIColor *)backgroundColor titleFont:(CGFloat)titleFont titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action;

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)withEvent;


/**
 * 设置普通状态与高亮状态的背景图片
 */
-(void)setN_BG:(NSString *)nbg H_BG:(NSString *)hbg;

/**
 * 设置普通状态与高亮状态的背景颜色
 */
-(void)setN_BGColor:(UIColor *)nbg H_BGColoor:(UIColor *)hbg;

/**
 * 设置普通状态与高亮状态的拉伸后背景图片
 */
-(void)setResizeN_BG:(NSString *)nbg H_BG:(NSString *)hbg;

/**
 * 设置可点击状态与不可点击状态的拉伸后背景图片
 */
- (void)setEnabledBG:(NSString *)bg unEnabledBG:(NSString *)unbg;

/**
 * 设置可点击状态与不可点击状态的拉伸后背景图片
 */
- (void)setEnabledBGColor:(UIColor *)nbg unEnabledBGColoor:(UIColor *)uhbg;
/** 获取button文字的宽度 */
-(CGFloat)getButtonTextWith;
@end
