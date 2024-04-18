//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 20/9/2019
- File name:  UILabel+Extension.h
- Description:
- Function List: 
- History:/Users/dzl/Desktop/test/test/IDETemplateMacros.plist
*/
        

#import <UIKit/UIKit.h>



@interface UILabel (Extension)
/** 左对齐label */
+ (UILabel *)leftLabelWithTitle:(NSString *)title font:(CGFloat)font color:(UIColor *)color;
/** 中间label */
+ (UILabel *)centerLabelWithTitle:(NSString *)title font:(CGFloat)font color:(UIColor *)color;
/** 右对齐label */
+ (UILabel *)rightLabelWithTitle:(NSString *)title font:(CGFloat)font color:(UIColor *)color;

/**
 设置iconfontlabel
 
 @param title 文字
 @param font 大小
 @param textColor 字体颜色
 @param iconfontColor 图标颜色
 @param iconfontRange 图标颜色位置
 @return label
 */
+ (UILabel *)iconfontLableWithTitle:(NSString*)title font:(CGFloat)font textColor:(UIColor*)textColor iconfontColor:(UIColor*)iconfontColor iconfontRange:(NSRange)iconfontRange;

/// 设置label在中文和其他语言的字体大小
/// @param font font description
/// @param otherFont otherFont description
-(void)setLabelNativeCHFontWith:(CGFloat)font otherFont:(CGFloat)otherFont;
@end


